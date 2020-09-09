// File:    bp_rd_tb.sv
// Author:  Lei Kuang
// Date:    14th August 2020
// @ Imperial College London

module bp_rd_tb;

logic            ila_clk;
logic            chip_clk;
logic            sys_nrst;
logic            sys_start;
logic [3:0]      sys_delay;
logic            sys_mode;      // 0: Normal
                                // 1: Debug
logic            data_clk;
logic [31:0]     data;
logic            data_valid;

logic            NRST;
logic            CLK_P;
logic            CLK_N;
logic            SPI_CS_P;
logic            SPI_CS_N;
logic            SPI_MOSI_P;
logic            SPI_MOSI_N;
logic            SPI_MISO_P;
logic            SPI_MISO_N;
logic [3:0]      ADC_OUT_P;
logic [3:0]      ADC_OUT_N;
logic            EoF_P;
logic            EoF_N;
    
bp_rd dut(.*);

initial begin
    CLK_P = '0;
    forever # 5ns CLK_P = ~CLK_P;
end

initial begin
    CLK_N = '1;
    forever # 5ns CLK_N = ~CLK_N;
end

initial begin
    sys_nrst   = '0;
    sys_start  = '0;
    sys_delay  = '0;
    sys_mode   = '1;
    
    SPI_MISO_P = '0;
    SPI_MISO_N = '1;
    
    #10ns
    
    @(posedge CLK_P)
    sys_nrst <= '1;
    
    @(posedge CLK_P)
    sys_start <= '1;
end

endmodule
