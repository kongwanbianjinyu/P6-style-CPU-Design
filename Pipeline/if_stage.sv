/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  if_stage.v                                          //
//                                                                     //
//  Description :  instruction fetch (IF) stage of the pipeline;       //
//                 fetch instruction, compute next PC location, and    //
//                 send them down the pipeline.                        //
//                 Should support 3-ways superscalar(fetch 3 insns)    //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

// ? how to use timescale
`timescale 1ns/100ps

module if_stage(
	input         				clock,                  // system clock
	input         				reset,                  // system reset
	input 	[1:0]				dispatch_num,  			// come back from ID stage, fetch should know how many insns are dispatched successfully
	input   	      			clear_all,     // taken-branch signal
	input  [`XLEN-1:0] 			ex_ic_target_pc ,       // target pc: use if take_branch is TRUE
	input  [1:0][63:0] 				Imem2proc_data ,   // Data coming back from instruction-memory
	output logic [1:0][`XLEN-1:0] 	proc2Imem_addr ,   // Address sent to Instruction memory
	output IF_ID_PACKET [2:0] 	if_packet_out         	// Output data packet from IF going to ID, see sys_defs for signal information
);


	logic    [`XLEN-1:0] PC_reg;    // PC we are currently fetching
	logic    [`XLEN-1:0] PC_prev;    // last time PC pointer
	logic           PC_enable;
	
	// 2 Imem addr
	assign proc2Imem_addr[0] = PC_reg[`XLEN-1:3];
	// address for third PC inst
	assign proc2Imem_addr[1] = PC_reg[`XLEN-1:3] + 1'b1;
	
	// this mux is because the Imem gives us 64 bits not 32 bits
	// choose 3 insns from 4 insns data according to PC_reg[2]
	always_comb begin
		// we fetch memory data in this format:
		// |2|1|
		// |x|3|
		if(!PC_reg[2]) begin // PC_reg[2] == 0
			if_packet_out[0].inst = Imem2proc_data[0][31:0];
			if_packet_out[1].inst = Imem2proc_data[0][63:32];
			if_packet_out[2].inst = Imem2proc_data[1][31:0];
		end
		// |1|x|
		// |3|2|
		else begin // PC_reg[2] == 1
			if_packet_out[0].inst = Imem2proc_data[0][63:32];
			if_packet_out[1].inst = Imem2proc_data[1][31:0];
			if_packet_out[2].inst = Imem2proc_data[1][63:32];
		end
	end
	
	// The take-branch signal must override stalling (otherwise it may be lost)
	// TODO: need to be modified later (one of the inst is valid, whether we set the pc_enable to be valid?)
	assign PC_enable = (if_packet_out[0].valid | if_packet_out[1].valid | if_packet_out[2].valid) | clear_all;
	
	// Pass PC+4 down pipeline w/instruction
	assign if_packet_out[0].NPC = PC_reg + 4;
	assign if_packet_out[1].NPC = PC_reg + 8;
	assign if_packet_out[2].NPC = PC_reg + 12;

	assign if_packet_out[0].PC  = PC_reg;
	assign if_packet_out[1].PC  = PC_reg + 4;
	assign if_packet_out[2].PC  = PC_reg + 8;

	// all valid
	assign if_packet_out[0].valid = 1;
	assign if_packet_out[1].valid = 1;
	assign if_packet_out[2].valid = 1;

	// This register holds the PC value
	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if(reset)
			PC_prev <= `SD 0;       // initial PC value is 0
		else if(PC_enable) begin
			PC_prev <= `SD PC_reg;
		end
	end

	always_comb begin
		if(reset) PC_reg = 0;
		else begin
			if(clear_all) begin // check if branch
				// TODO: change to priority selector
				PC_reg = ex_ic_target_pc;
			end else begin  // not branch
				PC_reg 	= PC_prev + 4 * dispatch_num; // fetch dispatch_num insns then, transition to next PC
			end
				
		end
	end
	
endmodule  // module if_stage
