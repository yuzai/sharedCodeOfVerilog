module key_debounce(clk,rst_n,key,o_key);
//对单个按键进行消抖
input clk,rst_n;
input key;
output o_key;
	reg           r0_fpga_key ;
	reg [21:0]    r_time_cnt ;

always@(posedge clk)
	r0_fpga_key <= key ;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		r_time_cnt <= 22'h3fffff ;
	else if(r0_fpga_key&&!key) //====判断按键按下是否到达指定时间
		r_time_cnt <= 22'h0 ;
	else if(r_time_cnt == 22'h3fffff)  
		r_time_cnt <= r_time_cnt ;
	else
		r_time_cnt <= r_time_cnt+1'b1 ;   
		

	reg            r_fpga_key   ;
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		r_fpga_key  <= 1'b0 ;
	else if((r_time_cnt == 22'h3ffff8)&&!r0_fpga_key)//到达指定时间，则认为是真正的按下而不是抖动
		r_fpga_key  <= 1'b1 ;
	else 
		r_fpga_key  <= 1'b0 ;             

	assign o_key = r_fpga_key;
            
endmodule