`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:27:28 01/23/2014
// Design Name:   Oscillator_clock
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_oscillator_clock.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Oscillator_clock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_oscillator_clock;

	// Inputs
	reg sys_clk;
	reg reset;
	reg osc_enable;

	// Outputs
	wire osc_clk;

	// Instantiate the Unit Under Test (UUT)
	Oscillator_clock uut (
		.sys_clk(sys_clk),
		.osc_enable(osc_enable),
		.reset(reset), 
		.osc_clk(osc_clk)
	);
	
	initial begin
		sys_clk <= 0;
		#100;
		forever #5 sys_clk <= ~sys_clk;
	end

	initial begin
		reset <= 0;
		osc_enable <= 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		osc_enable <= 1;
		
		#2000;
		
		reset <= 1;
		
		#2500;
		
		osc_enable <= 0;
		
		#500;
		
		reset <= 0;
		
		#500;
		
		osc_enable <= 0;
		
		#500;
		
		osc_enable <= 1;
		$finish;
	end
      
endmodule