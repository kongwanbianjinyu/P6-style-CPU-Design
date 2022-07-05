`timescale 1ns/100ps
module test_psel_gen;

  parameter WIDTH=6;
  parameter REQS=1;

  reg   [WIDTH-1:0]       req;
  wire  [WIDTH-1:0]       gnt;
  wire  [REQS*WIDTH-1:0]  gnt_bus;
  wire                    empty;

  psel_gen #(.REQS(REQS), .WIDTH(WIDTH)) dut
    ( .req(req),
      .gnt(gnt),
      .gnt_bus(gnt_bus),
      .empty(empty)
    );

  initial begin
    req = {WIDTH{1'b1}};
    #1; print_info;
    
    // repeat (10) begin
    //   req = {WIDTH/32{$random}};
    //   #1; print_info;
    // end
    req = 6'b111001;
    #1; print_info;
    req = 6'b110101;
    #1; print_info;
    req = 6'b111011;
    #1; print_info;

    req = 6'b001010;
    #1; print_info;

    #1;
    $finish;
  end

  integer i;
  task print_info;
    begin
      $display("free: %b", req);
      $display("gnts: %b", gnt);

      for(i=0; i<REQS; i=i+1) begin
        //$display("gnt bus: %b", gnt_bus);
        $display("gnt%1.0d: %b", i, gnt_bus[(i+1)*WIDTH-1 -: WIDTH]);
      end
      $display("");
    end
  endtask

endmodule