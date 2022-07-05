module testbench;
    logic         clk;              // Memory clock
    logic  [32-1:0] proc2mem_addr;    // address for current command
    //support for memory model with byte level addressing
    logic  [63:0] proc2mem_data;    // address for current command
    logic  [1:0]   proc2mem_command; // `BUS_NONE `BUS_LOAD or `BUS_STORE
    
    logic  [3:0] mem2proc_response;// 0 = can't accept, other=tag of transaction
    logic [63:0] mem2proc_data;    // data resulting from a load
    logic  [3:0] mem2proc_tag;     // 0 = no value, other=tag of transaction

    mem memory (.clk, .proc2mem_addr, .proc2mem_data, .proc2mem_command,.mem2proc_response,.mem2proc_data,.mem2proc_tag);
    
    
    always #5 clk = ~clk;
	
	task exit_on_error;
		begin
			#1;
			$display("@@@Failed at time %f", $time);
			$finish;
		end
	endtask

	
	initial begin

        $monitor("proc2mem_command:%d, proc2mem_addr:%h,proc2mem_data:%h,mem2proc_data:%h,mem2proc_tag:%h,mem2proc_response:%h",
                proc2mem_command,proc2mem_addr,proc2mem_data,mem2proc_data,mem2proc_tag,mem2proc_response);
        clk = 0;
        proc2mem_command = 2'h0;//BUS_NONE;
        @(posedge clk)
        proc2mem_command = 2'h2;//BUS_STORE;
        proc2mem_addr = 0;
        proc2mem_data = 233;
        @(posedge clk)
        proc2mem_command = 2'h2;//BUS_STORE;
        proc2mem_addr = 4;
        proc2mem_data = 996;
        @(posedge clk)
        proc2mem_command = 2'h2;//BUS_STORE;
        proc2mem_addr = 8;
        proc2mem_data = 666;

        @(posedge clk)
        proc2mem_command = 2'h1;//BUS_LOAD;
        proc2mem_addr = 0;
        @(posedge clk)

        proc2mem_command = 2'h1;//BUS_LOAD;
        proc2mem_addr = 4;
        @(posedge clk)

        proc2mem_command = 2'h1;//BUS_LOAD;
        proc2mem_addr = 8;
        @(posedge clk)
        proc2mem_command = 2'h0;//BUS_NONE;

        for(int i = 0; i < 20 ; i++) begin
            @(posedge clk);
        end

        
        $finish;
		end
	
endmodule
