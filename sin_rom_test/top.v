module top(
    input clk,
    output [23:0] dout
);

reg [10:0]address = 0;
always@(posedge clk)
    address<= address+1'b1;

dist_mem_gen_0 sin_wave (
  .a(address),      // input wire [10 : 0] a
  .spo(dout)  // output wire [23 : 0] spo
);

endmodule 

