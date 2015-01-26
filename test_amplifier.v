`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:32:11 02/23/2014
// Design Name:   Amplifier
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_amplifier.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Amplifier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_amplifier;

	// Inputs
	reg sys_clk;
	reg amp_ce;
	reg amp_rst;
	reg [31:0] envelope;
	reg [31:0] oscillator;

	// Outputs
	wire [31:0] amp_out;

	// Instantiate the Unit Under Test (UUT)
	Amplifier instance_name (
    .Sys_clk(sys_clk), 
    .Amp_ce(amp_ce), 
    .Amp_rst(amp_rst), 
    .Amplitude(envelope), 
    .Oscillator(oscillator), 
    .Amp_out(amp_out)
    );
	 
	 initial begin
	   sys_clk <= 0;
		#100;
		forever #5 sys_clk <= ~sys_clk;
	end

	initial begin
		// Initialize Inputs
		amp_ce = 0;
		amp_rst = 0;
		envelope = 0;
		oscillator = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add steimulus here
		amp_ce <= 1;
		envelope = 'h0000_7FFF;
		oscillator = 'h0000_8000;
		
		#200;
	end
      
endmodule