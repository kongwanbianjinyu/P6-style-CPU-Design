// EECS 470 - Winter 2009
//
// parametrized priority encoder (really just an encoder)
// parameter is output width
//

module pe (gnt,enc);
        //synopsys template
        parameter OUTWIDTH=4;
        parameter INWIDTH=1<<OUTWIDTH;//16

	input  [INWIDTH-1:0] gnt;

	output [OUTWIDTH-1:0] enc;
        wor    [OUTWIDTH-1:0] enc;

        genvar i,j;
        generate
          for(i=0;i<OUTWIDTH;i=i+1)
          begin : foo
            for(j=1;j<INWIDTH;j=j+1)
            begin : bar
              if (j[i])
                assign enc[i] = gnt[j];
            end
          end
        endgenerate
endmodule
