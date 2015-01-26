`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:37:57 01/24/2014
// Design Name:   Sinusoid
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_sinusoid.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Sinusoid
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_oscillator_sinusoid;

	// Inputs
	reg sys_clk;
	wire osc_clk;
	reg osc_enable;
	reg reset;
	reg [31:0] frequency = 0;

	// Outputs
	wire [31:0] sine_wave;
	
	 Synth_clk synth_clk (
    .Sys_clk(sys_clk), 
    .Syn_ce(osc_enable), 
    .Syn_rst(reset), 
    .Syn_clk(osc_clk)
    );

	// Instantiate the Unit Under Test (UUT)
	Sinusoid uut (
		.Sys_clk(sys_clk), 
		.Syn_clk(osc_clk), 
		.Sin_ce(osc_enable), 
		.Sin_rst(reset), 
		.Freq(frequency), 
		.Sine_wave(sine_wave)
	);
	
	initial begin
		sys_clk <= 0;
		#100;
		forever #5 sys_clk <= ~sys_clk;
	end

	initial begin
		// Initialize Inputs
		osc_enable = 0;
		reset = 0;
		frequency = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		frequency = 1000;
		#100;
		osc_enable = 1;
		reset = 1;
		#100;
		reset = 0;
		#10000;
		$finish;
		

	end
      
endmodule

