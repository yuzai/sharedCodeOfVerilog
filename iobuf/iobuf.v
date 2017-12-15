module top(
    input clk,
    input z,
    input din,
    output dout,
    inout dinout,

    input z2,
    input din2,
    output dout2,
    inout dinout2,

    input z3,
    input din3,
    output dout3,
    inout dinout3
);
//方法一
reg dout;
reg din_reg;
assign dinout = (!z)?din_reg:1'bz;
always@(posedge clk)
begin 
    if(!z)
        din_reg = din;
    else
        dout = dinout;
end

//方法二
assign dinout2 = (!z2)?din2:1'bz;
assign dout2 = dinout2;

//方法三
IOBUF iobuf(
    .I(din3),
    .O(dout3),
    .T(z3),
    .IO(dinout3)
);
endmodule

