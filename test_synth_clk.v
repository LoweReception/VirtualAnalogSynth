`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:39:14 04/12/2014
// Design Name:   Update_clock
// Module Name:   S:/Xilinx/synthesizer_v1_00_a/devl/projnav/test_Update_clk.v
// Project Name:  synthesizer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Update_clock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_synth_clk;

	// Inputs
	reg Sys_clk;
	reg Syn_ce;
	reg Syn_rst;

	// Outputs
	wire Syn_clk;

	// Instantiate the Unit Under Test (UUT)
	Synth_clk uut (
		.Sys_clk(Sys_clk), 
		.Syn_ce(Syn_ce), 
		.Syn_rst(Syn_rst), 
		.Syn_clk(Syn_clk)
	);
	
	initial begin
	   Sys_clk <= 0;
		#100;
		forever #5 Sys_clk <= ~Sys_clk;
	end

	initial begin
		// Initialize Inputs
		Syn_ce = 0;
		Syn_rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Syn_ce = 1;
		#5000;
		Syn_rst = 1;
		#2000;
		Syn_rst = 0;
		#2000;
		Syn_ce = 0;
		#5000;
		$finish;
	end
      
endmodule

