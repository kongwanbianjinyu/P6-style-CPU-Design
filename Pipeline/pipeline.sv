/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  pipeline.sv                                         //
//                                                                     //
//  Description :  Top-level module of the verisimple pipeline;        //
//                 This instantiates and connects the 5 stages of the  //
//                 Verisimple pipeline togeather.                      //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`ifndef __PIPELINE_V__
`define __PIPELINE_V__

`timescale 1ns/100ps

module pipeline (

	input         clk,                    // System clk
	input         reset,                    // System reset
	//input [3:0]   mem2proc_response,        // Tag from memory about current request
	input [1:0][63:0]  Imem2proc_data,            // Data coming back from memory
	input [63:0]  Dmem2proc_data,            // Data coming back from memory
	input [3:0]	  Dmem2proc_tag,
	input [3:0]   Dmem2proc_response,
	//input [3:0]   mem2proc_tag,              // Tag from memory about current reply

	output BUS_COMMAND 				proc2Dcache_command,
	output	logic [`XLEN-1:0] 		proc2Dcache_addr,
	output logic [31:0] 			proc2Dcache_data,

	output logic [1:0][`XLEN-1:0] proc2Imem_addr,      // Address sent to memory
	output logic [1:0]  proc2Dmem_command,    // command sent to memory
	output logic [`XLEN-1:0] proc2Dmem_addr,      // Address sent to memory
	output logic [63:0] proc2Dmem_data,     // Data sent to memory
	//output MEM_SIZE proc2mem_size,         // data size sent to memory

	output logic [3:0]  pipeline_completed_insts,
	output EXCEPTION_CODE   pipeline_error_status,
	output logic [2:0][4:0]  pipeline_commit_wr_idx,
	output logic [2:0][`XLEN-1:0] pipeline_commit_wr_data,
	output logic [2:0]       pipeline_commit_wr_en,
	output logic [2:0][`XLEN-1:0] pipeline_commit_NPC,


	// testing hooks (these must be exported so we can test
	// the synthesized version) data is tested by looking at
	// the final values in memory


	// test outputs for Fetch Stage
	output logic [2:0][`XLEN-1:0] if_NPC_out,
	output logic [2:0][31:0] if_IR_out,
	output logic [2:0]       if_valid_inst_out,

	// test outputs for Dispatch Stage from IF/ID Pipeline Register
	output logic [2:0][`XLEN-1:0] if_id_NPC,
	output logic [2:0][31:0] if_id_IR,
	output logic [2:0]       if_id_valid_inst,

	// test outputs for Issue Stage from RS_entry
	output logic [2:0][`XLEN-1:0] id_is_NPC_out,
	output logic [2:0][31:0] id_is_IR_out,
	output logic [2:0]       id_is_valid_inst_out,

	// test outputs for Execute stage from IS/EX reg
	output logic [2:0][`XLEN-1:0] is_ex_NPC_out,
	output logic [2:0][31:0] is_ex_IR_out,
	output logic [2:0]       is_ex_valid_inst_out,


	//test outputs for Complete Stage from EX/IC Pipeline Register
	output logic [2:0][`XLEN-1:0] ex_ic_NPC_out,
	output logic [2:0][31:0]      ex_ic_IR_out,
	output logic [2:0]       	  ex_ic_valid_inst_out,
	//output logic [2:0][$clog2(`ROB_SIZE)-1:0]   rob_tag;
	//output logic [2:0]take_branch;

	//TODO test outputs for Retire Stage from ROB retire
	output logic [2:0][`XLEN-1:0] ic_rt_NPC_out,
	output logic [2:0][31:0] ic_rt_IR_out,
	output logic [2:0]       ic_rt_valid_inst_out


);

	assign pipeline_completed_insts = ic_rt_valid_inst_out[0] + ic_rt_valid_inst_out[1] + ic_rt_valid_inst_out[2];

	//// Outputs from MEM/WB Pipeline Register
	//output logic [`XLEN-1:0] mem_wb_NPC,
	//output logic [31:0] mem_wb_IR,
	//output logic        mem_wb_valid_inst

	// Pipeline register enables
	logic   if_id_enable;
	logic    id_ex_enable;
	logic    ex_ic_enable;

	// Outputs from IF-Stage
	//logic [1:0][`XLEN-1:0] proc2Imem_addr;
	IF_ID_PACKET [2:0] if_packet;

	// Outputs from IF/ID Pipeline Register
	IF_ID_PACKET [2:0] if_id_packet;

	// Outputs from ID stage
	ID_IP_PACKET [2:0] id_packet;

	// Outputs from IS stage
	IS_EX_PACKET [2:0] is_packet_out;
	IS_EX_PACKET [2:0] is_ex_packet;

	// Outputs from EX-Stage
	EX_IC_PACKET [2:0] ex_packet;
	logic ex_stage_stall;

	// Outputs from EX/IC Pipeline Register
	EX_IC_PACKET [2:0] ex_ic_packet;

	// Outputs from IC stage
	logic [$clog2(`ROB_SIZE):0] exception_rob_tag;
	logic [2:0][$clog2(`ROB_SIZE):0] CDB_rob_tag;
    logic [2:0][`XLEN-1:0]                  CDB_value;
	logic [2:0]							CDB_halt;
	logic [1:0]                   complete_num;
	logic [2:0][`XLEN-1:0] alu_result;


	// Outputs from MEM-Stage
	//logic [`XLEN-1:0] mem_result_out;
	// logic [`XLEN-1:0] proc2Dmem_addr;
	// logic [`XLEN-1:0] proc2Dmem_data;
	// logic [1:0]  proc2Dmem_command;
	// MEM_SIZE proc2Dmem_size;

	// Outputs from MEM/WB Pipeline Register
	logic [2:0]  retire_halt;
	logic        mem_wb_illegal;
	logic  [4:0] mem_wb_dest_reg_idx;
	logic [`XLEN-1:0] mem_wb_result;
	logic        mem_wb_take_branch;

	// Outputs from WB-Stage  (These loop back to the register file in ID)
	logic packet_2_1_same; //A
	logic packet_2_0_same; //B
	logic packet_1_0_same; //C

	logic [2:0][`XLEN-1:0] wb_reg_wr_data_out;
	logic [2:0][4:0] wb_reg_wr_idx_out;
	logic [2:0]       wb_reg_wr_en_out;



	logic dispatch_en;
	logic issue_en;
	logic complete_en;
	logic execute_en;
	logic retire_en;

	assign dispatch_en = 1'b1;
	assign complete_en = 1'b1;
	assign issue_en = 1'b1;
	assign execute_en = 1'b1;
	assign retire_en = 1'b1;
	// Outputs from ROB
	ROB_ENTRY [`ROB_SIZE-1:0]     rob_entry_test;//as a rob test
	ROB_PACKET 	[2:0]		rob_packet_out;
	ROB_PACKET 	[2:0]		rob_packet_test;
	logic [$clog2(`ROB_SIZE)-1:0] rob_head;
	logic [`XLEN-1:0]             branch_PC;

	logic [1:0] dispatch_num;
	logic [1:0] retire_num;
	logic clear_all;


	// Outputs from Map_Table

	MT_PACKET [2:0] mt_packet;
	logic [`MAP_TABLE_SIZE-1:0]       check_ready;

	// Outputs from RS
	RS_PACKET [2:0]     rs_packet_out;
	logic [$clog2(`NUM_RS):0]         RS_available_size;
	logic [1:0]            issue_num;
	//logic [2:0][4:0]    RS_idx_test;

	// Outputs from LSQ
	logic [`XLEN-1:0]            lsq2dcache_addr;
	BUS_COMMAND                  lsq2dcache_command;
	logic [`XLEN-1:0]            lsq2dcache_data;
	logic [2:0]					 lsq2dcache_mem_size;
	logic [`XLEN-1:0]               lsq2cdb_value;
	logic [$clog2(`ROB_SIZE):0]     lsq2cdb_rob;
	//logic [$clog2(`LSQ_SIZE):0]	lsq_available_size;



	// Outputs from Dcache
	//logic [`XLEN-1:0] mem2SQ_data; // Mem[addr] return from Memory
	// outpus to proc
    logic [31:0]	dcache_data_in;
    logic			dcache_valid_in;



	// TODO : delete below
	//assign pipeline_completed_insts = {3'b0, mem_wb_valid_inst};
	// assign pipeline_error_status =  mem_wb_illegal             ? ILLEGAL_INST :
	//                                 mem_wb_halt                ? HALTED_ON_WFI :
	//                                 (mem2proc_response==4'h0)  ? LOAD_ACCESS_FAULT :
	//                                 NO_ERROR;

	assign pipeline_commit_wr_idx = wb_reg_wr_idx_out;
	assign pipeline_commit_wr_data = wb_reg_wr_data_out;
	assign pipeline_commit_wr_en = wb_reg_wr_en_out;
	assign pipeline_commit_NPC = {rob_packet_out[2].NPC,rob_packet_out[1].NPC,rob_packet_out[0].NPC};

	assign pipeline_error_status =  (retire_halt[2]  | retire_halt[1] | retire_halt[0])  ? HALTED_ON_WFI :
	                                NO_ERROR;

	// assign proc2mem_command =
	//      (proc2Dmem_command == BUS_NONE) ? BUS_LOAD : proc2Dmem_command;
	// assign proc2mem_addr =
	//      (proc2Dmem_command == BUS_NONE) ? proc2Imem_addr : proc2Dmem_addr;
	// //if it's an instruction, then load a double word (64 bits)
	// assign proc2mem_size =
	//      (proc2Dmem_command == BUS_NONE) ? DOUBLE : proc2Dmem_size;
	// assign proc2mem_data = {32'b0, proc2Dmem_data};

//////////////// show pipeline //////////////////
// IF, always fetch 3
	assign if_NPC_out[2:0]        = {if_packet[2].NPC,if_packet[1].NPC,if_packet[0].NPC};
	assign if_IR_out[2:0]         = {if_packet[2].inst,if_packet[1].inst,if_packet[0].inst};
	assign if_valid_inst_out[2:0] = {if_packet[2].valid,if_packet[1].valid,if_packet[0].valid};

// ID according to dispatch_num
	always_comb begin
		// first clear
		for(int i =0; i < 3; i++) begin
			if_id_NPC[i] = 0;
			if_id_IR [i] = `NOP;
			if_id_valid_inst[i] = 1'b0;
		end
		// then show dispatch insns
		for(int i =0; i < dispatch_num; i++) begin
			if_id_NPC[i] = if_id_packet[i].NPC;
			if_id_IR [i] = if_id_packet[i].inst;
			if_id_valid_inst [i] = if_id_packet[i].valid;
		end
	end

// IS
	always_comb begin
		// first clear
		for(int i =0; i < 3; i++) begin
			id_is_NPC_out[i] = 0;
			id_is_IR_out[i] = `NOP;
			id_is_valid_inst_out[i] = 1'b0;
		end
		for(int i =0; i < issue_num; i++) begin
			id_is_NPC_out[i] = rs_packet_out[i].rs_entry.NPC;
			id_is_IR_out[i] = rs_packet_out[i].rs_entry.inst;
			id_is_valid_inst_out [i] = rs_packet_out[i].valid;
		end

	end

// EX
	always_comb begin
		for(int i =0; i < 3; i++) begin
			is_ex_NPC_out[i] = is_ex_packet[i].NPC;
			is_ex_IR_out[i] = is_ex_packet[i].inst;
			is_ex_valid_inst_out[i] = is_ex_packet[i].issue_valid;
		end
	end

// IC
	//add NPC to ex_ic_packet
	assign ex_ic_NPC_out [2:0]       		= {ex_ic_packet[2].NPC,ex_ic_packet[1].NPC,ex_ic_packet[0].NPC};
	assign ex_ic_IR_out [2:0]   			= {ex_ic_packet[2].inst, ex_ic_packet[1].inst, ex_ic_packet[0].inst};
	assign ex_ic_valid_inst_out [2:0]		= {ex_ic_packet[2].exe_valid,ex_ic_packet[1].exe_valid,ex_ic_packet[0].exe_valid};

// IR
	assign ic_rt_NPC_out[2:0] = {rob_packet_out[2].NPC, rob_packet_out[1].NPC, rob_packet_out[0].NPC};
	assign ic_rt_IR_out[2:0] = {rob_packet_out[2].inst, rob_packet_out[1].inst, rob_packet_out[0].inst};
	assign ic_rt_valid_inst_out[2:0] = {rob_packet_out[2].retire_valid, rob_packet_out[1].retire_valid, rob_packet_out[0].retire_valid};


//////////////////////////////////////////////////
//                                              //
//                  IF-Stage                    //
//                                              //
//////////////////////////////////////////////////

	if_stage if_stage_0 (
	//input
	.clk(clk),
	.reset(reset),
	.dispatch_num(dispatch_num),
	.clear_all(clear_all),// when need to clear all, if restart
	.ex_ic_target_pc(branch_PC),
	// TODO: modify memory to array
	.Imem2proc_data(Imem2proc_data),
	// output
	.proc2Imem_addr(proc2Imem_addr),
	.if_packet_out(if_packet)
	);


//////////////////////////////////////////////////
//                                              //
//            IF/ID Pipeline Register           //
//                                              //
//////////////////////////////////////////////////



	assign if_id_enable = 1'b1; // always enabled
	// synopsys sync_set_reset "reset"
	always_ff @(posedge clk) begin
		// if (reset ||
		// 	(	(ex_ic_packet[2].exe_valid && ex_ic_packet[2].take_branch) ||
		// 		(ex_ic_packet[1].exe_valid && ex_ic_packet[1].take_branch) ||
		// 		(ex_ic_packet[0].exe_valid && ex_ic_packet[0].take_branch) )) begin
		if(reset || clear_all) begin
			for(int i = 0; i < 3; i++) begin
				if_id_packet[i].inst  <= `SD `NOP;
				if_id_packet[i].valid <= `SD `FALSE;
            	if_id_packet[i].NPC   <= `SD 0;
            	if_id_packet[i].PC    <= `SD 0;
			end
		end else begin// if (reset)
			if (if_id_enable) begin
				if_id_packet <= `SD if_packet;
			end // if (if_id_enable)
		end
	end // always


//////////////////////////////////////////////////
//                                              //
//                  ID-Stage                    //
//                                              //
//////////////////////////////////////////////////

	id_stage id_stage_0 (// Inputs
		.clk(clk),
		.reset(reset),
		.if_id_packet_in(if_id_packet),
		.wb_reg_wr_en_out   (wb_reg_wr_en_out),
		.wb_reg_wr_idx_out  (wb_reg_wr_idx_out),
		.wb_reg_wr_data_out (wb_reg_wr_data_out),
		// Outputs
		.id_packet_out(id_packet)
	);



//////////////////////////////////////////////////
//                                              //
//                  IS-Stage                    //
//                                              //
//////////////////////////////////////////////////

// is_stage is_stage_0(
// 	.rs_entry(rs_entry_test), // the selected rs_entry which can issue
// 	.permit_issue(permit_issue), // indicate whether the 3 insns are valid
// 	.is_packet_out(is_packet_out)
// );


//////////////////////////////////////////////////
//                                              //
//            IS/EX Pipeline Register           //
//                                              //
//////////////////////////////////////////////////

// TODO: according to issue_idx, choose RS_entry to IS/EX pipeline register

//for test



	assign id_ex_enable = !ex_stage_stall; // always enabled
	// synopsys sync_set_reset "reset"
	always_ff @(posedge clk) begin
		if(reset || clear_all) begin
			for(int i = 0; i < 3; i++) begin
				is_ex_packet[i].RS_tag <= `SD 0;
				is_ex_packet[i].rob_tag <= `SD 0;
				is_ex_packet[i].rs1_value <= `SD 0;
				is_ex_packet[i].rs2_value <= `SD 0;
				is_ex_packet[i].opa_select <= `SD OPA_IS_RS1;
				is_ex_packet[i].opb_select <= `SD OPB_IS_RS2;
				is_ex_packet[i].alu_func <= `SD ALU_ADD;
				is_ex_packet[i].cond_branch <= `SD 1'b0;
				is_ex_packet[i].uncond_branch <= `SD 1'b0;
				is_ex_packet[i].inst <= `SD `NOP;
				is_ex_packet[i].halt <= `SD 0;
				is_ex_packet[i].NPC <= `SD 0;
				is_ex_packet[i].PC <= `SD 0;
				is_ex_packet[i].issue_valid <= `SD 1'b0;

				//is_ex_packet[i].load_pos <= 0;
				//is_ex_packet[i].store_pos <= 0;
				is_ex_packet[i].rd_mem <= `SD 0;
				is_ex_packet[i].wr_mem <= `SD 0;

			end
		end else begin // if (reset)
			if (id_ex_enable) begin
				for(int i=0;i<3;i++) begin
					is_ex_packet[i].RS_tag <= `SD rs_packet_out[i].rs_entry.RS_tag;
					is_ex_packet[i].rob_tag <= `SD rs_packet_out[i].rs_entry.T;
					is_ex_packet[i].rs1_value <= `SD rs_packet_out[i].rs_entry.V1;
					is_ex_packet[i].rs2_value <= `SD rs_packet_out[i].rs_entry.V2;
					is_ex_packet[i].opa_select <= `SD rs_packet_out[i].rs_entry.opa_select;
					is_ex_packet[i].opb_select <= `SD rs_packet_out[i].rs_entry.opb_select;
					is_ex_packet[i].alu_func <= `SD rs_packet_out[i].rs_entry.alu_func;
					is_ex_packet[i].cond_branch <= `SD rs_packet_out[i].rs_entry.cond_branch;
					is_ex_packet[i].uncond_branch <= `SD rs_packet_out[i].rs_entry.uncond_branch;
					is_ex_packet[i].inst <= `SD rs_packet_out[i].rs_entry.inst;
					is_ex_packet[i].halt <= `SD rs_packet_out[i].rs_entry.halt;
					is_ex_packet[i].NPC <= `SD rs_packet_out[i].rs_entry.NPC;
					is_ex_packet[i].PC <= `SD rs_packet_out[i].rs_entry.PC;
					is_ex_packet[i].issue_valid <= `SD rs_packet_out[i].valid;

					//is_ex_packet[i].load_pos <= `SD rs_packet_out[i].rs_entry.load_pos;
					//is_ex_packet[i].store_pos <= `SD rs_packet_out[i].rs_entry.store_pos;
					is_ex_packet[i].rd_mem <= `SD rs_packet_out[i].rs_entry.rd_mem;
					is_ex_packet[i].wr_mem <= `SD rs_packet_out[i].rs_entry.wr_mem;
				end
			end // if
		end // else: !if(reset)
	end // always



//////////////////////////////////////////////////
//                                              //
//                  EX-Stage                    //
//                                              //
//////////////////////////////////////////////////
	ex_stage ex_stage_0 (
		// Inputs
		.clk(clk),
		.reset(reset),
		.is_ex_packet_in(is_ex_packet),
		// Outputs
		.ex_packet_out(ex_packet),
		.ex_stage_stall(ex_stage_stall)
	);


//////////////////////////////////////////////////
//                                              //
//           EX/IC Pipeline Register            //
//                                              //
//////////////////////////////////////////////////

	//assign ex_ic_rob_tag = ex_ic_packet.rob_tag;
	//assign ex_ic_take_branch = ex_ic_packet.take_branch;

	assign ex_ic_enable = 1'b1; // always enabled
	// synopsys sync_set_reset "reset"
	always_ff @(posedge clk) begin
		if (reset || clear_all) begin
			ex_ic_packet <= `SD 0;
		end else begin
			if (ex_ic_enable)   begin
				// EX outputs
				ex_ic_packet <= `SD ex_packet;
			end // if
		end // else: !if(reset)
	end // always


//////////////////////////////////////////////////
//                                              //
//                 IC-Stage                     //
//                                              //
//////////////////////////////////////////////////

	ic_stage ic_stage_0(
    .clk(clk),
    .reset(reset),
    .ex_ic_packet_in(ex_ic_packet),
	.clear_all(clear_all),
	.lsq2cdb_value(lsq2cdb_value),
	.lsq2cdb_rob(lsq2cdb_rob),
    // branch exception
    //.exception_rob_tag(exception_rob_tag),//output

    // alu R/V
    .CDB_rob_tag(CDB_rob_tag),
    .CDB_value(CDB_value),
	.CDB_halt(CDB_halt),

    // complete insns number
    .complete_num(complete_num),
	.alu_result(alu_result)
	// .branch_PC(branch_PC)
);



//////////////////////////////////////////////////
//                                              //
//                 Retire-Stage                 //
//                                              //
//////////////////////////////////////////////////


always_comb begin

	packet_2_1_same = 	(rob_packet_out[2].retire_valid && rob_packet_out[1].retire_valid) &&
						(rob_packet_out[2].retire_R_out == rob_packet_out[1].retire_R_out);
	packet_2_0_same = 	(rob_packet_out[2].retire_valid && rob_packet_out[0].retire_valid) &&
						(rob_packet_out[2].retire_R_out == rob_packet_out[0].retire_R_out);
	packet_1_0_same = 	(rob_packet_out[1].retire_valid && rob_packet_out[0].retire_valid) &&
						(rob_packet_out[1].retire_R_out == rob_packet_out[0].retire_R_out);

	// TODO: change id_ex_packet
	wb_reg_wr_en_out[2] = (rob_packet_out[2].retire_R_out != `ZERO_REG) && (rob_packet_out[2].retire_valid);
	wb_reg_wr_en_out[1] = (rob_packet_out[1].retire_R_out != `ZERO_REG) && (rob_packet_out[1].retire_valid) && ((!packet_2_1_same & !packet_2_0_same) | (!packet_2_1_same & !packet_1_0_same));
	wb_reg_wr_en_out[0] = (rob_packet_out[0].retire_R_out != `ZERO_REG) && (rob_packet_out[0].retire_valid) && ((!packet_2_0_same & !packet_1_0_same) );

	for(int i = 0; i < retire_num; i++) begin
		wb_reg_wr_idx_out[i] = rob_packet_out[i].retire_R_out;
		wb_reg_wr_data_out[i] = rob_packet_out[i].retire_V_out;
    end
end

always_ff @(posedge clk)begin
	for(int i = 0; i < retire_num; i++) retire_halt[i] <= `SD rob_packet_out[i].halt;
end



//////////////////////////////////////////////////
//assign dispatch_en = 1'b1;
//////////////////////////////////////////////////
//                                              //
//                 ROB module                   //
//                                              //
//////////////////////////////////////////////////
ROB #(.SIZE(`ROB_SIZE -1)) rob (
	.clk(clk),
	.reset(reset),
	.dispatch_en(dispatch_en),
	.id_packet_in(id_packet),
	.mt_packet_in(mt_packet),
	.RS_available_size(RS_available_size),			//from rs
	.complete_en(complete_en),
	.alu_result_in(alu_result),
	.CDB_rob_tag(CDB_rob_tag), //from ex packet
	.CDB_value(CDB_value), //from ex packet
	.CDB_halt(CDB_halt),
	.retire_en(retire_en),
	// change 0 to LSQ exception
	//.exception_en({{ex_ic_packet[2].take_branch,1'b0}, {ex_ic_packet[1].take_branch,1'b0}, {ex_ic_packet[0].take_branch,1'b0}} ),//from ex stage//LSQ at 0 bit
	.ex_ic_packet_in(ex_ic_packet),
	// fill after implment LSQ
	// .exception_rob_tag(ex_ic_packet[1:0].rob_tag),//from ex stage LSQ or branch predict
	.dispatch_num(dispatch_num),
	.retire_num(retire_num),
	.clear_all(clear_all),
	.rob_packet_out(rob_packet_out),
	.rob_entry_test(rob_entry_test),
	.rob_head(rob_head),
	.branch_PC(branch_PC));//as a rob test


	// .rob_packet_out.dispatch_value_out_1(dispatch_value_out_1),//to RS
	// .rob_packet_out.dispatch_value_out_2(dispatch_value_out_2),//to RS
	// .rob_packet_out.dispatch_num(dispatch_num),
	// .rob_packet_out.assigned_rob_tag(rob_tag), // rob tag to map table
	// .rob_packet_out.retire_R_out(retire_R_out),//to retire stage
	// .rob_packet_out.retire_V_out(retire_V_out),//to retire stage
	// .rob_packet_out.clear_all(clear_all),//



//////////////////////////////////////////////////
//                                              //
//                 MapTable module              //
//                                              //
//////////////////////////////////////////////////

Map_Table #(.SIZE(`MAP_TABLE_SIZE)) map_table(
	.clk(clk),
	.reset(reset),
	.dispatch_en(dispatch_en),
    // .source_reg_idx_in1({id_packet[2].source_reg_idx_in1, id_packet[1].source_reg_idx_in1, id_packet[0].source_reg_idx_in1}),
	// .source_reg_idx_in2({id_packet[2].source_reg_idx_in2, id_packet[1].source_reg_idx_in2, id_packet[0].source_reg_idx_in2}),
    // .dest_reg_idx_in({id_packet[2].dest_reg_idx, id_packet[1].dest_reg_idx, id_packet[0].dest_reg_idx}),
	.id_packet_in(id_packet),
	.rob_dispatch_num(dispatch_num),
	.dest_rob_tag({rob_packet_out[2].assigned_rob_tag, rob_packet_out[1].assigned_rob_tag, rob_packet_out[0].assigned_rob_tag}), // TODO : output from ROB the ROB#
	.complete_en(complete_en),
	.CDB_rob_tag(CDB_rob_tag),
	.retire_en(retire_en),
	.rob_packet_in(rob_packet_out),
	.clear_all(clear_all),
	.mt_packet(mt_packet),
	.check_ready(check_ready)
);





