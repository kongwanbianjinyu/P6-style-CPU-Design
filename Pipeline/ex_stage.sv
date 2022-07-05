//////////////////////////////////////////////////////////////////////////
//                                                                      //
//   Modulename :  ex_stage.v                                           //
//                                                                      //
//  Description :  instruction execute (EX) stage of the pipeline;      //
//                 given the instruction command code CMD, select the   //
//                 proper input A and B for the ALU, compute the result,//
//                 and compute the condition for branches, and pass all //
//                 the results down the pipeline. MWB                   //
//                                                                      //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
`ifndef __EX_STAGE_V__
`define __EX_STAGE_V__

`timescale 1ns/100ps

//
// The ALU
//
// given the command code CMD and proper operands A and B, compute the
// result of the instruction
//
// This module is purely combinational
//
// 3-way alu

// !: change to alu array
module alu(
	input [2:0][`XLEN-1:0] opa,
	input [2:0][`XLEN-1:0] opb,
	ALU_FUNC [2:0]    func,

	output logic [2:0][`XLEN-1:0] result
);

	logic signed [2:0][`XLEN-1:0] signed_opa, signed_opb;
	logic signed [2:0][2*`XLEN-1:0] signed_mul, mixed_mul;
	logic        [2:0][2*`XLEN-1:0] unsigned_mul;

	always_comb begin
		for(int i = 0; i < 3; i++) begin
			signed_opa[i] = opa[i];
			signed_opb[i] = opb[i];
			signed_mul[i] = $signed(signed_opa[i]) * $signed(signed_opb[i]);
			unsigned_mul[i] = opa[i] * opb[i];
			mixed_mul[i] = $signed(signed_opa[i]) * opb[i];
		end
	end

	always_comb begin
		for(int i=0;i<3;i++) begin
			case (func[i])
				ALU_ADD:      result[i] = opa[i] + opb[i];
				ALU_SUB:      result[i] = opa[i] - opb[i];
				ALU_AND:      result[i] = opa[i] & opb[i];
				ALU_SLT:      result[i] = $signed(signed_opa[i]) < $signed(signed_opb[i]);
				ALU_SLTU:     result[i] = opa[i] < opb[i];
				ALU_OR:       result[i] = opa[i] | opb[i];
				ALU_XOR:      result[i] = opa[i] ^ opb[i];
				ALU_SRL:      result[i] = opa[i] >> opb[i][4:0];
				ALU_SLL:      result[i] = opa[i] << opb[i][4:0];
				ALU_SRA:      result[i] = $signed(signed_opa[i]) >>> opb[i][4:0]; // arithmetic from logical shift
				ALU_MUL:      result[i] = $signed(signed_mul[i][`XLEN-1:0]);
				ALU_MULH:     result[i] = $signed(signed_mul[i][2*`XLEN-1:`XLEN]);
				ALU_MULHSU:   result[i] = $signed(mixed_mul[i][2*`XLEN-1:`XLEN]);
				ALU_MULHU:    result[i] = unsigned_mul[i][2*`XLEN-1:`XLEN];

				default:      result[i] = `XLEN'hfacebeec;  // here to prevent latches
			endcase
		end
	end
endmodule // alu

//
// BrCond module
//
// Given the instruction code, compute the proper condition for the
// instruction; for branches this condition will indicate whether the
// target is taken.
//
// This module is purely combinational
//
// 3-way brcond
module brcond(// Inputs
	input [2:0][`XLEN-1:0] rs1,    // Value to check against condition
	input [2:0][`XLEN-1:0] rs2,
	input [2:0][2:0] func,  // Specifies which condition to check

	output logic [2:0] cond    // 0/1 condition result (False/True)
);

	logic signed [2:0][`XLEN-1:0] signed_rs1, signed_rs2;

	always_comb begin
		for(int i = 0;i < 3;i++) begin
			signed_rs1[i] = rs1[i];
			signed_rs2[i] = rs2[i];
			cond[i] = 0;
			case (func[i])
				3'b000: cond[i] = $signed(signed_rs1[i]) == $signed(signed_rs2[i]);  // BEQ
				3'b001: cond[i] = $signed(signed_rs1[i]) != $signed(signed_rs2[i]);  // BNE
				3'b100: cond[i] = $signed(signed_rs1[i]) < $signed(signed_rs2[i]);   // BLT
				3'b101: cond[i] = $signed(signed_rs1[i]) >= $signed(signed_rs2[i]);  // BGE
				3'b110: cond[i] = rs1[i] < rs2[i];                 // BLTU
				3'b111: cond[i] = rs1[i] >= rs2[i];                // BGEU
			endcase
		end
	end
	
