module iis_top(
    input clk_100m,
    input rst,
    input sdata_i,
    output sdata_o,
    output bclk,
    output lrclk,

    input [23:0]sin_data,
    output [10:0]address    
);

wire rst_n;
assign rst_n = ~rst;

bclk_lrclk_logic clk_generator(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .bclk(bclk),
    .lrclk(lrclk)
);

wire [23:0]ldata;
wire [23:0]rdata;

iis_read_logic iis_read_u1(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .sdata_i(sdata_i),
    .bclk(bclk),
    .lrclk(lrclk),
    .ldata_l(ldata),
    .rdata_l(rdata)
);

read_sin read_sin_u1(
    .clk_fs(lrclk),  //fs = 48khz
    .rst_n(rst_n), 
    .address(address)
);

iis_write_logic iis_write_u1(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .bclk(bclk),
    .lrclk(lrclk),
    .ldata(sin_data),
    .rdata(rdata),
    .en(1'b1),
    .sdata_o(sdata_o)
);

endmodule