//////////////////////////////////////////////////
//                                              //
//                 RS module                   	//
//                                              //
//////////////////////////////////////////////////

RS rs (
	.clk(clk),
	.reset(reset),
	.dispatch_en(dispatch_en),
	// ? can we do that?
	.id_packet_in(id_packet),
	.mt_packet_in(mt_packet),
	.rob_packet_in(rob_packet_out),
    .issue_en(issue_en),	//??
    .execute_en(execute_en),
	.ex_stage_stall(ex_stage_stall),
	// .execute_rob_tag({is_packet[2].rob_tag, is_packet[1].rob_tag, is_packet[0].rob_tag}),//from is stage
	.is_ex_packet_in(is_ex_packet),
    .complete_en(complete_en),
	.CDB_rob_tag(CDB_rob_tag),//from ex satge
	.CDB_value(CDB_value),//from ex stage
	.complete_num(complete_num),
	.clear_all(clear_all),
	//.LQ_tail_in(LQ_tail_out),
	//.SQ_tail_in(SQ_tail_out),
    .RS_available_size(RS_available_size),
	//.lsq_available_size(lsq_available_size),
	//.RS_idx_test(RS_idx_test), //from rs itself as test
	.rs_packet_out(rs_packet_out),
	.issue_num(issue_num)
);

