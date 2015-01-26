`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:04:18 03/10/2014
// Design Name:   synth
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_synthesizer.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: synth
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_synthesizer;

	// Inputs
	reg sys_clk;
	reg syn_ce;
	reg syn_rst;
	reg key_trigger;
	reg [31:0] frequency;
	reg [31:0] a_lev;
	reg [31:0] d_lev;
	reg [31:0] s_lev;
	reg [31:0] a_len;
	reg [31:0] d_len;
	reg [31:0] r_len;

	// Outputs
	wire syn_clk;
	wire [31:0] env;
	wire [31:0] osc;
	wire [31:0] amp;
	wire [31:0] pcm_l;
	wire [31:0] pcm_r;

	// Instantiate the Unit Under Test (UUT)
	 synthesizer uut (
    .Sys_clk(sys_clk), 
    .Syn_clk(syn_clk), 
    .Syn_ce(syn_ce), 
    .Syn_rst(syn_rst), 
    .Syn_key(key_trigger), 
    .Freq(frequency), 
    .A_lvl(a_lev), 
    .D_lvl(d_lev), 
    .S_lvl(s_lev), 
    .A_len(a_len), 
    .D_len(d_len), 
    .R_len(r_len), 
    .Env(env), 
    .Osc(osc), 
    .Amp(amp), 
    .PCM_L(pcm_l), 
    .PCM_R(pcm_r)
    );
	
	initial begin
	   sys_clk <= 0;
		#100;
		forever #5 sys_clk <= ~sys_clk;
	end

	initial begin
		// Initialize Inputs
		syn_ce = 0;
		syn_rst = 0;
		key_trigger = 0;
		frequency = 0;
		a_lev = 0;
		d_lev = 0;
		s_lev = 0;
		a_len = 0;
		d_len = 0;
		r_len = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		syn_ce = 1;
		frequency = 10000;
		a_lev = 500;
		d_lev = 30000;
		s_lev = 10000;
		a_len = 5000;
		d_len = 5000;
		r_len = 5000;
		#100;
		
		key_trigger = 1;
		 #1000000;
		 $finish;
		

	end
      
endmodule