endmodule // brcond

//
module ex_stage(
	input clk,               // system clk
	input reset,               // system reset
	input IS_EX_PACKET [2:0] is_ex_packet_in,//changed from output to input
	output EX_IC_PACKET [2:0] ex_packet_out,
	output 					ex_stage_stall
);

	logic [2:0] brcond_result;
	logic [2:0][`XLEN-1:0] opa_mux_out;
	logic [2:0][`XLEN-1:0] opb_mux_out;
	logic [2:0][`XLEN-1:0] alu_result;


	// logic for Mult module
	EX_IC_PACKET [2:0] 	alu_ex_packet_out; // contain { alu_2, alu_1, alu_0} output packet, send to p-select
	EX_IC_PACKET [2:0] 	mult_ex_packet_out; // contain { mult_2, mult_1, mult_0} output packet, send to p-select
	EX_IC_PACKET [5:0]  ex_packet_out_reorder;
	logic [2:0] 		mult_start;
	logic [2:0] 		mult_done;


	// logic for P-sel module
	logic [6 - 1:0] complete_req;
	logic [6 - 1:0] complete_gnt;
	logic [(6 * 3) - 1:0] complete_gnt_bus;
	logic complete_empty;
	logic [2:0][2:0] complete_idx;

	assign ex_stage_stall = ((alu_ex_packet_out[0].exe_valid == 1) && (complete_gnt[3] == 0)) ||
							((alu_ex_packet_out[1].exe_valid == 1) && (complete_gnt[2] == 0)) ||
							((alu_ex_packet_out[2].exe_valid == 1) && (complete_gnt[1] == 0)); // any alu stuck

	assign ex_packet_out_reorder[5] = mult_ex_packet_out[0];
	assign ex_packet_out_reorder[4] = mult_ex_packet_out[1];
	assign ex_packet_out_reorder[3] = alu_ex_packet_out[0];
	assign ex_packet_out_reorder[2] = alu_ex_packet_out[1];
	assign ex_packet_out_reorder[1] = alu_ex_packet_out[2];
	assign ex_packet_out_reorder[0] = mult_ex_packet_out[2];

	logic   [2:0][2:0] complete_idx_from_pe;  
	pe  #(.OUTWIDTH(3), .INWIDTH(8)) complete_encoder [2:0]
	(.gnt({{2'b00,complete_gnt_bus[17 -:6]}, {2'b00, complete_gnt_bus[11 -: 6]}, {2'b00, complete_gnt_bus[5 -: 6]}}),
	.enc(complete_idx_from_pe));



	always_comb begin
		for(int i = 0; i < 3; i++)begin
			mult_start[i] = (is_ex_packet_in[i].issue_valid) && (is_ex_packet_in[i].alu_func == ALU_MUL);
		end

		//clog2
		complete_idx = complete_idx_from_pe;


		for(int i = 0; i < 3; i ++) begin
			if(complete_gnt_bus[(i + 1) * 6-1 -: 6] != 0) begin
				//complete_idx[i] = log2(complete_gnt_bus[(i + 1) * 6-1 -: 6]);
				ex_packet_out[i] = ex_packet_out_reorder[complete_idx[i]];
			end else begin
				ex_packet_out[i].exe_valid = 0;
			end
			
		end
		
	end


	assign complete_req = {mult_done[0],mult_done[1],alu_ex_packet_out[0].exe_valid,alu_ex_packet_out[1].exe_valid, alu_ex_packet_out[2].exe_valid,mult_done[2]};

	//
	// ALU opA mux
	//
	always_comb begin
		for(int i = 0; i< 3; i++)begin
			opa_mux_out[i] = `XLEN'hdeadfbac;
			case (is_ex_packet_in[i].opa_select)
				OPA_IS_RS1:  opa_mux_out[i] = is_ex_packet_in[i].rs1_value;
				OPA_IS_NPC:  opa_mux_out[i] = is_ex_packet_in[i].NPC;
				OPA_IS_PC:   opa_mux_out[i] = is_ex_packet_in[i].PC;
				OPA_IS_ZERO: opa_mux_out[i] = 0;
			endcase
		end
	end

	always_comb begin
		// Default value, Set only because the case isnt full.  If you see this
		// value on the output of the mux you have an invalid opb_select
		for(int i = 0; i < 3; i++) begin
			opb_mux_out[i] = `XLEN'hfacefeed;
			case (is_ex_packet_in[i].opb_select)
				OPB_IS_RS2:   opb_mux_out[i] = is_ex_packet_in[i].rs2_value;
				OPB_IS_I_IMM: opb_mux_out[i] = `RV32_signext_Iimm(is_ex_packet_in[i].inst);
				OPB_IS_S_IMM: opb_mux_out[i] = `RV32_signext_Simm(is_ex_packet_in[i].inst);
				OPB_IS_B_IMM: opb_mux_out[i] = `RV32_signext_Bimm(is_ex_packet_in[i].inst);
				OPB_IS_U_IMM: opb_mux_out[i] = `RV32_signext_Uimm(is_ex_packet_in[i].inst);
				OPB_IS_J_IMM: opb_mux_out[i] = `RV32_signext_Jimm(is_ex_packet_in[i].inst);
			endcase
		end
	end

	

	//
	// instantiate ALU modules
	//
	alu alu_0(// Inputs
		.opa(opa_mux_out),
		.opb(opb_mux_out),
		.func({is_ex_packet_in[2].alu_func, is_ex_packet_in[1].alu_func, is_ex_packet_in[0].alu_func}),
		// Output
		.result(alu_result)
	);



	 //
	 // instantiate branch condition testers
	 //
	brcond brcond(// Inputs
		.rs1({is_ex_packet_in[2].rs1_value, is_ex_packet_in[1].rs1_value, is_ex_packet_in[0].rs1_value}),
		.rs2({is_ex_packet_in[2].rs2_value, is_ex_packet_in[1].rs2_value, is_ex_packet_in[0].rs2_value}),
		.func({is_ex_packet_in[2].inst.b.funct3, is_ex_packet_in[1].inst.b.funct3, is_ex_packet_in[0].inst.b.funct3}), // inst bits to determine check
		// Output
		.cond(brcond_result)
	);

	mult m0(	.clk(clk),
				.reset(reset),
				.mcand({32'b0,opa_mux_out[0]}),
				.mplier({32'b0,opb_mux_out[0]}),
				.is_ex_packet_in(is_ex_packet_in[0]),
				.start(mult_start[0]),
				.mult_ex_packet_out(mult_ex_packet_out[0]),
				.done(mult_done[0]));

	mult m1(	.clk(clk),
				.reset(reset),
				.mcand({32'b0,opa_mux_out[1]}),
				.mplier({32'b0,opb_mux_out[1]}),
				.is_ex_packet_in(is_ex_packet_in[1]),
				.start(mult_start[1]),
				.mult_ex_packet_out(mult_ex_packet_out[1]),
				.done(mult_done[1]));

	mult m2(	.clk(clk),
				.reset(reset),
				.mcand({32'b0,opa_mux_out[2]}),
				.mplier({32'b0,opb_mux_out[2]}),
				.is_ex_packet_in(is_ex_packet_in[2]),
				.start(mult_start[2]),
				.mult_ex_packet_out(mult_ex_packet_out[2]),
				.done(mult_done[2]));

	psel_gen    #(.REQS(3), .WIDTH(6)) psel_complete
				(.req(complete_req),
				.gnt(complete_gnt),
				.gnt_bus(complete_gnt_bus),
				.empty(complete_empty)
				);


	// output
	// record packet out from ALU, index
	always_comb begin
		for (int i = 0; i < 3; i++) begin
			// pass through
			alu_ex_packet_out[i].rob_tag = is_ex_packet_in[i].rob_tag; 
			alu_ex_packet_out[i].alu_result = alu_result[i]; // from ALU module
			alu_ex_packet_out[i].take_branch = (is_ex_packet_in[i].uncond_branch) | (is_ex_packet_in[i].cond_branch & brcond_result[i]);// from br_cond module
			alu_ex_packet_out[i].exe_valid = is_ex_packet_in[i].issue_valid && (is_ex_packet_in[i].alu_func != ALU_MUL); // not mult insns
			alu_ex_packet_out[i].NPC = is_ex_packet_in[i].NPC;
			alu_ex_packet_out[i].inst = is_ex_packet_in[i].inst;
			alu_ex_packet_out[i].halt = is_ex_packet_in[i].halt;

			alu_ex_packet_out[i].rs2_value = is_ex_packet_in[i].rs2_value;
			//alu_ex_packet_out[i].load_pos = is_ex_packet_in[i].load_pos;
			//alu_ex_packet_out[i].store_pos = is_ex_packet_in[i].store_pos;
			alu_ex_packet_out[i].rd_mem = is_ex_packet_in[i].rd_mem;
			alu_ex_packet_out[i].wr_mem = is_ex_packet_in[i].wr_mem;
		end
	end
	

endmodule // module ex_stage
`endif // __EX_STAGE_V__
