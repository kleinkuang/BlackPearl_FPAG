// File:    bp_debug.sv
// Author:  Lei Kuang
// Date:    26th August 2020
// @ Imperial College London

module rb_debug
(
    input  logic        SYS_RST,
    input  logic        SYS_CLK_P,
    input  logic        SYS_CLK_N,
    
    output logic        sys_ready,
    output logic        sys_error,
    output logic        sys_full,
    output logic        fifo_full,
    
    // DDR4 PHY
    input  logic        DDR4_CLK_clk_n,
    input  logic        DDR4_CLK_clk_p,
    output logic        DDR4_act_n,
    output logic [16:0] DDR4_adr,
    output logic [1:0]  DDR4_ba,
    output logic        DDR4_bg,
    output logic        DDR4_ck_c,
    output logic        DDR4_ck_t,
    output logic        DDR4_cke,
    output logic        DDR4_cs_n,
    inout  logic [7:0]  DDR4_dm_n,
    inout  logic [63:0] DDR4_dq,
    inout  logic [7:0]  DDR4_dqs_c,
    inout  logic [7:0]  DDR4_dqs_t,
    output              DDR4_odt,
    output              DDR4_reset_n,
    // FT601Q PHY
    output logic [3:0]  FT601Q_ft_be,
    input  logic        FT601Q_ft_clk,
    output logic [31:0] FT601Q_ft_data,
    output logic        FT601Q_ft_nrst,
    output logic        FT601Q_ft_oe_n,
    output logic        FT601Q_ft_rd_n,
    input  logic        FT601Q_ft_rxf_n,
    output logic        FT601Q_ft_siwu_n,
    input  logic        FT601Q_ft_txe_n,
    output logic        FT601Q_ft_wr_n
);

logic           sys_nrst;
logic           sys_clk;

logic           sys_ready;

logic           sys_error;
logic           sys_full;
logic           fifo_full;

logic           ft_start;

logic           in_fifo_clk;
logic [31:0]    in_fifo_data;
logic           in_fifo_data_valid;
logic           in_fifo_full;
logic           in_fifo_error;

// System
clk_wiz_0 clk_inst
(
    .reset      (SYS_RST),
    .locked     (sys_nrst),
    
    .clk_in1_p  (SYS_CLK_P),
    .clk_in1_n  (SYS_CLK_N),

    .clk_out1   (sys_clk)
);

assign in_fifo_clk = sys_clk;

// Testbench
// - In FIFO must never become full
always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst)
        in_fifo_error <= '0;
    else
        if(~in_fifo_error)
            in_fifo_error <= in_fifo_full;

// - Generate 4 bytes every 8 clock cycles
logic [3:0] clk_cnt;

always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst) begin
        clk_cnt <= '0;
    end
    else
        if(ft_start)
            clk_cnt <= clk_cnt + 3'd1;

// - Data generation
logic [7:0] data_cnt;
logic       data_valid;

assign data_valid = clk_cnt=='1;

always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst)
        data_cnt <= '0;
    else
        if(data_valid)
            data_cnt <= data_cnt + 8'd4;
        
assign in_fifo_data       = {{data_cnt+8'd3}, {data_cnt+8'd2}, {data_cnt+8'd1}, {data_cnt}};
assign in_fifo_data_valid = data_valid;

// DUT
SYS SYS_i
(
    .sys_nrst           (sys_nrst),
    .sys_ready          (sys_ready),
    .sys_error          (sys_error),
    .sys_full           (sys_full),
    
    .ft_start           (ft_start),
    
    .in_fifo_clk        (in_fifo_clk),
    .in_fifo_data       (in_fifo_data),
    .in_fifo_data_valid (in_fifo_data_valid),
    .in_fifo_full       (in_fifo_full),

    .DDR4_CLK_clk_n     (DDR4_CLK_clk_n),
    .DDR4_CLK_clk_p     (DDR4_CLK_clk_p),
    .DDR4_act_n         (DDR4_act_n),
    .DDR4_adr           (DDR4_adr),
    .DDR4_ba            (DDR4_ba),
    .DDR4_bg            (DDR4_bg),
    .DDR4_ck_c          (DDR4_ck_c),
    .DDR4_ck_t          (DDR4_ck_t),
    .DDR4_cke           (DDR4_cke),
    .DDR4_cs_n          (DDR4_cs_n),
    .DDR4_dm_n          (DDR4_dm_n),
    .DDR4_dq            (DDR4_dq),
    .DDR4_dqs_c         (DDR4_dqs_c),
    .DDR4_dqs_t         (DDR4_dqs_t),
    .DDR4_odt           (DDR4_odt),
    .DDR4_reset_n       (DDR4_reset_n),

    .FT601Q_ft_be       (FT601Q_ft_be),
    .FT601Q_ft_clk      (FT601Q_ft_clk),
    .FT601Q_ft_data     (FT601Q_ft_data),
    .FT601Q_ft_nrst     (FT601Q_ft_nrst),
    .FT601Q_ft_oe_n     (FT601Q_ft_oe_n),
    .FT601Q_ft_rd_n     (FT601Q_ft_rd_n),
    .FT601Q_ft_rxf_n    (FT601Q_ft_rxf_n),
    .FT601Q_ft_siwu_n   (FT601Q_ft_siwu_n),
    .FT601Q_ft_txe_n    (FT601Q_ft_txe_n),
    .FT601Q_ft_wr_n     (FT601Q_ft_wr_n)
);

endmodule
