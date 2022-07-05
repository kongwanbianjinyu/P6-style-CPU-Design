`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module ROB_svsim #(parameter SIZE=63) (     input                          clk,reset,
        input                          dispatch_en,
        input ID_IP_PACKET [2:0]             id_packet_in ,          input MT_PACKET [2:0]                mt_packet_in,
            input  [$clog2(16):0]          RS_available_size,                 
        input                          complete_en,
    input [2:0][32-1:0]  alu_result_in,
    input  [2:0][$clog2(64):0]  CDB_rob_tag ,          
    input  [2:0][31:0]                  CDB_value ,                input  [2:0]                        CDB_halt,

        input                          retire_en,

        input EX_IC_PACKET [2:0]        ex_ic_packet_in,
        

        output ROB_PACKET [2:0] rob_packet_out,
    output logic [1:0] dispatch_num,
    output logic clear_all,
    output logic [1:0] retire_num,
    output ROB_ENTRY [64-1:0]     rob_entry_test,     output logic [32 - 1:0] branch_PC,
    output logic [$clog2(64)-1:0] rob_head
);



  ROB ROB( {>>{ clk }}, {>>{ reset }}, {>>{ dispatch_en }}, 
        {>>{ id_packet_in }}, {>>{ mt_packet_in }}, {>>{ RS_available_size }}, 
        {>>{ complete_en }}, {>>{ alu_result_in }}, {>>{ CDB_rob_tag }}, 
        {>>{ CDB_value }}, {>>{ CDB_halt }}, {>>{ retire_en }}, 
        {>>{ ex_ic_packet_in }}, {>>{ rob_packet_out }}, {>>{ dispatch_num }}, 
        {>>{ clear_all }}, {>>{ retire_num }}, {>>{ rob_entry_test }}, 
        {>>{ branch_PC }}, {>>{ rob_head }} );
endmodule
`endif
