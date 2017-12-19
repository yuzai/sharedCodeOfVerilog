module iis_read_logic_tb;

reg clk_100m;
reg rst;
reg stata_i;
wire bclk;
wire lrclk;
wire [23:0]ldata_l;
wire [23:0]rdata_l;

iis_logic test(
    .clk_100m(clk_100m),
    .rst(rst),
    .sdata_i(stata_i),
    .bclk(bclk),
    .lrclk(lrclk),
    .ldata_l(ldata_l),
    .rdata_l(rdata_l)
);

initial 
begin
    clk_100m <= 0;
    rst = 0;
    stata_i = 0;
end

always #1 clk_100m = ~clk_100m;

always@(negedge bclk)
    stata_i <= $random;

endmodule
