module testbench;
	logic clk,reset;
    // Dispatch stage logic
    logic                           dispatch_en;
    logic [6:0]                     opcode [2:0];           // opcode of the 3 insns

    logic [$clog2(`ROB_SIZE)-1:0]   ROB_tail;               //ROB tail
    //logic [$clog2(`ROB_SIZE)-1:0]   ROB_remain_size;        // ROB remain size

    logic [$clog2(`ROB_SIZE)-1:0]   MAP_TABLE_tag1 [2:0];   // MAP TABLE tag1/2
    logic [$clog2(`ROB_SIZE)-1:0]   MAP_TABLE_tag2 [2:0];
    logic [2:0]                     MAP_TABLE_ready1;       // MAP TABLE ready 1/2 "+"
    logic [2:0]                     MAP_TABLE_ready2;
    logic [2:0]                     MAP_TABLE_hit1;         //MAP TABLE hit 1/2 
    logic [2:0]                     MAP_TABLE_hit2;

    logic [31:0]                    OPA [2:0];           // value from Real Register File(RRF), can be [rs1] or PC
    logic [31:0]                    OPB [2:0];           // value from Real Register File(RRF), can be [rs2] or IMM

    logic [31:0]                    ROB_V1 [2:0];           // value from ROB value
    logic [31:0]                    ROB_V2 [2:0];

    // Issue stage logic
    logic                           issue_en;
    //logic [$clog2(`ROB_SIZE)-1:0]   issue_rob_tag [2:0];    // which insn in ROB what to issue

    // Execute stage logic
    logic                           execute_en;
    logic [$clog2(`ROB_SIZE)-1:0]   execute_rob_tag [2:0];  // which insn in ROB what to execute

    // Complete stage logic
    logic                           complete_en;
    logic [$clog2(`ROB_SIZE)-1:0]   CDB_tag [2:0];           //CDB tag 
    logic [31:0]                    CDB_value [2:0];         // CDB value

    // Dispatch stage output
    logic [2:0]                     RS_available_size;      // RS available size, {0,1,2,3}
    logic [4:0]                     RS_idx_test[2:0];

    // Issue Stage output
    logic [2:0]                    permit_issue;           // whether the insn can issue 
    logic [31:0]                   issue_V1_out [2:0];     // send the value out to FU
    logic [31:0]                   issue_V2_out [2:0];
    RS_ENTRY [15:0]                 rs_entry_test;

	RS rs ( .clk, .reset, .dispatch_en, .opcode, 
            .ROB_tail,.MAP_TABLE_tag1,.MAP_TABLE_tag2,.MAP_TABLE_ready1,.MAP_TABLE_ready2,.MAP_TABLE_hit1,.MAP_TABLE_hit2,
            .OPA,.OPB,.ROB_V1,.ROB_V2,
            .issue_en,
            .execute_en,.execute_rob_tag,
            .complete_en,.CDB_tag,.CDB_value,
            .RS_available_size,.RS_idx_test,.permit_issue,.issue_V1_out,.issue_V2_out,.rs_entry_test);
                                    
	
	always #5 clk = ~clk;
	
	task exit_on_error;
		begin
			#1;
			$display("@@@Failed at time %f", $time);
			$finish;
		end
	endtask
	
	initial begin
		
		$monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[0]:%d,V2[0]:%d,V1[3]:%d,V2[3]:%d,V1[6]:%d,V2[6]:%d,T[0]:%d,T[3]:%d,T[6]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[0].V1,rs_entry_test[0].V2,
         rs_entry_test[3].V1,rs_entry_test[3].V2,
         rs_entry_test[6].V1,rs_entry_test[6].V2,
         rs_entry_test[0].T,rs_entry_test[3].T,rs_entry_test[6].T);
        //  || 
		clk = 0;
		dispatch_en = 0;
		issue_en = 0;
		execute_en = 0;
        complete_en = 0;
		
		/***RESET***/
		reset = 1;
		@(negedge clk)
		reset = 0;
		
		/***CHECK DISPATCH WORKS WELL, not hit, value from RRF***/
		dispatch_en = 1;
		opcode [0] = `RV32_LOAD;    //load
		opcode [1] = `RV32_STORE;   //store
		opcode [2] = `RV32_ADDI;    //add
		ROB_tail = 3; // impact T , {ROB#4,ROB#5,ROB#6}
        ROB_remain_size = 7;

        MAP_TABLE_hit1 = 0;
        MAP_TABLE_hit2 = 0;

        OPA[0] = 11;
        OPA[1] = 12;
        OPA[2] = 13;

        OPB[0] = 14;
        OPB[1] = 15;
        OPB[2] = 16;

		@(negedge clk)
        $display("@@@Dispatch1.1 Passed");

        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[1]:%d,V2[1]:%d,V1[4]:%d,V2[4]:%d,V1[7]:%d,V2[7]:%d,T[1]:%d,T[4]:%d,T[7]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[1].V1,rs_entry_test[1].V2,
         rs_entry_test[4].V1,rs_entry_test[4].V2,
         rs_entry_test[7].V1,rs_entry_test[7].V2,
         rs_entry_test[1].T,rs_entry_test[4].T,rs_entry_test[7].T);
        
        @(negedge clk)
        $display("@@@Dispatch1.2 Passed");
        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[2]:%d,V2[2]:%d,V1[5]:%d,V2[5]:%d,V1[8]:%d,V2[8]:%d,T[2]:%d,T[5]:%d,T[8]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[2].V1,rs_entry_test[2].V2,
         rs_entry_test[5].V1,rs_entry_test[5].V2,
         rs_entry_test[8].V1,rs_entry_test[8].V2,
         rs_entry_test[2].T,rs_entry_test[5].T,rs_entry_test[8].T);

        @(negedge clk)
        $display("@@@Dispatch1.3 Passed");
        // nothing happened since RS structure hazard, notice value not enter RS#10.V
        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[9]:%d,V2[9]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[9].V1,rs_entry_test[9].V2);

        @(negedge clk)
		$display("@@@Dispatch1 Passed");
        $display("-----------------------------------------------------------------------------------------------------------------------------------");

        /***RESET***/
		reset = 1;
		@(negedge clk)
		reset = 0;

        /***CHECK DISPATCH WORKS WELL, hit and ready,  value from ROB***/
		dispatch_en = 1;
		opcode [0] = `RV32_LOAD;    //load
		opcode [1] = `RV32_STORE;   //store
		opcode [2] = `RV32_ADDI;    //add
		ROB_tail = 3; // impact T , {ROB#4,ROB#5,ROB#6}
        ROB_remain_size = 7;

        MAP_TABLE_hit1 = 3'b111;
        MAP_TABLE_hit2 = 3'b111;
        MAP_TABLE_ready1 = 3'b111;
        MAP_TABLE_ready2 = 3'b111;

        ROB_V1[0] = 21;
        ROB_V1[1] = 22;
        ROB_V1[2] = 23;

        ROB_V2[0] = 24;
        ROB_V2[1] = 25;
        ROB_V2[2] = 26;

        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[0]:%d,V2[0]:%d,V1[3]:%d,V2[3]:%d,V1[6]:%d,V2[6]:%d,T[0]:%d,T[3]:%d,T[6]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[0].V1,rs_entry_test[0].V2,
         rs_entry_test[3].V1,rs_entry_test[3].V2,
         rs_entry_test[6].V1,rs_entry_test[6].V2,
         rs_entry_test[0].T,rs_entry_test[3].T,rs_entry_test[6].T);
        @(negedge clk)
        $display("@@@Dispatch2.1 Passed");

         $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[1]:%d,V2[1]:%d,V1[4]:%d,V2[4]:%d,V1[7]:%d,V2[7]:%d,T[1]:%d,T[4]:%d,T[7]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[1].V1,rs_entry_test[1].V2,
         rs_entry_test[4].V1,rs_entry_test[4].V2,
         rs_entry_test[7].V1,rs_entry_test[7].V2,
         rs_entry_test[1].T,rs_entry_test[4].T,rs_entry_test[7].T);
        
        @(negedge clk)
        $display("@@@Dispatch2.2 Passed");
        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[2]:%d,V2[2]:%d,V1[5]:%d,V2[5]:%d,V1[8]:%d,V2[8]:%d,T[2]:%d,T[5]:%d,T[8]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[2].V1,rs_entry_test[2].V2,
         rs_entry_test[5].V1,rs_entry_test[5].V2,
         rs_entry_test[8].V1,rs_entry_test[8].V2,
         rs_entry_test[2].T,rs_entry_test[5].T,rs_entry_test[8].T);

        @(negedge clk)
        $display("@@@Dispatch2.3 Passed");
        
        // nothing happened since RS structure hazard, notice value not enter RS#10.V
        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,V1[9]:%d,V2[9]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[9].V1,rs_entry_test[9].V2);

        @(negedge clk)
		$display("@@@Dispatch2 Passed");
        $display("-----------------------------------------------------------------------------------------------------------------------------------");

        /***RESET***/
		reset = 1;
		@(negedge clk)
		reset = 0;

        /***CHECK DISPATCH WORKS WELL, hit and not ready, T1 T2 from MAP_TABLE***/
		dispatch_en = 1;
		opcode [0] = `RV32_LOAD;    //load
		opcode [1] = `RV32_STORE;   //store
		opcode [2] = `RV32_ADDI;    //add
		ROB_tail = 3; // impact T , {ROB#4,ROB#5,ROB#6}
        ROB_remain_size = 7;

        MAP_TABLE_hit1 = 3'b111;
        MAP_TABLE_hit2 = 3'b111;
        MAP_TABLE_ready1 = 3'b000;
        MAP_TABLE_ready2 = 3'b000;

        MAP_TABLE_tag1[0] = 1;
        MAP_TABLE_tag1[1] = 2;
        MAP_TABLE_tag1[2] = 3;

        MAP_TABLE_tag2[0] = 4;
        MAP_TABLE_tag2[1] = 5;
        MAP_TABLE_tag2[2] = 6;

        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,T1[0]:%d,T2[0]:%d,T1[3]:%d,T2[3]:%d,T1[6]:%d,T2[6]:%d,T[0]:%d,T[3]:%d,T[6]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[0].T1,rs_entry_test[0].T2,
         rs_entry_test[3].T1,rs_entry_test[3].T2,
         rs_entry_test[6].T1,rs_entry_test[6].T2,
         rs_entry_test[0].T,rs_entry_test[3].T,rs_entry_test[6].T);
        @(negedge clk)
        $display("@@@Dispatch3.1 Passed");

        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,T1[1]:%d,T2[1]:%d,T1[4]:%d,T2[4]:%d,T1[7]:%d,T2[7]:%d,T[1]:%d,T[4]:%d,T[7]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[1].T1,rs_entry_test[1].T2,
         rs_entry_test[4].T1,rs_entry_test[4].T2,
         rs_entry_test[7].T1,rs_entry_test[7].T2,
         rs_entry_test[1].T,rs_entry_test[4].T,rs_entry_test[7].T);
        @(negedge clk)
        $display("@@@Dispatch3.2 Passed");

        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,T1[2]:%d,T2[2]:%d,T1[5]:%d,T2[5]:%d,T1[8]:%d,T2[8]:%d,T[2]:%d,T[5]:%d,T[8]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[2].T1,rs_entry_test[2].T2,
         rs_entry_test[5].T1,rs_entry_test[5].T2,
         rs_entry_test[8].T1,rs_entry_test[8].T2,
         rs_entry_test[2].T,rs_entry_test[5].T,rs_entry_test[8].T);
        @(negedge clk)
        $display("@@@Dispatch3.3 Passed");
        // nothing happened since RS structure hazard, notice value not enter RS#10.V
        $monitor("dispatch_en: %b,RS_available_size:%d,RS_idx[0]:%d,RS_idx[1]:%d,RS_idx[2]:%d,T1[9]:%d,T2[9]:%d",
         dispatch_en, RS_available_size,RS_idx_test[0],RS_idx_test[1],RS_idx_test[2],
         rs_entry_test[9].T1,rs_entry_test[9].T2);

        @(negedge clk)
         $display("@@@Dispatch3 Passed");
         $display("-----------------------------------------------------------------------------------------------------------------------------------");

        /***CHECK ISSUE WORKS WELL, T1 T2 not zero, can't permit issue***/
        $monitor("issue_en: %b,permit_issue:%b,issue_V1_out[0]:%d,issue_V2_out[0]:%d,issue_V1_out[1]:%d,issue_V2_out[1]:%d,issue_V1_out[2]:%d,issue_V2_out[2]:%d,", issue_en,permit_issue,
        issue_V1_out[0],issue_V2_out[0],
        issue_V1_out[1],issue_V2_out[1],
        issue_V1_out[2],issue_V2_out[2]);
        dispatch_en = 0;
        issue_en = 1;
        issue_rob_tag[0] = 4;
        issue_rob_tag[1] = 5;
        issue_rob_tag[2] = 6;

        @(negedge clk);
        assert(permit_issue == 3'b000) else #1 exit_on_error;
        $display("@@@Issue Passed");
        $display("-----------------------------------------------------------------------------------------------------------------------------------");

        /***CHECK EXECUTE WORKS WELL, execute 3***/
        $monitor("execute_en: %b,T1[0]:%d,T2[0]:%d,T1[3]:%d,T2[3]:%d,T1[6]:%d,T2[6]:%d,T[0]:%d,T[3]:%d,T[6]:%d, busy[0]:%d,busy[3]:%d,busy[6]:%d,",
        execute_en, 
         rs_entry_test[0].T1,rs_entry_test[0].T2,
         rs_entry_test[3].T1,rs_entry_test[3].T2,
         rs_entry_test[6].T1,rs_entry_test[6].T2,
         rs_entry_test[0].T,rs_entry_test[3].T,rs_entry_test[6].T,
         rs_entry_test[0].busy,rs_entry_test[3].busy,rs_entry_test[6].busy);
        issue_en = 0;
        execute_en = 1;
        execute_rob_tag[0] = 4;
        execute_rob_tag[1] = 5;
        execute_rob_tag[2] = 6;

        @(negedge clk);
        $display("@@@Execute Passed");
        $display("-----------------------------------------------------------------------------------------------------------------------------------");


        /***CHECK COMPLETE WORKS WELL, complete 3***/
        $monitor("complete_en: %b,T1[1]:%d,T2[1]:%d,T1[4]:%d,T2[4]:%d,T1[7]:%d,T2[7]:%d,V1[1]:%d,V2[1]:%d,V1[4]:%d,V2[4]:%d,V1[7]:%d,V2[7]:%d,",
        complete_en, 
         rs_entry_test[1].T1,rs_entry_test[1].T2,
         rs_entry_test[4].T1,rs_entry_test[4].T2,
         rs_entry_test[7].T1,rs_entry_test[7].T2,

         rs_entry_test[1].V1,rs_entry_test[1].V2,
         rs_entry_test[4].V1,rs_entry_test[4].V2,
         rs_entry_test[7].V1,rs_entry_test[7].V2,
         );
        execute_en = 0;
        complete_en = 1;
        CDB_tag[0] = 4;
        CDB_tag[1] = 5;
        CDB_tag[2] = 6;

        CDB_value[0] = 31;
        CDB_value[1] = 32;
        CDB_value[2] = 33;

        @(negedge clk);
        $display("@@@Complete Passed");

		$finish;
		
	end
	
endmodule
