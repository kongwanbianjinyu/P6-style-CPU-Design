`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module mult_svsim(
				input clk, reset,
				input [63:0] mcand, mplier,
				input IS_EX_PACKET is_ex_packet_in,
				input start,
	
				output EX_IC_PACKET mult_ex_packet_out,
				output logic done
			);

  

  mult mult( {>>{ clk }}, {>>{ reset }}, {>>{ mcand }}, {>>{ mplier }}, 
        {>>{ is_ex_packet_in }}, {>>{ start }}, {>>{ mult_ex_packet_out }}, 
        {>>{ done }} );
endmodule
`endif
