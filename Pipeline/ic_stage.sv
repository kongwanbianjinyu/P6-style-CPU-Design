/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  ic_stage.v                                          //
//                                                                     //
//  Description :  instruction complete (IC) stage of the pipeline;    //
//                 boardcast the rob_tag and alu_result on CDB         //
//                 Should support 3-ways superscalar(complete 3 insns) //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps


module ic_stage(
    input clock,
    input reset,
    input EX_IC_PACKET [2:0] ex_ic_packet_in,
    input clear_all,
    //xyz 4/4
    input [`XLEN-1:0] lsq2cdb_value,
    input [$clog2(`ROB_SIZE):0]     lsq2cdb_rob,
    // alu R/V
    output logic [2:0][$clog2(`ROB_SIZE):0]  CDB_rob_tag,
    output logic [2:0][31:0]                  CDB_value,
    output logic [2:0]                         CDB_halt,

    // complete insns number
    output logic [1:0]                   complete_num,
    output logic [`XLEN-1:0]             branch_PC
);


always_comb begin
    if(reset || clear_all) begin
        for (int i = 0; i < 3; i++) CDB_rob_tag[i] = 0;
    end
    else begin
        // clear CDB first
        complete_num = 0;
        for (int i = 0; i < 3; i++) CDB_rob_tag[i] = 0;
        
        // handle branch exception
        //do not use num, use valid??
        for (int i = 0; i < 3; i++) begin
            if(ex_ic_packet_in[i].exe_valid) begin//normal complete, not ST or LD
                if (!ex_ic_packet_in[i].rd_mem & !ex_ic_packet_in[i].wr_mem) begin
                    // if take branch, store next pc value to register. otherwise store the alu result
                    CDB_value[i] = ex_ic_packet_in[i].take_branch ? ex_ic_packet_in[i].NPC : ex_ic_packet_in[i].alu_result;
                    CDB_rob_tag[i]  = ex_ic_packet_in[i].rob_tag;
                    CDB_halt[i] = ex_ic_packet_in[i].halt;
                end

                // calculate branch target PC when branch complete
                if(ex_ic_packet_in[i].take_branch) begin
                    branch_PC = ex_ic_packet_in[i].alu_result;
                end
            end
        end
        if (lsq2cdb_rob > 0)begin
            CDB_value[2] = lsq2cdb_value;
            CDB_rob_tag[2] = lsq2cdb_rob;
        end
        for (int i = 0; i < 3; i++)begin
            if (CDB_rob_tag[i] > 0)begin
                complete_num += 1;
            end
        end
    end
end


endmodule