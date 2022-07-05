/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  SQ.sv                                               //
//                                                                     //
//  Description :  Store Queue of the P6 architure;                    //
//                 Support 3-way superscalar execution;                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module SQ #(parameter SQ_SIZE=16)(
    input clock,reset,
    // dispatch stage
    input dispatch_en,
    input ID_IP_PACKET [2:0] id_ip_packet_in,
    // complete stage input
    input complete_en,
    input EX_IC_PACKET ex_ic_packet_in, // ex_ic pipeline register in
    input ROB_PACKET  [2:0] rob_packet_in,

    input retire_en,

    // dispatch stage output
    output logic [$clog2(SQ_SIZE):0] SQ_tail_out, // when dispatch, RS record SQ_tail
    // complete stage output
    input [`XLEN-1:0] mem2SQ_data, // Mem[addr] return from Memory
    output logic [`XLEN-1:0] SQ2mem_addr, // addr send to memory if miss in SQ

    output logic [`XLEN-1:0] SQ2CDB_value,

    // retire 
    output logic [`XLEN-1:0] retire_addr_out, // head of the SQ write to Mem
    output logic [`XLEN-1:0] retire_value_out,
    output BUS_COMMAND       SQ2mem_command
    

);
logic [$clog2(SQ_SIZE):0] head;
logic [$clog2(SQ_SIZE):0] tail;
SQ_ENTRY [SQ_SIZE - 1:0] SQ_entry;

logic hit; // whether find the addr in SQ
logic [`XLEN-1:0] SQ_value;//record the value in SQ

logic [1:0] dispatch_store_num; //dispatch how many store insns{0,1,2,3}
logic retire_store_valid; 

logic [$clog2(SQ_SIZE):0] next_head;
logic [$clog2(SQ_SIZE):0] next_tail;

logic [$clog2(SQ_SIZE):0] SQ_complete_idx; // write address and data to which SQ slot

logic [2:0][$clog2(`ROB_SIZE):0] store_rob_tag; // record only store's rob_tag

// register for psel_geb
logic [SQ_SIZE - 1 :0] SQ_load_req;
logic [SQ_SIZE - 1 :0] SQ_load_gnt;
logic [(SQ_SIZE * 1) - 1:0] SQ_load_gnt_bus;
logic SQ_load_empty;

psel_gen    #(.REQS(1), .WIDTH(SQ_SIZE)) psel_SQ
				(.req(SQ_load_req),
				.gnt(SQ_load_gnt),
				.gnt_bus(SQ_load_gnt_bus),
				.empty(SQ_load_empty)
				);

assign SQ2mem_command = (ex_ic_packet_in.exe_valid && ex_ic_packet_in.rd_mem && SQ_load_gnt == 0) ? BUS_LOAD :
                        (retire_store_valid) ? BUS_STORE : BUS_NONE;

// comb logic
assign SQ_tail_out = tail;
always_comb begin
    //################      LOAD    ######################
    if(ex_ic_packet_in.exe_valid && ex_ic_packet_in.rd_mem) begin// packet is load
        for(int i = 0; i < SQ_SIZE; i++) begin 
            if((i < ex_ic_packet_in.store_pos) && (i >= head) && (SQ_entry[i].addr == ex_ic_packet_in.alu_result)) begin // SQ#<SQ_pos && == addr
                SQ_load_req[i] = 1'b1;
            end else begin
                SQ_load_req[i] = 1'b0;
            end
        end
        
        if(SQ_load_gnt != 0) begin // find
            hit = 1'b1;
            SQ_value = SQ_entry[$clog2(SQ_load_gnt)].value;
        end else begin // miss, if miss in SQ, get value from mem
            hit = 1'b0;
            SQ2mem_addr = ex_ic_packet_in.alu_result; // addr send to mem
            //SQ2mem_command = BUS_LOAD;
        end
        // final output value : choose SQ value or mem value according to whether find in SQ
        SQ2CDB_value = hit ? SQ_value : mem2SQ_data;
        
    end

    //################      STORE   ######################
    // calculate how many store insns when dispatch
    dispatch_store_num = 0;
    for(int i = 0; i < 3; i++)begin
        if(id_ip_packet_in[i].valid && id_ip_packet_in[i].wr_mem && (rob_packet_in[i].assigned_rob_tag > 0)) begin// insn packet is store and make sure it have been dispatched by ROB
            store_rob_tag[dispatch_store_num] = rob_packet_in[i].assigned_rob_tag;
            dispatch_store_num += 1;
        end
    end

    // calculate next_tail value
    next_tail = (tail + dispatch_store_num) % SQ_SIZE;


    // find the SQ index we want to write addr and data to 
    if(ex_ic_packet_in.exe_valid && ex_ic_packet_in.wr_mem) begin// complete packet is store
        for(int i = 0; i < SQ_SIZE ; i++) begin
            if((SQ_entry[i].rob_tag > 0) && (SQ_entry[i].rob_tag == ex_ic_packet_in.rob_tag)) begin
                SQ_complete_idx = i;
            end
        end
    end
    

    // calculate retire number
    retire_store_valid =  SQ_entry[head].complete && !(SQ2mem_command == BUS_LOAD);   // only BUS_NONE can retire store               

    if(retire_en) begin
        if(retire_store_valid) begin
            retire_addr_out = SQ_entry[head].addr;
            retire_value_out = SQ_entry[head].value;
            //SQ2mem_command = BUS_STORE;
        end 
    end

    // calculate next_head value
    next_head = retire_store_valid ? ((head + 1) % SQ_SIZE) : head;
    
end

// seq logic
always_ff @(posedge clock) begin
    if(reset) begin
        head <= 0;
        tail <= 0;
        for(int i = 0; i < SQ_SIZE; i++) begin
            SQ_entry[i].rob_tag <= 0;
            SQ_entry[i].complete <= 0;
        end
    end
    else begin
        //################      STORE   ######################
        if(dispatch_en) begin
            // updata next tail
            tail <= next_tail;
            // set rob# 
            for(int i = 0; i < dispatch_store_num; i++)begin
                SQ_entry[(tail + i) % SQ_SIZE].rob_tag <= store_rob_tag[i];
            end
        end
        if(complete_en) begin
            // write addr and value to right index
            if(ex_ic_packet_in.exe_valid && ex_ic_packet_in.wr_mem) begin// complete packet is store
                SQ_entry[SQ_complete_idx].addr <= ex_ic_packet_in.alu_result;
                SQ_entry[SQ_complete_idx].value <= ex_ic_packet_in.rs2_value;
                SQ_entry[SQ_complete_idx].complete <= 1'b1;
            end
        end

        if(retire_en) begin
            head <= next_head;
            // clear these have retired
            if(retire_store_valid) begin
                SQ_entry[head].rob_tag <= 0;
                SQ_entry[head].complete <= 0;
            end

        end

        
    end
        
end


endmodule