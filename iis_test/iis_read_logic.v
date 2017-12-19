module iis_read_logic(
    input clk_100m,
    input rst,
    input sdata_i,
    output bclk,
    output lrclk,
    output [23:0]ldata_l,
    output [23:0]rdata_l
);

//get the true rst signal,zynq开发板默认按键低电平
wire rst_n;
assign rst_n = ~rst;

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

//检测lrclk和bclk的上升沿及下降沿信号
reg bclk_d1;
reg lrclk_d1;
wire bclk_start;
wire left_start;
wire right_start;
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
begin 
    bclk_d1<=0;
    lrclk_d1<=0;
end
else
begin 
    bclk_d1<=bclk;
    lrclk_d1<=lrclk;
end

assign left_start = lrclk_d1 & !lrclk;//左声道的开始信号， lrclk的下降沿
assign right_start = lrclk & !lrclk_d1;//右声道的开始信号，lrclk的上升沿
assign bclk_start = bclk & !bclk_d1;//上升沿，读写有效

//读写状态机控制
//芯片距离lrclk信号发生改变有1个时钟的延迟
parameter init       = 7'b0000001,
          wait_left  = 7'b0000010,
          skip_left  = 7'b0000100,   
          read_left  = 7'b0001000,
          wait_right = 7'b0010000,
          skip_right = 7'b0100000,
          read_right = 7'b1000000;
parameter data_bit = 5'd24;
reg [6:0]iis_state;
reg [4:0]cnt;
//控制状态迁移
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
    iis_state <= init;
else
    case(iis_state)
    init: iis_state <= wait_left;
    wait_left: 
        if(left_start)
            iis_state <= skip_left;
    skip_left:
        if(bclk_start)
            iis_state <= read_left;
    read_left:
        if(cnt == data_bit)
            iis_state <= wait_right;
    wait_right:
        if(right_start)
            iis_state <= skip_right;
    skip_right:
        if(bclk_start)
            iis_state <= read_right;
    read_right:
        if(cnt == data_bit)
            iis_state <= wait_left;
    default:iis_state <= init;
    endcase

//控制数据计数
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
    cnt<=0;
else
    if(iis_state == read_left || iis_state == read_right)
    begin 
        if(bclk_start)
            cnt<=cnt+1'b1;
    end
    else
        cnt<=0;

//控制数据读取
reg [23:0]ldata;
reg [23:0]rdata;
reg [23:0]ldata_r;
reg [23:0]rdata_r;

always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
begin 
    ldata<=0;
    rdata<=0;
end
else 
    if(iis_state==read_left && bclk_start) 
        ldata[23:0] = {ldata[22:0],sdata_i};
    else if(iis_state == read_right && bclk_start)
        rdata[23:0] = {rdata[22:0],sdata_i};

//锁存读取到的信号
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
begin 
    ldata_r<=0;
    rdata_r<=0;
end
else
    if(iis_state==read_left && cnt==data_bit)
        ldata_r <= ldata;
    else if(iis_state==read_right && cnt==data_bit)
        rdata_r <= rdata;

//锁存信号输出
assign ldata_l = ldata_r;
assign rdata_l = rdata_r;

endmodule

    


        





