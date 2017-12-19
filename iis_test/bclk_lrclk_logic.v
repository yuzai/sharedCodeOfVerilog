module bclk_lrclk_logic(
    input clk_100m,
    input rst_n,
    output bclk,
    output lrclk
);

//产生bclk和lrclk信号：bclk:3M 100/32 lrclk:48k 100/2048
reg [4:0]count1;
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
    count1<=0;
else
    count1<=count1+1'b1;
assign bclk = count1[4];

reg [10:0]count2;
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
    count2<=0;
else
    count2<=count2+1'b1;
assign lrclk = count2[10];

endmodule
