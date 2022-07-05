`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module mult_stage_svsim(
					input clk, reset, start,
					input [63:0] product_in, mplier_in, mcand_in,
					input IS_EX_PACKET is_ex_packet_in,

					output logic done,
					output logic [63:0] product_out, mplier_out, mcand_out,
					output IS_EX_PACKET is_ex_packet_out
				);

	

  mult_stage mult_stage( {>>{ clk }}, {>>{ reset }}, {>>{ start }}, 
        {>>{ product_in }}, {>>{ mplier_in }}, {>>{ mcand_in }}, 
        {>>{ is_ex_packet_in }}, {>>{ done }}, {>>{ product_out }}, 
        {>>{ mplier_out }}, {>>{ mcand_out }}, {>>{ is_ex_packet_out }} );
endmodule
`endif
