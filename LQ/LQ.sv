/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  LQ.v                                                //
//                                                                     //
//  Description :  Load Queue of the P6 architecture;                  //
//                 Support 3-way superscalar execution;                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module LQ #(parameter LQ_SIZE=16)(
    input clock,reset,
    //dispatch stage
    input dispatch_en,
    // complete stage input
    input complete_en,
    input EX_IC_PACKET ex_ic_packet_in, // ex_ic pipeline register in
    input ID_IP_PACKET [2:0] id_ip_packet_in,
    input ROB_PACKET [2:0] rob_packet_in,

    input retire_en,

    // dispatch stage output
    output logic [$clog2(LQ_SIZE):0] LQ_tail_out,
  
    //output LQ_ENTRY [LQ_SIZE - 1:0] lq_packet_out,
    output logic [$clog2(`ROB_SIZE):0] lsq_exception_rob_tag
);
logic [$clog2(LQ_SIZE):0] head;
logic [$clog2(LQ_SIZE):0] tail;
LQ_ENTRY [LQ_SIZE - 1:0] LQ_entry;

//logic [2:0] lq_hit;     //whether find the addr in LQ
logic [1:0] dispatch_load_num; //{0,1,2,3}
logic retire_load_valid; //{0,1,2,3}

logic [$clog2(LQ_SIZE):0] next_head;
logic [$clog2(LQ_SIZE):0] next_tail;

logic [$clog2(LQ_SIZE):0] LQ_complete_idx; // write address and data to which LQ slot

logic [2:0][$clog2(`ROB_SIZE):0] load_rob_tag; // record only load's rob_tag

// register for psel_geb
logic [LQ_SIZE - 1 :0] LQ_store_req;
logic [LQ_SIZE - 1 :0] LQ_store_gnt;
logic [(LQ_SIZE * 1) - 1:0] LQ_store_gnt_bus;
logic LQ_store_empty;

psel_gen    #(.REQS(1), .WIDTH(LQ_SIZE)) psel_LQ
				(.req(LQ_store_req),
				.gnt(LQ_store_gnt),
				.gnt_bus(LQ_store_gnt_bus),
				.empty(LQ_store_emptyy)
				);


//assign lq_packet_out = LQ_entry;
assign LQ_tail_out = tail;
always_comb begin
    //  exception check
    if(ex_ic_packet_in.exe_valid && ex_ic_packet_in.wr_mem) begin// packet is load
        for(int i = 0; i < LQ_SIZE; i++) begin 
            if((i >= ex_ic_packet_in.load_pos) && (i < tail) && (LQ_entry[i].addr == ex_ic_packet_in.alu_result)) begin // SQ#<SQ_pos && == addr
                LQ_store_req[LQ_SIZE - i - 1] = 1'b1;
            end else begin
                LQ_store_req[LQ_SIZE - i - 1] = 1'b0;
            end
        end
    end

    if(LQ_store_gnt !=0 ) begin
        lsq_exception_rob_tag = LQ_entry[LQ_SIZE - $clog2(LQ_store_gnt)].rob_tag; //exception happen
    end else begin
        lsq_exception_rob_tag = 0;
    end


    // calculate how many load insns when dispatch
    dispatch_load_num = 0;
    for(int i = 0; i < 3; i++)begin
        if(id_ip_packet_in[i].valid && id_ip_packet_in[i].rd_mem && (rob_packet_in[i].assigned_rob_tag > 0)) begin// insn packet is load and make sure it have been dispatched by ROB
            load_rob_tag[dispatch_load_num] = rob_packet_in[i].assigned_rob_tag;
            dispatch_load_num += 1;
        end
    end

    //calculate next_tail value
    next_tail = (tail + dispatch_load_num) % LQ_SIZE;

    // find the LQ index we want to write addr to 
    if(ex_ic_packet_in.exe_valid && ex_ic_packet_in.rd_mem) begin// complete packet is load
        for(int i = 0; i < LQ_SIZE ; i++) begin
            if((LQ_entry[i].rob_tag > 0) && (LQ_entry[i].rob_tag == ex_ic_packet_in.rob_tag)) begin
                LQ_complete_idx = i;
            end
        end
    end

    // calculate retire number
    retire_load_valid =   LQ_entry[head].complete;

end


always_ff @(posedge clock) begin
    if(reset) begin
        head <= 0;
        tail <= 0;
        for(int i = 0; i < LQ_SIZE; i++) begin
            LQ_entry[i].rob_tag <= 0;
            LQ_entry[i].complete <= 0;
        end
    end
    else begin
        //################      LOAD   ######################
        if(dispatch_en) begin
            tail <= next_tail;
            // set rob#
            for(int i = 0; i < dispatch_load_num; i++) begin
                LQ_entry[(tail + i) % LQ_SIZE].rob_tag <= load_rob_tag[i];
            end
        end
        if(complete_en) begin
            if(ex_ic_packet_in.exe_valid && ex_ic_packet_in.rd_mem) begin// complete packet is load
                LQ_entry[LQ_complete_idx].addr <= ex_ic_packet_in.alu_result;
                LQ_entry[LQ_complete_idx].complete <= 1'b1;
            end
        end
        if(retire_en) begin
            head <= next_head;
            // clear these have retired
            if(retire_load_valid) begin
                LQ_entry[head].rob_tag <= 0;
                LQ_entry[head].complete <= 0;
            end

        end
    end
       
end

endmodule