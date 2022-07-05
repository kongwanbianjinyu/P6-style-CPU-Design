`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module LSQ_svsim (
    input clk,reset,
        input dispatch_en,
        input complete_en,
    input EX_IC_PACKET [2:0]    ex_ic_packet_in,     input ID_IP_PACKET [2:0]    id_ip_packet_in,
    input ROB_PACKET [2:0]      rob_packet_in,

    input retire_en,
    input [31:0]            dcache_data_in,
    input                   dcache_valid_in,
    input clear_all,
    input [$clog2(64)-1:0] rob_head,
            output logic [32-1:0]            lsq2dcache_addr,     output BUS_COMMAND                  lsq2dcache_command,     output logic [32-1:0]            lsq2dcache_data,     output logic [2:0]                  lsq2dcache_mem_size,
    output logic [32-1:0]               lsq2cdb_value,     output logic [$clog2(64):0]     lsq2cdb_rob
);


  LSQ LSQ( {>>{ clk }}, {>>{ reset }}, {>>{ dispatch_en }}, 
        {>>{ complete_en }}, {>>{ ex_ic_packet_in }}, {>>{ id_ip_packet_in }}, 
        {>>{ rob_packet_in }}, {>>{ retire_en }}, {>>{ dcache_data_in }}, 
        {>>{ dcache_valid_in }}, {>>{ clear_all }}, {>>{ rob_head }}, 
        {>>{ lsq2dcache_addr }}, {>>{ lsq2dcache_command }}, 
        {>>{ lsq2dcache_data }}, {>>{ lsq2dcache_mem_size }}, 
        {>>{ lsq2cdb_value }}, {>>{ lsq2cdb_rob }} );
endmodule
`endif
