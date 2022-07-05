module testbench;
	logic                      clk,reset;
    // Dispatch stage input
    logic                      dispatch_en;
    logic [2:0][4:0]           dest_reg_idx_in;      // 3-way dest reg index
    logic [1:0]                 valid_insn_num;             // valid instruction number : 0,1,2,3, from RS

    logic [2:0][$clog2(`TEST_SIZE)-1:0]    map_table_rob_num;    // from map table, which number is ready
    //logic[2:0]                 map_table_tag_ready;        // from map table, +

    // Complete stage input
    logic                      complete_en;
    logic [2:0][$clog2(`TEST_SIZE)-1:0]    CDB_rob_num;          // CDB tag
    logic [2:0][31:0]                CDB_value ;            // CDB value

    // Retire stage input
    logic                      retire_en;

    logic [1:0]             	exception_en; // exception_en[0]: LSQ exception; exception_en[1]: Branch exception;
    logic [1:0][$clog2(`TEST_SIZE)-1:0]  exception_rob_tag;
    // Dispatch stage output
    logic [2:0][31:0]           dispatch_value_out ;   // value output to RS if map table ready
	logic [$clog2(`TEST_SIZE)-1:0] head_test;
    logic [$clog2(`TEST_SIZE)-1:0] tail_test;

    // Retire stage output
    logic [2:0][4:0]  retire_R_out ;
    logic [2:0][31:0] retire_V_out ;
	logic                clear_all;
	ROB_ENTRY [`TEST_SIZE-1:0] rob_entry_test;

	ROB #(.SIZE(`TEST_SIZE -1)) rob (.clk, .reset,
									.dispatch_en, .dest_reg_idx_in, .valid_insn_num, .map_table_rob_num,
									.complete_en, .CDB_rob_num, .CDB_value,
									.retire_en, .exception_en, .exception_rob_tag,
									.dispatch_value_out,.head_test,.tail_test, .retire_R_out,.retire_V_out,.clear_all,.rob_entry_test);
	
	always #5 clk = ~clk;
	
	task exit_on_error;
		begin
			#1;
			$display("@@@Failed at time %f", $time);
			$finish;
		end
	endtask
	
	initial begin
		
		$monitor("dispatch_en: %b, head:%d, tail:%d,rob_entry_test[1].R:%h,rob_entry_test[2].R:%h,rob_entry_test[3].R:%h", dispatch_en,head_test,tail_test,rob_entry_test[1].reg_idx,rob_entry_test[2].reg_idx,rob_entry_test[3].reg_idx);
	
		clk = 0;
		dispatch_en = 0;
		complete_en = 0;
		retire_en = 0;
		/***RESET***/
		reset = 1;
		@(negedge clk)
		reset = 0;
		dispatch_en = 1;
		dest_reg_idx_in [0] = 5'b00001; //R1
		dest_reg_idx_in [1] = 5'b00010; //R2
		dest_reg_idx_in [2] = 5'b00011; //R3
		valid_insn_num = 0;
		@(negedge clk)
		assert(head_test == 0 && tail_test == 0) else #1 exit_on_error;
		$display("@@@Dispatch_00 Passed");

		/***RESET***/
		reset = 1;
		@(negedge clk)
		reset = 0;
		dispatch_en = 1;
		dest_reg_idx_in [0] = 5'b00001; //R1
		dest_reg_idx_in [1] = 5'b00010; //R2
		dest_reg_idx_in [2] = 5'b00011; //R3
		valid_insn_num = 1;
		@(negedge clk)
		assert(head_test == 1 && tail_test == 1) else #1 exit_on_error;
		$display("@@@Dispatch_01 Passed");
		
		/***RESET***/
		reset = 1;
		@(negedge clk)
		reset = 0;
		
		/***CHECK DISPATCH WORKS WELL***/
		//assert(head_test == 0 && tail_test == 0) else #1 exit_on_error;
		
		dispatch_en = 1;
		dest_reg_idx_in [0] = 5'b00001; //R1
		dest_reg_idx_in [1] = 5'b00010; //R2
		dest_reg_idx_in [2] = 5'b00011; //R3
		valid_insn_num = 3;
		

		map_table_rob_num[0] = 0;
		map_table_rob_num[1] = 0;
		map_table_rob_num[2] = 0;

		@(negedge clk);
		assert(head_test == 1 && tail_test == 3) else #1 exit_on_error;
		$display("@@@Dispatch1 Passed");

		$monitor("dispatch_en: %b, head:%d, tail:%d,rob_entry_test[4].R:%d,rob_entry_test[5].R:%d,rob_entry_test[6].R:%d", dispatch_en,head_test,tail_test,rob_entry_test[4].reg_idx,rob_entry_test[5].reg_idx,rob_entry_test[6].reg_idx);

		dispatch_en = 1;
		dest_reg_idx_in [0] = 5'b00100; //R4
		dest_reg_idx_in [1] = 5'b00101; //R5
		dest_reg_idx_in [2] = 5'b00110; //R6
		valid_insn_num = 3;
		
		@(negedge clk);
		$display("@@@Dispatch2 Passed");

		$monitor("dispatch_en: %b, head:%d, tail:%d,rob_entry_test[4].R:%d,rob_entry_test[5].R:%d", dispatch_en,head_test,tail_test,rob_entry_test[7].reg_idx,rob_entry_test[8].reg_idx);
		assert(head_test == 1 && tail_test == 6) else #1 exit_on_error;
		dest_reg_idx_in [0] = 5'b00111; //R7
		dest_reg_idx_in [1] = 5'b01000; //R8
		dest_reg_idx_in [2] = 5'b01001; //R9
		valid_insn_num = 3;

		@(negedge clk);
		
		assert(head_test == 1 && tail_test ==8) else #1 exit_on_error;

		$display("@@@Dispatch3 Passed");

		/***CHECK COMPLETE WORKS WELL***/
		@(negedge clk);

		$monitor("complete_en: %b, head:%d, tail:%d,complete[1]:%b,complete[3]:%b,complete[5]:%b,V[1]:%d,V[3]:%d,V[5]:%d",
		complete_en,head_test,tail_test,
		rob_entry_test[1].complete,rob_entry_test[3].complete,rob_entry_test[5].complete,
		rob_entry_test[1].reg_val,rob_entry_test[3].reg_val,rob_entry_test[5].reg_val);

		dispatch_en = 0;
		complete_en = 1;
		CDB_rob_num[0] = 1;
		CDB_rob_num[1] = 3;
		CDB_rob_num[2] = 5;
		CDB_value[0] = 15;
		CDB_value[1] = 16;
		CDB_value[2] = 17;

		@(negedge clk);
		$display("@@@Complete Passed");


		/***CHECK RETIRE WORKS WELL***/
		@(negedge clk);
		$monitor("retire_en: %b, head:%d, tail:%d,retire_R_out[0]:%d,retire_R_out[1]:%d,retire_R_out[2]:%d,retire_V_out[0]:%d,retire_V_out[1]:%d,retire_V_out[2]:%d,",
		retire_en,head_test,tail_test,
		retire_R_out[0],retire_R_out[1],retire_R_out[2],
		retire_V_out[0],retire_V_out[1],retire_V_out[2]);
		complete_en = 0;
		retire_en = 1;
		@(negedge clk);
		$display("@@@Retire Passed");
		

		/***CHECK Tail return back WELL and dispatch value out well***/
		@(negedge clk);
		$monitor("dispatch_en: %b, head:%d, tail:%d,dispatch_value_out[0]:%d,dispatch_value_out[1]:%d,dispatch_value_out[2]:%d,",
		dispatch_en,head_test,tail_test,
		dispatch_value_out[0],dispatch_value_out[1],dispatch_value_out[2]);

		retire_en = 0;
		dispatch_en = 1;
		dest_reg_idx_in [0] = 5'b01001; //R9
		dest_reg_idx_in [1] = 5'b01010; //R10
		dest_reg_idx_in [2] = 5'b01011; //R11

		map_table_rob_num[0] = 3;
		map_table_rob_num[1] = 0;
		map_table_rob_num[2] = 0;
		@(negedge clk);
		
		$display("@@@ Tail loop && dispatch_value_out  Passed");

		/***CHECK Tail stall due to ROB structure hazard well***/
		@(negedge clk);
		$monitor("dispatch_en: %b, head:%d, tail:%d",
		dispatch_en,head_test,tail_test);
		retire_en = 0;
		dispatch_en = 1;
		@(negedge clk);
		$display("@@@ Tail stall due to ROB structure hazard Passed");

		/*** Exception Test ***/
		@(negedge clk);
		$monitor("complete_en: %b, head:%d, tail:%d,complete[2]:%b,complete[4]:%b,complete[6]:%b,V[2]:%d,V[4]:%d,V[6]:%d,exception[4]:%d",
		complete_en,head_test,tail_test,
		rob_entry_test[2].complete,rob_entry_test[4].complete,rob_entry_test[6].complete,
		rob_entry_test[2].reg_val,rob_entry_test[4].reg_val,rob_entry_test[6].reg_val,
		rob_entry_test[4].exception);
		// First complte and set exception
		dispatch_en = 0;
		complete_en = 1;
		CDB_rob_num[0] = 2;
		CDB_rob_num[1] = 4;
		CDB_rob_num[2] = 6;
		CDB_value[0] = 18;
		CDB_value[1] = 19;
		CDB_value[2] = 20;

		exception_en = 2'b01;
		exception_rob_tag[0] = 4;
		exception_rob_tag[1] = 0;
		@(negedge clk);
		// Then retire
		$monitor("retire_en: %b, head:%d, tail:%d,retire_R_out[0]:%d,retire_R_out[1]:%d,retire_R_out[2]:%d,retire_V_out[0]:%d,retire_V_out[1]:%d,retire_V_out[2]:%d,clear_all:%d",
		retire_en,head_test,tail_test,
		retire_R_out[0],retire_R_out[1],retire_R_out[2],
		retire_V_out[0],retire_V_out[1],retire_V_out[2], clear_all);

		complete_en = 0;
		retire_en = 1;
		
		@(negedge clk);
		// head should point to ROB#4 (due to excpetion in ROB#4)and retire ROB#2 and ROB#3

		@(negedge clk);
		// should clear all, head and tail point to 0

		$display("@@@ Exception test Passed");
		$finish;
		
	end
	
endmodule
