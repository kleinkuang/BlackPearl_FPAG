// File:    spi.sv
// Author:  Lei Kuang
// Date:    2nd April 2020
// @ Imperial College London

// SPI Master for BlackPearl
// - 10-bit SPI
// - Update SPI_MOSI at failing edge
// - Read   SPI_MISO at failing edge

module spi
(
    input  logic        nrst,
    input  logic        clk,
    // User Interface
    input  logic        spi_req,
    input  logic [3:0]  spi_delay,
    input  logic [9:0]  spi_data_out,
    output logic [9:0]  spi_data_in,
    output logic        spi_done,
    output logic        spi_ready,
    // SPI Physical Port
    output logic        SPI_CS,
    input  logic        SPI_MISO,
    output logic        SPI_MOSI
);

logic       rst_int;
logic [3:0] cnt;
logic [9:0] spi_data_out_reg;

assign rst_int = ~nrst;

enum {rst, idle, busy, done} state;

always_ff @ (negedge clk, posedge rst_int) begin
    if(rst_int) begin
        state  <= rst;
        SPI_CS <= '1;
    end
    else
        case(state)
            rst:    state <= idle;
            idle:   if(spi_req) begin
                        state  <= busy;
                        SPI_CS <= '0;
                    end
            busy:   if(cnt=='0) begin
                        state <= done;
                        SPI_CS <= '1;
                    end
            done:   state <= idle;
        endcase
end

always_ff @ (negedge clk, posedge rst_int) begin
    if(rst_int) begin
        cnt              <= '0;
        spi_data_out_reg <= '0;
    end
    else
        if(spi_req) begin
            cnt              <= 4'd9;
            spi_data_out_reg <= spi_data_out;
        end
        else
            if(cnt!='0) begin
                cnt              <= cnt - 4'd1;
                spi_data_out_reg <= spi_data_out_reg << 1;
            end
end

assign SPI_MOSI = spi_data_out_reg[9];

// Delay
logic [2:0] shift_reg [15:0];

genvar i;
generate 
begin:shift_loop
    for(i=1; i<16; i++) begin
        always_ff @(negedge clk, posedge rst_int)
            if(rst_int)
                shift_reg[i] <= '0;
            else
                shift_reg[i] <= shift_reg[i-1];
    end
end
endgenerate

assign shift_reg[0][0] = state == idle;    // spi_ready
assign shift_reg[0][1] = state == done;    // spi_done
assign shift_reg[0][2] = SPI_CS;

logic SPI_CS_delay;

assign spi_ready      = shift_reg[spi_delay][0];
assign spi_done       = shift_reg[spi_delay][1];
assign SPI_CS_delay   = shift_reg[spi_delay][2];

always_ff @ (negedge clk, posedge rst_int) begin
    if(rst_int)
        spi_data_in <= '0;
    else
        if(~SPI_CS_delay)
            spi_data_in <= {spi_data_in[8:0], SPI_MISO};
end

endmodule
