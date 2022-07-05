// This is one stage of an 8 stage (9 depending on how you look at it)
// pipelined multiplier that multiplies 2 64-bit integers and returns
// the low 64 bits of the result.  This is not an ideal multiplier but
// is sufficient to allow a faster clock period than straight *
`define depth 8
module mult_stage(
					input clock, reset, start,
					input [63:0] product_in, mplier_in, mcand_in,
					input IS_EX_PACKET is_ex_packet_in,

					output logic done,
					output logic [63:0] product_out, mplier_out, mcand_out,
					output IS_EX_PACKET is_ex_packet_out
				);

	logic [63:0] prod_in_reg, partial_prod_reg;
	logic [63:0] partial_product, next_mplier, next_mcand;

	assign product_out = prod_in_reg + partial_prod_reg;

	assign partial_product = mplier_in[(`depth - 1):0] * mcand_in;

	assign next_mplier = {`depth'b0,mplier_in[63:`depth]}; // shift right 64/stage_num
	assign next_mcand = {mcand_in[(63 - `depth):0],`depth'b0}; // shift left 64/stage_num

	//synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		prod_in_reg      <= #1 product_in;
		partial_prod_reg <= #1 partial_product;
		mplier_out       <= #1 next_mplier;
		mcand_out        <= #1 next_mcand;
		is_ex_packet_out <= #1 is_ex_packet_in;
	end

	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if(reset)
			done <= #1 1'b0;
		else
			done <= #1 start;
	end

endmodule

