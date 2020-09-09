// File:    ft_tx_debug.sv
// Author:  Lei Kuang
// Date:    26th August 2020
// @ Imperial College London


module ft_tx_debug
(
    input logic         sys_rst,
    
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

logic           nrst;
logic           ft_ready;
logic           ft_start;

logic           wr_clk;
logic [31:0]    wr_data;
logic           wr_en;
logic           wr_full;

assign nrst = ~sys_rst;

// Testbench
logic [7:0]     data_cnt;

always_ff @ (posedge wr_clk, negedge nrst)
    if(~nrst)
        data_cnt <= '0;
    else
        if(wr_en)
            data_cnt <= data_cnt + 8'd4;
            
assign wr_data = {{data_cnt+8'd3},{data_cnt+8'd2},{data_cnt+8'd1},{data_cnt}};
assign wr_en   = ft_ready & ~wr_full;

SYS SYS_i
(
    .nrst               (nrst),
    
    .ft_ready           (ft_ready),
    .ft_start           (ft_start),
    
    .wr_clk             (wr_clk),
    .wr_data            (wr_data),
    .wr_en              (wr_en),
    .wr_full            (wr_full),
    
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
