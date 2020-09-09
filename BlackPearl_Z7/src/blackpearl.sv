// File:    bp.sv
// Author:  Lei Kuang
// Date:    2nd of April 2020
// @ Imperial College London

// BlackPearl Digital Controller

module bp
(
    input  logic        clk,
    input  logic        rst,
    
    input  logic        spi_ss,
    input  logic        spi_FtoC,
    output logic        spi_CtoF,
    //output logic        EoF,
    
    output logic [3:0]  ADC_OUT,
    
    output logic        led,
    output logic        clk_led
);

logic ADC_enable;
logic nrst;

assign nrst = ~rst;

CentralController c0
(
    .clk        (clk),
    .n_reset    (nrst),

    .spi_ss     (spi_ss),
    .spi_FtoC   (spi_FtoC),
    .spi_CtoF   (spi_CtoF),

    .S1         (),
    .S2bar      (),
    .S3         (),

    .ADC_enable (ADC_enable),
    .EoF        (EoF)
);
	
ADC_Counter a0
(
    .clk     (clk),
    .n_reset (n_reset),
    .enable  (ADC_enable),
    .ADC_OUT (ADC_OUT)
);

logic [31:0] clk_cnt;

always_ff @ (posedge clk, negedge nrst)
    if(~nrst) begin
        clk_cnt <= '0;
        clk_led <= '0;
    end
    else
        if(clk_cnt==32'd5000000) begin
            clk_cnt <= '0;
            clk_led <= ~clk_led;
        end
        else
            clk_cnt <= clk_cnt + 32'd1;
            
assign led = nrst;

ila_0 i0
(
    .clk (clk),
    
    .probe0 (spi_ss),
    .probe1 (spi_FtoC),
    .probe2 (spi_CtoF),
    
    .probe3 (ADC_OUT[3:0])
);

endmodule
