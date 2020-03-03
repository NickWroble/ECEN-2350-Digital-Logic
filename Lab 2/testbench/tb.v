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
	Lab2 U1(
	//Passing vectors to file.   
	.ADC_CLK_10(CLK),
	.SW(SW),
	.LEDR(LEDR),
	.KEY(KEY),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.HEX4(HEX4),
	.HEX5(HEX5));

	initial
	begin
		$dumpfile("output.vcd");
		$dumpvars;
		$display("Starting simulation");
		#0 CLK = 0;
		#0 KEY[0] = 1;
		#0 KEY[1] = 1;
		#0  SW[9] = 0;
		#10_000 $display("Simulation ended.");
	end
	initial begin
		#10		KEY[0] = 0; //start clk

		#2_500 KEY[0] = 1;
		#10    KEY[0] = 0; //reset clk and regs

		#500	KEY[0] = 1;
		#500	KEY[0] = 0; //restart clk

		#100	KEY[1] = 0; //enable 5 HZ
		#1_000  SW[9]  = 1; //enable leap year
	end
	always #1 CLK = ~CLK;
	initial  #10_000 $finish;
endmodule
