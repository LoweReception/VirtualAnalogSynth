`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:19:10 02/21/2014
// Design Name:   Envelope
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_envelope.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Envelope
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_envelope;

	// Inputs
	reg sys_clk;
	reg env_ce;
	reg env_rst;
	reg key_trigger;
	reg [31:0] a_lvl;
	reg [31:0] d_lvl;
	reg [31:0] s_lvl;
	reg [31:0] a_len;
	reg [31:0] d_len;
	reg [31:0] r_len;

	// Outputs
	wire [15:0] envelope_level;
	
	// WIRE DECLARATIONS
	wire syn_clk;
	
	 Synth_clk synth_clk (
    .Sys_clk(sys_clk), 
    .Syn_ce(env_ce), 
    .Syn_rst(env_rst), 
    .Syn_clk(syn_clk)
    );

	// Instantiate the Unit Under Test (UUT)
Envelope uut (
    .Sys_clk(sys_clk), 
    .Syn_clk(syn_clk), 
    .Env_rst(env_rst), 
    .Env_ce(env_ce), 
    .Syn_key(key_trigger), 
    .A_lvl(a_lvl), 
    .D_lvl(d_lvl), 
    .S_lvl(s_lvl), 
    .A_len(a_len), 
    .D_len(d_len), 
    .R_len(r_len), 
    .Env_lvl(envelope_level)
    );
	
	initial begin
	   sys_clk <= 0;
		#100;
		forever #5 sys_clk <= ~sys_clk;
	end

	initial begin
		// Initialize Inputs
		env_ce = 0;
		env_rst = 0;
		key_trigger = 0;
		a_lvl = 0;
		d_lvl = 0;
		s_lvl = 0;
		a_len = 0;
		d_len = 0;
		r_len = 0;

		// Wait 100 ns for global reset to finish
		#100;
       
		// Add stimulus here
		env_ce = 1;
		a_lvl = 0;
		d_lvl = 16383;
		s_lvl = 5000;
		
		a_len = 30;
		d_len = 30;
		r_len = 30;
		
		#200;
		key_trigger = 1;
		
		#30000;
				key_trigger = 0;
		#1000;		

		$finish;

	end
      
endmodule