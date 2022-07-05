module num_ones #(parameter WIDTH=16)(
    input [WIDTH - 1:0] A,
    output reg [$clog2(WIDTH):0] ones
    );

integer i;

always@(A)
begin
    ones = 0;  //initialize count variable.
    for(i=0;i<WIDTH;i=i+1)   //for all the bits.
        ones = ones + A[i]; //Add the bit to the count.
end

endmodule