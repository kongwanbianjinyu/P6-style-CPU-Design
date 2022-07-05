`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module RS_svsim(
    input clk,reset,
        input                           dispatch_en,
        input ID_IP_PACKET [2:0]        id_packet_in,
    input MT_PACKET [2:0]           mt_packet_in,
    input ROB_PACKET [2:0]          rob_packet_in,

        input                           issue_en,

        input                           execute_en,
    input                           ex_stage_stall,
        input IS_EX_PACKET [2:0]        is_ex_packet_in,

        input                                complete_en,
    input [2:0][$clog2(64):0]   CDB_rob_tag,               input [2:0][31:0]                    CDB_value,             input [1:0]                          complete_num,

        input                                clear_all,

        
        output logic [$clog2(16):0]     RS_available_size,          
        output RS_PACKET [2:0]          rs_packet_out,
    output logic   [1:0]            issue_num  

);



  RS RS( {>>{ clk }}, {>>{ reset }}, {>>{ dispatch_en }}, {>>{ id_packet_in }}, 
        {>>{ mt_packet_in }}, {>>{ rob_packet_in }}, {>>{ issue_en }}, 
        {>>{ execute_en }}, {>>{ ex_stage_stall }}, {>>{ is_ex_packet_in }}, 
        {>>{ complete_en }}, {>>{ CDB_rob_tag }}, {>>{ CDB_value }}, 
        {>>{ complete_num }}, {>>{ clear_all }}, {>>{ RS_available_size }}, 
        {>>{ rs_packet_out }}, {>>{ issue_num }} );
endmodule
`endif
