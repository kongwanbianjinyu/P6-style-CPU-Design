/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  Map_Table.v                                         //
//                                                                     //
//  Description :  Map_Table of the P6 architure;                      //
//                 Support 3-way superscalar execution;                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

module Map_Table #(parameter SIZE=32)(
    input                           clk,reset,
    // Dispatch stage
    input                           dispatch_en,
    // Dispatch stage, read tags input
    input ID_IP_PACKET [2:0]                   id_packet_in,
    // input [$clog2(SIZE)-1:0]        source_reg_idx_in_1 [2:0], // source reg rs1
    // input [$clog2(SIZE)-1:0]        source_reg_idx_in_2 [2:0], // source reg rs2
    // input logic [2:0][$clog2(SIZE)-1:0] dest_reg_idx_in,

    // Dispatch stage, write tags input
    //input [$clog2(SIZE)-1:0]        dest_reg_idx_in [2:0], // dest reg rd
    input [1:0]                     rob_dispatch_num, // dispatch insn number : {0,1,2,3} from ROB

    // input [2:0][4:0]                dest_reg_idx_in,    // input [$clog2(`ROB_SIZE)-1:0]   rob_tail_in, // tail pointer, from ROB
    input [2:0][$clog2(`ROB_SIZE):0]   dest_rob_tag ,
    // Complete Stage
    input                           complete_en,
    input [2:0][$clog2(`ROB_SIZE):0]   CDB_rob_tag,
    input                           retire_en,
    input ROB_PACKET [2:0]          rob_packet_in,

    // Exception happen
    input                           clear_all,
    

    // Dispatch stage, read tags output
    output MT_PACKET [2:0] mt_packet,
    // output logic [$clog2(`ROB_SIZE)-1:0]    tag_out_1 [2:0], // rob number
    // output logic [$clog2(`ROB_SIZE)-1:0]    tag_out_2 [2:0],
    // output logic [2:0]                      ready_out_1, // ready "+" signal
    // output logic [2:0]                      ready_out_2,
    output logic [SIZE - 1:0]               check_ready // just for test complete stage
    
);

// map table entry
MT_ENTRY [SIZE - 1:0] mt_entry;

always_comb begin
    for(int i = 0; i < SIZE; i++)begin
        check_ready[i] = mt_entry[i].ready;
    end
end

always_comb begin
    if(dispatch_en) begin
        //READ: read rs1 tag and rs2 tag out
        for(int i=0;i<rob_dispatch_num;i++) begin // check each insn's rs
            mt_packet[i].mt_entry_1 = mt_entry[id_packet_in[i].source_reg_idx_in_1];
            mt_packet[i].mt_entry_2 = mt_entry[id_packet_in[i].source_reg_idx_in_2];
        end
    end
end


always_ff @(posedge clk)begin
    if(reset || clear_all)begin
        for(int i = 0; i < SIZE; i ++)begin
            mt_entry[i].rob_tag <= 0;
            mt_entry[i].ready <= 0;
        end
    end

    // ########## dispatch ##########
    if(dispatch_en) begin
        //WRITE: write rd ROB# in
        for(int i=0;i<rob_dispatch_num;i++) begin
                // ? do we need to determine it's a write into R0
                //if(id_packet_in[i].dest_reg_idx != 0)begin
                if(dest_rob_tag[i] >0) begin // dest rob tag valid
                    if(id_packet_in[i].dest_reg_idx != 0) begin
                        mt_entry[id_packet_in[i].dest_reg_idx].rob_tag    <= dest_rob_tag[i];
                        mt_entry[id_packet_in[i].dest_reg_idx].ready <= 1'b0;
                    end
                end
                // end else begin
                //     mt_entry[id_packet_in[i].dest_reg_idx].rob_tag   <= 0;
                //     mt_entry[id_packet_in[i].dest_reg_idx].ready <= 1'b0;
                // end
        end
    end

    // ########## complete ##########
    if(complete_en) begin
        // for(int i = 0; i < 3; i++) begin  // for all insn
        //     if(rob_packet_in[i].complete_reg_idx_out != 0) mt_entry[rob_packet_in[i].complete_reg_idx_out].ready <= 1'b1;
        // end

        for(int i =0;i<3;i++) begin
            for(int j =0;j<32;j++) begin
                // when new dispatch dest_reg_idx and old insn's complete happen together, dispatch prior
                //if((CDB_rob_tag[i] == mt_entry[j].rob_tag) &&(CDB_rob_tag[i] !=0)&&(id_packet_in[i].dest_reg_idx != j)&&(rob_packet_in[i].retire_R_out != j)) begin
                if((CDB_rob_tag[i] == mt_entry[j].rob_tag) &&(CDB_rob_tag[i] !=0)) begin
                    if((id_packet_in[i].valid && id_packet_in[i].dest_reg_idx == j)||rob_packet_in[i].retire_R_out == j) begin
                        mt_entry[j].ready <= 1'b0;
                    end else
                        mt_entry[j].ready <= 1'b1;
                end
            end
        end
    end

    // ########## retire ############
    if(retire_en)   begin
        for(int i = 0; i < 3; i++) begin
            // if this entry of retire does happen and the map table [reg, rob_tag] matches the retired rob entry [reg, rob_tag]
            // we set the rob tag to be 0(empty) and ready bit to 0
            if(rob_packet_in[i].retire_valid && (mt_entry[rob_packet_in[i].retire_R_out].rob_tag == rob_packet_in[i].retire_rob_tag_out)) begin
                mt_entry[rob_packet_in[i].retire_R_out].ready <= 0;
                mt_entry[rob_packet_in[i].retire_R_out].rob_tag <= 0;
            end
        end
    end

end
endmodule