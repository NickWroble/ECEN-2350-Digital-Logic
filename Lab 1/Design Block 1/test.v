`timescale 1 ns / 100 ps
module tb();

  reg [9:0]SW, [9:0]LEDR, [1:0]KEY, [7:0]HEX0, [7:0]HEX1, [7:0]HEX2, [7:0]HEX3,[7:0]HEX4, [7:0]HEX, ;
  wire c;

  top DesignBlock1(.SW(SW), .LEDR(LEDR), KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	initial
	  begin
		$dumpfile("output.vcd");
		$dumpvars;
		$display("Starting simulation");
               a = 0;
		     b = 0;
         #10   a = 1;
         #10   b = 1;
	    #10   a = 0;
	    #10	$display("Simulation ended.");
			$finish;
	  end

  initial
    begin
      $monitor($time, "  a = %b,  b = %b,  c = %b", a, b, c);
    end
endmodule
