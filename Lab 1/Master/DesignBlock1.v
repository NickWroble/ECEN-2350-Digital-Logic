module DesignBlock1(SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [7:0] SW;
	input [0:0] KEY;
	output [7:0] LEDR;
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [7:0] HEX2;
	output [7:0] HEX3;
	output [7:0] HEX4;
	output [7:0] HEX5;
	assign LEDR = KEY[0] ? SW: ~SW;
	assign HEX0 [7:0] = 8'b1100_0000; //0
	assign HEX1 [7:0] = 8'b1100_0000; //0
	assign HEX2 [7:0] = KEY[0] ? 8'b0001_0010 : 8'b0000_0000; //5 or 8
	assign HEX3 [7:0] = KEY[0] ? 8'b1100_0000 : 8'b1111_1001; //0 or 1
	assign HEX4 [7:0] = KEY[0] ? 8'b0001_1001 : 8'b0011_0000; //3 or 4
	assign HEX5 [7:0] = 8'b1100_0000; //0
endmodule   

//march 18th 2000
//03/18/00
//04/05/00