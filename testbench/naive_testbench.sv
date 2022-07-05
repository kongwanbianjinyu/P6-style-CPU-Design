/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  testbench.v                                         //
//                                                                     //
//  Description :  Testbench module for the verisimple pipeline;       //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

import "DPI-C" function void print_header(string str);
import "DPI-C" function void print_cycles();
import "DPI-C" function void print_close();
import "DPI-C" function void print_change_line();
import "DPI-C" function void print_stage(string div, int inst, int npc, int valid_inst);
import "DPI-C" function void print_reg(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                                       int wb_reg_wr_idx_out, int wb_reg_wr_en_out);

import "DPI-C" function void print_membus(int proc2mem_command, int mem2proc_response,
										int proc2mem_addr_hi, int proc2mem_addr_lo,
										int proc2mem_data_hi, int proc2mem_data_lo);


module testbench;

	// variables used in the testbench
	logic        clk;
	logic        reset;
    logic [31:0] clk_count;
	logic [31:0] instr_count;
	int          wb_fileno;

    logic [1:0][`XLEN-1:0] proc2Imem_addr;
    logic [1:0][63:0] Imem2proc_data;

	logic [63:0]  Dmem2proc_data;
	logic [1:0]  proc2Dmem_command;    // command sent to memory
	logic [`XLEN-1:0] proc2Dmem_addr;      // Address sent to memory
	logic [63:0] proc2Dmem_data;     // Data sent to memory

	logic [1:0]  proc2Dcache_command;    // command sent to memory
	logic [`XLEN-1:0] proc2Dcache_addr;      // Address sent to memory
	logic [31:0] proc2Dcache_data;     // Data sent to memory

	logic  [3:0] Dmem2proc_response;
	logic  [3:0] Dmem2proc_tag;

	EXCEPTION_CODE   pipeline_error_status;

	logic [2:0][4:0] pipeline_commit_wr_idx;
	logic [2:0][`XLEN-1:0] pipeline_commit_wr_data;
	logic [2:0]       pipeline_commit_wr_en;
	logic [2:0][`XLEN-1:0] pipeline_commit_NPC;

	logic [3:0] pipeline_completed_insts;

    logic [63:0] debug_counter;
	logic [63:0] tb_mem [`MEM_64BIT_LINES - 1:0];

    logic [2:0][`XLEN-1:0] if_NPC_out;
	logic [2:0][31:0] if_IR_out;
	logic [2:0]       if_valid_inst_out;
	logic [2:0][`XLEN-1:0] if_id_NPC;
	logic [2:0][31:0] if_id_IR;
	logic [2:0]       if_id_valid_inst;

	logic [2:0][`XLEN-1:0] id_is_NPC_out;
	logic [2:0][31:0] id_is_IR_out;
	logic [2:0]       id_is_valid_inst_out;

	logic [2:0][`XLEN-1:0] is_ex_NPC_out;
	logic [2:0][31:0] is_ex_IR_out;
	logic [2:0]       is_ex_valid_inst_out;

	logic [2:0][`XLEN-1:0] ex_ic_NPC_out;
	logic [2:0][31:0]      ex_ic_IR_out;
	logic [2:0]       	  ex_ic_valid_inst_out;

	logic [2:0][`XLEN-1:0] ic_rt_NPC_out;
	logic [2:0][31:0] ic_rt_IR_out;
	logic [2:0]       ic_rt_valid_inst_out;


	//Instantiate the Data Memory
	mem memory (
		.clk               (clk),
		.proc2mem_command  (proc2Dmem_command),
		.proc2mem_addr     (proc2Dmem_addr),
		.proc2mem_data     (proc2Dmem_data),
		// Outputs

		.mem2proc_response (Dmem2proc_response),
		.mem2proc_data     (Dmem2proc_data),
		.mem2proc_tag      (Dmem2proc_tag)
	);

	assign Imem2proc_data[0] = tb_mem[proc2Imem_addr[0]];
	assign Imem2proc_data[1] = tb_mem[proc2Imem_addr[1]];
	// Generate System Clock
	always begin
		#(`VERILOG_CLOCK_PERIOD/2.0);
		clk = ~clk;
	end

    pipeline core(
		// Inputs
		.clk             (clk),
		.reset             (reset),
		//.mem2proc_response (mem2proc_response),
		.Imem2proc_data     (Imem2proc_data),
		.proc2Imem_addr     (proc2Imem_addr),

		.Dmem2proc_data(Dmem2proc_data),
		.Dmem2proc_response(Dmem2proc_response),
		.Dmem2proc_tag(Dmem2proc_tag),
		.proc2Dmem_command(proc2Dmem_command),
		.proc2Dmem_addr(proc2Dmem_addr),
		.proc2Dmem_data(proc2Dmem_data),

		.proc2Dcache_command(proc2Dcache_command),
		.proc2Dcache_addr(proc2Dcache_addr),
		.proc2Dcache_data(proc2Dcache_data),

		.pipeline_error_status(pipeline_error_status),

		.pipeline_completed_insts(pipeline_completed_insts),
		.pipeline_commit_wr_data(pipeline_commit_wr_data),
		.pipeline_commit_wr_idx(pipeline_commit_wr_idx),
		.pipeline_commit_wr_en(pipeline_commit_wr_en),
		.pipeline_commit_NPC(pipeline_commit_NPC),

		.if_NPC_out(if_NPC_out),
		.if_IR_out(if_IR_out),
		.if_valid_inst_out(if_valid_inst_out),
		.if_id_NPC(if_id_NPC),
		.if_id_IR(if_id_IR),
		.if_id_valid_inst(if_id_valid_inst),
		.id_is_NPC_out(id_is_NPC_out),
		.id_is_IR_out(id_is_IR_out),
		.id_is_valid_inst_out(id_is_valid_inst_out),
		.is_ex_NPC_out(is_ex_NPC_out),
		.is_ex_IR_out(is_ex_IR_out),
		.is_ex_valid_inst_out(is_ex_valid_inst_out),
		.ex_ic_NPC_out(ex_ic_NPC_out),
		.ex_ic_IR_out(ex_ic_IR_out),
		.ex_ic_valid_inst_out(ex_ic_valid_inst_out),
		.ic_rt_NPC_out(ic_rt_NPC_out),
		.ic_rt_IR_out(ic_rt_IR_out),
		.ic_rt_valid_inst_out(ic_rt_valid_inst_out)
	);

    // Task to display # of elapsed clk edges
	task show_clk_count;
		real cpi;
		
		begin
			cpi = (clk_count + 1.0) / instr_count;
			$display("@@  %0d cycles / %0d instrs = %f CPI\n@@",
			          clk_count+1, instr_count, cpi);
			$display("@@  %4.2f ns total time to execute\n@@\n",
			          clk_count*`VERILOG_CLOCK_PERIOD);
		end
	endtask  // task show_clk_count 


	// Show contents of a range of Unified Memory, in both hex and decimal
	task show_mem_with_decimal;
		input [31:0] start_addr;
		input [31:0] end_addr;
		int showing_data;
		begin
			//$display("@@@");
			showing_data=0;
			for(int k=start_addr;k<=end_addr; k=k+1)
				if (memory.unified_memory[k] != 0) begin
					$display("@@@ mem[%5d] = %x : %0d", k*8, memory.unified_memory[k],
				                                            memory.unified_memory[k]);
					showing_data=1;
				end else if(showing_data!=0) begin
					$display("@@@");
					showing_data=0;
				end
			$display("@@@");
		end
	endtask  // task show_mem_with_decimal

    // Count the number of posedges and number of instructions completed
	// till simulation ends
	always @(posedge clk) begin
		if(reset) begin
			clk_count <= `SD 0;
			instr_count <= `SD 0;
		end else begin
			clk_count <= `SD (clk_count + 1);
			instr_count <= `SD (instr_count + pipeline_completed_insts);
		end
	end

    always @(negedge clk) begin
        if(reset) begin
			// $display("@@\n@@  %t : System STILL at reset, can't show anything\n@@",
			//          $realtime);
			//$display("@@@ Unified Memory contents hex on left, decimal on right:\n@@");
            debug_counter <= `SD 0;
        end else begin
			`SD;
			`SD;
            debug_counter <= `SD debug_counter  + 1;
			 // print the piepline stuff via c code to the pipeline.out
			 print_cycles();//TODO
			 for(int i = 0; i < 3; i++) begin
				print_stage(" ", if_IR_out[i], if_NPC_out[i], {31'b0,if_valid_inst_out[i]});//Fetch stage//
				print_stage("|", if_id_IR[i], if_id_NPC[i], {31'b0,if_id_valid_inst[i]});//Dispatch stage//
				print_stage("|", id_is_IR_out[i], id_is_NPC_out[i], {31'b0,id_is_valid_inst_out[i]});//Issue stage from RS_issue
				print_stage("|", is_ex_IR_out[i], is_ex_NPC_out[i], {31'b0,is_ex_valid_inst_out[i]});//Excute stage from IS/EX reg
				print_stage("|", ex_ic_IR_out[i], ex_ic_NPC_out[i], {31'b0,ex_ic_valid_inst_out[i]});//Complete stage from EX/IC reg
				print_stage("|", ic_rt_IR_out[i], ic_rt_NPC_out[i], {31'b0,ic_rt_valid_inst_out[i]});//Retire stage from ROB retire
				print_reg(32'b0, pipeline_commit_wr_data[i][31:0],{27'b0,pipeline_commit_wr_idx[i]}, {31'b0,pipeline_commit_wr_en[i]});
				// print_membus({30'b0,proc2Dmem_command}, {28'b0,Dmem2proc_response},
				// 				32'b0, proc2Dmem_addr[31:0],
				// 				proc2Dmem_data[63:32], proc2Dmem_data[31:0]);
				if( i < 1 ) begin
			    print_membus({30'b0,proc2Dcache_command}, {28'b0,Dmem2proc_response},
								32'b0, proc2Dcache_addr[31:0],
								32'b0, proc2Dcache_data[31:0]);
				end
				if(i < 2) print_change_line();
			 end

             // print the writeback information to writeback.out
			for(int i = 0; i < 3; i++) begin
				if(pipeline_commit_wr_en[i])
					$fdisplay(wb_fileno, "PC=%x, REG[%d]=%x",
						pipeline_commit_NPC[i] - 4,
						pipeline_commit_wr_idx[i],
						pipeline_commit_wr_data[i]);
				// else
				// 	$fdisplay(wb_fileno, "PC=%x, ---",pipeline_commit_NPC-4);
			end
			 if(pipeline_error_status != NO_ERROR || debug_counter > 50000) begin

				show_mem_with_decimal(0,`MEM_64BIT_LINES - 1);
				// 8Bytes per line, 16kB total
                //$display("@@  %t : System halted\n@@", $realtime);
				case(pipeline_error_status)
					LOAD_ACCESS_FAULT:
						$display("@@@ System halted on memory error");
					HALTED_ON_WFI:
						$display("@@@ System halted on WFI instruction");
					ILLEGAL_INST:
						$display("@@@ System halted on illegal instruction");
					default:
						$display("@@@ System halted on unknown error code %x",
							pipeline_error_status);
				endcase
				$display("@@@\n@@");
                show_clk_count;
				print_close(); // close the pipe_print output file
				$fclose(wb_fileno);
				#100 $finish;
             end
        end
    end
	initial begin
		$dumpvars;
		$display("@@@ Unified Memory contents hex on left, decimal on right:\n@@@");
		$readmemh("program.mem", tb_mem);


		clk = 1'b0;
		reset = 1'b0;

		// Pulse the reset signal
		//$display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
		reset = 1'b1;
		@(posedge clk);
		@(posedge clk);
		$readmemh("program.mem", memory.unified_memory);

		@(posedge clk);
		@(posedge clk);
		`SD;
		// This reset is at an odd time to avoid the pos & neg clk edges

		reset = 1'b0;
  		//$display("@@  %t  Deasserting System reset......\n@@\n", $realtime);
		wb_fileno = $fopen("writeback.out");

		//Open header AFTER throwing the reset otherwise the reset state is displayed
		print_header("                                                                           				 D-MEM Bus &\n");
		print_header("Cycle:      IF      |     ID      |     IS      |     EX      |     IC      |     IR      |Reg Result");

	end


endmodule  // module testbench
