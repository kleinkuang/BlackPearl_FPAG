# ----------------------------------------------------------------
# System Indicator
# ----------------------------------------------------------------
# - SW - South
set_property IOSTANDARD LVCMOS18                [get_ports SYS_RST]
set_property PACKAGE_PIN BE22                   [get_ports SYS_RST]

# - GPIO 7
set_property IOSTANDARD LVCMOS12                [get_ports SYS_READY]
set_property PACKAGE_PIN BA37                   [get_ports SYS_READY]
# - GPIO 6
set_property IOSTANDARD LVCMOS12                [get_ports CLK_LED]
set_property PACKAGE_PIN AV36                   [get_ports CLK_LED]
# - GPIO 5
#set_property IOSTANDARD LVCMOS12                [get_ports SYS_READY]
#set_property PACKAGE_PIN AU37                   [get_ports SYS_READY]
# - GPIO 4
#set_property IOSTANDARD LVCMOS12                [get_ports CLK_LED]
#set_property PACKAGE_PIN BF32                   [get_ports CLK_LED]
# - GPIO 3
set_property IOSTANDARD LVCMOS12                [get_ports SYS_FULL]
set_property PACKAGE_PIN BB32                   [get_ports SYS_FULL]
# - GPIO 2
set_property IOSTANDARD LVCMOS12                [get_ports SYS_ERROR]
set_property PACKAGE_PIN AY30                   [get_ports SYS_ERROR]
# - GPIO 1
#set_property IOSTANDARD LVCMOS12                [get_ports F_VDD1_LED]
#set_property PACKAGE_PIN AV34                   [get_ports F_VDD1_LED]
# - GPIO 0
#set_property IOSTANDARD LVCMOS12                [get_ports F_AVDD_LED]
#set_property PACKAGE_PIN AT32                   [get_ports F_AVDD_LED]

# ----------------------------------------------------------------
# BlackPearl PCB
# ----------------------------------------------------------------
create_clock -period 4                          [get_ports BP_clk_p]
# - FMCP H34, F_CLK_P
set_property IOSTANDARD LVDS                    [get_ports BP_clk_p]
set_property PACKAGE_PIN N38                    [get_ports BP_clk_p]
# - FMCP H35, F_CLK_N
set_property IOSTANDARD LVDS                    [get_ports BP_clk_n]
set_property PACKAGE_PIN M38                    [get_ports BP_clk_n]

set_property CLOCK_DEDICATED_ROUTE FALSE        [get_nets SYS_i/bp_rd_0/inst/i_clk/O]

# - FMCP H7, H8, C_NRST
#set_property IOSTANDARD LVCMOS18                [get_ports BP_nrst]
#set_property PACKAGE_PIN AJ32                   [get_ports BP_nrst]
set_property IOSTANDARD LVDS                    [get_ports BP_nrst_p]
set_property PACKAGE_PIN AJ32                   [get_ports BP_nrst_p]
set_property IOSTANDARD LVDS                    [get_ports BP_nrst_n]
set_property PACKAGE_PIN AK32                   [get_ports BP_nrst_n]

# - FMCP G12, F_AVDD_EN
set_property IOSTANDARD LVCMOS18                [get_ports F_AVDD_EN]
set_property PACKAGE_PIN AK29                   [get_ports F_AVDD_EN]
# - FMCP G27, F_VDD2_EN
set_property IOSTANDARD LVCMOS18                [get_ports F_VDD2_EN]
set_property PACKAGE_PIN Y34                    [get_ports F_VDD2_EN]
# - FMCP G28, F_VDD1_EN
set_property IOSTANDARD LVCMOS18                [get_ports F_VDD1_EN]
set_property PACKAGE_PIN W34                    [get_ports F_VDD1_EN]

# - FMCP G9, F_I2C_SCL
set_property IOSTANDARD LVCMOS18                [get_ports iic_rtl_scl_io]
set_property PACKAGE_PIN AT39                   [get_ports iic_rtl_scl_io]
# - FMCP G10, F_I2C_SDA
set_property IOSTANDARD LVCMOS18                [get_ports iic_rtl_sda_io]
set_property PACKAGE_PIN AT40                   [get_ports iic_rtl_sda_io]

