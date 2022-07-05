`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module Map_Table_svsim #(parameter SIZE=32)(
    input                           clk,reset,
        input                           dispatch_en,
        input ID_IP_PACKET [2:0]                   id_packet_in,
            
            input [1:0]                     rob_dispatch_num, 
        input [2:0][$clog2(64):0]   dest_rob_tag ,
        input                           complete_en,
    input [2:0][$clog2(64):0]   CDB_rob_tag,
    input                           retire_en,
    input ROB_PACKET [2:0]          rob_packet_in,

        input                           clear_all,


        output MT_PACKET [2:0] mt_packet,
                    output logic [SIZE - 1:0]               check_ready 
);



  Map_Table Map_Table( {>>{ clk }}, {>>{ reset }}, {>>{ dispatch_en }}, 
        {>>{ id_packet_in }}, {>>{ rob_dispatch_num }}, {>>{ dest_rob_tag }}, 
        {>>{ complete_en }}, {>>{ CDB_rob_tag }}, {>>{ retire_en }}, 
        {>>{ rob_packet_in }}, {>>{ clear_all }}, {>>{ mt_packet }}, 
        {>>{ check_ready }} );
endmodule
`endif
