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
reg [23:0] counter;
reg clk;
reg [2:0] leftSignal;
reg [2:0] rightSignal;
reg turnSignal;

initial begin
	rst = 0;
	counter <= 0;
	clk <= 0;
	leftSignal <= 0;
	rightSignal <= 0;
	turnSignal <= 0;
end

assign LEDR [6:3] = 0;
assign HEX5 = 8'hFF;
assign HEX4 = 8'hFF;
assign HEX3 = 8'hFF;
assign HEX2 = 8'hFF;
assign HEX1 = 8'hFF;
assign LEDR[9:7] = leftSignal;
assign LEDR[2:0] = rightSignal;

always @(negedge KEY[0]) begin
	rst <= ~rst;
end
always @(negedge KEY[1]) begin
	turnSignal <= ~turnSignal;
end

always @(posedge ADC_CLK_10) begin
	if(counter == 1_000_000) begin 
		counter <= 0;
		clk = ~clk;
	end
	else counter <= counter + 1;
end

always @(posedge clk) begin
	if(rst == 1 || SW[1] == 0) begin
		leftSignal <= 0;
		rightSignal <= 0;
	end
	else begin
		if(SW[0] == 1) begin
			casex(leftSignal[2])
				1'b1: begin
					leftSignal <= 3'b000;
					rightSignal <= 3'b000;
				end
				1'b0: begin
					leftSignal <= 3'b111;
					rightSignal <= 3'b111;
				end
			endcase
		end
		else begin
			if(SW[1] == 1 && SW[0] == 0) begin
				if(turnSignal == 0) begin
					rightSignal <= 0;
					case(leftSignal)
						3'b000: leftSignal <= 3'b001;
						3'b001: leftSignal <= 3'b011;
						3'b011: leftSignal <= 3'b111;
						3'b111: leftSignal <= 3'b000;
					endcase
				end
				else begin
					leftSignal <= 0;
					case(rightSignal)
						3'b000: rightSignal <= 3'b100;
						3'b100: rightSignal <= 3'b110;
						3'b110: rightSignal <= 3'b111;
						3'b111: rightSignal <= 3'b000;
					endcase
				end
			end
		end
	end
end
endmodule
