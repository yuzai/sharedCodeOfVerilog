`timescale 1ns/1ps

module iobuf_tb;

reg I1,I2,I3,T1,T2,T3;
wire O1,O2,O3,IO1,IO2,IO3;
reg clk;

top u1(
    .clk(clk),
    .z(T1),
    .din(I1),
    .dout(O1),
    .dinout(IO1),

    .z2(T2),
    .din2(I2),
    .dout2(O2),
    .dinout2(IO2),

    .z3(T3),
    .din3(I3),
    .dout3(O3),
    .dinout3(IO3)
);

initial
begin 
  clk = 0;
  I1 = 0;
  I2 = 1;
  I3 = 1;
  T1 = 1;
  T2 = 1;
  T3 = 1;

  #10 T1 = 0;
  #10 T2 = 0;
  #10 T3 = 0;
end

always #1 clk=~clk;

endmodule

