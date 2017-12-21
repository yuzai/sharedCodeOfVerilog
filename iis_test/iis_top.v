module iis_top(
    //input clk ,this fpga operate at 100Mhz
    input clk_100m,
    //reset signal , 1 for reset
    input rst,
    //iis audio_in
    input sdata_i,
    //iis audio_out
    output sdata_o,
    //iis bclk
    output bclk,
    //iis lrclk
    output lrclk,
    //the sin wave from rom
    input [23:0]sin_data,
    //the rom address
    output [10:0]address,
    //channel select:1-sin_wave,0-audio_in
    input source,
    //sin_wave f select:SW Khz
    input [6:0]SW    
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

read_rom read_sin_u1(
    .clk_fs(lrclk),  //fs = 48khz
    .rst_n(rst_n), 
    .SW(SW),
    .address(address)
);

iis_write_logic iis_write_u1(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .bclk(bclk),
    .lrclk(lrclk),
    .ldata(source==1?sin_data:ldata),
    .rdata(source==1?sin_data:rdata),
    .en(1'b1),
    .sdata_o(sdata_o)
);

endmodule
