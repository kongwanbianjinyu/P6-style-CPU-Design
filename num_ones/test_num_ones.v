module tb;

    // Inputs
    reg [15:0] A;

    // Outputs
    wire [4:0] ones;

    // Instantiate the Unit Under Test (UUT)
    num_ones #(.WIDTH(16))uut (
        .A(A), 
        .ones(ones)
    );

    initial begin
        $monitor("sum:%d", ones);
        A = 16'hFFFF;   #100;
        A = 16'hF56F;   #100;
        A = 16'h3FFF;   #100;
        A = 16'h0001;   #100;
        A = 16'hF10F;   #100;
        A = 16'h7822;   #100;
        A = 16'h7ABC;   #100;   
    end
      
endmodule
