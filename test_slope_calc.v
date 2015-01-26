`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:23:50 02/12/2014
// Design Name:   Slope_Calc
// Module Name:   /home/riker/Xilinx/AC97SYNTH/AC97SYNTH/test_slope_calc.v
// Project Name:  AC97SYNTH
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Slope_Calc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_envelope_slope_calc;

	// Inputs
	reg sys_clk;
	reg env_ce;
	reg env_rst;
	reg [31:0] rise;
	reg [31:0] run;

	// Outputs
	wire [31:0] slope;

	// Instantiate the Unit Under Test (UUT)
	Slope_Calc uut (
		.Sys_clk(sys_clk), 
		.Env_ce(env_ce), 
		.Env_rst(env_rst), 
		.Rise(rise), 
		.Run(run), 
		.Slope(slope)
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
		rise = 0;
		run = 0;

		// Wait 100 ns for global reset to finish
		#100;
		env_ce = 1;
        
		// Add stimulus here
		env_rst = 1;
		rise =  'h7FFF_0000;
		run = 'h0000_03E8;
		
		#1000;
		
		env_rst = 0;
		
		#1000;
		
		run = 'h0000_07D0;
		
		#1000;
		
		env_rst = 1;
		
		#1000;
		
		env_rst = 0;
		
		#1000;

		env_ce = 0;
		
		#1000;
		
		env_rst = 1;
		
		#1000;
		
		env_ce = 1;
		
		#1000;
		
		env_ce = 0;
		env_rst = 0;
		$finish;


	end
      
endmodule