//////////////////////////////////////////////////
//                                              //
//                 LSQ module                   	//
//                                              //
//////////////////////////////////////////////////




LSQ  lsq (
    .clk(clk),
	.reset(reset),
    //dispatch stage
    .dispatch_en(dispatch_en),
    // complete stage input
    .complete_en(complete_en),
    .ex_ic_packet_in(ex_ic_packet), // ex_ic pipeline register in
    .id_ip_packet_in(id_packet),
    .rob_packet_in(rob_packet_out),
	.retire_en(retire_en),
	.dcache_data_in(dcache_data_in), //
	.dcache_valid_in(dcache_valid_in),//
	.clear_all(clear_all),
	.rob_head(rob_head),
	//.dcache_store_success(dcache_store_success),
	//  output
	.lsq2dcache_addr(lsq2dcache_addr),
	.lsq2dcache_command(lsq2dcache_command),
	.lsq2dcache_data(lsq2dcache_data),
	.lsq2dcache_mem_size(lsq2dcache_mem_size),
	.lsq2cdb_value(lsq2cdb_value),
	.lsq2cdb_rob(lsq2cdb_rob)
	//.lsq_available_size(lsq_available_size)
);


assign proc2Dcache_command = lsq2dcache_command;
always_comb begin
	if(proc2Dcache_command == BUS_LOAD) begin
		proc2Dcache_addr = lsq2dcache_addr;
		//mem2SQ_data = SQ2mem_addr[2] ? Dmem2proc_data[63:32] : Dmem2proc_data[31:0] ;
	end else if (proc2Dcache_command == BUS_STORE) begin
		proc2Dcache_addr = lsq2dcache_addr;
		proc2Dcache_data = lsq2dcache_data;
	end else begin
		proc2Dcache_addr = 0;
	end
