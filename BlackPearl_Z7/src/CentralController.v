module CentralController(
	//4-port-spi
	input			spi_FtoC,
	input  			spi_ss,
	output 			spi_CtoF,

	//switches S1 to S3 for Frame and AZ
	output	reg		S1,
	output	reg	[127:0]	S2bar,
	output	reg		S3,

	//switches for the ADC
	output	reg 		ADC_enable,
	
	//global input
	input			clk,	//250MHz
	input			n_reset,

	//synchronisation
	output	reg		EoF
	);

//state machine definition
reg	[1:0]	state;
localparam	IDLE = 2'b00;
localparam	RESET = 2'b01;
localparam	READOUT = 2'b10;
//localparam	INDIVIDUAL =2'b11;

reg 	[3:0] 	spi_counter;
reg 	[9:0]	spi_reg_i;
reg	[9:0]	spi_reg_o;

reg	[9:0]	spi_received;
reg	[9:0]	spi_transmit;

reg 	[2:0]	Reset_counter;
reg	[7:0]	S2_counter;
reg	[8:0]	Readout_counter;

//FPGA to Chip, serial to parallel
always @ (posedge clk, negedge n_reset) begin
	if (~n_reset) begin
		spi_counter <= 4'd0;
		spi_received <= 10'd0;
		spi_reg_i <= 10'd0;
	end
	else if (~spi_ss) begin
		spi_counter <= spi_counter + 4'd1;
		spi_reg_i <= {spi_reg_i[8:0],spi_FtoC};
	end
	else begin
		spi_counter <= 4'd0;
		spi_received <= spi_reg_i;
	end
end

//Chip to FPGA, parallel to serial
always @ (posedge clk, negedge n_reset) begin
	if (~n_reset) spi_reg_o <= 10'd0;
	else if (~spi_ss) begin
		if (spi_counter == 4'd0) spi_reg_o <= spi_transmit;
		else spi_reg_o <= {spi_reg_o[8:0], 1'b0};
	end
end

assign spi_CtoF = spi_reg_o[9];
//assign state = (n_reset) ? spi_received[9:8] : 2'b00;

//Identify which state should the controller should enter
always @ (posedge clk, negedge n_reset) begin
	if (~n_reset) begin
		S1 <= 1'b0;
		S2bar <= {128{1'b1}};
		S3 <= 1'b0;
		ADC_enable <= 1'b0;
		spi_transmit <= 10'd0;
		S2_counter <= 8'd0;
		Reset_counter <= 3'd0;
		state <=  IDLE;
		Readout_counter <= 9'd0;
		EoF <= 1'b0;
	end
	else begin
		if(spi_received[9:8] == 2'b00) begin		//IDLE
			S1 <= 1'b0;
			S2bar <= {128{1'b1}};
			S3 <= 1'b0;
			ADC_enable <= 1'b0;
			spi_transmit <= spi_received;
		end

		else if(spi_received[9:8] == 2'b01) begin	//CALIBRATION
			S1 <= 1'b1;
			S2bar <= {128{1'b1}};
			S3 <= 1'b1;
			ADC_enable <= 1'b0;
			spi_transmit <= {2'b01, 8'd1};
		end

		else if(spi_received[9:8] == 2'b10) begin	//READOUT
			case (state)

				IDLE : begin
					S1 <= 1'b0;
					S3 <= 1'b0;
					ADC_enable <= 1'b1;
					spi_transmit <= {2'b10, 8'd1};
					S2bar <= {128{1'b1}};
					Reset_counter <= 3'd0;
					S2_counter <= 8'd0;
					Readout_counter <= 9'd0;
					state <= RESET;
				end

				RESET : begin							//7 clk cycles for reset signal
					if (Reset_counter == 3'd6) begin
						Reset_counter <= 3'd0;
						state <= READOUT;
					end
					else if (Reset_counter == 3'd1) begin
						Reset_counter <= Reset_counter + 3'd1;
						S2bar <= {128{1'b1}};
					end
					else if (Reset_counter == 3'd3) begin
						Reset_counter <= Reset_counter + 3'd1;
						if (S2_counter == 8'd128) begin
							EoF <= 1'b1;
							S2_counter <= 8'd0;
						end
						else begin
							S2_counter <= S2_counter + 8'd1;
							EoF <= 1'b0;
						end
					end
					else if (Reset_counter == 3'd4) begin
						S2bar <= ~(1 << (S2_counter - 3'd1));
						Reset_counter <= Reset_counter + 3'd1;
					end
					else Reset_counter <= Reset_counter + 3'd1;
				end

				READOUT: begin							//255 clk cycles for readout integration
					if (Readout_counter == 9'd255) begin
						Readout_counter <= 9'd0;
						state <= RESET;
					end
					else Readout_counter <= Readout_counter + 9'd1;
				end
			endcase			
		end

		else if(spi_received[9:8] == 2'b11) begin	//INDIVIDUAL
			S1 <= 1'b0;
			S3 <= 1'b0;
			S2bar <= ~(1 << spi_received[6:0]);
			ADC_enable <= spi_received[7];
		end
	end
end
endmodule