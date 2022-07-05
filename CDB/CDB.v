/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  CDB.v                                               //
//                                                                     //
//  Description :  CDB of the P6 architure;                            // 
//                 Support 3-way superscalar execution;                // 
//                                                                     //
/////////////////////////////////////////////////////////////////////////

module CDB #((parameter SIZE=8, ROB_SIZE=SIZE+1) (
    input                               clk,reset,
    
    // Complete Stage
    input                               complete_en,  //???set 0 next cycle??
    //input [$clog2(`ROB_SIZE)-1:0]     CDB_tag_in [2:0], // CDB tag
    input  [1:0]                        rob_complete_num, // the number of completed insns: {0,1,2,3} * Q: from where
    
    input  [$clog2(ROB_SIZE)-1:0][2:0]  CDB_rob_num_in ,    // completed ROB number *
    input  [31:0][2:0]                  CDB_value_in ,      // CDB value ??from complete stage?? *


    output [$clog2(ROB_SIZE)-1:0][2:0]  CDB_rob_num_out ,    // CDB tag to Map_Table & RS as CDB_tag_in   *
    output [31:0][2:0]                  CDB_value_out ,      // CDB value to ROB & RS *
);

// register 
// logic [clog2(SIZE)-1:0] Reg [SIZE - 1:0];
logic [SIZE - 1:0]              valid; // whether the content in CDB is valid
                                        //1 when complete_en ==1
logic [$clog2(`ROB_SIZE)-1:0] Tag [SIZE - 1:0];
//logic [SIZE - 1:0]              ready;



always_ff @(posedge clk)begin
    if(reset)begin
        valid   <= 0;
        
    end


    end
    if(complete_en) begin
        for(int i=0;i<rob_complete_num;i++) begin  // for all insn
            for(int j=0;j<SIZE;j++)begin // search all tags and compare
                if(CDB_tag_in[i]==Tag[j] && valid[j]) begin// if find
                    ready[j] <= 1'b1;
                end
            end
            
        end
    end








endmodule