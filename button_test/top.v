module top(clk,rst,buttons,leds);

input clk,rst;
input [3:0]buttons;
output leds;

wire rst_n;
wire [3:0]buttons_n;

assign rst_n = ~rst;
assign buttons_n = ~buttons;

wire [3:0]output_keys;
keys_debounce u1(
    .clk(clk),
    .input_keys(buttons_n),
    .rst_n(rst_n),
    .output_keys(output_keys)
);

reg [7:0]leds;
always@(posedge clk or negedge rst_n)
if(!rst_n)
    leds<=0;
else
    if(output_keys[0])
        leds<=leds+1'b1;

endmodule
