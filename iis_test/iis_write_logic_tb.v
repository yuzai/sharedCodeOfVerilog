module iis_write_logic_tb;

reg clk_100m;
reg rst_n;
reg [23:0]ldata;
reg [23:0]rdata;
reg en;

wire bclk;
wire lrclk;
wire sdata_o;

bclk_lrclk_logic clk_generate(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .bclk(bclk),
    .lrclk(lrclk)
);

iis_write_logic test(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .bclk(bclk),
    .lrclk(lrclk),
    .ldata(ldata),
    .rdata(rdata),
    .en(en),

    .sdata_o(sdata_o)
);

initial begin 
    clk_100m = 0;
    rst_n = 1;
    en = 1;
    ldata = 0;
    rdata = 0;
    #10
    rst_n = 0;
    #10
    rst_n = 1;
end

always #1 clk_100m = ~clk_100m;

always@(posedge lrclk)
begin
    ldata<=$random;
    rdata<=$random;
end

endmodule
