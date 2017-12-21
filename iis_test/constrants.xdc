#audio iis
set_property PACKAGE_PIN AA6 [get_ports bclk_1]
set_property IOSTANDARD LVCMOS33 [get_ports bclk_1]

set_property PACKAGE_PIN Y6 [get_ports lrclk_1]
set_property IOSTANDARD LVCMOS33 [get_ports lrclk_1]

set_property PACKAGE_PIN AA7 [get_ports sdata_i_1]
set_property IOSTANDARD LVCMOS33 [get_ports sdata_i_1]

set_property PACKAGE_PIN Y8 [get_ports sdata_o_1]
set_property IOSTANDARD LVCMOS33 [get_ports sdata_o_1]

set_property PACKAGE_PIN P16 [get_ports rst];  # "BTNC"
set_property IOSTANDARD LVCMOS33 [get_ports rst]

#old audio iis
set_property PACKAGE_PIN T22 [get_ports BCLK];  # "LD0"
set_property IOSTANDARD LVCMOS33 [get_ports BCLK]

set_property PACKAGE_PIN T21 [get_ports LRCLK];  # "LD1"
set_property IOSTANDARD LVCMOS33 [get_ports LRCLK]

set_property PACKAGE_PIN U22 [get_ports SDATA_O];  # "LD2"
set_property IOSTANDARD LVCMOS33 [get_ports SDATA_O]

set_property PACKAGE_PIN R16 [get_ports SDATA_I];  # "BTND"
set_property IOSTANDARD LVCMOS33 [get_ports SDATA_I]

#MCLK
set_property PACKAGE_PIN AB2 [get_ports FCLK_CLK1]
set_property IOSTANDARD LVCMOS33 [get_ports FCLK_CLK1]

set_property PACKAGE_PIN AB4 [get_ports iic_1_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_1_scl_io]

set_property PACKAGE_PIN AB5 [get_ports iic_1_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_1_sda_io]

set_property PACKAGE_PIN AB1 [get_ports {ADDRESS[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADDRESS[0]}]

set_property PACKAGE_PIN Y5 [get_ports {ADDRESS[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADDRESS[1]}]


#clk select
set_property PACKAGE_PIN F22 [get_ports {SW0}];  # "SW0"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property PACKAGE_PIN G22 [get_ports {SW1}];  # "SW1"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property PACKAGE_PIN H22 [get_ports {SW2}];  # "SW2"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
set_property PACKAGE_PIN F21 [get_ports {SW3}];  # "SW3"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[3]}]
set_property PACKAGE_PIN H19 [get_ports {SW4}];  # "SW4"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[4]}]
set_property PACKAGE_PIN H18 [get_ports {SW5}];  # "SW5"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[5]}]
set_property PACKAGE_PIN H17 [get_ports {SW6}];  # "SW6"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[6]}]

set_property PACKAGE_PIN M15 [get_ports source];  # "SW7"
set_property IOSTANDARD LVCMOS33 [get_ports source]