// File:    ft_tx.sv
// Author:  Lei Kuang
// Date:    25th August 2020
// @ Imperial College London

// FIFO Master for FT601Q
// - for 245 synchronous FIFO mode protocols
// - !!! TX ONLY (Write Only)
// - !!! Minimum data size of 4KB for each transaction

module ft_tx
(
    input  logic        nrst,       // System reset
    output logic        ft_ready,   // System ready
    output logic        ft_start,   // Indicate a data request from the host (PC)
                                    // - will be used as start of readout
    // User Interface
    output logic        wr_clk,     // FIFO write clock
    input  logic        wr_en,      // FIFO write enable
    input  logic [31:0] wr_data,    // FIFO write data
    output logic        wr_full,    // FIFO write full

    // FT601Q Physical Port
    input  logic        FT_CLK,     // FT601Q FIFO bus clock
    output logic        FT_NRST,    // FT601Q FIFO nreset
    input  logic        FT_TXE_N,   // FT601Q FIFO write acknowledge
    input  logic        FT_RXF_N,   // FT601Q FIFO read data available
    output logic        FT_WR_N,    // FT601Q FIFO write enable
    output logic        FT_RD_N,    // FT601Q FIFO read enable
    output logic        FT_OE_N,    // FT601Q FIFO output enable (data bus direction)
    output logic [3:0]  FT_BE,      // FT601Q FIFO bus byte enable
    output logic [31:0] FT_DATA,    // FT601Q FIFO data
    // - Reserved
    output logic        FT_SIWU_N   // Externel pull up
);

// ----------------------------------------------------------------
// FT601Q Physical Port Translation
// ----------------------------------------------------------------
assign FT_NRST   = nrst;
assign FT_RD_N   = '1;  // Never read
assign FT_OE_N   = '1;  // Always input
assign FT_BE     = '1;  // Always 4 bytes
assign FT_SIWU_N = '1;  // Reserved

logic        ft_clk;
logic        ft_wr_ack;
logic        ft_wr_en;
logic [31:0] ft_wr_data;

assign ft_clk    = FT_CLK;
assign wr_clk    = FT_CLK;
assign ft_wr_ack = ~FT_TXE_N;
assign FT_WR_N   = ~ft_wr_en;
assign FT_DATA   = ft_wr_data;

always_ff @ (posedge ft_clk, negedge nrst)
    if(~nrst)
        ft_start <= '0;
    else
        if(~ft_start)
            ft_start <= ft_wr_ack;
            
assign ft_ready = w_state!=rst;


// FT_TXE_N Delay
logic [1:0] txe_cnt;
logic       txe_lock;

always_ff @ (posedge ft_clk, negedge ft_wr_ack)
    if(~ft_wr_ack)
        txe_cnt <= '0;
    else
        if(~txe_lock)
            txe_cnt <= txe_cnt + 2'd1;
            
assign txe_lock = txe_cnt=='1;

// ----------------------------------------------------------------
// FIFO for Burst
// ----------------------------------------------------------------
logic           rd_en;
logic           rd_empty;
logic [31:0]    rd_data;
logic           prog_full;

fifo_32bx32k f0
(
    .clk       (ft_clk),
    .rst       (~nrst),
    
    .full      (wr_full),
    .wr_en     (wr_en),
    .din       (wr_data),
    
    .empty     (rd_empty),
    .rd_en     (rd_en),
    .dout      (ft_wr_data),

    .prog_full (prog_full)
);

//assign prog_full = wr_full;

// ----------------------------------------------------------------
// FT601Q Write Control
// ----------------------------------------------------------------
// trans_cnt:   how many data left to read out

enum {rst, init, trans} w_state;

logic [9:0] trans_cnt; // 0..1023
logic       trans_end;

assign trans_end = trans_cnt=='1;

always_ff @ (posedge ft_clk, negedge nrst) begin
    if(~nrst) begin
        w_state   <= rst;
        trans_cnt <= '0;
    end
    else
        case(w_state)
            rst:    if(~wr_full)                                    // FIFO end of reset flag
                        w_state <= init;
                        
            init:   if(prog_full) 
                        w_state <= trans;
                    
            trans:  if(ft_wr_en) begin
                        trans_cnt = trans_cnt + 10'd1;
                        if(trans_end & ~prog_full)
                            w_state <= init;
                    end
        endcase
end

assign rd_en    = (w_state==init) & prog_full  | 
                  (w_state==trans & ~trans_end | prog_full) & ft_wr_ack & txe_lock;

assign ft_wr_en = w_state==trans & ft_wr_ack & txe_lock;

// Debug
logic [7:0] data_debug;
logic       data_error;

always_ff @ (posedge ft_clk, negedge nrst)
    if(~nrst) begin
        data_debug <= '0;
        data_error <= '0;
    end
    else
        if(ft_wr_en) begin
            data_debug <= data_debug + 8'd4;
            if(~data_error)
                data_error <= data_debug!=ft_wr_data[7:0];
        end

// ----------------------------------------------------------------
// Internal Logic Analyzer
// ----------------------------------------------------------------
logic [31:0] cnt_4k;

always_ff @ (posedge ft_clk, negedge nrst)
    if(~nrst)
        cnt_4k <= '0;
    else
        if(trans_end)
            cnt_4k <= cnt_4k + 32'd1;

ila_ft i0
(
    .clk     (ft_clk),
    .probe0  (nrst),
    .probe1  (ft_ready),

    .probe2  (wr_en),
    .probe3  (wr_data[31:0]),
    .probe4  (wr_full),
    .probe5  (prog_full),
    
    .probe6  (rd_en),
    .probe7  (rd_empty),
    
    .probe8  (ft_wr_data[31:0]),
    .probe9  (ft_wr_en),
    .probe10 (ft_wr_ack),
    .probe11 (trans_cnt[9:0]),
    .probe12 (trans_end),
    
    .probe13 (data_debug[7:0]),
    .probe14 (data_error),
    .probe15 (cnt_4k[31:0]),
    .probe16 (FT_TXE_N)
);

endmodule
