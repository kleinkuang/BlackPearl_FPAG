//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Wed Sep  9 13:41:23 2020
//Host        : Klein_Workspace running 64-bit major release  (build 9200)
//Command     : generate_target SYS_wrapper.bd
//Design      : SYS_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module SYS_wrapper
   (BP_adc_out_n,
    BP_adc_out_p,
    BP_clk_n,
    BP_clk_p,
    BP_eof_n,
    BP_eof_p,
    BP_nrst_n,
    BP_nrst_p,
    BP_spi_cs_n,
    BP_spi_cs_p,
    BP_spi_miso_n,
    BP_spi_miso_p,
    BP_spi_mosi_n,
    BP_spi_mosi_p,
    CLK_LED,
    DDR4_C0_act_n,
    DDR4_C0_adr,
    DDR4_C0_ba,
    DDR4_C0_bg,
    DDR4_C0_ck_c,
    DDR4_C0_ck_t,
    DDR4_C0_cke,
    DDR4_C0_cs_n,
    DDR4_C0_dm_n,
    DDR4_C0_dq,
    DDR4_C0_dqs_c,
    DDR4_C0_dqs_t,
    DDR4_C0_odt,
    DDR4_C0_reset_n,
    DDR4_CLK_clk_n,
    DDR4_CLK_clk_p,
    FT601Q_ft_be,
    FT601Q_ft_clk,
    FT601Q_ft_data,
    FT601Q_ft_nrst,
    FT601Q_ft_oe_n,
    FT601Q_ft_rd_n,
    FT601Q_ft_rxf_n,
    FT601Q_ft_siwu_n,
    FT601Q_ft_txe_n,
    FT601Q_ft_wr_n,
    F_AVDD_EN,
    F_VDD1_EN,
    F_VDD2_EN,
    MCU_CLK_clk_n,
    MCU_CLK_clk_p,
    MCU_RST,
    SYS_ERROR,
    SYS_FULL,
    SYS_READY,
    SYS_RST,
    iic_rtl_scl_io,
    iic_rtl_sda_io,
    rs232_uart_rxd,
    rs232_uart_txd);
  input [3:0]BP_adc_out_n;
  input [3:0]BP_adc_out_p;
  input BP_clk_n;
  input BP_clk_p;
  input BP_eof_n;
  input BP_eof_p;
  output BP_nrst_n;
  output BP_nrst_p;
  output BP_spi_cs_n;
  output BP_spi_cs_p;
  input BP_spi_miso_n;
  input BP_spi_miso_p;
  output BP_spi_mosi_n;
  output BP_spi_mosi_p;
  output [0:0]CLK_LED;
  output DDR4_C0_act_n;
  output [16:0]DDR4_C0_adr;
  output [1:0]DDR4_C0_ba;
  output DDR4_C0_bg;
  output DDR4_C0_ck_c;
  output DDR4_C0_ck_t;
  output DDR4_C0_cke;
  output DDR4_C0_cs_n;
  inout [7:0]DDR4_C0_dm_n;
  inout [63:0]DDR4_C0_dq;
  inout [7:0]DDR4_C0_dqs_c;
  inout [7:0]DDR4_C0_dqs_t;
  output DDR4_C0_odt;
  output DDR4_C0_reset_n;
  input DDR4_CLK_clk_n;
  input DDR4_CLK_clk_p;
  output [3:0]FT601Q_ft_be;
  input FT601Q_ft_clk;
  output [31:0]FT601Q_ft_data;
  output FT601Q_ft_nrst;
  output FT601Q_ft_oe_n;
  output FT601Q_ft_rd_n;
  input FT601Q_ft_rxf_n;
  output FT601Q_ft_siwu_n;
  input FT601Q_ft_txe_n;
  output FT601Q_ft_wr_n;
  output [0:0]F_AVDD_EN;
  output [0:0]F_VDD1_EN;
  output [0:0]F_VDD2_EN;
  input MCU_CLK_clk_n;
  input MCU_CLK_clk_p;
  input MCU_RST;
  output SYS_ERROR;
  output SYS_FULL;
  output SYS_READY;
  input [0:0]SYS_RST;
  inout iic_rtl_scl_io;
  inout iic_rtl_sda_io;
  input rs232_uart_rxd;
  output rs232_uart_txd;

  wire [3:0]BP_adc_out_n;
  wire [3:0]BP_adc_out_p;
  wire BP_clk_n;
  wire BP_clk_p;
  wire BP_eof_n;
  wire BP_eof_p;
  wire BP_nrst_n;
  wire BP_nrst_p;
  wire BP_spi_cs_n;
  wire BP_spi_cs_p;
  wire BP_spi_miso_n;
  wire BP_spi_miso_p;
  wire BP_spi_mosi_n;
  wire BP_spi_mosi_p;
  wire [0:0]CLK_LED;
  wire DDR4_C0_act_n;
  wire [16:0]DDR4_C0_adr;
  wire [1:0]DDR4_C0_ba;
  wire DDR4_C0_bg;
  wire DDR4_C0_ck_c;
  wire DDR4_C0_ck_t;
  wire DDR4_C0_cke;
  wire DDR4_C0_cs_n;
  wire [7:0]DDR4_C0_dm_n;
  wire [63:0]DDR4_C0_dq;
  wire [7:0]DDR4_C0_dqs_c;
  wire [7:0]DDR4_C0_dqs_t;
  wire DDR4_C0_odt;
  wire DDR4_C0_reset_n;
  wire DDR4_CLK_clk_n;
  wire DDR4_CLK_clk_p;
  wire [3:0]FT601Q_ft_be;
  wire FT601Q_ft_clk;
  wire [31:0]FT601Q_ft_data;
  wire FT601Q_ft_nrst;
  wire FT601Q_ft_oe_n;
  wire FT601Q_ft_rd_n;
  wire FT601Q_ft_rxf_n;
  wire FT601Q_ft_siwu_n;
  wire FT601Q_ft_txe_n;
  wire FT601Q_ft_wr_n;
  wire [0:0]F_AVDD_EN;
  wire [0:0]F_VDD1_EN;
  wire [0:0]F_VDD2_EN;
  wire MCU_CLK_clk_n;
  wire MCU_CLK_clk_p;
  wire MCU_RST;
  wire SYS_ERROR;
  wire SYS_FULL;
  wire SYS_READY;
  wire [0:0]SYS_RST;
  wire iic_rtl_scl_i;
  wire iic_rtl_scl_io;
  wire iic_rtl_scl_o;
  wire iic_rtl_scl_t;
  wire iic_rtl_sda_i;
  wire iic_rtl_sda_io;
  wire iic_rtl_sda_o;
  wire iic_rtl_sda_t;
  wire rs232_uart_rxd;
  wire rs232_uart_txd;

  SYS SYS_i
       (.BP_adc_out_n(BP_adc_out_n),
        .BP_adc_out_p(BP_adc_out_p),
        .BP_clk_n(BP_clk_n),
        .BP_clk_p(BP_clk_p),
        .BP_eof_n(BP_eof_n),
        .BP_eof_p(BP_eof_p),
        .BP_nrst_n(BP_nrst_n),
        .BP_nrst_p(BP_nrst_p),
        .BP_spi_cs_n(BP_spi_cs_n),
        .BP_spi_cs_p(BP_spi_cs_p),
        .BP_spi_miso_n(BP_spi_miso_n),
        .BP_spi_miso_p(BP_spi_miso_p),
        .BP_spi_mosi_n(BP_spi_mosi_n),
        .BP_spi_mosi_p(BP_spi_mosi_p),
        .CLK_LED(CLK_LED),
        .DDR4_C0_act_n(DDR4_C0_act_n),
        .DDR4_C0_adr(DDR4_C0_adr),
        .DDR4_C0_ba(DDR4_C0_ba),
        .DDR4_C0_bg(DDR4_C0_bg),
        .DDR4_C0_ck_c(DDR4_C0_ck_c),
        .DDR4_C0_ck_t(DDR4_C0_ck_t),
        .DDR4_C0_cke(DDR4_C0_cke),
        .DDR4_C0_cs_n(DDR4_C0_cs_n),
        .DDR4_C0_dm_n(DDR4_C0_dm_n),
        .DDR4_C0_dq(DDR4_C0_dq),
        .DDR4_C0_dqs_c(DDR4_C0_dqs_c),
        .DDR4_C0_dqs_t(DDR4_C0_dqs_t),
        .DDR4_C0_odt(DDR4_C0_odt),
        .DDR4_C0_reset_n(DDR4_C0_reset_n),
        .DDR4_CLK_clk_n(DDR4_CLK_clk_n),
        .DDR4_CLK_clk_p(DDR4_CLK_clk_p),
        .FT601Q_ft_be(FT601Q_ft_be),
        .FT601Q_ft_clk(FT601Q_ft_clk),
        .FT601Q_ft_data(FT601Q_ft_data),
        .FT601Q_ft_nrst(FT601Q_ft_nrst),
        .FT601Q_ft_oe_n(FT601Q_ft_oe_n),
        .FT601Q_ft_rd_n(FT601Q_ft_rd_n),
        .FT601Q_ft_rxf_n(FT601Q_ft_rxf_n),
        .FT601Q_ft_siwu_n(FT601Q_ft_siwu_n),
        .FT601Q_ft_txe_n(FT601Q_ft_txe_n),
        .FT601Q_ft_wr_n(FT601Q_ft_wr_n),
        .F_AVDD_EN(F_AVDD_EN),
        .F_VDD1_EN(F_VDD1_EN),
        .F_VDD2_EN(F_VDD2_EN),
        .MCU_CLK_clk_n(MCU_CLK_clk_n),
        .MCU_CLK_clk_p(MCU_CLK_clk_p),
        .MCU_RST(MCU_RST),
        .SYS_ERROR(SYS_ERROR),
        .SYS_FULL(SYS_FULL),
        .SYS_READY(SYS_READY),
        .SYS_RST(SYS_RST),
        .iic_rtl_scl_i(iic_rtl_scl_i),
        .iic_rtl_scl_o(iic_rtl_scl_o),
        .iic_rtl_scl_t(iic_rtl_scl_t),
        .iic_rtl_sda_i(iic_rtl_sda_i),
        .iic_rtl_sda_o(iic_rtl_sda_o),
        .iic_rtl_sda_t(iic_rtl_sda_t),
        .rs232_uart_rxd(rs232_uart_rxd),
        .rs232_uart_txd(rs232_uart_txd));
  IOBUF iic_rtl_scl_iobuf
       (.I(iic_rtl_scl_o),
        .IO(iic_rtl_scl_io),
        .O(iic_rtl_scl_i),
        .T(iic_rtl_scl_t));
  IOBUF iic_rtl_sda_iobuf
       (.I(iic_rtl_sda_o),
        .IO(iic_rtl_sda_io),
        .O(iic_rtl_sda_i),
        .T(iic_rtl_sda_t));
endmodule
