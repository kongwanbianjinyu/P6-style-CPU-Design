`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version S-2021.06-SP1 -- Jul 13, 2021
//

// For simulation only. Do not modify.

module pipeline_svsim (

	input         clk,                    	input         reset,                    		input [1:0][63:0]  Imem2proc_data,            	input [63:0]  Dmem2proc_data,            	input [3:0]	  Dmem2proc_tag,
	input [3:0]   Dmem2proc_response,
	
	output BUS_COMMAND 				proc2Dcache_command,
	output	logic [32-1:0] 		proc2Dcache_addr,
	output logic [31:0] 			proc2Dcache_data,

	output logic [1:0][32-1:0] proc2Imem_addr,      	output logic [1:0]  proc2Dmem_command,    	output logic [32-1:0] proc2Dmem_addr,      	output logic [63:0] proc2Dmem_data,     	
	output logic [3:0]  pipeline_completed_insts,
	output EXCEPTION_CODE   pipeline_error_status,
	output logic [2:0][4:0]  pipeline_commit_wr_idx,
	output logic [2:0][32-1:0] pipeline_commit_wr_data,
	output logic [2:0]       pipeline_commit_wr_en,
	output logic [2:0][32-1:0] pipeline_commit_NPC,


			

		output logic [2:0][32-1:0] if_NPC_out,
	output logic [2:0][31:0] if_IR_out,
	output logic [2:0]       if_valid_inst_out,

		output logic [2:0][32-1:0] if_id_NPC,
	output logic [2:0][31:0] if_id_IR,
	output logic [2:0]       if_id_valid_inst,

		output logic [2:0][32-1:0] id_is_NPC_out,
	output logic [2:0][31:0] id_is_IR_out,
	output logic [2:0]       id_is_valid_inst_out,

		output logic [2:0][32-1:0] is_ex_NPC_out,
	output logic [2:0][31:0] is_ex_IR_out,
	output logic [2:0]       is_ex_valid_inst_out,


		output logic [2:0][32-1:0] ex_ic_NPC_out,
	output logic [2:0][31:0]      ex_ic_IR_out,
	output logic [2:0]       	  ex_ic_valid_inst_out,
		
		output logic [2:0][32-1:0] ic_rt_NPC_out,
	output logic [2:0][31:0] ic_rt_IR_out,
	output logic [2:0]       ic_rt_valid_inst_out


);

	

  pipeline pipeline( {>>{ clk }}, {>>{ reset }}, {>>{ Imem2proc_data }}, 
        {>>{ Dmem2proc_data }}, {>>{ Dmem2proc_tag }}, 
        {>>{ Dmem2proc_response }}, {>>{ proc2Dcache_command }}, 
        {>>{ proc2Dcache_addr }}, {>>{ proc2Dcache_data }}, 
        {>>{ proc2Imem_addr }}, {>>{ proc2Dmem_command }}, 
        {>>{ proc2Dmem_addr }}, {>>{ proc2Dmem_data }}, 
        {>>{ pipeline_completed_insts }}, {>>{ pipeline_error_status }}, 
        {>>{ pipeline_commit_wr_idx }}, {>>{ pipeline_commit_wr_data }}, 
        {>>{ pipeline_commit_wr_en }}, {>>{ pipeline_commit_NPC }}, 
        {>>{ if_NPC_out }}, {>>{ if_IR_out }}, {>>{ if_valid_inst_out }}, 
        {>>{ if_id_NPC }}, {>>{ if_id_IR }}, {>>{ if_id_valid_inst }}, 
        {>>{ id_is_NPC_out }}, {>>{ id_is_IR_out }}, 
        {>>{ id_is_valid_inst_out }}, {>>{ is_ex_NPC_out }}, 
        {>>{ is_ex_IR_out }}, {>>{ is_ex_valid_inst_out }}, 
        {>>{ ex_ic_NPC_out }}, {>>{ ex_ic_IR_out }}, 
        {>>{ ex_ic_valid_inst_out }}, {>>{ ic_rt_NPC_out }}, 
        {>>{ ic_rt_IR_out }}, {>>{ ic_rt_valid_inst_out }} );
endmodule
`endif
