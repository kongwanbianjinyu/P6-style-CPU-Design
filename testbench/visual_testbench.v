/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  visual_testbench.v                                  //
//                                                                     //
//  Description :  Testbench module for the verisimple pipeline        //
//                   for the visual debugger                           //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

extern void initcurses(int,int,int,int,int,int,int,int,int,int,int,int);
extern void flushpipe();
extern void waitforresponse();
extern void initmem();
extern int get_instr_at_pc(int);
extern int not_valid_pc(int);

module testbench();

  // variables used in the testbench
	logic        clock;
	logic        reset;
    logic [31:0] clock_count;
	int          wb_fileno;

    logic [1:0][`XLEN-1:0] proc2Imem_addr;
    logic [1:0][63:0] Imem2proc_data;

	logic [63:0]  Dmem2proc_data;
	logic [1:0]  proc2Dmem_command;    // command sent to memory
	logic [`XLEN-1:0] proc2Dmem_addr;      // Address sent to memory
	logic [63:0] proc2Dmem_data;     // Data sent to memory

	logic  [3:0] Dmem2proc_response; 
	logic  [3:0] Dmem2proc_tag;

	EXCEPTION_CODE   pipeline_error_status;

	logic [2:0][4:0] pipeline_commit_wr_idx;
	logic [2:0][`XLEN-1:0] pipeline_commit_wr_data;
	logic [2:0]       pipeline_commit_wr_en;
	logic [2:0][`XLEN-1:0] pipeline_commit_NPC;

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
	// Instantiate the Pipeline
	pipeline pipeline_0(
		// Inputs
		.clock             (clock),
		.reset             (reset),
		//.mem2proc_response (mem2proc_response),
		.Imem2proc_data     (Imem2proc_data),
		.proc2Imem_addr     (proc2Imem_addr),

		.Dmem2proc_data(Dmem2proc_data),
		.proc2Dmem_command(proc2Dmem_command),
		.proc2Dmem_addr(proc2Dmem_addr),
		.proc2Dmem_data(proc2Dmem_data),

		.pipeline_error_status(pipeline_error_status),

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


	//Instantiate the Data Memory
	mem memory (
		.clk               (clock),
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
		clock = ~clock;
	end

  // Count the number of posedges and number of instructions completed
  // till simulation ends
  // Count the number of posedges and number of instructions completed
	// till simulation ends
	always @(posedge clock) begin
		if(reset) begin
			clock_count <= `SD 0;
		end else begin
			clock_count <= `SD (clock_count + 1);
		end
	end   

  initial
  begin
    clock = 0;
    reset = 0;

    // Call to initialize visual debugger
    // *Note that after this, all stdout output goes to visual debugger*
    // each argument is number of registers/signals for the group
    // (IF, IF/ID, ID, ID/EX, EX, EX/MEM, MEM, MEM/WB, WB, Misc)
    initcurses(13,10,39,18,12,37,4,6,9,5,16,1);

    // Pulse the reset signal
    reset = 1'b1;
    @(posedge clock);
    @(posedge clock);

    // Read program contents into memory array
    $readmemh("program.mem", tb_mem);

    @(posedge clock);
    @(posedge clock);
    `SD;
    // This reset is at an odd time to avoid the pos & neg clock edges
    reset = 1'b0;
  end

  always @(negedge clock)
  begin
    if(!reset)
    begin
      `SD;
      `SD;

      // deal with any halting conditions
      if(pipeline_error_status!=NO_ERROR)
      begin
        #100
        $display("\nDONE\n");
        waitforresponse();
        flushpipe();
        $finish;
      end

    end
  end 

  // This block is where we dump all of the signals that we care about to
  // the visual debugger.  Notice this happens at *every* clock edge.
  always @(clock) begin
    #2;

    // Dump clock and time onto stdout
    $display("c%h%7.0d",clock,clock_count);
    $display("t%8.0f",$time);
    $display("z%h",reset);

    // dump ARF contents
    $write("a");
    for(int i = 0; i < 32; i=i+1)
    begin
      $write("%h", pipeline_0.id_stage_0.regf_0.registers[i]);
    end
    $display("");

    // dump Map Table contents
    $write("l");
    for(int i = 0; i < 32; i=i+1)
    begin
      $write("%h", pipeline_0.map_table.mt_entry[i].rob_tag);
    end
    $display("");

    // dump IR information so we can see which instruction
    // is in each stage
    $write("p");
    $write("%h%h%h%h%h%h%h%h%h%h%h%h",
            pipeline_0.if_IR_out[0], pipeline_0.if_valid_inst_out[0],
            pipeline_0.if_id_IR[0],  pipeline_0.if_id_valid_inst[0],
            pipeline_0.id_is_IR_out[0],  pipeline_0.id_is_valid_inst_out[0],
            pipeline_0.is_ex_IR_out[0], pipeline_0.is_ex_valid_inst_out[0],
            pipeline_0.ex_ic_IR_out[0], pipeline_0.ex_ic_valid_inst_out[0],
            pipeline_0.ic_rt_IR_out[0], pipeline_0.ic_rt_valid_inst_out[0]);
    $write("%h%h%h%h%h%h%h%h%h%h%h%h",
            pipeline_0.if_IR_out[1], pipeline_0.if_valid_inst_out[1],
            pipeline_0.if_id_IR[1],  pipeline_0.if_id_valid_inst[1],
            pipeline_0.id_is_IR_out[1],  pipeline_0.id_is_valid_inst_out[1],
            pipeline_0.is_ex_IR_out[1], pipeline_0.is_ex_valid_inst_out[1],
            pipeline_0.ex_ic_IR_out[1], pipeline_0.ex_ic_valid_inst_out[1],
            pipeline_0.ic_rt_IR_out[1], pipeline_0.ic_rt_valid_inst_out[1]);
    $write("%h%h%h%h%h%h%h%h%h%h%h%h ",
            pipeline_0.if_IR_out[2], pipeline_0.if_valid_inst_out[2],
            pipeline_0.if_id_IR[2],  pipeline_0.if_id_valid_inst[2],
            pipeline_0.id_is_IR_out[2],  pipeline_0.id_is_valid_inst_out[2],
            pipeline_0.is_ex_IR_out[2], pipeline_0.is_ex_valid_inst_out[2],
            pipeline_0.ex_ic_IR_out[2], pipeline_0.ex_ic_valid_inst_out[2],
            pipeline_0.ic_rt_IR_out[2], pipeline_0.ic_rt_valid_inst_out[2]);
    $display("");
    
    // Dump interesting register/signal contents onto stdout
    // format is "<reg group prefix><name> <width in hex chars>:<data>"
    // Current register groups (and prefixes) are:
    // f: IF   d: ID   e: EX   m: MEM    w: WB  v: misc. reg
    // g: IF/ID   h: ID/EX  i: EX/MEM  j: MEM/WB

    // IF signals (13) - prefix 'f'
    $display("fNPC[0] 8:%h",          pipeline_0.if_packet[0].NPC);
    $display("fIR[0] 8:%h",            pipeline_0.if_packet[0].inst);
    $display("fif_valid[0] 1:%h",      pipeline_0.if_packet[0].valid);
    $display("fNPC[1] 8:%h",          pipeline_0.if_packet[1].NPC);
    $display("fIR[1] 8:%h",            pipeline_0.if_packet[1].inst);
    $display("fif_valid[1] 1:%h",      pipeline_0.if_packet[1].valid);
    $display("fNPC[2] 8:%h",          pipeline_0.if_packet[2].NPC);
    $display("fIR[2] 8:%h",            pipeline_0.if_packet[2].inst);
    $display("fif_valid[2] 1:%h",      pipeline_0.if_packet[2].valid);
    $display("fImem_addr[0] 8:%h",    pipeline_0.if_stage_0.proc2Imem_addr[0]);
    $display("fImem_addr[1] 8:%h",    pipeline_0.if_stage_0.proc2Imem_addr[1]);
    $display("fPC_en 1:%h",         pipeline_0.if_stage_0.PC_enable);
    $display("fPC_reg 8:%h",       pipeline_0.if_stage_0.PC_reg);

    // IF/ID signals (10) - prefix 'g'
    $display("genable 1:%h",        pipeline_0.if_id_enable);
    $display("gNPC[0] 16:%h",          pipeline_0.if_id_packet[0].NPC);
    $display("gIR[0] 8:%h",            pipeline_0.if_id_packet[0].inst);
    $display("gvalid[0] 1:%h",         pipeline_0.if_id_packet[0].valid);
    $display("gNPC[1] 16:%h",          pipeline_0.if_id_packet[1].NPC);
    $display("gIR[1] 8:%h",            pipeline_0.if_id_packet[1].inst);
    $display("gvalid[1] 1:%h",         pipeline_0.if_id_packet[1].valid);
    $display("gNPC[2] 16:%h",          pipeline_0.if_id_packet[2].NPC);
    $display("gIR[2] 8:%h",            pipeline_0.if_id_packet[2].inst);
    $display("gvalid[2] 1:%h",         pipeline_0.if_id_packet[2].valid);

    // ID signals (39) - prefix 'd'
    $display("drs1[0] 8:%h",         pipeline_0.id_packet[0].rs1_value);
    $display("drs2[0] 8:%h",         pipeline_0.id_packet[0].rs2_value);
    $display("ddest_reg[0] 2:%h",      pipeline_0.id_packet[0].dest_reg_idx);
    $display("drd_mem[0] 1:%h",        pipeline_0.id_packet[0].rd_mem);
    $display("dwr_mem[0] 1:%h",        pipeline_0.id_packet[0].wr_mem);
    $display("dopa_sel[0] 1:%h",       pipeline_0.id_packet[0].opa_select);
    $display("dopb_sel[0] 1:%h",       pipeline_0.id_packet[0].opb_select);
    $display("dalu_func[0] 2:%h",      pipeline_0.id_packet[0].alu_func);
    $display("dcond_br[0] 1:%h",       pipeline_0.id_packet[0].cond_branch);
    $display("duncond_br[0] 1:%h",     pipeline_0.id_packet[0].uncond_branch);
    $display("dhalt[0] 1:%h",          pipeline_0.id_packet[0].halt);
    $display("dillegal[0] 1:%h",       pipeline_0.id_packet[0].illegal);
    $display("dvalid[0] 1:%h",         pipeline_0.id_packet[0].valid);
    
    $display("drs1[1] 8:%h",         pipeline_0.id_packet[1].rs1_value);
    $display("drs2[1] 8:%h",         pipeline_0.id_packet[1].rs2_value);
    $display("ddest_reg[1] 2:%h",      pipeline_0.id_packet[1].dest_reg_idx);
    $display("drd_mem[1] 1:%h",        pipeline_0.id_packet[1].rd_mem);
    $display("dwr_mem[1] 1:%h",        pipeline_0.id_packet[1].wr_mem);
    $display("dopa_sel[1] 1:%h",       pipeline_0.id_packet[1].opa_select);
    $display("dopb_sel[1] 1:%h",       pipeline_0.id_packet[1].opb_select);
    $display("dalu_func[1] 2:%h",      pipeline_0.id_packet[1].alu_func);
    $display("dcond_br[1] 1:%h",       pipeline_0.id_packet[1].cond_branch);
    $display("duncond_br[1] 1:%h",     pipeline_0.id_packet[1].uncond_branch);
    $display("dhalt[1] 1:%h",          pipeline_0.id_packet[1].halt);
    $display("dillegal[1] 1:%h",       pipeline_0.id_packet[1].illegal);
    $display("dvalid[1] 1:%h",         pipeline_0.id_packet[1].valid);

    $display("drs1[2] 8:%h",         pipeline_0.id_packet[2].rs1_value);
    $display("drs2[2] 8:%h",         pipeline_0.id_packet[2].rs2_value);
    $display("ddest_reg[2] 2:%h",      pipeline_0.id_packet[2].dest_reg_idx);
    $display("drd_mem[2] 1:%h",        pipeline_0.id_packet[2].rd_mem);
    $display("dwr_mem[2] 1:%h",        pipeline_0.id_packet[2].wr_mem);
    $display("dopa_sel[2] 1:%h",       pipeline_0.id_packet[2].opa_select);
    $display("dopb_sel[2] 1:%h",       pipeline_0.id_packet[2].opb_select);
    $display("dalu_func[2] 2:%h",      pipeline_0.id_packet[2].alu_func);
    $display("dcond_br[2] 1:%h",       pipeline_0.id_packet[2].cond_branch);
    $display("duncond_br[2] 1:%h",     pipeline_0.id_packet[2].uncond_branch);
    $display("dhalt[2] 1:%h",          pipeline_0.id_packet[2].halt);
    $display("dillegal[2] 1:%h",       pipeline_0.id_packet[2].illegal);
    $display("dvalid[2] 1:%h",         pipeline_0.id_packet[2].valid);

    // IS/EX signals (18) - prefix 'h'
    $display("henable 1:%h",        pipeline_0.id_ex_enable);
    $display("hRS_tag 1:%h",        pipeline_0.is_ex_packet[0].RS_tag);
    $display("hrob_tag 3:%h",       pipeline_0.is_ex_packet[0].rob_tag);
    $display("hNPC 16:%h",          pipeline_0.is_ex_packet[0].NPC); 
    $display("hIR 8:%h",            pipeline_0.is_ex_packet[0].inst); 
    $display("hrs1 8:%h",          pipeline_0.is_ex_packet[0].rs1_value); 
    $display("hrs2 8:%h",          pipeline_0.is_ex_packet[0].rs2_value); 
    $display("hrd_mem 1:%h",        pipeline_0.is_ex_packet[0].rd_mem);
    $display("hwr_mem 1:%h",        pipeline_0.is_ex_packet[0].wr_mem);
    $display("hopa_sel 1:%h",       pipeline_0.is_ex_packet[0].opa_select);
    $display("hopb_sel 1:%h",       pipeline_0.is_ex_packet[0].opb_select);
    $display("halu_func 2:%h",      pipeline_0.is_ex_packet[0].alu_func);
    $display("hcond_br 1:%h",       pipeline_0.is_ex_packet[0].cond_branch);
    $display("huncond_br 1:%h",     pipeline_0.is_ex_packet[0].uncond_branch);
    $display("hhalt 1:%h",          pipeline_0.is_ex_packet[0].halt);
    $display("hvalid 1:%h",         pipeline_0.is_ex_packet[0].issue_valid);
    $display("hload_pos 1:%h",        pipeline_0.is_ex_packet[0].load_pos);
    $display("hstore_pos 1:%h",         pipeline_0.is_ex_packet[0].store_pos); 


    // EX signals (12) - prefix 'e'
    $display("eopa_mux[0] 8:%h",      pipeline_0.ex_stage_0.opa_mux_out[0]);
    $display("eopb_mux[0] 8:%h",      pipeline_0.ex_stage_0.opb_mux_out[0]);
    $display("ealu_result[0] 8:%h",   pipeline_0.ex_packet[0].alu_result);
    $display("etake_branch[0] 1:%h",   pipeline_0.ex_packet[0].take_branch);

    $display("eopa_mux[1] 8:%h",      pipeline_0.ex_stage_0.opa_mux_out[1]);
    $display("eopb_mux[1] 8:%h",      pipeline_0.ex_stage_0.opb_mux_out[1]);
    $display("ealu_result[1] 8:%h",   pipeline_0.ex_packet[1].alu_result);
    $display("etake_branch[1] 1:%h",   pipeline_0.ex_packet[1].take_branch);

    $display("eopa_mux[2] 8:%h",      pipeline_0.ex_stage_0.opa_mux_out[2]);
    $display("eopb_mux[2] 8:%h",      pipeline_0.ex_stage_0.opb_mux_out[2]);
    $display("ealu_result[2] 8:%h",   pipeline_0.ex_packet[2].alu_result);
    $display("etake_branch[2] 1:%h",   pipeline_0.ex_packet[2].take_branch);

    // EX/IC signals (37) - prefix 'i'
    $display("ienable 1:%h",        pipeline_0.ex_ic_enable);
    $display("irob_tag[0] 3:%h",       pipeline_0.ex_ic_packet[0].rob_tag);
    $display("iNPC[0] 8:%h",          pipeline_0.ex_ic_packet[0].NPC);
    $display("iIR[0] 8:%h",            pipeline_0.ex_ic_IR_out[0]);
    $display("irs2[0] 8:%h",          pipeline_0.ex_ic_packet[0].rs2_value);
    $display("ialu_result[0] 8:%h",   pipeline_0.ex_ic_packet[0].alu_result);
    $display("ird_mem[0] 1:%h",        pipeline_0.ex_ic_packet[0].rd_mem);
    $display("iwr_mem[0] 1:%h",        pipeline_0.ex_ic_packet[0].wr_mem);
    $display("itake_branch[0] 1:%h",   pipeline_0.ex_ic_packet[0].take_branch);
    $display("ihalt[0] 1:%h",          pipeline_0.ex_ic_packet[0].halt);
    $display("ivalid[0] 1:%h",         pipeline_0.ex_ic_packet[0].exe_valid);
    $display("iload_pos[0] 1:%h",      pipeline_0.ex_ic_packet[0].load_pos);
    $display("istore_pos[0] 1:%h",     pipeline_0.ex_ic_packet[0].store_pos); 
    
    $display("irob_tag[1] 3:%h",       pipeline_0.ex_ic_packet[1].rob_tag);
    $display("iNPC[1] 8:%h",          pipeline_0.ex_ic_packet[1].NPC);
    $display("iIR[1] 8:%h",            pipeline_0.ex_ic_IR_out[1]);
    $display("irs2[1] 8:%h",          pipeline_0.ex_ic_packet[1].rs2_value);
    $display("ialu_result[1] 8:%h",   pipeline_0.ex_ic_packet[1].alu_result);
    $display("ird_mem[1] 1:%h",        pipeline_0.ex_ic_packet[1].rd_mem);
    $display("iwr_mem[1] 1:%h",        pipeline_0.ex_ic_packet[1].wr_mem);
    $display("itake_branch[1] 1:%h",   pipeline_0.ex_ic_packet[1].take_branch);
    $display("ihalt[1] 1:%h",          pipeline_0.ex_ic_packet[1].halt);
    $display("ivalid[1] 1:%h",         pipeline_0.ex_ic_packet[1].exe_valid);
    $display("iload_pos[1] 1:%h",      pipeline_0.ex_ic_packet[1].load_pos);
    $display("istore_pos[1] 1:%h",     pipeline_0.ex_ic_packet[1].store_pos); 

    $display("irob_tag[2] 3:%h",       pipeline_0.ex_ic_packet[2].rob_tag);
    $display("iNPC[2] 8:%h",          pipeline_0.ex_ic_packet[2].NPC);
    $display("iIR[2] 8:%h",            pipeline_0.ex_ic_IR_out[2]);
    $display("irs2[2] 8:%h",          pipeline_0.ex_ic_packet[2].rs2_value);
    $display("ialu_result[2] 8:%h",   pipeline_0.ex_ic_packet[2].alu_result);
    $display("ird_mem[2] 1:%h",        pipeline_0.ex_ic_packet[2].rd_mem);
    $display("iwr_mem[2] 1:%h",        pipeline_0.ex_ic_packet[2].wr_mem);
    $display("itake_branch[2] 1:%h",   pipeline_0.ex_ic_packet[2].take_branch);
    $display("ihalt[2] 1:%h",          pipeline_0.ex_ic_packet[2].halt);
    $display("ivalid[2] 1:%h",         pipeline_0.ex_ic_packet[2].exe_valid);
    $display("iload_pos[2] 1:%h",      pipeline_0.ex_ic_packet[2].load_pos);
    $display("istore_pos[2] 1:%h",     pipeline_0.ex_ic_packet[2].store_pos); 


    // MEM signals (4) - prefix 'm'
    $display("mmem_data 16:%h",     pipeline_0.Dmem2proc_data);
    //$display("mresult_out 8:%h",   pipeline_0.mem_result_out);
    $display("m2Dmem_data 16:%h",   pipeline_0.proc2Dmem_data);
    $display("m2Dmem_addr 8:%h",   pipeline_0.proc2Dmem_addr);
    $display("m2Dmem_cmd 1:%h",     pipeline_0.proc2Dmem_command);


    // CDB signals (6) - prefix 'j'
    $display("jCDB_rob_tag[0] 3:%h",     pipeline_0.ic_stage_0.CDB_rob_tag[0]);
    $display("jCDB_value[0] 8:%h",      pipeline_0.ic_stage_0.CDB_value[0]);

    $display("jCDB_rob_tag[1] 3:%h",     pipeline_0.ic_stage_0.CDB_rob_tag[1]);
    $display("jCDB_value[1] 8:%h",      pipeline_0.ic_stage_0.CDB_value[1]);

    $display("jCDB_rob_tag[2] 3:%h",     pipeline_0.ic_stage_0.CDB_rob_tag[2]);
    $display("jCDB_value[2] 8:%h",      pipeline_0.ic_stage_0.CDB_value[2]);

    // WB signals (9) - prefix 'w'
    $display("wwr_data[0] 8:%h",      pipeline_0.wb_reg_wr_data_out[0]);
    $display("wwr_idx[0] 2:%h",        pipeline_0.wb_reg_wr_idx_out[0]);
    $display("wwr_en[0] 1:%h",         pipeline_0.wb_reg_wr_en_out[0]);

    $display("wwr_data[1] 8:%h",      pipeline_0.wb_reg_wr_data_out[1]);
    $display("wwr_idx[1] 2:%h",        pipeline_0.wb_reg_wr_idx_out[1]);
    $display("wwr_en[1] 1:%h",         pipeline_0.wb_reg_wr_en_out[1]);

    $display("wwr_data[2] 8:%h",      pipeline_0.wb_reg_wr_data_out[2]);
    $display("wwr_idx[2] 2:%h",        pipeline_0.wb_reg_wr_idx_out[2]);
    $display("wwr_en[2] 1:%h",         pipeline_0.wb_reg_wr_en_out[2]);


    // ROB signals (5) - prefix 'o' // donn't use 'b', because it is break
    $display("ohead 3:%h",      pipeline_0.rob.head);
    $display("otail 3:%h",      pipeline_0.rob.tail);
    $display("orob_tag[0] 3:%h",      pipeline_0.rob_packet_out[0].assigned_rob_tag);
    $display("orob_tag[1] 3:%h",      pipeline_0.rob_packet_out[1].assigned_rob_tag);
    $display("orob_tag[2] 3:%h",      pipeline_0.rob_packet_out[2].assigned_rob_tag);

    // RS signals (16) - prefix 's'
    $display("sissue_num 1:%h",      pipeline_0.issue_num);
    $display("sT[0] 3:%h",      pipeline_0.rs_packet_out[0].rs_entry.T);
    $display("sT1[0] 3:%h",      pipeline_0.rs_packet_out[0].rs_entry.T1);
    $display("sT2[0] 3:%h",      pipeline_0.rs_packet_out[0].rs_entry.T2);
    $display("sV1[0] 8:%h",      pipeline_0.rs_packet_out[0].rs_entry.V1);
    $display("sV2[0] 8:%h",      pipeline_0.rs_packet_out[0].rs_entry.V2);

    $display("sT[1] 3:%h",      pipeline_0.rs_packet_out[1].rs_entry.T);
    $display("sT1[1] 3:%h",      pipeline_0.rs_packet_out[1].rs_entry.T1);
    $display("sT2[1] 3:%h",      pipeline_0.rs_packet_out[1].rs_entry.T2);
    $display("sV1[1] 8:%h",      pipeline_0.rs_packet_out[1].rs_entry.V1);
    $display("sV2[1] 8:%h",      pipeline_0.rs_packet_out[1].rs_entry.V2);

    $display("sT[2] 3:%h",      pipeline_0.rs_packet_out[2].rs_entry.T);
    $display("sT1[2] 3:%h",      pipeline_0.rs_packet_out[2].rs_entry.T1);
    $display("sT2[2] 3:%h",      pipeline_0.rs_packet_out[2].rs_entry.T2);
    $display("sV1[2] 8:%h",      pipeline_0.rs_packet_out[2].rs_entry.V1);
    $display("sV2[2] 8:%h",      pipeline_0.rs_packet_out[2].rs_entry.V2);


    // Misc signals(1) - prefix 'v'
    //$display("vcompleted 1:%h",     pipeline_0.pipeline_completed_insts);
    $display("vpipe_err 1:%h",      pipeline_error_status);


    // must come last
    $display("break");

    // This is a blocking call to allow the debugger to control when we
    // advance the simulation
    waitforresponse();
  end
endmodule
