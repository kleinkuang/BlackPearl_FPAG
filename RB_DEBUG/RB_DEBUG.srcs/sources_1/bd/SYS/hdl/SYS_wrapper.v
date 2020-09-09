//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Thu Aug 27 17:46:08 2020
//Host        : Klein_Workspace running 64-bit major release  (build 9200)
//Command     : generate_target SYS_wrapper.bd
//Design      : SYS_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module SYS_wrapper
   (DDR4_CLK_clk_n,
    DDR4_CLK_clk_p,
    DDR4_act_n,
    DDR4_adr,
    DDR4_ba,
    DDR4_bg,
    DDR4_ck_c,
    DDR4_ck_t,
    DDR4_cke,
    DDR4_cs_n,
    DDR4_dm_n,
    DDR4_dq,
    DDR4_dqs_c,
    DDR4_dqs_t,
    DDR4_odt,
    DDR4_reset_n,
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
    ft_start,
    in_fifo_clk,
    in_fifo_data,
    in_fifo_data_valid,
    in_fifo_full,
    sys_error,
    sys_full,
    sys_nrst,
    sys_ready);
  input DDR4_CLK_clk_n;
  input DDR4_CLK_clk_p;
  output DDR4_act_n;
  output [16:0]DDR4_adr;
  output [1:0]DDR4_ba;
  output DDR4_bg;
  output DDR4_ck_c;
  output DDR4_ck_t;
  output DDR4_cke;
  output DDR4_cs_n;
  inout [7:0]DDR4_dm_n;
  inout [63:0]DDR4_dq;
  inout [7:0]DDR4_dqs_c;
  inout [7:0]DDR4_dqs_t;
  output DDR4_odt;
  output DDR4_reset_n;
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
  output ft_start;
  input in_fifo_clk;
  input [31:0]in_fifo_data;
  input in_fifo_data_valid;
  output in_fifo_full;
  output sys_error;
  output sys_full;
  input [0:0]sys_nrst;
  output sys_ready;

  wire DDR4_CLK_clk_n;
  wire DDR4_CLK_clk_p;
  wire DDR4_act_n;
  wire [16:0]DDR4_adr;
  wire [1:0]DDR4_ba;
  wire DDR4_bg;
  wire DDR4_ck_c;
  wire DDR4_ck_t;
  wire DDR4_cke;
  wire DDR4_cs_n;
  wire [7:0]DDR4_dm_n;
  wire [63:0]DDR4_dq;
  wire [7:0]DDR4_dqs_c;
  wire [7:0]DDR4_dqs_t;
  wire DDR4_odt;
  wire DDR4_reset_n;
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
  wire ft_start;
  wire in_fifo_clk;
  wire [31:0]in_fifo_data;
  wire in_fifo_data_valid;
  wire in_fifo_full;
  wire sys_error;
  wire sys_full;
  wire [0:0]sys_nrst;
  wire sys_ready;

  SYS SYS_i
       (.DDR4_CLK_clk_n(DDR4_CLK_clk_n),
        .DDR4_CLK_clk_p(DDR4_CLK_clk_p),
        .DDR4_act_n(DDR4_act_n),
        .DDR4_adr(DDR4_adr),
        .DDR4_ba(DDR4_ba),
        .DDR4_bg(DDR4_bg),
        .DDR4_ck_c(DDR4_ck_c),
        .DDR4_ck_t(DDR4_ck_t),
        .DDR4_cke(DDR4_cke),
        .DDR4_cs_n(DDR4_cs_n),
        .DDR4_dm_n(DDR4_dm_n),
        .DDR4_dq(DDR4_dq),
        .DDR4_dqs_c(DDR4_dqs_c),
        .DDR4_dqs_t(DDR4_dqs_t),
        .DDR4_odt(DDR4_odt),
        .DDR4_reset_n(DDR4_reset_n),
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
        .ft_start(ft_start),
        .in_fifo_clk(in_fifo_clk),
        .in_fifo_data(in_fifo_data),
        .in_fifo_data_valid(in_fifo_data_valid),
        .in_fifo_full(in_fifo_full),
        .sys_error(sys_error),
        .sys_full(sys_full),
        .sys_nrst(sys_nrst),
        .sys_ready(sys_ready));
endmodule
