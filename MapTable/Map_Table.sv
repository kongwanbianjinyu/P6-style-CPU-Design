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
logic [2:0] rob_dispatch_num_valid;
assign rob_dispatch_num_valid = (rob_dispatch_num == 0) ? 3'b000:
                                (rob_dispatch_num == 1) ? 3'b001:
                                (rob_dispatch_num == 2) ? 3'b011:3'b111;


logic [2:0] [2:0] conflict;
logic [2:0] [2:0] pass_valid;

logic [2:0] dispatch_valid, complete_valid, retire_valid;


always_comb begin
    for(int i = 0; i < 3; i ++) begin
        dispatch_valid[i] = rob_dispatch_num_valid[i] && dest_rob_tag[i] > 0 && id_packet_in[i].dest_reg_idx > 0 && id_packet_in[i].valid;
        complete_valid[i] = rob_packet_in[i].complete_reg_idx_out > 0 && mt_entry[rob_packet_in[i].complete_reg_idx_out].rob_tag == CDB_rob_tag[i] && CDB_rob_tag[i] > 0;
        retire_valid[i] = rob_packet_in[i].retire_valid && mt_entry[rob_packet_in[i].retire_R_out].rob_tag == rob_packet_in[i].retire_rob_tag_out;
    end
end

always_comb begin
    for(int i = 0; i < 3; i ++) begin
        conflict[i] = 3'b000;
        for(int j = 0; j < 3; j ++) begin
            if(dispatch_valid[i] && complete_valid[j] && id_packet_in[i].dest_reg_idx == rob_packet_in[j].complete_reg_idx_out) begin
             conflict[i][0] = 1'b1;
            end
            if(dispatch_valid[j] && complete_valid[i] && id_packet_in[j].dest_reg_idx == rob_packet_in[i].complete_reg_idx_out) begin
             conflict[i][0] = 1'b1;
            end
        end
        for(int j = 0; j < 3; j ++) begin
            if(dispatch_valid[i] && retire_valid[j] && id_packet_in[i].dest_reg_idx == rob_packet_in[j].retire_R_out) begin
             conflict[i][1] = 1'b1;
            end
            if(dispatch_valid[j] && retire_valid[i] && id_packet_in[j].dest_reg_idx == rob_packet_in[i].retire_R_out) begin
             conflict[i][1] = 1'b1;
            end
        end
        for(int j = 0; j < 3; j ++) begin
            if(complete_valid[i] && retire_valid[j] && rob_packet_in[i].complete_reg_idx_out == rob_packet_in[j].retire_R_out) begin
             conflict[i][2] = 1'b1;
            end
            if(complete_valid[j] && retire_valid[i] && rob_packet_in[j].complete_reg_idx_out == rob_packet_in[i].retire_R_out) begin
             conflict[i][2] = 1'b1;
            end
        end
        // conflict[i][0] = dispatch_valid[i] && complete_valid[i] && id_packet_in[i].dest_reg_idx == rob_packet_in[i].complete_reg_idx_out;
        // conflict[i][1] = dispatch_valid[i] && retire_valid[i] &&id_packet_in[i].dest_reg_idx == rob_packet_in[i].retire_R_out;
        // conflict[i][2] = complete_valid[i] && retire_valid[i] && rob_packet_in[i].complete_reg_idx_out == rob_packet_in[i].retire_R_out;

        pass_valid[i] = (conflict[i] == 3'b111) ? 3'b001 :
                        (conflict[i] == 3'b001) ? 3'b101 :
                        (conflict[i] == 3'b010) ? 3'b011 :
                        (conflict[i] == 3'b100) ? 3'b011 :
                        (conflict[i] == 3'b000) ? 3'b111 : 3'b000;
    end
end

always_comb begin
    for(int i = 0; i < SIZE; i++)begin
        check_ready[i] = mt_entry[i].ready;
    end
end

always_comb begin
    if(dispatch_en) begin
        //READ: read rs1 tag and rs2 tag out
        for(int i=0;i<3;i++) begin // check each insn's rs
            if(rob_dispatch_num_valid[i])begin
                mt_packet[i].mt_entry_1 = mt_entry[id_packet_in[i].source_reg_idx_in_1];
                mt_packet[i].mt_entry_2 = mt_entry[id_packet_in[i].source_reg_idx_in_2];
            end
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
    else begin
        for(int i = 0; i < 3; i ++) begin
            if(dispatch_valid[i] && pass_valid[i][0]) begin
                mt_entry[id_packet_in[i].dest_reg_idx].rob_tag    <= dest_rob_tag[i];
                mt_entry[id_packet_in[i].dest_reg_idx].ready <= 1'b0;
            end

            if(complete_valid[i] && pass_valid[i][1]) begin
                mt_entry[rob_packet_in[i].complete_reg_idx_out].ready <= 1'b1;
            end
            if(retire_valid[i] && pass_valid[i][2]) begin
                mt_entry[rob_packet_in[i].retire_R_out].ready <= 0;
                mt_entry[rob_packet_in[i].retire_R_out].rob_tag <= 0;
            end
            
        end
    end
end
endmodule