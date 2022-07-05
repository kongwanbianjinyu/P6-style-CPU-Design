/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  RS.v                                                //
//                                                                     //
//  Description :  Reservation Station of the P6 architure;            //
//                 Support 3-way superscalar execution;
//                 contain FU of LD(*3), ST(*3), ALU(*10) 16 entries   //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module RS(
    input clk,reset,
    // Dispatch stage input
    input                           dispatch_en,
    //input [6:0]                     opcode [2:0],           // opcode of the 3 insns
    input ID_IP_PACKET [2:0]        id_packet_in,
    input MT_PACKET [2:0]           mt_packet_in,
    input ROB_PACKET [2:0]          rob_packet_in,

    // Issue stage input
    input                           issue_en,

    // Execute stage input
    input                           execute_en,
    input                           ex_stage_stall,
    //input [$clog2(`ROB_SIZE)-1:0]   execute_rob_tag [2:0],  // which insn in ROB what to execute
    input IS_EX_PACKET [2:0]        is_ex_packet_in,

    // Complete stage input
    input                                complete_en,
    input [2:0][$clog2(`ROB_SIZE):0]   CDB_rob_tag,           //CDB tag
    input [2:0][31:0]                    CDB_value,         // CDB value
    input [1:0]                          complete_num,

    // Exception happen
    input                                clear_all,

    //input [$clog2(`LQ_SIZE):0]           LQ_tail_in,
    //input [$clog2(`SQ_SIZE):0]           SQ_tail_in,

    // Dispatch stage output
    output logic [$clog2(`NUM_RS):0]     RS_available_size,      // RS available size, {0 - 16}
    // output logic [2:0][4:0]         RS_idx_test, // RS idx for test

    // Issue Stage output
    output RS_PACKET [2:0]          rs_packet_out,
    output logic   [1:0]            issue_num  // issue number  {0,1,2,3}


);

// structure register table
RS_ENTRY [`NUM_RS-1:0] rs_entry;

// FU      fu_name [2:0];
logic   [2:0][$clog2(`NUM_RS)-1:0] dispatch_idx_from_pe;  // record which RS the insn use when dispatch.(eg [1,4,7]) from 0-15
logic   [2:0][$clog2(`NUM_RS)-1:0] issue_idx_from_pe ; //0-15
logic   [2:0][$clog2(`NUM_RS)-1:0] dispatch_idx;  // record which RS the insn use when dispatch.(eg [1,4,7]) from 0-15
logic   [2:0][$clog2(`NUM_RS)-1:0] issue_idx ; //0-15

logic   [1:0]  id_packet_valid_size; // packet valid size {0,1,2,3}
logic   [1:0] dispatch_num; // dispatch number  {0,1,2,3}
logic   [2:0] dispatch_num_valid;//for for-loop synth



// p-selector for dispatch
logic [`NUM_RS - 1:0] dispatch_req;
logic [`NUM_RS - 1:0] dispatch_gnt;
logic [(`NUM_RS * 3) - 1:0] dispatch_gnt_bus;
logic dispatch_empty;

// p-selector for issue
logic [`NUM_RS - 1:0] issue_req;
logic [`NUM_RS - 1:0] issue_gnt;
logic [(`NUM_RS * 3) - 1:0] issue_gnt_bus;
logic issue_empty;


logic [$clog2(`NUM_RS):0] want_to_issue_num; //{0-16}
logic [2:0]               issue_num_valid;//for for-loop synth


logic [2:0] find_V1_in_CDB;
logic [2:0][1:0] V1_in_CDB_index;

logic [2:0]find_V2_in_CDB;
logic [2:0][1:0] V2_in_CDB_index;

assign id_packet_valid_size =   !id_packet_in[0].valid ? 0 :
                                !id_packet_in[1].valid ? 1 :
                                !id_packet_in[2].valid ? 1 : 3;

// calculate dispatch number = min(id_packet_valid_size,RS_available_size)
assign dispatch_num        =   (RS_available_size < id_packet_valid_size) ? RS_available_size : id_packet_valid_size;

assign dispatch_num_valid =  (dispatch_num == 0) ? 3'b000 :
                             (dispatch_num == 1) ? 3'b001 :
                             (dispatch_num == 2) ? 3'b011 : 3'b111;

// calculate issue number = min(3,want_to_issue_num)
assign issue_num = (want_to_issue_num < 3) ? want_to_issue_num : 3;
assign issue_num_valid =  (issue_num == 0) ? 3'b000 :
                          (issue_num == 1) ? 3'b001 :
                          (issue_num == 2) ? 3'b011 : 3'b111;

// priority selector for dispatch
psel_gen #(.REQS(3), .WIDTH(`NUM_RS)) psel_dispatch
    (.req(dispatch_req),
      .gnt(dispatch_gnt),
      .gnt_bus(dispatch_gnt_bus),
      .empty(dispatch_empty)
    );


// priority selector for issue
psel_gen #(.REQS(3), .WIDTH(`NUM_RS)) psel_issue
    (.req(issue_req),
      .gnt(issue_gnt),
      .gnt_bus(issue_gnt_bus),
      .empty(issue_empty)
    );

// dispatch : calculate RS available size
num_ones #(.WIDTH(`NUM_RS)) dispatch_slots_sum
(.A(dispatch_req),
.ones(RS_available_size));

// issue : calculate want to issue number
num_ones #(.WIDTH(`NUM_RS)) issue_slots_sum
(.A(issue_req),
 .ones(want_to_issue_num));

// TODO: verify correctness
pe #(.OUTWIDTH(4), .INWIDTH(16)) dispatch_encoder [2:0] 
(.gnt(dispatch_gnt_bus),
.enc(dispatch_idx_from_pe));

pe  #(.OUTWIDTH(4), .INWIDTH(16)) issue_encoder [2:0]
(.gnt(issue_gnt_bus),
.enc(issue_idx_from_pe));



// calculate right RS index

always_comb begin
    for(int i = 0; i < 3; i++) begin
        dispatch_idx[i] = 0;
        issue_idx[i] = 0;
        rs_packet_out[i].valid = 1'b0;
    end

    // ########## dispatch ##########
    // calculator req bit for priority selector -> pass to ps
    if(dispatch_en) begin
        // if not busy, request for dispatch
        for (int i = 0; i < `NUM_RS; i++) begin
            dispatch_req[i] = !rs_entry[i].busy;
        end

        dispatch_idx = dispatch_idx_from_pe;
        // // get from ps, calculate issue idx
        // for(int i = 0; i < 3; i ++) begin
        //     if(dispatch_gnt_bus[(i + 1) * `NUM_RS-1 -: `NUM_RS] != 0) begin
        //         dispatch_idx[i] = $clog2(dispatch_gnt_bus[(i + 1) * `NUM_RS-1 -: `NUM_RS]);
        //     end
        // end

        // search CDB for V1,V2
        for(int i = 0;i < 3; i++) begin
            if(id_packet_in[i].valid) begin
                find_V1_in_CDB[i] = 0;
                if((id_packet_in[i].opa_select == OPA_IS_RS1 || id_packet_in[i].cond_branch) && mt_packet_in[i].mt_entry_1.rob_tag > 0) begin
                    for(int j = 0; j < 3; j++) begin
                        if(CDB_rob_tag[j] > 0 && CDB_rob_tag[j]==mt_packet_in[i].mt_entry_1.rob_tag) begin
                            find_V1_in_CDB[i] = 1;
                            V1_in_CDB_index[i] = j;
                        end
                    end
                end

                // search CDB for V2
                find_V2_in_CDB[i] = 0;
                if((id_packet_in[i].opb_select == OPB_IS_RS2 || id_packet_in[i].wr_mem || id_packet_in[i].cond_branch) && mt_packet_in[i].mt_entry_2.rob_tag > 0) begin
                    for(int j = 0; j < 3; j++) begin
                        if(CDB_rob_tag[j] > 0 && CDB_rob_tag[j]==mt_packet_in[i].mt_entry_2.rob_tag) begin
                            find_V2_in_CDB[i] = 1;
                            V2_in_CDB_index[i] = j;
                        end
                    end
                end
            end else begin
                find_V1_in_CDB[i] = 0;
                find_V2_in_CDB[i] = 0;
            end
        end

    end
    // ########## issue ##########
    if(issue_en)begin
        // issue request: busy & T1 T2 zero & haven't been issued
        for(int i = 0;i < `NUM_RS; i++) begin // search for 16 RS entries
            issue_req[i] = rs_entry[i].busy && ((rs_entry[i].T1 == 0) && (rs_entry[i].T2 == 0)) && (rs_entry[i].already_issue == 0);
        end
        
        issue_idx = issue_idx_from_pe;

        // // get from ps, calculate issue idx
        // for(int i = 0; i < 3; i ++) begin
        //     if(issue_gnt_bus[(i + 1) * `NUM_RS-1 -: `NUM_RS] != 0) begin
        //         issue_idx[i] = $clog2(issue_gnt_bus[(i + 1) * `NUM_RS-1 -: `NUM_RS]);
        //     end

        // end

        // issue rs out
        // first clear all 3 packet
        for(int i = 0; i < 3; i++) begin
            rs_packet_out[i].rs_entry.NPC = 0;
            rs_packet_out[i].rs_entry.inst = `NOP;
            rs_packet_out[i].valid = 1'b0;
        end
        // then issue issue_num's insn
        for(int i = 0; i < 3; i++) begin  // want to issue at most 3 insns
            if(issue_num_valid[i])begin
                // send the value out to FU
                rs_packet_out[i].rs_entry = rs_entry[issue_idx[i]];
                rs_packet_out[i].valid = 1'b1;
            end
        end
    end
end

// synopsys sync_set_reset "reset"
always_ff @(posedge clk) begin
    if(reset || clear_all)begin
        for(int i = 0; i < `NUM_RS;i++) begin
            rs_entry[i].RS_tag  <= `SD i;
            rs_entry[i].busy    <= `SD 0;
            rs_entry[i].T       <= `SD 0;
            rs_entry[i].T1      <= `SD 0;
            rs_entry[i].T2      <= `SD 0;
            rs_entry[i].already_issue      <= `SD 0;
            // set rs_entry.busy
            // set NPC
            rs_entry[i].NPC <= `SD 0;
            // set PC
            rs_entry[i].PC <= `SD 0;
            // set inst
            rs_entry[i].inst <= `SD 0;
            // set halt
            rs_entry[i].halt <= `SD 0;
            // set alu_func
            rs_entry[i].alu_func <= `SD ALU_ADD;
            // set cond_branch
            rs_entry[i].cond_branch <= `SD 0;
            // set uncond_branch
            rs_entry[i].uncond_branch<= `SD 0;
            // set opa_select
            rs_entry[i].opa_select <= `SD OPA_IS_RS1;
            // set opb_select
            rs_entry[i].opb_select <= `SD OPB_IS_RS2;
            // set rd_mem
            rs_entry[i].rd_mem <= `SD 0;
            // set wr_mem
            rs_entry[i].wr_mem <= `SD 0;

        end
    end
    else begin
        // ########## dispatch ##########
        if(dispatch_en) begin
            // set tag value in dispatch_idx
            for(int i = 0;i < 3; i++) begin // for each insn we can dispatch
                if(dispatch_num_valid[i])begin                
                    // set rs_entry.T to be the ROB#
                    rs_entry[dispatch_idx[i]].T <= `SD rob_packet_in[i].assigned_rob_tag;
                    // set rs_entry.busy
                    rs_entry[dispatch_idx[i]].busy <= `SD 1'b1;
                    // set NPC
                    rs_entry[dispatch_idx[i]].NPC <= `SD id_packet_in[i].NPC;
                    // set PC
                    rs_entry[dispatch_idx[i]].PC <= `SD id_packet_in[i].PC;
                    // set inst
                    rs_entry[dispatch_idx[i]].inst <= `SD id_packet_in[i].inst;
                    // set halt
                    rs_entry[dispatch_idx[i]].halt <= `SD id_packet_in[i].halt;
                    // set alu_func
                    rs_entry[dispatch_idx[i]].alu_func <= `SD id_packet_in[i].alu_func;
                    // set cond_branch
                    rs_entry[dispatch_idx[i]].cond_branch <= `SD id_packet_in[i].cond_branch;
                    // set uncond_branch
                    rs_entry[dispatch_idx[i]].uncond_branch<= `SD id_packet_in[i].uncond_branch;
                    // set opa_select
                    rs_entry[dispatch_idx[i]].opa_select <= `SD id_packet_in[i].opa_select;
                    // set opb_select
                    rs_entry[dispatch_idx[i]].opb_select <= `SD id_packet_in[i].opb_select;
                    // set rd_mem
                    rs_entry[dispatch_idx[i]].rd_mem <= `SD id_packet_in[i].rd_mem;
                    // set wr_mem
                    rs_entry[dispatch_idx[i]].wr_mem <= `SD id_packet_in[i].wr_mem;

                    //rs_entry[dispatch_idx[i]].load_pos <= LQ_tail_in;
                    //rs_entry[dispatch_idx[i]].store_pos <= SQ_tail_in;




                    // set T1/T2 or V1/V2 according to the hit and ready "+" bit
                    if(id_packet_in[i].opa_select == OPA_IS_RS1 || id_packet_in[i].cond_branch) begin
                        if(mt_packet_in[i].mt_entry_1.rob_tag > 0) begin
                            if(find_V1_in_CDB[i] == 1) begin
                                rs_entry[dispatch_idx[i]].V1 <= `SD CDB_value[V1_in_CDB_index[i]];
                                rs_entry[dispatch_idx[i]].T1 <= `SD 0;
                            end else if (mt_packet_in[i].mt_entry_1.ready)begin
                                rs_entry[dispatch_idx[i]].V1 <= `SD rob_packet_in[i].dispatch_value_out_1;             // use value from ROB
                                rs_entry[dispatch_idx[i]].T1 <= `SD 0;
                            end else begin
                                rs_entry[dispatch_idx[i]].T1 <= `SD mt_packet_in[i].mt_entry_1.rob_tag;     // just copy the tag
                            end
                        end else if( mt_packet_in[i].mt_entry_1.rob_tag == 0)begin
                            rs_entry[dispatch_idx[i]].V1 <= `SD id_packet_in[i].rs1_value;             // use value from RRF
                            rs_entry[dispatch_idx[i]].T1 <= `SD 0;
                        end
                    end else begin // OPA not RS1, just issue, don't need to set tag
                            rs_entry[dispatch_idx[i]].V1 <= `SD id_packet_in[i].rs1_value;
                            rs_entry[dispatch_idx[i]].T1 <= `SD 0;
                    end



                    // the same thing for T2/V2
                    // set T1/T2 or V1/V2 according to the hit and ready "+" bit
                    if(id_packet_in[i].opb_select == OPB_IS_RS2 || id_packet_in[i].wr_mem || id_packet_in[i].cond_branch) begin
                        if(mt_packet_in[i].mt_entry_2.rob_tag > 0) begin
                            if(find_V2_in_CDB[i] == 1) begin
                                rs_entry[dispatch_idx[i]].V2 <= `SD CDB_value[V2_in_CDB_index[i]];
                                rs_entry[dispatch_idx[i]].T2 <= `SD 0;
                            end else if (mt_packet_in[i].mt_entry_2.ready)begin
                                rs_entry[dispatch_idx[i]].V2 <= `SD rob_packet_in[i].dispatch_value_out_2;             // use value from ROB
                                rs_entry[dispatch_idx[i]].T2 <= `SD 0;
                            end else begin
                                rs_entry[dispatch_idx[i]].T2 <= `SD mt_packet_in[i].mt_entry_2.rob_tag;     // just copy the tag
                            end
                        end else if( mt_packet_in[i].mt_entry_2.rob_tag == 0)begin
                            rs_entry[dispatch_idx[i]].V2 <= `SD id_packet_in[i].rs2_value;             // use value from RRF
                            rs_entry[dispatch_idx[i]].T2 <= `SD 0;
                        end
                    end else begin // OPA not RS1
                            rs_entry[dispatch_idx[i]].V2 <= `SD id_packet_in[i].rs2_value;
                            rs_entry[dispatch_idx[i]].T2 <= `SD 0;
                    end
                end
            end
        end
        // ########## issue ##########

        // after issued, set already_issue to be 1;
        if(issue_en) begin
            for(int i = 0; i < 3;i++)begin
                if(!ex_stage_stall && issue_num_valid[i])begin
                    rs_entry[issue_idx[i]].already_issue <= `SD 1'b1;
                end
            end
        end

        // ########## execute ##########
        if(execute_en) begin
            for(int i = 0; i < 3;i++)begin
                if(is_ex_packet_in[i].issue_valid) begin
                    // clear RS entry
                    rs_entry[is_ex_packet_in[i].RS_tag].busy <= `SD 1'b0;
                    rs_entry[is_ex_packet_in[i].RS_tag].T    <= `SD 0;
                    rs_entry[is_ex_packet_in[i].RS_tag].T1   <= `SD 0;
                    rs_entry[is_ex_packet_in[i].RS_tag].T2   <= `SD 0;
                    rs_entry[is_ex_packet_in[i].RS_tag].already_issue   <= `SD 0;
                end
            end
        end

        // ########## complete ##########
        if(complete_en) begin
            for(int i = 0;i < 3;i++) begin
                for(int j = 0;j < `NUM_RS;j++) begin
                    if(rs_entry[j].busy && (rs_entry[j].T1 == CDB_rob_tag[i]) && (rs_entry[j].T1 > 0)) begin// find match of T1
                        rs_entry[j].T1 <= `SD 0;
                        rs_entry[j].V1 <= `SD CDB_value[i];
                    end
                end
                for(int j = 0;j < `NUM_RS;j++) begin
                    if(rs_entry[j].busy && (rs_entry[j].T2 == CDB_rob_tag[i]) && (rs_entry[j].T2 > 0)) begin// find match of rs_entry.T2
                        rs_entry[j].T2 <= `SD 0;
                        rs_entry[j].V2 <= `SD CDB_value[i];
                    end
                end
            end
        end
    end
end


endmodule