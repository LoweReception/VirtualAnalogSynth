`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:45:24 01/23/2014
// Design Name:   Sinusoid_Increment
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_sinusoid_increment.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Sinusoid_Increment
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_oscillator_sinusoid_increment;

	// Inputs
	reg sys_clk;
	reg [31:0] frequency;
	reg sin_ce;
	reg sin_rst;
	
	// Outputs
	wire [31:0] increment;
	
	// Instantiate the Unit Under Test (UUT)
	 Sinusoid_Increment uut (
    .Sys_clk(sys_clk),
	 .Sin_rst(sin_rst),
	 .Sin_ce(sin_ce),
    .Freq(frequency), 
    .Sin_inc(increment)
    );
	
	initial begin
		sys_clk <= 0;
		#100;
		forever #5 sys_clk <= ~sys_clk;
	end

	initial begin
		// Initialize Inputs
		sin_ce = 0;
		sin_rst = 0;
		frequency = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		sin_ce = 1;
		frequency = 440;
			
		#1000;
		frequency = 880;
		#1000;
		frequency = 1000;
		#100;
		$finish;
	end
      
endmodule