`include "FILENAME"
`timescale 1 ns / 100 ps
module tb();
//Declaring Test wires and regs.
  wire		     [9:0]		HEX0;
	wire		     [7:0]		HEX1;
	wire		     [7:0]		HEX2;
	wire		     [7:0]		HEX3;
	wire		     [7:0]		HEX4;
	wire		     [7:0]		HEX5;
  wire		     [9:0]		LEDR;
  reg 		     [9:0]		SW;
  reg 		     [1:0]		KEY;
  FILENAME U1 (
  //Passing vectors to file.   
   .HEX0(HEX0),
   .HEX1(HEX1),
   .HEX2(HEX2),
   .HEX3(HEX3),
   .HEX4(HEX4),
   .HEX5(HEX5),
   .LEDR(LEDR),
   .SW(SW),
   .KEY(KEY)
    );

	initial
	  begin
		$dumpfile("output.vcd");
		$dumpvars;
		$display("Starting simulation");

    //////////////////////////////Design Block 1//////////////////////////////
    //Switch Modes
    SW[9:8] = 2’b00

    //Flipping LEDs
    SW[7:0]= 8'b11010011;
    #10 KEY[0] = 1'b0;
    #10 KEY[0] = 1'b1;
    //Birthday
    #10 KEY[1] = 1'b0;
    #10 KEY[1] = 1'b1;

    //////////////////////////////Design Block 2//////////////////////////////
    //Switch Modes
    SW[9:8] = 2’b01

    //2+2
    #10 SW[7:0] = 8'b00100010

    //Subtraction
    #10 KEY[0] = 1'b0

    //////////////////////////////Design Block 3//////////////////////////////
    //Switch Modes
    SW[9:8] = 2’b10

    //Declare Values
    #10 SW[7:0] = 8'b11000111
    #10 SW[7:0] = 8'01001000


    //Switch Modes
    SW[9:8] = 2’b11
    
    //Declare Values
    #10 SW[7:0] = 8'b11000111
    #10 SW[7:0] = 8'01001000

	  #10	$display("Simulation ended.");
		$finish;
	  end
endmodule
