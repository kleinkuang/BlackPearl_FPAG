
# Clock
set_property PACKAGE_PIN Y9         [get_ports clk]
set_property IOSTANDARD LVCMOS18    [get_ports clk]

set_property PACKAGE_PIN P14        [get_ports clk_led]
set_property IOSTANDARD LVCMOS33    [get_ports clk_led]

# Reset
set_property PACKAGE_PIN D19        [get_ports rst]
set_property IOSTANDARD LVCMOS33    [get_ports rst]

set_property PACKAGE_PIN R14        [get_ports led]
set_property IOSTANDARD LVCMOS33    [get_ports led]

# SPI
set_property PACKAGE_PIN W8         [get_ports spi_ss]
set_property IOSTANDARD LVCMOS18    [get_ports spi_ss]

set_property PACKAGE_PIN Y7         [get_ports spi_CtoF]
set_property IOSTANDARD LVCMOS18    [get_ports spi_CtoF]

set_property PACKAGE_PIN Y6         [get_ports spi_FtoC]
set_property IOSTANDARD LVCMOS18    [get_ports spi_FtoC]

# ADC
set_property PACKAGE_PIN V10        [get_ports {ADC_OUT[3]}]
set_property IOSTANDARD LVCMOS18    [get_ports {ADC_OUT[3]}]

set_property PACKAGE_PIN V8         [get_ports {ADC_OUT[2]}]
set_property IOSTANDARD LVCMOS18    [get_ports {ADC_OUT[2]}]

set_property PACKAGE_PIN U8         [get_ports {ADC_OUT[1]}]
set_property IOSTANDARD LVCMOS18    [get_ports {ADC_OUT[1]}]

set_property PACKAGE_PIN V7         [get_ports {ADC_OUT[0]}]
set_property IOSTANDARD LVCMOS18    [get_ports {ADC_OUT[0]}]



