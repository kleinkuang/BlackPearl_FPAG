// File:    piso.sv
// Author:  Lei Kuang
// Date:    16th August 2020
// @ Imperial College London

// Parallel In Serial Out for BlackPearl
// - In:  512-bit
// - Out: 32-bit

module piso
(
    input  logic         nrst,
    // Read
    output logic         rd_clk,
    input  logic         rd_empty,
    output logic         rd_en,
    input  logic [511:0] rd_data,
    // Write
    input  logic         wr_clk,
    output logic         wr_en,
    output logic [31:0]  wr_data,
    input  logic         wr_full
);

logic [4:0] wr_index; // 0..16
logic       wr_valid;

assign wr_valid = ~wr_index[4];
assign wr_en    = wr_valid & ~wr_full;
assign wr_end   = wr_index[3:0]=='1;
assign wr_data  = rd_data >> ({5'd0, wr_index[3:0]} << 5);

assign rd_clk   = wr_clk;
assign rd_en    = (~wr_valid | wr_end & ~wr_full) & ~rd_empty;

always_ff @ (posedge rd_clk, negedge nrst)
    if(~nrst)
        wr_index <= 5'd16;
    else 
        if(rd_en)
            wr_index <= '0;
        else
            if(wr_en)
                wr_index <= wr_index + 5'd1;
                
// For debug
logic [7:0] data_debug;
logic       data_error;

always_ff @ (posedge wr_clk, negedge nrst)
    if(~nrst) begin
        data_error <= '0;
        data_debug <= '0;
    end
    else begin
        if(wr_en) begin
            data_debug <= data_debug + 8'd4;
            if(~data_error)
                data_error <= wr_data[7:0] != data_debug;
        end
    end

ila_piso i0
(
    .clk     (wr_clk),

    .probe0  (rd_empty),
    .probe1  (rd_en),

    .probe2  (wr_index[4:0]),
    .probe3  (wr_valid),
    .probe4  (wr_en),
    .probe5  (wr_end),
    .probe6  (wr_data[31:0]),
    .probe7  (wr_full),

    .probe8  (data_debug[7:0]),
    .probe9  (data_error)
);

endmodule
