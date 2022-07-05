/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  lsq.v                                                //
//                                                                     //
//  Description :  Load Queue of the P6 architecture;                  //
//                 Support 3-way superscalar execution;                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module LSQ (
    input clock,reset,
    //dispatch stage
    input dispatch_en,
    // complete stage input
    input complete_en,
    input EX_IC_PACKET [2:0]    ex_ic_packet_in, // ex_ic pipeline register in
    input ID_IP_PACKET [2:0]    id_ip_packet_in,
    input ROB_PACKET [2:0]      rob_packet_in,

    input retire_en,
    input [31:0]            dcache_data_in,
    input                   dcache_valid_in,
    //input                   dcache_store_success,
    // dispatch stage output
    output logic [`XLEN-1:0]            lsq2dcache_addr, // both L and S
    output BUS_COMMAND                  lsq2dcache_command, // L or S
    output logic [`XLEN-1:0]            lsq2dcache_data, // store value
    output logic [`XLEN-1:0]               lsq2cdb_value, // load to cdb
    output logic [$clog2(`ROB_SIZE):0]     lsq2cdb_rob//load to cdb
    
);
logic [$clog2(`LSQ_SIZE):0] head;
logic [$clog2(`LSQ_SIZE):0] tail;
LSQ_ENTRY [`LSQ_SIZE - 1:0] lsq_entry;


logic [1:0] dispatch_num; //{0,1,2,3}
logic [2:0] dispatch_num_valid; // for for-loop synth
logic retire_valid;


logic [$clog2(`LSQ_SIZE):0] next_head;
logic [$clog2(`LSQ_SIZE):0] next_tail;

logic [2:0][$clog2(`LSQ_SIZE):0]       lsq_addr_complete_idx;
logic [2:0][$clog2(`ROB_SIZE):0] lsq_rob_tag; // record only load's rob_tag
logic [2:0][1:0]                    lsq_inst; //l or s
                              


assign dispatch_num_valid =  (dispatch_num == 0) ? 3'b000 :
                                  (dispatch_num == 1) ? 3'b001 :
                                  (dispatch_num == 2) ? 3'b011 : 3'b111;

      



always_comb begin

    // calculate how many load/store insns when dispatch
    dispatch_num = 0;
    for(int i = 0; i < 3; i++)begin
        if(id_ip_packet_in[i].valid
            && (id_ip_packet_in[i].rd_mem | id_ip_packet_in[i].wr_mem)
            && (rob_packet_in[i].assigned_rob_tag > 0)) begin
            // insn packet is load and make sure it have been dispatched by ROB
            lsq_rob_tag[dispatch_num] = rob_packet_in[i].assigned_rob_tag;
            if (id_ip_packet_in[i].rd_mem) begin
                lsq_inst[dispatch_num] = 2'b10;
            end
            else begin
                lsq_inst[dispatch_num] = 2'b01;
            end
            dispatch_num += 1;
        end
    end

    //calculate next_tail value
    next_tail = (tail + dispatch_num) % `LSQ_SIZE;

    // find the lsq index we want to write addr to
    for(int i = 0; i < 3; i++)begin
        if(ex_ic_packet_in[i].exe_valid && (ex_ic_packet_in[i].rd_mem | ex_ic_packet_in[i].wr_mem)) begin// complete packet is load
            for(int j = 0; j < `LSQ_SIZE ; j++) begin
                if((lsq_entry[j].rob_tag > 0) && (lsq_entry[j].rob_tag == ex_ic_packet_in[i].rob_tag)) begin
                    lsq_addr_complete_idx[i] = j;
                end
            end
        end
    end
    
    

    //can to cache
    if (lsq_entry[head].ready_to_dcache == 1 && lsq_entry[head].complete == 0)begin
        if (lsq_entry[head].l_or_s == 2'b10)begin //load
            lsq2dcache_command = BUS_LOAD;
            lsq2dcache_addr = lsq_entry[head].addr;
        end
        else begin
            lsq2dcache_command = BUS_STORE;
            lsq2dcache_addr = lsq_entry[head].addr;
            lsq2dcache_data = lsq_entry[head].value;
        end
    end
    else begin
        lsq2dcache_command = BUS_NONE;
        lsq2dcache_addr = 0;
        lsq2dcache_data = 0;
    end



    // check if the head can retire
    retire_valid =  !(ex_ic_packet_in[2].exe_valid & (!ex_ic_packet_in[2].rd_mem) & (!ex_ic_packet_in[2].wr_mem))
                     & lsq_entry[head].complete;
    
    // send dest value and rob tag to cdb
    lsq2cdb_value = 0;
    lsq2cdb_rob = 0;
    if (retire_valid) begin
        lsq2cdb_value = lsq_entry[head].value;
        // if (lsq_entry[head].l_or_s == 2'b10) begin // load
		// 	if (~lsq_entry[head].mem_size[2]) begin //is this an signed/unsigned load?
		// 		if (lsq_entry[head].mem_size[1:0] == 2'b0)
		// 			lsq2cdb_value = {{(`XLEN-8){ lsq_entry[head].value[7]}},  lsq_entry[head].value[7:0]};
		// 		else if  (lsq_entry[head].mem_size[1:0] == 2'b01)
		// 			lsq2cdb_value = {{(`XLEN-16){ lsq_entry[head].value[15]}},  lsq_entry[head].value[15:0]};
		// 		else lsq2cdb_value =  lsq_entry[head].value;
		// 	end else begin
		// 		if (lsq_entry[head].mem_size[1:0] == 2'b0)
		// 			lsq2cdb_value = {{(`XLEN-8){1'b0}},  lsq_entry[head].value[7:0]};
		// 		else if  (lsq_entry[head].mem_size[1:0] == 2'b01)
		// 			lsq2cdb_value = {{(`XLEN-16){1'b0}},  lsq_entry[head].value[15:0]};
		// 		else lsq2cdb_value =  lsq_entry[head].value;
		// 	end
        // end else begin
        //     lsq2cdb_value = lsq_entry[head].value;
        // end
        lsq2cdb_rob = lsq_entry[head].rob_tag;
    end
    else begin
        lsq2cdb_rob = 0;
    end


    // calculate next_head value
    next_head = (head + retire_valid) % `LSQ_SIZE;

end

// synopsys sync_set_reset "reset"
always_ff @(posedge clock) begin
    if(reset) begin
        head <= 0;
        tail <= 0;
        for(int i = 0; i < `LSQ_SIZE; i++) begin
            lsq_entry[i].l_or_s <= 0;
            lsq_entry[i].rob_tag <= 0;
            lsq_entry[i].ready_to_dcache <= 0;
            lsq_entry[i].complete <= 0;
            lsq_entry[i].value <= 0;
            lsq_entry[i].addr <= 0;
        end
    end
    else begin
        // always check if load value form Dcache
        // load
        if (dcache_valid_in && lsq_entry[head].ready_to_dcache && !lsq_entry[head].complete && lsq_entry[head].l_or_s == 2'b10 ) begin
            lsq_entry[head].value <= dcache_data_in;
            lsq_entry[head].complete <= 1;
        end
        //store
        //???
        else if(dcache_valid_in && lsq_entry[head].ready_to_dcache && !lsq_entry[head].complete && lsq_entry[head].l_or_s == 2'b01 ) begin
            lsq_entry[head].complete <= 1;
        end
        else begin
            lsq_entry[head].value <= lsq_entry[head].value;
            lsq_entry[head].complete <= lsq_entry[head].complete;
        end


        //dispatch
        if(dispatch_en) begin
            tail <= next_tail;
            // set rob#
            for(int i = 0; i < 3; i++) begin
                if(dispatch_num_valid[i]) begin
                    lsq_entry[(tail + i) % `LSQ_SIZE].rob_tag <= lsq_rob_tag[i];
                    lsq_entry[(tail + i) % `LSQ_SIZE].l_or_s <= lsq_inst[i];
                    //lsq_entry[(tail + i) % lsq_SIZE].valid <= 1'b1;
                end
                else begin
                    lsq_entry[(tail + i) % `LSQ_SIZE].rob_tag <= 0;
                    lsq_entry[(tail + i) % `LSQ_SIZE].l_or_s <= 0;
                end
            end
        end
           
        
        if(complete_en) begin
            // write addr and data  lsq
            for(int i = 0; i < 3; i++) begin
                if(ex_ic_packet_in[i].exe_valid) begin
                    // set mem size to BYTE HALF WORD
                    lsq_entry[lsq_addr_complete_idx[i]].mem_size <= ex_ic_packet_in[i].inst.r.funct3;
                    if(ex_ic_packet_in[i].rd_mem) begin// complete packet is load
                        lsq_entry[lsq_addr_complete_idx[i]].addr <= ex_ic_packet_in[i].alu_result;
                        lsq_entry[lsq_addr_complete_idx[i]].ready_to_dcache <= 1'b1;
                    end
                    else if (ex_ic_packet_in[i].wr_mem) begin// complete packet is store
                        lsq_entry[lsq_addr_complete_idx[i]].addr <= ex_ic_packet_in[i].alu_result;
                        lsq_entry[lsq_addr_complete_idx[i]].ready_to_dcache <= 1'b1;
                        lsq_entry[lsq_addr_complete_idx[i]].value <= ex_ic_packet_in[i].rs2_value;
                    end
                end
                // else begin
                //     lsq_entry[lsq_addr_complete_idx[i]].addr <= lsq_entry[lsq_addr_complete_idx[i]].addr;
                //     lsq_entry[lsq_addr_complete_idx[i]].ready_to_dcache <= lsq_entry[lsq_addr_complete_idx[i]].ready_to_dcache;
                //     lsq_entry[lsq_addr_complete_idx[i]].value <= lsq_entry[lsq_addr_complete_idx[i]].value;
                // end
            end
                                                  
        end
        

        if(retire_en) begin
            head <= next_head;
            // clear these have retired
           if(retire_valid) begin
                lsq_entry[head].l_or_s <= 0;
                lsq_entry[head].rob_tag <= 0;
                lsq_entry[head].complete <= 0;
                lsq_entry[head].ready_to_dcache <= 0;
                lsq_entry[head].addr <= 0;
                lsq_entry[head].value <= 0;
            end
        end
    end
end

endmodule