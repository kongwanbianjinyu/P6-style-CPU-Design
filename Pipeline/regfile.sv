/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  regfile.v                                           //
//                                                                     //
//  Description :  This module creates the Regfile used by the ID and  //
//                 WB Stages of the Pipeline.                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`ifndef __REGFILE_V__
`define __REGFILE_V__

`timescale 1ns/100ps

module regfile(
        input [2:0][4:0]              rda_idx, rdb_idx, wr_idx,    // read/write index
        input [2:0][`XLEN-1:0]        wr_data,            // write data
        input [2:0]                   wr_en,
        input                         wr_clk,

        output logic [2:0][`XLEN-1:0] rda_out, rdb_out    // read data
          
      );
  
  logic  [31:0] [`XLEN-1:0] registers;   // 32, 64-bit Registers

  //wire  [`XLEN-1:0] rda_reg = registers[rda_idx];
  //wire  [`XLEN-1:0] rdb_reg = registers[rdb_idx];

  

  //
  // Read port A, 3 way
  //
  always_comb begin
    for(int i = 0; i < 3; i++) begin
      if (rda_idx[i] == `ZERO_REG)
        rda_out[i] = 0;
      else if (wr_en[i] && (wr_idx[i] == rda_idx[i]))
        rda_out[i] = wr_data[i];  // internal forwarding
      else
        rda_out[i] = registers[rda_idx[i]];
    end
  end

  //
  // Read port B, 3 way
  //
  always_comb begin
    for(int i = 0; i < 3; i++) begin
      if (rdb_idx[i] == `ZERO_REG)
        rdb_out[i] = 0;
      else if (wr_en[i] && (wr_idx[i] == rdb_idx[i]))
        rdb_out[i] = wr_data[i];  // internal forwarding
      else
        rdb_out[i] = registers[rdb_idx[i]];
    end
  end
  //
  // Write port
  //
  always_ff @(posedge wr_clk)begin
      for(int i=0; i<3; i++) begin
        if (wr_en[i]) begin
          registers[wr_idx[i]] <= `SD wr_data[i];
        end
    end
  end
endmodule // regfile
`endif //__REGFILE_V__
