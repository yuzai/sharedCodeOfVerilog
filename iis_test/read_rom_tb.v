module read_rom_tb;

reg clk_fs;
reg rst_n;
reg [6:0]SW;
wire [10:0]address;

read_rom test(
    .clk_fs(clk_fs),  //fs = 48khz
    .rst_n(rst_n), 
    .SW(SW),
    .address(address)
);

initial begin 
    clk_fs = 0;
    rst_n = 1;
    #10
    rst_n = 0;
    #10
    rst_n = 1;
    SW = 7'd2;
    #100
    SW = 7'd5;
end

always #10 clk_fs = ~clk_fs;

endmodule

