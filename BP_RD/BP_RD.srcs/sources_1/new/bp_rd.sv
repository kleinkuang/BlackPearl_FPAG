// File:    bp_rd.sv
// Author:  Lei Kuang
// Date:    14th August 2020
// @ Imperial College London

// Readout Interface for BlackPearl

module bp_rd
(
    // System
    input  logic            ila_clk,
    output logic            chip_clk,
    input  logic            sys_nrst,
    input  logic            sys_start,
    input  logic [3:0]      sys_delay,
    input  logic            sys_mode,   // 0: Normal
                                        // 1: Debug
    // Data Stream
    output logic            data_clk,
    output logic [31:0]     data,
    output logic            data_valid,
    // BlackPearl Port
    output logic            NRST_P,
    output logic            NRST_N,
    input  logic            CLK_P,
    input  logic            CLK_N,
    output logic            SPI_CS_P,
    output logic            SPI_CS_N,
    output logic            SPI_MOSI_P,
    output logic            SPI_MOSI_N,
    input  logic            SPI_MISO_P,
    input  logic            SPI_MISO_N,
    input  logic [3:0]      ADC_OUT_P,
    input  logic [3:0]      ADC_OUT_N,
    input  logic            EoF_P,
    input  logic            EoF_N
);

logic [8:0] god_cnt;
logic [8:0] god_cnt_delay;
logic [7:0] col_cnt;

logic       CLK;
logic       SPI_CS;
logic       SPI_MOSI;
logic       SPI_MISO;
logic [3:0] ADC_OUT;
logic       EoF;

//assign NRST     = sys_nrst;
assign sys_clk  = CLK;
assign chip_clk = CLK;
assign data_clk = CLK;

// ----------------------------------------------------------------
// Differential
// ----------------------------------------------------------------

// In ----------------------------------------------------------------
// CLK
IBUFDS 
#(
    .DIFF_TERM      ("FALSE"),      // Differential Termination
    .IBUF_LOW_PWR   ("TRUE"),       // Low power="TRUE", Highest performance="FALSE"
    .IOSTANDARD     ("DEFAULT")     // Specify the input I/O standard
) 
i_clk
(
    .I  (CLK_P),
    .IB (CLK_N),
    .O  (CLK)
);

// SPI_MISO
IBUFDS 
#(
    .DIFF_TERM      ("FALSE"),      // Differential Termination
    .IBUF_LOW_PWR   ("TRUE"),       // Low power="TRUE", Highest performance="FALSE"
    .IOSTANDARD     ("DEFAULT")     // Specify the input I/O standard
) 
i_miso
(
    .I  (SPI_MISO_P),
    .IB (SPI_MISO_N),
    .O  (SPI_MISO)
);

// ADC_OUT
genvar i;
generate 
begin: adc
    for( i=0; i<4; i++) begin: b
        IBUFDS 
        #(
            .DIFF_TERM      ("FALSE"),      // Differential Termination
            .IBUF_LOW_PWR   ("TRUE"),       // Low power="TRUE", Highest performance="FALSE"
            .IOSTANDARD     ("DEFAULT")     // Specify the input I/O standard
        ) 
        IBUFDS_ADC_OUT
        (
            .I  (ADC_OUT_P[i]),
            .IB (ADC_OUT_N[i]),
            .O  (ADC_OUT[i])
        );
    end
end
endgenerate

// EoF
IBUFDS 
#(
    .DIFF_TERM      ("FALSE"),      // Differential Termination
    .IBUF_LOW_PWR   ("TRUE"),       // Low power="TRUE", Highest performance="FALSE"
    .IOSTANDARD     ("DEFAULT")     // Specify the input I/O standard
) 
i_eof
(
    .I  (EoF_P),
    .IB (EoF_N),
    .O  (EoF)
);

