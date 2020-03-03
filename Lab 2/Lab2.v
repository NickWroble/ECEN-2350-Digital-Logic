module Lab2(ADC_CLK_10, SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  ADC_CLK_10;
	input  [1:0]  KEY;
	input  [9:0]   SW;
	output [9:0] LEDR;
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [7:0] HEX2;
	output [7:0] HEX3;
	output [7:0] HEX4;
	output [7:0] HEX5;
	reg					 clk;
	reg [23:0]		 counter; 
	reg [3:0]  dayOfYearOnes; 
	reg [3:0]  dayOfYearTens; 
	reg [3:0]		   month;
	reg [3:0]		day_tens;
	reg [3:0]		day_ones;
	reg [6:0]	   dayOfYear;
	reg [4:0]		february;
	reg			  clk_enable;
	reg		   fiveHZ_enable;
	assign LEDR[9] =	  SW[9];
	assign LEDR[1] =		clk;
	assign LEDR[0] = clk_enable;
	initial begin
		clk = 0;
		counter = 0; 
		month = 1;
		day_tens = 0;
		day_ones = 1;
		dayOfYear = 1;
		february = 28;
		clk_enable = 0;
		fiveHZ_enable = 0;
	end

	deciSevSeg dayOfYeartens (.tens_enable(1'b1), .inputReg(dayOfYearTens),.outputReg(HEX5));
	deciSevSeg dayOfYearones (.tens_enable(1'b0), .inputReg(dayOfYearOnes),.outputReg(HEX4));
	assign HEX3 = 8'b1111_1111;
	deciSevSeg monthones	 (.tens_enable(1'b0), .inputReg(month),		   .outputReg(HEX2));
	deciSevSeg daytens		 (.tens_enable(1'b1), .inputReg(day_tens),	   .outputReg(HEX1));
	deciSevSeg dayones		 (.tens_enable(1'b0), .inputReg(day_ones),	   .outputReg(HEX0));

	always @(SW[9]) begin
		if(~SW[9]) february <= 28;
		else february <= 29;
	end
	always @(negedge KEY[0]) clk_enable = ~clk_enable;
	always @(negedge KEY[1]) fiveHZ_enable = ~fiveHZ_enable;
	always @(dayOfYear) begin
		dayOfYearOnes <= dayOfYear % 10;
		dayOfYearTens <= dayOfYear / 10;
		if(dayOfYear <= 31) begin
			month <= 1;
			day_tens <= dayOfYear / 10;
			day_ones <= dayOfYear % 10;
		end
		else if(dayOfYear <= (31 + february)) begin
			month <= 2;
			day_tens <= (dayOfYear - 31) / 10;
			day_ones <= (dayOfYear - 31) % 10;
		end
		else if(dayOfYear <= (31 + 31 + february)) begin 
			month <= 3;
			day_tens <= (dayOfYear - (31 + february)) / 10;
			day_ones <= (dayOfYear - (31 + february)) % 10;
		end
		else begin
			month <= 4;
			day_tens = 4'd15; //blank
			day_ones <= (dayOfYear - (31 + february + 31)) % 10;
		end
	end
	always @(posedge ADC_CLK_10) begin
		if(~clk_enable) begin //resets if KEY0 0 is pressed
			clk <= 0;
			counter <= 0;
			dayOfYear <= 1;
		end
		else if(clk_enable) begin
			counter <= counter + 1;
			if(fiveHZ_enable) begin
				if(counter == 1_000_000 || counter == 3_000_000 || counter == 5_000_000 || counter == 7_000_000 || counter == 9_000_000) clk <= 1'b0;
				if(counter == 2_000_000 || counter == 4_000_000 || counter == 6_000_000 || counter == 8_000_000 || counter == 10_000_000) begin
					counter <= 0;
					clk <= 1'b1;
					dayOfYear <= dayOfYear + 1;
				end
			end
			else begin
				if(counter == 5_000_000) clk <= 1'b0;
				if(counter == 10_000_000) begin
					counter <= 0;
					clk <= 1'b1;
					dayOfYear <= dayOfYear + 1;
				end
			end
		end
		if(dayOfYear == 100) dayOfYear <= 1;
	end
endmodule

module deciSevSeg(tens_enable, inputReg, outputReg);
	input  [3:0]  inputReg;
	input	   tens_enable;
	output [7:0] outputReg;
	reg    [7:0] outputHEX;
	assign outputReg = outputHEX;
	always @(inputReg) begin
		casex({tens_enable, inputReg})
			default:  outputHEX = 8'b11111111; // blank
			5'b00000: outputHEX = 8'b11000000; //0
			5'bx0001: outputHEX = 8'b11111001; //1
			5'bx0010: outputHEX = 8'b10100100; //2
			5'bx0011: outputHEX = 8'b10110000; //3
			5'bx0100: outputHEX = 8'b10011001; //4
			5'bx0101: outputHEX = 8'b10010010; //5
			5'bx0110: outputHEX = 8'b10000010; //6
			5'bx0111: outputHEX = 8'b11111000; //7
			5'bx1000: outputHEX = 8'b10000000; //8
			5'bx1001: outputHEX = 8'b10010000; //9
		endcase
	end
endmodule