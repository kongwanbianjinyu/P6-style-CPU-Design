// This is an 8 stage (9 depending on how you look at it) pipelined 
// multiplier that multiplies 2 64-bit integers and returns the low 64 bits 
// of the result.  This is not an ideal multiplier but is sufficient to 
// allow a faster clock period than straight *
// This module instantiates 8 pipeline stages as an array of submodules.

`define stage_num 8

module mult(
				input clock, reset,
				input [63:0] mcand, mplier,
				input IS_EX_PACKET is_ex_packet_in,
				input start,
	
				output EX_IC_PACKET mult_ex_packet_out,
				output logic done
			);

  logic [63:0] product;
  logic [63:0] mcand_out, mplier_out;
  logic [((`stage_num - 1)*64)-1:0] internal_products, internal_mcands, internal_mpliers;
  logic [(`stage_num - 2):0] internal_dones;
  
  IS_EX_PACKET [(`stage_num - 2):0] internal_is_ex_packet;
  IS_EX_PACKET is_ex_packet_out;

	mult_stage  mstage [(`stage_num - 1):0]  (
		.clock(clock),
		.reset(reset),
		.product_in({internal_products,64'h0}),
		.mplier_in({internal_mpliers,mplier}),
		.mcand_in({internal_mcands,mcand}),
		.start({internal_dones,start}),
		.is_ex_packet_in({internal_is_ex_packet,is_ex_packet_in}),
		.product_out({product,internal_products}),
		.mplier_out({mplier_out,internal_mpliers}),
		.mcand_out({mcand_out,internal_mcands}),
		.done({done,internal_dones}),
		.is_ex_packet_out({is_ex_packet_out,internal_is_ex_packet})
	);

	always_comb begin
		mult_ex_packet_out.rob_tag = is_ex_packet_out.rob_tag;
		mult_ex_packet_out.alu_result = product[31:0];
		mult_ex_packet_out.take_branch = 0;
		mult_ex_packet_out.exe_valid = is_ex_packet_out.issue_valid;
		mult_ex_packet_out.NPC = is_ex_packet_out.NPC;
		mult_ex_packet_out.inst = is_ex_packet_out.inst;
		mult_ex_packet_out.halt = is_ex_packet_out.halt;
		mult_ex_packet_out.rs2_value = is_ex_packet_out.rs2_value;
		//mult_ex_packet_out.load_pos = is_ex_packet_out.load_pos;
		//mult_ex_packet_out.store_pos = is_ex_packet_out.store_pos;
		mult_ex_packet_out.rd_mem = is_ex_packet_out.rd_mem;
		mult_ex_packet_out.wr_mem = is_ex_packet_out.wr_mem;
	end

	

endmodule