// Output ----------------------------------------------------------------
// SPI_CS
OBUFDS 
#(
    .IOSTANDARD ("DEFAULT"), // Specify the output I/O standard
    .SLEW       ("FAST") // Specify the output slew rate
) 
o_cs
(
    .I          (SPI_CS),
    .O          (SPI_CS_P),
    .OB         (SPI_CS_N)
);

// SPI_MOSI
OBUFDS 
#(
    .IOSTANDARD ("DEFAULT"), // Specify the output I/O standard
    .SLEW       ("FAST") // Specify the output slew rate
) 
o_mosi
(
    .I          (SPI_MOSI),
    .O          (SPI_MOSI_P),
    .OB         (SPI_MOSI_N)
);

// NRST
OBUFDS 
#(
    .IOSTANDARD ("DEFAULT"), // Specify the output I/O standard
    .SLEW       ("FAST") // Specify the output slew rate
) 
o_nrst
(
    .I          (sys_nrst),
    .O          (NRST_P),
    .OB         (NRST_N)
);

// ----------------------------------------------------------------
// SPI Master
// ----------------------------------------------------------------
logic        spi_req;
logic [9:0]  spi_data_out;
logic [9:0]  spi_data_in;
logic        spi_done;
logic        spi_ready;

spi s0
(
    .nrst         (sys_nrst),
    .clk          (sys_clk),
    // User Interface
    .spi_req      (spi_req),
    .spi_delay    (sys_delay),
    .spi_data_out (spi_data_out),
    .spi_data_in  (spi_data_in),
    .spi_done     (spi_done),
    .spi_ready    (spi_ready),
    // SPI Physical Port
    .SPI_CS       (SPI_CS),
    .SPI_MISO     (SPI_MISO),
    .SPI_MOSI     (SPI_MOSI)
);

logic [9:0]  spi_data_in_int;

always_ff @ (posedge sys_clk) begin
    if(spi_done)
        spi_data_in_int <= spi_data_in;
end

// ----------------------------------------------------------------
// Readout Controller
// ----------------------------------------------------------------
enum {init, rst, cali, idle, sync, dely, buff, read} state;

