/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  ROB.v                                               //
//                                                                     //
//  Description :  Re-order buffer of the P6 architure;                //
//                 Support 3-way superscalar execution;                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

// ? what bit can we use to set a var to be invalid. Does [X, Z, -1] work?
`timescale 1ns/100ps
module ROB #(parameter SIZE=63) ( //SIZE is {ROB1:ROBSIZE}, ROB_SIZE is register number
    input                          clk,reset,
    // Dispatch stage input
    input                          dispatch_en,
    // TODO: change it when integrate into pipeline
    input ID_IP_PACKET [2:0]             id_packet_in ,      // 3-way instruction in
    input MT_PACKET [2:0]                mt_packet_in,
    // input DEST_REG_SEL          dest_reg_select [2:0],      // from decoder
    //input  [2:0][4:0]                   dest_reg_idx_in,        // destination register from inst
    input  [$clog2(`NUM_RS):0]          RS_available_size,             // valid instruction number : 0,1,2,3, from RS
    // input [2:0]                 map_table_tag_ready,        // from map table, +

    // Complete stage input
    input                          complete_en,
    input [2:0][`XLEN-1:0]  alu_result_in,
    input  [2:0][$clog2(`ROB_SIZE):0]  CDB_rob_tag ,          // CDB tag

    input  [2:0][31:0]                  CDB_value ,            // CDB value
    input  [2:0]                        CDB_halt,

    // Retire stage input
    input                          retire_en,

    // Precise Exception
    input EX_IC_PACKET [2:0]        ex_ic_packet_in,
    //input  [2:0][1:0]                   exception_en, // exception_en[0]: LSQ exception; exception_en[1]: Branch exception;
    // input  [1:0][$clog2(ROB_SIZE)-1:0]  exception_rob_tag ,       // which insn in rob have exception.(e.g. ROB#3). Shoule come from LSQ or branch(select the least ROB#)


    //input ID_EX_PACKET          id_packet_in[2:0],   // exception signal from Branch taken
    output ROB_PACKET [2:0] rob_packet_out,
    output logic [1:0] dispatch_num,
    output logic clear_all,
    output logic [1:0] retire_num,
    output ROB_ENTRY [`ROB_SIZE-1:0]     rob_entry_test, // just for test
    output logic [`XLEN - 1:0] branch_PC,
    output logic [$clog2(`ROB_SIZE)-1:0] rob_head
);

// sturcture register
logic [$clog2(`ROB_SIZE)-1:0] head;          // head pointer
logic [$clog2(`ROB_SIZE)-1:0] tail;          // tail pointer

assign rob_head = head;

// ! here we have ROB_SIZE rob_entry as we need one dummy row as the strarting point
ROB_ENTRY [`ROB_SIZE-1:0] rob_entry;


// variable
logic [$clog2(`ROB_SIZE)-1:0]    rob_remain_size;       // remain size in rob
logic [$clog2(`ROB_SIZE):0]      dispatch_num_temp;
logic [2:0]                      dispatch_num_valid;
logic [2:0]                     retire_num_valid;
logic [$clog2(`ROB_SIZE)-1:0]    next_head;             // next head pointer
logic [$clog2(`ROB_SIZE)-1:0]    next_tail;             // next tail pointer
logic [1:0]                      id_packet_valid_size; // packet valid size {0,1,2,3}


// just for test
always_comb begin
    for(int i=0;i<`ROB_SIZE;i++)begin
        rob_entry_test[i] = rob_entry[i];
    end
end

// rob remain size according to tail head which one is larger
// we use idx as dummy head that represents the state of reset
assign   rob_remain_size =     (head ==  0)    ?   SIZE:
                                (tail >= head)  ?   (SIZE - (tail - head + 1)) :
                                (tail ==  head- 1 ) ? SIZE : (head - tail - 1);


assign id_packet_valid_size =   !id_packet_in[0].valid ? 0 :
                                !id_packet_in[1].valid ? 1 :
                                !id_packet_in[2].valid ? 1 : 3;


// ########## dispatch #############
// determine where next head is pointed at
always_comb begin
    for(int i = 0; i < 3; i ++) begin
        rob_packet_out[i].dispatch_value_out_1 = 0;
        rob_packet_out[i].dispatch_value_out_2 = 0;
        rob_packet_out[i].assigned_rob_tag = 0;
    end
    if(dispatch_en) begin
        //  dispatch_num = min(rob_remain,RS_available_size,id_packet_valid_size)
        dispatch_num_temp   =   (rob_remain_size < RS_available_size) ? rob_remain_size : RS_available_size;
        dispatch_num   =   (dispatch_num_temp < id_packet_valid_size) ? dispatch_num_temp : id_packet_valid_size;

        dispatch_num_valid = (dispatch_num == 0) ? 3'b000 :
                             (dispatch_num == 1) ? 3'b001 :
                             (dispatch_num == 2) ? 3'b011 : 3'b111;

        
    
        // when map table ready, output V to rob.v
        for (int i = 0; i< 3; i++)begin
            if(dispatch_num_valid[i])begin
            // if (map_table_tag_ready [i])
            // TODO: set for immediate value
            //if(rob_entry[mt_packet_in[i].mt_entry_1.rob_tag].complete)begin
                rob_packet_out[i].dispatch_value_out_1 = rob_entry[mt_packet_in[i].mt_entry_1.rob_tag].reg_val;
            //end
            //if(rob_entry[mt_packet_in[i].mt_entry_2.rob_tag].complete) begin
                rob_packet_out[i].dispatch_value_out_2 = rob_entry[mt_packet_in[i].mt_entry_2.rob_tag].reg_val;
            //end
            // TODO: add rob_tag output to map table here
                rob_packet_out[i].assigned_rob_tag = (tail + i) % SIZE + 1;
            end
        end

        next_tail = (dispatch_num == 0) ? tail: ((tail + dispatch_num - 1 ) % SIZE + 1);
    end
    
    
end


// ########## complete ##########
always_comb begin
    for(int i = 0;i < 3; i++) begin
        rob_packet_out[i].complete_reg_idx_out = 0;
    end
    for(int i = 0; i < 3; i ++) begin
        if(CDB_rob_tag[i] > 0) begin
            rob_packet_out[i].complete_reg_idx_out = rob_entry[CDB_rob_tag[i]].reg_idx;
        end
    end
end


// ######### retire #############
always_comb begin
    // only head complete finish can retire
    retire_num_valid[0] = rob_entry[(head - 1) % SIZE + 1].complete;
    retire_num_valid[1] = rob_entry[(head - 1) % SIZE + 1].complete && !rob_entry[(head - 1) % SIZE + 1].exception &&
                          rob_entry[(head) % SIZE + 1].complete;
    retire_num_valid[2] = rob_entry[(head - 1) % SIZE + 1].complete && !rob_entry[(head - 1) % SIZE + 1].exception &&
                          rob_entry[(head) % SIZE + 1].complete && !rob_entry[(head) % SIZE + 1].exception &&
                          rob_entry[(head + 1) % SIZE + 1].complete;
    retire_num = retire_num_valid == 3'b111 ? 3 :
                 retire_num_valid == 3'b011 ? 2 :
                 retire_num_valid == 3'b001 ? 1 : 0;
    clear_all = (rob_entry[(head - 1) % SIZE + 1].exception && retire_num == 1) || (rob_entry[(head) % SIZE + 1].exception && retire_num == 2) || (rob_entry[(head + 1) % SIZE + 1].exception && retire_num == 3);
    next_head = (head + retire_num - 1) % SIZE + 1;
    branch_PC = (retire_num_valid == 3'b001 && rob_entry[(head - 1) % SIZE + 1].exception) ? rob_entry[(head - 1) % SIZE + 1].alu_result :
                (retire_num_valid == 3'b011 && rob_entry[(head) % SIZE + 1].exception) ? rob_entry[(head) % SIZE + 1].alu_result :
                (retire_num_valid == 3'b111 && rob_entry[(head + 1) % SIZE + 1].exception) ? rob_entry[(head + 1) % SIZE + 1].alu_result : 0;
    //         clear_all = 1;
    //         break;
    //     end
    // end


    // retire value output
    // clear the packet firstly
    for (int i = 0; i < 3; i++)begin
        // retire stage output
        rob_packet_out[i].retire_R_out = 0;
        rob_packet_out[i].retire_V_out = 0;
        rob_packet_out[i].retire_rob_tag_out = 0;
        rob_packet_out[i].retire_valid = 0;
        rob_packet_out[i].halt = 0;
        //logic                        	clear_all; // when exception happens, clear all ROB/RS/Map_Table
        //for test
        rob_packet_out[i].inst = `NOP;
        rob_packet_out[i].NPC = 0;
    end
    // then pass the rob_entry
    for (int i = 0; i < 3; i++)begin
        if(retire_num_valid[i])begin
            rob_packet_out[i].retire_R_out = rob_entry[(head + i - 1) % SIZE + 1].reg_idx;
            rob_packet_out[i].retire_V_out = rob_entry[(head + i - 1 ) % SIZE + 1].reg_val;
            rob_packet_out[i].retire_valid = rob_entry[(head + i - 1 ) % SIZE + 1].valid;
            rob_packet_out[i].retire_rob_tag_out = (head + i - 1) % SIZE + 1;
            rob_packet_out[i].NPC = rob_entry[(head + i - 1 ) % SIZE + 1].NPC;
            rob_packet_out[i].inst = rob_entry[(head + i - 1 ) % SIZE + 1].inst;
            rob_packet_out[i].halt = rob_entry[(head + i - 1 ) % SIZE + 1].halt;
        end
    end

end



// always_comb begin
//     for(int i=0;i<3;i++) begin
// 		case (dest_reg_select[i])
// 			DEST_RD:    dest_reg_idx_in[i] = if_id_packet_in[i].inst.r.rd;
// 			DEST_NONE:  dest_reg_idx_in[i] = `ZERO_REG;
// 			default:    dest_reg_idx_in[i] = `ZERO_REG;
// 		endcase
//     end
// end

// synopsys sync_set_reset "reset"
always_ff @(posedge clk) begin
    // reset
    if(reset || clear_all)begin
        // head tail zero means no rob_entry in rob
        head <= `SD 0;
        tail <= `SD 0;
        //clear_all <= 0 ;
        // reset every row
        // ? should we reset value for reg_idx and reg_val
        for(int i = 0; i <  `ROB_SIZE; i ++)begin
            rob_entry[i].exception  <= `SD 0;
            rob_entry[i].complete   <= `SD 0;
            rob_entry[i].valid      <= `SD 0;
            rob_entry[i].reg_idx    <= `SD 0;
            rob_entry[i].reg_val    <= `SD 0;
            rob_entry[i].inst       <= `SD `NOP;
            rob_entry[i].halt       <= `SD 0;
            rob_entry[i].NPC        <= `SD 0;
        end
    end
    else begin
         // head pointer move
        if(head != 0) head <= `SD next_head;
        // head tail pointer move
        if(head == 0 && dispatch_num !=0) begin
            head <= `SD 1;
        end
        tail <= `SD next_tail;

        // ########## dispatch ##########
        if(dispatch_en)begin
            // dest reg record in R
            for (int i = 0; i < 3; i++)begin // i = 1:dispatch_num
                if(dispatch_num_valid[i])begin
                    rob_entry[(tail + i) % SIZE + 1].reg_idx <= `SD id_packet_in[i].dest_reg_idx;
                    rob_entry[(tail + i) % SIZE + 1].NPC<= `SD id_packet_in[i].NPC; //////for test
                    rob_entry[(tail + i) % SIZE + 1].inst<= `SD id_packet_in[i].inst;
                    rob_entry[(tail + i) % SIZE + 1].valid<= `SD id_packet_in[i].valid;
                end
            end
        end

        // ########## complete ##########
        if(complete_en)begin
            // receive CDB.value and save it in V[CDB.tag], set complete_finish[CDB.tag] = 1
            for (int i = 0; i < 3 ; i++)begin
                if(CDB_rob_tag[i] != 0) begin
                    rob_entry[CDB_rob_tag[i]].reg_val <= `SD CDB_value[i];
                    rob_entry[CDB_rob_tag[i]].complete <= `SD 1'b1;
                    rob_entry[CDB_rob_tag[i]].halt <= `SD CDB_halt[i];
                    rob_entry[CDB_rob_tag[i]].alu_result <= `SD alu_result_in[i];
                end
            end
        end

        // ! remember to reset exception_en after one cycle
        for(int i = 0; i < 3; i ++)begin
            if((ex_ic_packet_in[i].take_branch) && (ex_ic_packet_in[i].rob_tag != 0)&& (ex_ic_packet_in[i].exe_valid)) begin
                rob_entry[ex_ic_packet_in[i].rob_tag].exception <= `SD 1'b1;
            end
        end

        // ########## retire ##########
        if(retire_en) begin
            // if head point to exception, clear all
                for (int i = 0; i < 3; i++)begin
                    if(retire_num_valid[i]) begin
                        rob_entry[(head + i - 1) % SIZE + 1].complete <= `SD 0; // clear rob
                        rob_entry[(head + i - 1) % SIZE + 1].exception <= `SD 0;
                        rob_entry[(head + i - 1) % SIZE + 1].valid    <= `SD 0;
                    end
                end
        end
    end
end

endmodule