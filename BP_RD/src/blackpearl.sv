// File:    bp.sv
// Author:  Lei Kuang
// Date:    2nd of April 2020
// @ Imperial College London

// BlackPearl Digital Controller

module bp
(
    input  logic clk,
    input  logic n_reset,
    
    input  logic spi_ss,
    input  logic spi_FtoC,
    output logic spi_CtoF,
    output logic EoF,
    
    output [3:0] ADC_OUT
);

logic ADC_enable;

CentralController c0
(
    .clk        (clk),
    .n_reset    (n_reset),

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

endmodule
