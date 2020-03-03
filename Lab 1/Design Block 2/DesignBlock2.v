module DesignBlock2(KEY, LEDR, SW, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input  [7:0]     SW;
	input  [0:0]    KEY;
	output [7:0]   HEX5;
	output [7:0]   HEX4;
	output [7:0]   HEX3;
	output [7:0]   HEX2;
	output [7:0]   HEX1;
	output [7:0]   HEX0;
	output [7:0]   LEDR;
	wire   [3:0] input1;
	wire   [3:0] input2;
	wire   [4:0]  carry;
	wire   [4:0]    sum;
	assign LEDR  [7:0] =               0;
	assign carry [0]   =         ~KEY[0];
	assign input1[0]   =           SW[4];
	assign input1[1]   =           SW[5];
	assign input1[2]   =           SW[6];
	assign input1[3]   =           SW[7];
	assign input2[0]   = SW[0] ^ ~KEY[0];
	assign input2[1]   = SW[1] ^ ~KEY[0];
	assign input2[2]   = SW[2] ^ ~KEY[0];
	assign input2[3]   = SW[3] ^ ~KEY[0];

	bitAdder bitsZero (input1[0], input2[0], carry[0],  carry[1], sum[0]);
	bitAdder bitsOne  (input1[1], input2[1], carry[1],  carry[2], sum[1]);
	bitAdder bitsTwo  (input1[2], input2[2], carry[2],  carry[3], sum[2]);
	bitAdder bitsThree(input1[3], input2[3], carry[3],  carry[4], sum[3]);
	assign sum[4] = ((input1[3] == 0 & input2[3] == 0) & (sum[3] == 1)) | ((input1[3] == 1 & input2[3] == 1) & sum[3] == 0);

	inputToHEX input1Convert(.bits(SW [7:4]), .HEXSign(HEX5), .HEXDigit(HEX4), .checkOverflow(logic_zero));
	inputToHEX input2Convert(.bits(SW [3:0]), .HEXSign(HEX3), .HEXDigit(HEX2), .checkOverflow(blanks));
	inputToHEX sumConvert   (.bits(sum[3:0]), .HEXSign(HEX1), .HEXDigit(HEX0), .checkOverflow(sum[4]));
endmodule

module bitAdder(bit0, bit1, carryIn, carryOut, sumOut);
	input       bit0;
	input       bit1;
	input    carryIn;
	output    sumOut;
	output  carryOut;
	wire w0;
	wire w1;
	wire w2;
	assign w0       = bit0 ^    bit1;
	assign w1       = w0   & carryIn;
	assign w2       = bit0 &    bit1;
	assign sumOut   = w0   ^ carryIn;
	assign carryOut = w1   |      w2;
endmodule

module inputToHEX(bits, HEXSign, HEXDigit, checkOverflow);
	input  [3:0]          bits;
	output [7:0]       HEXSign;
	output [7:0]      HEXDigit;
	input  [0:0] checkOverflow;
	assign HEXSign  =  binSign;
	assign HEXDigit = binDigit;
	reg [7:0]  binSign;
	reg [7:0] binDigit;
	always @(bits[3], checkOverflow[0]) begin
		casex({checkOverflow, bits[3]})
			2'b1x: binSign = 8'b11000000;
			2'b01: binSign = 8'b10111111;
			2'b00: binSign = 8'b11111111;
		endcase
	end
	always @(bits, checkOverflow[0]) begin
		 casex({checkOverflow[0], bits[3] , bits[2], bits[1], bits[0]})
	 		 5'b01000: binDigit <= 8'b10000000;
			 5'b01001: binDigit <= 8'b11111000;
			 5'b01010: binDigit <= 8'b10000010;
			 5'b01011: binDigit <= 8'b10010010;
			 5'b01100: binDigit <= 8'b10011001;
			 5'b01101: binDigit <= 8'b10110000;
			 5'b01110: binDigit <= 8'b10100100;
			 5'b01111: binDigit <= 8'b11111001; 
			 5'b00000: binDigit <= 8'b11000000;
			 5'b00001: binDigit <= 8'b11111001;
			 5'b00010: binDigit <= 8'b10100100;
			 5'b00011: binDigit <= 8'b10110000;
			 5'b00100: binDigit <= 8'b10011001;
			 5'b00101: binDigit <= 8'b10010010;
			 5'b00110: binDigit <= 8'b10000010;
			 5'b00111: binDigit <= 8'b11111000;
			 5'b1xxxx: binDigit <= 8'b10001110;
		endcase
	end
endmodule