always_ff @ (posedge sys_clk, negedge sys_nrst) begin
    if(~sys_nrst)
        state <= init;
    else
        case(state)
            init:   if(spi_ready)               // Ready
                        state <= rst;
            rst:    if(spi_done)                // Reset blackpearl
                        state <=  cali ;
            cali:   if(spi_done)                // Calibrate blackpearl
                        state <= idle;
            idle:   if(sys_start)               // Wait for FT601 ack
                        state <= sync;
            sync:   if(spi_done)                // Synchronize god counter
                        state <= dely;
            dely:   if(god_cnt==9'd262)         // Delay reset clocks
                        state <= buff;
            buff:   if(god_cnt==9'd262)         // Wait for data
                        state <= read;
            read:   state <= read;              // Readout
        endcase
end

always_comb begin
    spi_req = '0;
    spi_data_out = '0;
    case(state)
        rst:    begin
                spi_req = spi_ready;
                spi_data_out = 10'b00_1010_0101;    // Reset
                end
        cali:   begin
                spi_req = spi_ready;
                spi_data_out = 10'b01_0000_0000;    // Calibration
                end
        sync:   begin
                spi_req = spi_ready;
                spi_data_out = 10'b10_0000_0000;    // Readout
                end
    endcase
end

// ----------------------------------------------------------------
// ADC DATA Acquisition
// ----------------------------------------------------------------
logic       adc_valid;
logic [3:0] adc_data;

assign adc_data = ADC_OUT;

// Same behaviour as the counter in BlackPearl ADC for synchronizaion
always_ff @ (posedge sys_clk, negedge sys_nrst) begin
    if(~sys_nrst)
        god_cnt <= '1;
    else
        if(state==sync & spi_done)
            god_cnt <= 9'd254;
        else
            if(state==dely | state==buff | state==read)
                if(god_cnt==9'd262)
                    god_cnt <= '0;
                else
                    god_cnt <= god_cnt + 9'd1;
end

always_ff @ (posedge sys_clk, negedge sys_nrst) begin
    if(~sys_nrst)
        col_cnt <= '0;
    else
        if(state==read & god_cnt==9'd262)
            col_cnt <= col_cnt[7] ? '0 : (col_cnt + 8'd1);
end

// Compensation for PCB transmission delay !!!
logic [8:0] shift_reg [15:0];

genvar j;
generate 
begin:shift_loop
    for(j=1; j<16; j++) begin
        always_ff @(posedge sys_clk, negedge sys_nrst)
            if(~sys_nrst)
                shift_reg[j] <= '1;
            else
                shift_reg[j] <= shift_reg[j-1];
    end
end
endgenerate

assign shift_reg[0] = god_cnt;

assign god_cnt_delay = shift_reg[sys_delay];

assign adc_valid = (state==read) & (god_cnt_delay[8]=='0) & (~col_cnt[7]);

// ----------------------------------------------------------------
// Serial In Parallel Out
// ----------------------------------------------------------------
// - LSB comes first
logic [7:0] byte_data;
logic [7:0] byte_debug;
logic [7:0] byte_out;
logic       byte_valid;
logic [1:0] byte_cnt;

assign byte_valid = byte_cnt[1];

always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst)
        byte_cnt <= '0;
    else
        if(adc_valid)
            byte_cnt <= byte_valid ? 8'd1 : byte_cnt + 2'd1;
        else 
            if(byte_valid)
                byte_cnt <= '0;
                
always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst)
        byte_data <= '0;
    else
        if(adc_valid)
            byte_data <= {adc_data, byte_data[7:4]};
            
// For debug
always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst)
        byte_debug <= '0;
    else
        if(byte_valid)
            byte_debug <= byte_debug + 8'd1;
            
assign byte_out = sys_mode ? byte_debug : byte_data;

// Concatenation
logic [31:0] data_int;
logic        data_int_valid;
logic [2:0]  data_int_cnt;

assign data_int_valid = data_int_cnt[2];

always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst)
        data_int_cnt <= '0;
    else
        if(byte_valid)
            data_int_cnt <= data_int_valid ? 8'd1 : data_int_cnt + 8'd1;
        else 
            if(data_int_valid)
                data_int_cnt <= '0;

always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst)
        data_int <= '0;
    else
        if(byte_valid)
            data_int <= {byte_out, data_int[31:8]};

// Output
always_ff @ (posedge sys_clk, negedge sys_nrst)
    if(~sys_nrst) begin
        data       <= '0;
        data_valid <= '0;
    end
    else begin
        data_valid <= data_int_valid;
        data       <= data_int;
    end

// ----------------------------------------------------------------
// Internal Logic Analyzer
// ----------------------------------------------------------------

ila_bp i0
(
    .clk     (ila_clk),
    
    .probe0  (sys_nrst),
    .probe1  (sys_delay[3:0]),
    .probe2  (sys_mode),
    .probe3  (sys_start),
    
    .probe4  (spi_req),
    .probe5  (spi_data_out[9:0]),
    .probe6  (spi_data_in[9:0]),
    .probe7  (spi_done),
    .probe8  (spi_ready),
    .probe9  (SPI_CS),
    .probe10 (SPI_MOSI),
    .probe11 (SPI_MISO),
    
    .probe12 (god_cnt[8:0]),
    .probe13 (god_cnt_delay[8:0]),
    .probe14 (col_cnt[7:0]),
    
    .probe15 (adc_valid),
    .probe16 (adc_data[3:0]),
    
    .probe17 (byte_cnt[1:0]),
    .probe18 (byte_valid),
    .probe19 (byte_data[3:0]),
    
    .probe20 (data_int_cnt[2:0]),
    .probe21 (data_int_valid),
    .probe22 (data_int[31:0]),
    
    .probe23 (EoF)
);

endmodule
