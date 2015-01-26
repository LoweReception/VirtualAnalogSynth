`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:53:31 02/10/2014
// Design Name:   Oscillator
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_oscillator.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Oscillator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_oscillator;

	// Inputs
	reg sys_clk;
	reg osc_ce;
	reg osc_rst;
	reg [31:0] frequency;
	reg [7:0] counter = 0;
	reg signed [31:0] last_reg = 0;

	// Outputs
	wire syn_clk;
	wire signed [31:0] wave;
	
	 Synth_clk synth_clk (
    .Sys_clk(sys_clk), 
    .Syn_ce(osc_ce), 
    .Syn_rst(osc_rst), 
    .Syn_clk(syn_clk)
    );

	// Instantiate the Unit Under Test (UUT)
	Oscillator uut (
    .Sys_clk(sys_clk), 
    .Syn_clk(syn_clk), 
    .Osc_rst(osc_rst), 
    .Osc_ce(osc_ce), 
    .Freq(frequency), 
    .Waveform(wave)
    );
	
	initial begin
	   sys_clk <= 0;
		#100;
		forever #5 sys_clk <= ~sys_clk;
	end

	initial begin
		// Initialize Inputs
		osc_ce = 0;
		osc_rst = 0;
		frequency = 0;

		// Wait 100 ns for global reset to finish
		#100;
      osc_ce = 1;
		osc_rst = 1;
		#100;
		
		// Add stimulus here
		osc_rst = 0;
		frequency = 1000;
	
		#100000000;
	
		$finish;
	end
	
	always @(wave) begin 
			if (last_reg < 0 && wave > 0) begin
				counter <= counter + 1;
				frequency <= frequency + 100;
				last_reg <= wave;
			end
			else begin
				last_reg <= wave;
		   end
	end
	
endmodule

