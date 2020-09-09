// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:ft_tx:1.0
// IP Revision: 17

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module SYS_ft_tx_0_0 (
  nrst,
  ft_ready,
  ft_start,
  wr_clk,
  wr_en,
  wr_data,
  wr_full,
  FT_CLK,
  FT_NRST,
  FT_TXE_N,
  FT_RXF_N,
  FT_WR_N,
  FT_RD_N,
  FT_OE_N,
  FT_BE,
  FT_DATA,
  FT_SIWU_N
);

input wire nrst;
output wire ft_ready;
output wire ft_start;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME wr_clk, ASSOCIATED_BUSIF DATA_IN, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:user:FT_WR:1.0 DATA_IN wr_clk, xilinx.com:signal:clock:1.0 wr_clk CLK" *)
output wire wr_clk;
(* X_INTERFACE_INFO = "xilinx.com:user:FT_WR:1.0 DATA_IN wr_en" *)
input wire wr_en;
(* X_INTERFACE_INFO = "xilinx.com:user:FT_WR:1.0 DATA_IN wr_data" *)
input wire [31 : 0] wr_data;
(* X_INTERFACE_INFO = "xilinx.com:user:FT_WR:1.0 DATA_IN wr_full" *)
output wire wr_full;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME FT_CLK, ASSOCIATED_BUSIF FT, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_CLK, xilinx.com:signal:clock:1.0 FT_CLK CLK" *)
input wire FT_CLK;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_NRST" *)
output wire FT_NRST;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_TXE_N" *)
input wire FT_TXE_N;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_RXF_N" *)
input wire FT_RXF_N;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_WR_N" *)
output wire FT_WR_N;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_RD_N" *)
output wire FT_RD_N;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_OE_N" *)
output wire FT_OE_N;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_BE" *)
output wire [3 : 0] FT_BE;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_DATA" *)
output wire [31 : 0] FT_DATA;
(* X_INTERFACE_INFO = "xilinx.com:user:FT601Q:1.0 FT FT_SIWU_N" *)
output wire FT_SIWU_N;

  ft_tx inst (
    .nrst(nrst),
    .ft_ready(ft_ready),
    .ft_start(ft_start),
    .wr_clk(wr_clk),
    .wr_en(wr_en),
    .wr_data(wr_data),
    .wr_full(wr_full),
    .FT_CLK(FT_CLK),
    .FT_NRST(FT_NRST),
    .FT_TXE_N(FT_TXE_N),
    .FT_RXF_N(FT_RXF_N),
    .FT_WR_N(FT_WR_N),
    .FT_RD_N(FT_RD_N),
    .FT_OE_N(FT_OE_N),
    .FT_BE(FT_BE),
    .FT_DATA(FT_DATA),
    .FT_SIWU_N(FT_SIWU_N)
  );
endmodule
