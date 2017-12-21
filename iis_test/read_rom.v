module read_rom(
    input clk_fs,  //fs = 48khz
    input rst_n, 
    input [6:0]SW,
    output [10:0] address
);


// parameter sin_fs = 11'd42;//less than fs/2,1khz sin_fs = 2048/(fs/f) 
wire [10:0]sin_f;
assign sin_f = 11'd43 * {4'd0,SW};

reg [10:0]address;
always@(posedge clk_fs or negedge rst_n)
if(!rst_n)
    address <= 0;
else
    address <= address+sin_f;

endmodule
