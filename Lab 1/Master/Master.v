module Master(KEY, LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0]  SW;
	input [1:0] KEY;
	output reg [9:0] LEDR;
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [7:0] HEX2;
	output [7:0] HEX3;
	output [7:0] HEX4;
	output [7:0] HEX5;
	wire   [3:0] input1;
	wire   [3:0] input2;
	wire   [4:0]  carry;
	wire   [4:0]    sum;
	reg  [6:0] hex0Num;
	reg  [6:0] hex1Num;
	reg  [6:0] hex2Num;
	reg  [6:0] hex3Num;
	reg  [6:0] hex4Num;
	reg  [6:0] hex5Num;

	assign carry [0]   = ~KEY[0];
	assign input1[0]   =   SW[4];
	assign input1[1]   =   SW[5];
	assign input1[2]   =   SW[6];
	assign input1[3]   =   SW[7];
	assign input2[0]   =   SW[0];
	assign input2[1]   =   SW[1];
	assign input2[2]   =   SW[2];
	assign input2[3]   =   SW[3];

	inputToHEX hex0(.num(hex0Num), .sevSeg(HEX0));
	inputToHEX hex1(.num(hex1Num), .sevSeg(HEX1));
	inputToHEX hex2(.num(hex2Num), .sevSeg(HEX2));
	inputToHEX hex3(.num(hex3Num), .sevSeg(HEX3));
	inputToHEX hex4(.num(hex4Num), .sevSeg(HEX4));
	inputToHEX hex5(.num(hex5Num), .sevSeg(HEX5));

	bitAdder bitsZero (.bit0(input1[0]), .bit1(input2[0]), .carryIn(carry[0]),  .carryOut(carry[1]), .sumOut(sum[0]), .button(~KEY[0]));
	bitAdder bitsOne  (.bit0(input1[1]), .bit1(input2[1]), .carryIn(carry[1]),  .carryOut(carry[2]), .sumOut(sum[1]), .button(~KEY[0]));
	bitAdder bitsTwo  (.bit0(input1[2]), .bit1(input2[2]), .carryIn(carry[2]),  .carryOut(carry[3]), .sumOut(sum[2]), .button(~KEY[0]));
	bitAdder bitsThree(.bit0(input1[3]), .bit1(input2[3]), .carryIn(carry[3]),  .carryOut(carry[4]), .sumOut(sum[3]), .button(~KEY[0]));
	assign sum[4] = ((input1[3] == 0 & input2[3] == 0) & sum[3] == 1) | 
					((input1[3] == 1 & input2[3] == 1) & sum[3] == 0) |
					((input1[3] == 0 & KEY[0] & input2[3] == 1) & sum[3] == 1) | 
					((input1[3] == 1 & KEY[0] & input2[3] == 0) & sum[3] == 0); 


	always @(SW, KEY) begin
		casex({SW[9], SW[8]}) 
			2'b00: begin
				LEDR [9] = 0;
				LEDR [8] = 0;
				LEDR[7:0] = KEY[1] ? SW: ~SW;
				hex0Num = 7'b0000000; //0
				hex1Num = 7'b0000000; //0
				hex2Num = KEY[1] ? 7'b0000101 : 7'b0001000; //5 or 8
				hex3Num = KEY[1] ? 7'b0000000 : 7'b0000001; //0 or 1
				hex4Num = KEY[1] ? 7'b0000100 : 7'b0000011; //4 or 3
				hex5Num = 7'b0000000; //0
			end

			2'b01: begin
				LEDR [9] = 0;
				LEDR [8] = 1;
				LEDR [7:0] = 0;
				case({input1[3]})
				//num[6] checks overflow, num[5] enables twos comp, num[4] chooses sign or digit display, rest of num is input number
					1'b0: hex5Num = 7'b001_0000; //blank sign
					1'b1: hex5Num = 7'b011_1000; //    - sign
				endcase
				case({input2[3]})
					1'b0: hex3Num = 7'b001_0000; //blank sign
					1'b1: hex3Num = 7'b011_1000; //    - sign
				endcase

				casex({sum[4], sum[3]})
					2'b1x: begin 
						hex1Num = 7'b1010000; //0 overflow
						hex0Num = 7'b1000000; //F overflow
					end
					2'b00: begin
						hex1Num = 7'b0010000; //blank
					end
					2'b01: begin 
						hex1Num = 7'b011_1000; //- sign
					end
				endcase

				//num[6] checks overflow, num[5] enables twos comp, num[4] chooses sign or digit display, rest of num is input number
				hex4Num[0] = input1[0];
				hex4Num[1] = input1[1];
				hex4Num[2] = input1[2];
				hex4Num[3] = input1[3];
				hex4Num[4] = 0;
				hex4Num[5] = 1;
				hex4Num[6] = 0;

				hex2Num[0] = input2[0];
				hex2Num[1] = input2[1];
				hex2Num[2] = input2[2];
				hex2Num[3] = input2[3];
				hex2Num[4] = 0;
				hex2Num[5] = 1;
				hex2Num[6] = 0;

				hex0Num[0] = sum[0];
				hex0Num[1] = sum[1];
				hex0Num[2] = sum[2];
				hex0Num[3] = sum[3];
				hex0Num[4] = 0;
				hex0Num[5] = 1;
				hex0Num[6] = sum[4];
			end


			2'b1x: begin
				LEDR [9] = 1;
				LEDR [8] = SW[8];
				casex({SW[8]})
				1'b0: begin
					LEDR [7:0] = 0;
					//hex5Num = input1[3] ? 7'b001_0000: 7'b011_1000;
					hex4Num[0] = input1[0];
					hex4Num[1] = input1[1];
					hex4Num[2] = input1[2];
					hex4Num[3] = input1[3];
					hex4Num[4] = 0;
					hex4Num[5] = 0;
					hex4Num[6] = 0;
					end
				1'b1: begin
					LEDR [7:0] = 0;
					//hex1Num = input2[3] ? 7'b001_0000: 7'b011_1000;
					hex0Num[0] = input2[0];
					hex0Num[1] = input2[1];
					hex0Num[2] = input2[2];
					hex0Num[3] = input2[3];
					hex0Num[4] = 0;
					hex0Num[5] = 1;
					hex0Num[6] = 0;
					end
				endcase
			end
		endcase
	end
