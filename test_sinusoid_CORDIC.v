`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:17:59 01/24/2014
// Design Name:   Sinusoid_CORDIC
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_sinusoid_CORDIC.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Sinusoid_CORDIC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_oscillator_sinusoid_CORDIC;
	 // Inputs
	 reg sys_clk;
	 wire syn_clk;
	 reg sin_rst;
	 reg sin_ce;
	 reg signed [31:0] phase;
	 
	 // Output
	 wire signed [31:0] wave;

	 reg [31:0] cnt = 0;
	 
	 Synth_clk synth_clk (
    .Sys_clk(sys_clk), 
    .Syn_ce(sin_ce), 
    .Syn_rst(sin_rst), 
    .Syn_clk(syn_clk)
    );

	 // Instantiate the unit Under Test (UUT)
	Sinusoid_CORDIC uut (
    .Sys_clk(sys_clk), 
    .Syn_clk(syn_clk), 
    .Sin_rst(sin_rst), 
    .Sin_ce(sin_ce), 
    .Phase(phase), 
    .Wave(wave)
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
		phase = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		sin_ce = 1;
		sin_rst = 0;
		phase = 'h0000_00B5;
		while (cnt < 1500) begin
			if ($signed(phase > $signed('h00030000))) begin
				phase = -14000;
			end
			else phase = phase + 'h0000_00B4;
			cnt = cnt + 1;
			#200;

		end
		$finish;
    
	end
      
endmodule