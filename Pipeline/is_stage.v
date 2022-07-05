/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  is_stage.v                                          //
//                                                                     //
//  Description :  instruction issue (IS) stage of the pipeline;       //
//                 issue the instructions from RS and record it on the //
//                 IS/EX pipeline register                             //
//                 Should support 3-ways superscalar(fetch 3 insns)    //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps
module is_stage (
    input RS_ENTRY [2:0] rs_entry, // the selected rs_entry which can issue
    input [2:0]          permit_issue, // indicate whether the 3 insns are valid 

    output IS_EX_PACKET [2:0] is_packet_out 

);
    // Pass-throughs rs_entry
    always_comb begin
        for (int i=0 ; i<3;i++) begin
            is_packet_out[i].RS_tag = rs_entry[i].RS_tag;
            is_packet_out[i].rob_tag =  rs_entry[i].T;
            is_packet_out[i].OPA =  rs_entry[i].V1;
            is_packet_out[i].OPB =  rs_entry[i].V2;
            is_packet_out[i].alu_func = rs_entry[i].alu_func;
            is_packet_out[i].inst = rs_entry[i].inst;
            is_packet_out[i].issue_valid = permit_issue[i];
            is_packet_out[i].NPC = rs_entry[i].NPC;
        end
    end


endmodule