endmodule

module inputToHEX(num, sevSeg);
	input  [6:0] num;
	//num[6] checks overflow, num[5] enables twos comp, num[4] chooses sign or digit display, rest of num is input number
	output reg[7:0] sevSeg;
	always @(num) begin
		casex({num[6], num[5], num[4], num[3], num[2], num[1], num[0]})
			7'b1x1_xxxx: sevSeg = 8'b11000000; //0 overflow
			7'b1x0_xxxx: sevSeg = 8'b10001110; //f overflow
			7'b011_1xxx: sevSeg = 8'b10111111; //-
			7'b0x1_0xxx: sevSeg = 8'b11111111; //blank
			7'b010_1000: sevSeg = 8'b10000000; //-8
			7'b010_1001: sevSeg = 8'b11111000; //-7
			7'b010_1010: sevSeg = 8'b10000010; //-6
			7'b010_1011: sevSeg = 8'b10010010; //-5
			7'b010_1100: sevSeg = 8'b10011001; //-4
			7'b010_1101: sevSeg = 8'b10110000; //-3
			7'b010_1110: sevSeg = 8'b10100100; //-2
			7'b010_1111: sevSeg = 8'b11111001; //-1
			7'b0x0_0000: sevSeg = 8'b11000000; // 0
			7'b0x0_0001: sevSeg = 8'b11111001; //+1
			7'b0x0_0010: sevSeg = 8'b10100100; //+2
			7'b0x0_0011: sevSeg = 8'b10110000; //+3
			7'b0x0_0100: sevSeg = 8'b10011001; //+4
			7'b0x0_0101: sevSeg = 8'b10010010; //+5
			7'b0x0_0110: sevSeg = 8'b10000010; //+6
			7'b0x0_0111: sevSeg = 8'b11111000; //+7
			7'b000_1000: sevSeg = 8'b10000000; //+8
			7'b000_1001: sevSeg = 8'b10010000; //+9
			7'b000_1010: sevSeg = 8'b10001000; // A
			7'b000_1011: sevSeg = 8'b10000011; // B
			7'b000_1100: sevSeg = 8'b11000110; // C
			7'b000_1101: sevSeg = 8'b10100001; // d
			7'b000_1110: sevSeg = 8'b10000110; // E
			7'b000_1111: sevSeg = 8'b10001110; // F
		endcase
	end
endmodule

module bitAdder(bit0, bit1, carryIn, carryOut, sumOut, button);
	input       bit0;
	input       bit1;
	input    carryIn;
	input     button;
	output    sumOut;
	output  carryOut;
	wire w0;
	wire w1;
	wire w2;
	wire w3;
	assign w0       = bit1 ^  button;
	assign w1       = w0   ^    bit0;
	assign w2       = w1   & carryIn;
	assign w3       = w0   &    bit0;
	assign sumOut   = w1   ^ carryIn;
	assign carryOut = w2   |      w3;
endmodule
