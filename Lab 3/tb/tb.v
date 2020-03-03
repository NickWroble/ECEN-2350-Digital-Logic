`timescale 1 us / 100 ns

module tb();
//Declaring Test wires and regs.
	wire		    [7:0]		HEX0;
	wire		    [7:0]		HEX1;
	wire		    [7:0]		HEX2;
	wire		    [7:0]		HEX3;
	wire		    [7:0]		HEX4;
	wire		    [7:0]		HEX5;
	wire		    [9:0]		LEDR;
	reg 						 CLK;
	reg 		    [1:0]		 KEY;
	reg				[9:0]		  SW;
	Lab3 U1(
	//Passing vectors to file.   
	.ADC_CLK_10(CLK),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.HEX4(HEX4),
	.HEX5(HEX5),
	.KEY(KEY),
	.LEDR(LEDR),
	.SW(SW));

	initial
	begin
		$dumpfile("output.vcd");
		$dumpvars;
		$display("Starting simulation");
		#0 CLK     = 0;
		#0 KEY[0]  = 1;
		#0 KEY[1]  = 1;
		#0 SW[9:0] = 0;
		#10_000 $display("Simulation ended.");
	end
	initial begin
		#500    SW[0] = 1;
		#1_500  SW[1] = 1;
		#500    SW[0]  = 0;
		#2_000 KEY[1] = 0;
		#2_000 KEY[0] = 0;
	end
	always #1 CLK = ~CLK;
	initial  #10_000 $finish;
endmodule
