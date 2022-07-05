module testbench;
	logic                           clk,reset;
    // Dispatch stage
    logic                           dispatch_en;
    COMMAND                         command;
    // Dispatch stage, read tags logic
    logic [2:0]        source_reg_idx_in1 [2:0]; // source reg rs1
    logic [2:0]        source_reg_idx_in2 [2:0]; // source reg rs2

    // Dispatch stage, write tags logic
    logic [2:0]        dest_reg_idx_in [2:0]; // dest reg rd
    logic [1:0]                     rob_dispatch_num; // dispatch insn number : {0,1,2,3}
    logic [$clog2(`ROB_SIZE)-1:0]   rob_tail_in; // tail pointer, from ROB

    // Complete Stage
    logic                           complete_en;
    logic [$clog2(`ROB_SIZE)-1:0]   CDB_tag_in [2:0]; // CDB tag
    logic [1:0]                     rob_complete_num;// complete insn number : {0,1,2,3}
    

    // Dispatch stage, read tags output
    logic [$clog2(`ROB_SIZE)-1:0]    tag_out1 [2:0]; // rob number
    logic [$clog2(`ROB_SIZE)-1:0]    tag_out2 [2:0];
    logic                            ready_out1 [2:0]; // ready "+" signal
    logic                            ready_out2 [2:0];
    logic [2:0]                      hit1 ; // whether find flag, whether tag_out and ready_out is meaningful. If hit, RS can use tag_out, otherwise RS use RRF.v or ROB.v
    logic [2:0]                      hit2 ;
	logic [`TEST_SIZE - 1:0]               check_ready;

	`DUT(Map_Table) #(.SIZE(`TEST_SIZE)) dut (.clk, .reset, 
                                        .dispatch_en, .command, 
                                        .source_reg_idx_in1, .source_reg_idx_in2, 
                                        .dest_reg_idx_in, .rob_dispatch_num,.rob_tail_in,
                                        .complete_en,.CDB_tag_in,.rob_complete_num,
                                        .tag_out1, .tag_out2,.ready_out1,.ready_out2,.hit1,.hit2,
										.check_ready);
	
	always #5 clk = ~clk;
	
	task exit_on_error;
		begin
			#1;
			$display("@@@Failed at time %f", $time);
			$finish;
		end
	endtask
	
	initial begin
		
		$monitor("Command: %s, dispatch_en: %b, complete_en: %b, tag_out1[0]: %h,  tag_out2[0]: %h, ready_out1[0]: %h,  hit1[0]: %b ,check_ready :%b", command.name, dispatch_en, complete_en, tag_out1[0], tag_out2[0], ready_out1[0], hit1[0],check_ready);
	
		clk = 0;
		dispatch_en = 1;
		complete_en = 0;
		command = READ;
		source_reg_idx_in1[0] = 1;
		source_reg_idx_in1[1] = 0;
		source_reg_idx_in1[2] = 0;
		source_reg_idx_in2[0] = 2;
		source_reg_idx_in2[1] = 0;
		source_reg_idx_in2[2] = 0;

		
		/***RESET***/		
		reset = 1;
		@(negedge clk)
		reset = 0;
		
		/***CHECK THAT ALL ELEMENTS ARE INVALID***/
		@(negedge clk);
		assert(!hit1 && !hit2) else #1 exit_on_error;
		
		/***DISPATCH STAGE: WRITE TAG****/
		command = WRITE;
		dest_reg_idx_in[0] = 1; //r1
		dest_reg_idx_in[1] = 2; //r2
		dest_reg_idx_in[2] = 3; //r3

		rob_dispatch_num = 2;
		rob_tail_in = 5;


		/***DISPATCH STAGE: READ TAG****/
		@(negedge clk);
		// already set Tag
		command = READ;
		@(negedge clk);
		assert(hit1[0] && hit2[0] && tag_out1[0] == 4 && tag_out2[0] == 5) else #1 exit_on_error;
		assert(!hit1[1] && !hit2[1]) else #1 exit_on_error;
		assert(!hit1[2] && !hit2[2]) else #1 exit_on_error;


		$display("@@@Dispatch Passed");

		/***COMPLETE STAGE TEST****/
		@(negedge clk);
		complete_en = 1;
		dispatch_en = 0;
		rob_complete_num = 1;
		CDB_tag_in[0] = 5;
		CDB_tag_in[1] = 0;
		CDB_tag_in[2] = 0;
		@(negedge clk);
		assert(check_ready[2] == 1'b1) else #1 exit_on_error;
		$display("@@@Complete Passed");

		$finish;
		
	end
	
endmodule