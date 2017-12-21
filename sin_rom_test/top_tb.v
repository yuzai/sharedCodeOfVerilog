module top_tb;

reg clk;
wire dout;

top test(
    .clk(clk),
    .dout(dout)
);

initial begin 
    clk = 0;
end

always #10 clk = ~clk;

endmodule
