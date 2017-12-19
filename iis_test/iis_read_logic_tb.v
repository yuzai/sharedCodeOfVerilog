module iis_read_logic_tb;

reg clk_100m;
reg rst_n;
reg stata_i;
wire bclk;
wire lrclk;
wire [23:0]ldata_l;
wire [23:0]rdata_l;

bclk_lrclk_logic clk_generate(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .bclk(bclk),
    .lrclk(lrclk)
);

iis_read_logic test(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .sdata_i(stata_i),
    .bclk(bclk),
    .lrclk(lrclk),
    .ldata_l(ldata_l),
    .rdata_l(rdata_l)
);

initial 
begin
    clk_100m <= 0;
    rst_n = 1;
    stata_i = 0;
    #10
    rst_n = 0;
    #10
    rst_n = 1;
end

always #1 clk_100m = ~clk_100m;

always@(negedge bclk)
    stata_i <= $random;

endmodule
