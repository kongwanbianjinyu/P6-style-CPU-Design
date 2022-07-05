`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module num_ones_svsim #(parameter WIDTH=16)(
    input [WIDTH - 1:0] A,
    output reg [$clog2(WIDTH):0] ones
    );



  num_ones num_ones( {>>{ A }}, {>>{ ones }} );
endmodule
`endif
