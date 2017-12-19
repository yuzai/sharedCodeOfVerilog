module iis_write_logic(
    input clk_100m,
    input rst_n,
    input bclk,
    input lrclk,
    input [23:0]ldata,
    input [23:0]rdata,
    input en,
    
    output sdata_o
);

