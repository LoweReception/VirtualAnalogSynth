`timescale 1ns / 1ps
`default_nettype wire
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:15 11/30/2013 
// Design Name: 
// Module Name:    Slope_Calc 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// DEFINITON
`define REG_WIDTH 		32

module Slope_Calc(
	 // INPUT DECLARATIONS
    input Sys_clk,			// input system clk
	 input Env_ce,		// input active high enable
	 input Env_rst,			// input active high reset
    input [31:0] Rise,	// input delta level
    input [31:0] Run,		// input delta length
	 
	 // OUTPUT DECLARATIONS
    output [31:0] Slope	// output slope -> signed 16Q.16N
    );
		
	 // REGISTER DECLARATIONS
	 reg signed [31:0] dividend_i = 0;
	 reg signed [31:0] divisor_i = 0;
	 reg signed [31:0] quotient_i = 0;
	 reg [31:0] fractional_i = 0;
	 
	 // DIVIDER 32 MODULE CONTROL SIGNAL DECLARATIONS
	 reg nd = 0;					// new data flag
	 reg ce = 0;					// active high clock enable
	 wire rfd, rdy;				// ready for data flag / new data ready flag
	 wire [31:0] q,f;				// connects module to appropriate modualt to 
	 
	 Div32 slope_divider (
	 .clk(Sys_clk), // input clk
	 .ce(ce), // input ce
	 .sclr(Env_rst), // input sclr
	 .nd(nd), // input nd
	 .rdy(rdy), // output rdy
	 .rfd(rfd), // output rfd
	 .dividend(dividend_i), // input [31 : 0] dividend
	 .divisor(divisor_i), // input [31 : 0] divisor
	 .quotient(q), // output [31 : 0] quotient
	 .fractional(f)); // output [31 : 0] fractional
	 
	 always @(posedge Sys_clk) begin
		 if (!Env_ce) ce <= 0;				 // ENABLE BLOCK
		 else if (Env_rst) begin			 // RESET BLOCK
			dividend_i <= 0;
			divisor_i <= 0;
			quotient_i <= 0;
		 end
		 else begin						 		// NOMINAL BLOCK
			 if (nd) begin 				// NEW DATA FLAG RESET
				 nd <= 0;
			 end
			 if (Rise != dividend_i && rfd) begin	 // NEW DIVIDENT DATA CHECK
				 dividend_i <= Rise;
				 nd <= 1;
				 ce <= 1;
			 end
			 if (Run != divisor_i && rfd) begin			 // NEW DIVIOR DATA CHECK
				 divisor_i <= Run;
				 nd <= 1;
				 ce <= 1;
			 end	
			 if (rdy) begin			 // NEW OUTPUT DATA CHECK	
				 quotient_i <= q;
				 fractional_i <= f;
				 ce <= 0;
			 end
		 end								// END NOMINAL BLOCK
	 end									// END ALWAYS BLOCK
	 
	 // WIRE ASSIGNMENTS
	 assign Slope = quotient_i;
endmodule
