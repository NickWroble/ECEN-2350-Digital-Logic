module DesignBlock3(LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  [9:0]   SW;
	output reg [9:0] LEDR;
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [7:0] HEX2;
	output [7:0] HEX3;
	output [7:0] HEX4;
	output [7:0] HEX5;
	assign HEX2 = 8'b11111111;
	assign HEX3 = 8'b11111111;
	reg [3:0] input1;
	reg [3:0] input2;

	always @(SW[9:8]) begin
		case({SW[9], SW[8]})
			2'b10: begin //unsigned
				input1 = SW[7:4];
				input2 = SW[3:0];
			end
			2'b11: begin //twos complemenet
				input1 = -2**3 + SW[6:4];
				input2 = -2**3 + SW[2:0];
			end
		endcase
		if(input1[3:0] == input2[3:0]) begin
			LEDR[2] = 1'b1;
			LEDR[1] = 1'b0;
			LEDR[0] = 1'b0;
		end
		else if(SW[3:0] > SW[7:4]) begin
			LEDR[2] = 1'b0;
			LEDR[1] = 1'b1;
			LEDR[0] = 1'b0;
		end
		else begin
			LEDR[2] = 1'b0;
			LEDR[1] = 1'b0;
			LEDR[0] = 1'b1;
		end	
	end


	inputToHEX input1Convert(.bits(SW [7:4]), .HEXSign(HEX5), .HEXDigit(HEX4), .checkOverflow(logic_zero));
	inputToHEX input2Convert(.bits(SW [3:0]), .HEXSign(HEX1), .HEXDigit(HEX0), .checkOverflow(logic_zero));
endmodule

module inputToHEX(num, HEXSign, HEXDigit, checkOverflow);
	input  integer         num;
	output [7:0]       HEXSign;
	output [7:0]      HEXDigit;
	input  [0:0] checkOverflow;
	assign HEXSign  =  binSign;
	assign HEXDigit = binDigit;
	reg [7:0]  binSign;
	reg [7:0] binDigit;
	always @(bits[3], checkOverflow[0]) begin
		casex({checkOverflow, bits[3]})
			2'b1x: binSign = 8'b11000000; //0
			2'b01: binSign = 8'b10111111; //-
			2'b00: binSign = 8'b11111111; //blank
		endcase
	end
	always @(bits, checkOverflow[0]) begin
		 casex({checkOverflow[0], bits[3] , bits[2], bits[1], bits[0]})
	 		 5'b01000: binDigit = 8'b10000000; //-8
			 5'b01001: binDigit = 8'b11111000; //-7
			 5'b01010: binDigit = 8'b10000010; //-6
			 5'b01011: binDigit = 8'b10010010; //-5
			 5'b01100: binDigit = 8'b10011001; //-4
			 5'b01101: binDigit = 8'b10110000; //-3
			 5'b01110: binDigit = 8'b10100100; //-2
			 5'b01111: binDigit = 8'b11111001; //-1
			 5'b00000: binDigit = 8'b11000000; // 0
			 5'b00001: binDigit = 8'b11111001; // 1
			 5'b00010: binDigit = 8'b10100100; // 2
			 5'b00011: binDigit = 8'b10110000; // 3
			 5'b00100: binDigit = 8'b10011001; // 4
			 5'b00101: binDigit = 8'b10010010; // 5
			 5'b00110: binDigit = 8'b10000010; // 6
			 5'b00111: binDigit = 8'b11111000; // 7
			 5'b1xxxx: binDigit = 8'b10001110; // 8
		endcase
	end
endmodule