module ADC_Counter
(
	input  clk,
	input  n_reset,
	input  enable,

	output [3:0] ADC_OUT
);

reg [127:0] flag;
reg         reset;

reg [8:0] counter;
reg [127:0] flag_buffer;
reg [7:0] i;
reg [1023:0] ADC_OUT_buffer;
reg [1023:0] ADC_result;
reg [127:0] flag_changed;

always @(posedge clk, negedge n_reset)
begin
	if (~n_reset)
	begin
		counter <= 9'd255;
		reset <= 1'b1;
		ADC_OUT_buffer <= 1024'd0;
		ADC_result <= 1024'd0;
		flag_changed <= 128'd0;
	end
	else
	begin
		if (enable)
		begin
			if (counter > 9'd255 && counter <= 9'd261)
			begin
				counter <= counter + 8'd1;
				reset <= 1'b1;
				ADC_OUT_buffer <= ADC_result;
				flag_changed <= 128'd0;
			end
			else if (counter == 9'd255)
			begin
				for (i = 0; i < 128; i = i + 1)
				begin
					if (~flag_changed[i]) ADC_result[(8*i) +: 8] <= 8'hff;
				end
				counter <= counter + 9'd1;
			end
			else if (counter == 9'd262)
			begin
				counter <= 9'd0;
				reset <= 1'b0;
			end
			else
			begin
				reset <= 1'b0;
				counter <= counter + 9'd1;

				for (i = 0; i < 128; i = i + 1)
				begin
					if (flag_buffer[i] != flag[i])
					begin
					ADC_result[(8*i) +: 8] <= counter[7:0];		
					flag_changed[i] <= 1'b1;
					end		
				end
			end
					
		end
		else counter <= 9'd255;
	end
end

always @ (posedge clk, negedge n_reset)
begin
	if (~n_reset)
		flag_buffer <= 128'd0;
	else if (reset)
		flag_buffer <= 128'd0;
	else
		flag_buffer <= flag;
end

// Fake flag
reg [6:0] flag_offset;

always @ (posedge clk, negedge n_reset) begin
        if (~n_reset)
            flag_offset <= 7'd127;
        else
            if(counter==255 & enable)
                flag_offset <= flag_offset + 7'd1;
end 

always @ (posedge clk, posedge reset) begin
    if (reset)
        flag <= 128'd0;
    else
        if(counter==flag_offset)
            flag <= 128'd1;
        else
            flag <= {flag[126:0], flag[0]};
end 

assign ADC_OUT = ADC_OUT_buffer >> 4*counter;

endmodule