end

//////////////////////////////////////////////////
//                                              //
//                 Dcache module                //
//                                              //
//////////////////////////////////////////////////
MEM_SIZE dcache_mem_size;
assign dcache_mem_size = 	(lsq2dcache_mem_size[1:0]  == 2'h0) ? BYTE:
							(lsq2dcache_mem_size[1:0]  == 2'h1) ? HALF:
							(lsq2dcache_mem_size[1:0]  == 2'h2) ? WORD: DOUBLE;
Dcache dcache(
    .clk(clk),
    .reset(reset),
	// inputs from memory (arbiter)
    .Dmem2proc_response(Dmem2proc_response),
    .Dmem2proc_data(Dmem2proc_data),
    .Dmem2proc_tag(Dmem2proc_tag),
	// inputs from proc
    .proc2Dcache_addr(proc2Dcache_addr),
	.proc2Dcache_command(proc2Dcache_command), // TODO: how to decide the command sent to Dcache?
	.proc2Dcache_data(proc2Dcache_data),
	.mem_size(dcache_mem_size),
	//.mem_size(WORD),
	// outputs to memory (arbiter)
    .proc2Dmem_command(proc2Dmem_command),
    .proc2Dmem_addr(proc2Dmem_addr),
	.proc2Dmem_data(proc2Dmem_data),
	//.proc2Dmem_size(),
	// outpus to proc
    .Dcache_data_out(dcache_data_in), // value is memory[proc2Dcache_addr]
    .Dcache_valid_out(dcache_valid_in)      // when this is high
    );


endmodule  // module verisimple
`endif // __PIPELINE_V__