# ----------------------------------------------------------------
# BlackPearl
# ----------------------------------------------------------------
# - FMCP, H10, H11, SPI_CS
set_property IOSTANDARD LVDS                    [get_ports BP_spi_cs_p]
set_property PACKAGE_PIN AR37                   [get_ports BP_spi_cs_p]
set_property IOSTANDARD LVDS                    [get_ports BP_spi_cs_n]
set_property PACKAGE_PIN AT37                   [get_ports BP_spi_cs_n]
# - FMCP, H13, H14, SPI_MOSI
set_property IOSTANDARD LVDS                    [get_ports BP_spi_mosi_p]
set_property PACKAGE_PIN AP36                   [get_ports BP_spi_mosi_p]
set_property IOSTANDARD LVDS                    [get_ports BP_spi_mosi_n]
set_property PACKAGE_PIN AP37                   [get_ports BP_spi_mosi_n]
# - FMCP, H25, H26, SPI_MISO
set_property IOSTANDARD LVDS                    [get_ports BP_spi_miso_p]
set_property PACKAGE_PIN M35                    [get_ports BP_spi_miso_p]
set_property IOSTANDARD LVDS                    [get_ports BP_spi_miso_n]
set_property PACKAGE_PIN L35                    [get_ports BP_spi_miso_n]

# - FMCP, H16, H17, ADC_OUT[3]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_p[3]}]
set_property PACKAGE_PIN AJ30                   [get_ports {BP_adc_out_p[3]}]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_n[3]}]
set_property PACKAGE_PIN AJ31                   [get_ports {BP_adc_out_n[3]}]
# - FMCP, H19, H20, ADC_OUT[2]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_p[2]}]
set_property PACKAGE_PIN AG32                   [get_ports {BP_adc_out_p[2]}]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_n[2]}]
set_property PACKAGE_PIN AG33                   [get_ports {BP_adc_out_n[2]}]
# - FMCP, H22, H23, ADC_OUT[1]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_p[1]}]
set_property PACKAGE_PIN N33                    [get_ports {BP_adc_out_p[1]}]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_n[1]}]
set_property PACKAGE_PIN M33                    [get_ports {BP_adc_out_n[1]}]
# - FMCP, H28, H29, ADC_OUT[0]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_p[0]}]
set_property PACKAGE_PIN T34                    [get_ports {BP_adc_out_p[0]}]
set_property IOSTANDARD LVDS                    [get_ports {BP_adc_out_n[0]}]
set_property PACKAGE_PIN T35                    [get_ports {BP_adc_out_n[0]}]
# - FMCP, H31, H32, EoF
set_property IOSTANDARD LVDS                    [get_ports BP_eof_p]
set_property PACKAGE_PIN M36                    [get_ports BP_eof_p]
set_property IOSTANDARD LVDS                    [get_ports BP_eof_n]
set_property PACKAGE_PIN L36                    [get_ports BP_eof_n]

# ----------------------------------------------------------------
# FT601Q
# ----------------------------------------------------------------
create_clock -period 15                         [get_ports FT601Q_ft_clk]
set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_clk]
set_property PACKAGE_PIN AP12                   [get_ports FT601Q_ft_clk]

set_property CLOCK_DEDICATED_ROUTE FALSE        [get_nets FT601Q_ft_clk_IBUF_inst/O]

set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_nrst]
set_property PACKAGE_PIN BB12                   [get_ports FT601Q_ft_nrst]

set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_be[3]}]
set_property PACKAGE_PIN BA14                   [get_ports {FT601Q_ft_be[3]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_be[2]}]
set_property PACKAGE_PIN BB14                   [get_ports {FT601Q_ft_be[2]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_be[1]}]
set_property PACKAGE_PIN BB16                   [get_ports {FT601Q_ft_be[1]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_be[0]}]
set_property PACKAGE_PIN BC16                   [get_ports {FT601Q_ft_be[0]}]

set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_txe_n]
set_property PACKAGE_PIN BD15                   [get_ports FT601Q_ft_txe_n]
set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_rxf_n]
set_property PACKAGE_PIN BC15                   [get_ports FT601Q_ft_rxf_n]
set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_wr_n]
set_property PACKAGE_PIN BE15                   [get_ports FT601Q_ft_wr_n]
set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_rd_n]
set_property PACKAGE_PIN BA9                    [get_ports FT601Q_ft_rd_n]
set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_oe_n]
set_property PACKAGE_PIN AY9                    [get_ports FT601Q_ft_oe_n]

