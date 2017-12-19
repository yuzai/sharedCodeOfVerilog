module keys_debounce(clk,input_keys,rst_n,output_keys);
//对8个按键进行消抖
input clk,rst_n;
input [3:0]input_keys;
output [3:0]output_keys;

key_debounce key3(
    .clk(clk),
    .rst_n(rst_n),
    .key(input_keys[3]),
    .o_key(output_keys[3])
);
key_debounce key2(
    .clk(clk),
    .rst_n(rst_n),
    .key(input_keys[2]),
    .o_key(output_keys[2])
);
key_debounce key1(
    .clk(clk),
    .rst_n(rst_n),
    .key(input_keys[1]),
    .o_key(output_keys[1])
);
key_debounce key0(
    .clk(clk),
    .rst_n(rst_n),
    .key(input_keys[0]),
    .o_key(output_keys[0])
);

endmodule
