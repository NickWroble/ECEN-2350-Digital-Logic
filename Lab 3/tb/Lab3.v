module Lab3(
	input 		          		ADC_CLK_10,
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,
	input 		     [1:0]		KEY,
	output		     [9:0]		LEDR,
	input 		     [9:0]		SW
);
reg rst;
reg [3:0] counter;
reg clk;
reg [3:0] LEDs;
reg turnSignal;
reg [7:0] sevSeg0;

initial begin
	rst = 0;
	counter <= 0;
	clk <= 0;
	LEDs <= 0;
	turnSignal <= 0;
	sevSeg0 <= 8'b1111_1111;
end

assign HEX5 = 8'hFF;
assign HEX4 = 8'hFF;
assign HEX3 = 8'hFF;
assign HEX2 = 8'hFF;
assign HEX1 = 8'hFF;
assign HEX0 = sevSeg0;
assign LEDR[9:0] = LEDs;

always @(negedge KEY[0]) begin
	rst <= ~rst;
end
always @(negedge KEY[1]) begin
	turnSignal <= ~turnSignal;
end

always @(posedge ADC_CLK_10) begin
	if(counter == 15) begin 
		counter <= 0;
		clk = ~clk;
	end
	else counter <= counter + 1;
end

always @(posedge clk) begin
	if(rst == 1 || SW[9:0] == 10'b00_0000_0000) begin
		LEDs <= 10'b00_0000_0000;
		sevSeg0 <= 8'b1111_1111;
	end
	else begin
		if(SW[0] == 1) begin
			sevSeg0 <= 8'b1000_1001;
			casex(LEDs[9])
				1'b1: begin
					LEDs <= 10'b00_0000_0000;
				end
				1'b0: begin
					LEDs <= 10'b11_1000_0111;
				end
			endcase
		end
		else if(SW[1] == 1) begin
			if(turnSignal == 1'b1) begin
				sevSeg0 <= 8'b1100_0111;
				casex(LEDs)
					10'b00_0xxx_xxxx: LEDs <= 10'b00_1000_0000;
					10'b00_1xxx_xxxx: LEDs <= 10'b01_1000_0000;
					10'b01_1xxx_xxxx: LEDs <= 10'b11_1000_0000;
					10'b11_1xxx_xxxx: LEDs <= 10'b00_0000_0000;
				endcase
			end
			else begin
				sevSeg0 <= 8'b1010_1111;
				casex(LEDs)
					10'bxx_xxxx_x000: LEDs <= 10'b00_0000_0100;
					10'bxx_xxxx_x100: LEDs <= 10'b00_0000_0110;
					10'bxx_xxxx_x110: LEDs <= 10'b00_0000_0111;
					10'bxx_xxxx_x111: LEDs <= 10'b00_0000_0000;
				endcase
			end
		end
	end
end
endmodule
