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
assign bclk_start = bclk_d1 & !bclk;//下降沿写信号

//iis_write状态机
parameter init       = 5'b00001,
          wait_left  = 5'b00010,
          write_left = 5'b00100,
          wait_right = 5'b01000,
          write_right = 5'b10000;

parameter bit_cnt = 5'd25;
reg [4:0]iis_state;
reg [4:0]cnt;
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
    iis_state<=init;
else
    case(iis_state)
    init:if(en)
            iis_state<=wait_left;
    wait_left:
         if(!en)
            iis_state<=init;
         else if(left_start)
            iis_state<=write_left;
    write_left:
         if(!en)
            iis_state<=init;
         else if(cnt == bit_cnt)
            iis_state<=wait_right;
    wait_right:
         if(!en)
            iis_state<=init;
         else if(right_start)
            iis_state<=write_right;
    write_right:
         if(!en)
            iis_state<=init;
         else if(cnt == bit_cnt)
            iis_state<=wait_left;
    default:iis_state<=init;
    endcase

//控制数据计数
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
    cnt<=0;
else
    if(iis_state==write_left||iis_state==write_right)
    begin 
        if(bclk_start)
            cnt<=cnt+1'b1;
    end
    else 
        cnt<=0;

//控制输出信号进行输出
reg [23:0]ldata_r;
reg [23:0]rdata_r;
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
begin 
    ldata_r<=0;
    rdata_r<=0;
end
else 
    if(iis_state==init)
    begin 
        ldata_r<=0;
        rdata_r<=0;
    end
    else if(iis_state==wait_left && left_start == 1'b1)
    begin 
        ldata_r<=ldata;
        rdata_r<=rdata;
    end
    else if(iis_state==write_left && bclk_start==1'b1)
        ldata_r[23:0] <= {ldata_r[22:0],1'b0};
    else if(iis_state==write_right && bclk_start==1'b1)
        rdata_r[23:0] <= {rdata_r[22:0],1'b0};

//寄存输出信号
reg sdata_r;
always@(posedge clk_100m or negedge rst_n)
if(!rst_n)
    sdata_r<=0;
else
    if(iis_state == write_left && bclk_start==1'b1)
        sdata_r<=ldata_r[23];
    else if(iis_state==write_right && bclk_start==1'b1)
        sdata_r<=rdata_r[23];

assign sdata_o = sdata_r;

endmodule
