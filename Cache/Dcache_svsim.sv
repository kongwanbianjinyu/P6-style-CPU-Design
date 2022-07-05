`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module Dcache_svsim(
    input   clk,
    input   reset,
        input   [3:0] Dmem2proc_response,
    input  [63:0] Dmem2proc_data,
    input   [3:0] Dmem2proc_tag,
            input BUS_COMMAND proc2Dcache_command,
    input      [32-1:0] proc2Dcache_data,
    input      [32-1:0] proc2Dcache_addr,
    input       MEM_SIZE mem_size,
            output BUS_COMMAND proc2Dmem_command,
    output logic [32-1:0] proc2Dmem_addr,
    output logic [63:0] proc2Dmem_data,
            output logic [32-1:0] Dcache_data_out,     output logic        Dcache_valid_out          );


    

  Dcache Dcache( {>>{ clk }}, {>>{ reset }}, {>>{ Dmem2proc_response }}, 
        {>>{ Dmem2proc_data }}, {>>{ Dmem2proc_tag }}, 
        {>>{ proc2Dcache_command }}, {>>{ proc2Dcache_data }}, 
        {>>{ proc2Dcache_addr }}, {>>{ mem_size }}, {>>{ proc2Dmem_command }}, 
        {>>{ proc2Dmem_addr }}, {>>{ proc2Dmem_data }}, 
        {>>{ Dcache_data_out }}, {>>{ Dcache_valid_out }} );
endmodule
`endif