set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[31]}]
set_property PACKAGE_PIN AR14                   [get_ports {FT601Q_ft_data[31]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[30]}]
set_property PACKAGE_PIN AT14                   [get_ports {FT601Q_ft_data[30]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[29]}]
set_property PACKAGE_PIN AW11                   [get_ports {FT601Q_ft_data[29]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[28]}]
set_property PACKAGE_PIN AY10                   [get_ports {FT601Q_ft_data[28]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[27]}]
set_property PACKAGE_PIN AW12                   [get_ports {FT601Q_ft_data[27]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[26]}]
set_property PACKAGE_PIN AY12                   [get_ports {FT601Q_ft_data[26]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[25]}]
set_property PACKAGE_PIN AN16                   [get_ports {FT601Q_ft_data[25]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[24]}]
set_property PACKAGE_PIN AP16                   [get_ports {FT601Q_ft_data[24]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[23]}]
set_property PACKAGE_PIN AW13                   [get_ports {FT601Q_ft_data[23]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[22]}]
set_property PACKAGE_PIN AU11                   [get_ports {FT601Q_ft_data[22]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[21]}]
set_property PACKAGE_PIN AY13                   [get_ports {FT601Q_ft_data[21]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[20]}]
set_property PACKAGE_PIN AV11                   [get_ports {FT601Q_ft_data[20]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[19]}]
set_property PACKAGE_PIN AK15                   [get_ports {FT601Q_ft_data[19]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[18]}]
set_property PACKAGE_PIN AL14                   [get_ports {FT601Q_ft_data[18]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[17]}]
set_property PACKAGE_PIN AL15                   [get_ports {FT601Q_ft_data[17]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[16]}]
set_property PACKAGE_PIN AM14                   [get_ports {FT601Q_ft_data[16]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[15]}]
set_property PACKAGE_PIN AT12                   [get_ports {FT601Q_ft_data[15]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[14]}]
set_property PACKAGE_PIN AP13                   [get_ports {FT601Q_ft_data[14]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[13]}]
set_property PACKAGE_PIN AU12                   [get_ports {FT601Q_ft_data[13]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[12]}]
set_property PACKAGE_PIN AR13                   [get_ports {FT601Q_ft_data[12]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[11]}]
set_property PACKAGE_PIN AN15                   [get_ports {FT601Q_ft_data[11]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[10]}]
set_property PACKAGE_PIN AV10                   [get_ports {FT601Q_ft_data[10]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[9]}]
set_property PACKAGE_PIN AP15                   [get_ports {FT601Q_ft_data[9]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[8]}]
set_property PACKAGE_PIN AW10                   [get_ports {FT601Q_ft_data[8]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[7]}]
set_property PACKAGE_PIN AM13                   [get_ports {FT601Q_ft_data[7]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[6]}]
set_property PACKAGE_PIN AK12                   [get_ports {FT601Q_ft_data[6]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[5]}]
set_property PACKAGE_PIN AM12                   [get_ports {FT601Q_ft_data[5]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[4]}]
set_property PACKAGE_PIN AL12                   [get_ports {FT601Q_ft_data[4]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[3]}]
set_property PACKAGE_PIN AK14                   [get_ports {FT601Q_ft_data[3]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[2]}]
set_property PACKAGE_PIN AJ13                   [get_ports {FT601Q_ft_data[2]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[1]}]
set_property PACKAGE_PIN AK13                   [get_ports {FT601Q_ft_data[1]}]
set_property IOSTANDARD LVCMOS18                [get_ports {FT601Q_ft_data[0]}]
set_property PACKAGE_PIN AJ12                   [get_ports {FT601Q_ft_data[0]}]

set_property IOSTANDARD LVCMOS18                [get_ports FT601Q_ft_siwu_n]
set_property PACKAGE_PIN BF15                   [get_ports FT601Q_ft_siwu_n]
set_property PULLUP TRUE                        [get_ports FT601Q_ft_siwu_n]

# ----------------------------------------------------------------
# SPI Settings for Configuration Memory of VCU118 Rev2.0
# ----------------------------------------------------------------
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_desig]

# ----------------------------------------------------------------
# False Path
# ----------------------------------------------------------------
# ft_start -> blackpearl_readout
set_false_path -from [get_clocks FT601Q_ft_clk] -to [get_clocks BP_clk_p]
# microblaze -> blackpearl_readout
#            -> ft601q
#            -> ddr4
set_false_path -from [get_clocks -of_objects [get_pins SYS_i/mcu_box/clk_wiz_1/clk_out1]] -to [get_clocks BP_clk_p]
set_false_path -from [get_clocks -of_objects [get_pins SYS_i/mcu_box/clk_wiz_1/clk_out1]] -to [get_clocks FT601Q_ft_clk]
set_false_path -from [get_clocks -of_objects [get_pins SYS_i/mcu_box/clk_wiz_1/clk_out1]] -to [get_clocks -of_objects [get_pins SYS_i/ddr4_box/ddr4_ui_clk]]
