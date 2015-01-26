`timescale 1ns / 1ps
`default_nettype wire 
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 Shippensburg University
// Engineer: 		 Joshua Lowe
// 
// Create Date:    19:52:26 10/21/2013 
// Design Name: 
// Module Name:    Phase_Increment_Calc 
// Project Name: 	 AC97SYNTH
// Target Devices: 
// Tool versions: 
// Description:	 Generates the a phase increment amount for the oscillator for
// 					 the specified frequency at a 1MHz update.
//						 The phase increment only changes when the frequency changes
//						 as the other variables stay constant
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
//				1.50 - Crypt_keeper
//	 3/10/14	1.60 - Crypt_keeper_scares
// 
// Additional Comments: 
//				essentially completes the following equation
//				( frequency x 2 x pi) / 1000000000 
//////////////////////////////////////////////////////////////////////////////////
// PIx2 describes 2(pi) in 16Q.16N format
`define	PIx2					'h006_487E
// OSC_CLK_RATE describes the 1MHz update clock provided by the synth update clk
`define 	SYN_CLK_RATE 		'd1000000

module Sinusoid_Increment(
	 // CONTROL SIGNALS	
    input 		Sys_clk,						// input system clock
	 input 		Sin_rst,						// input active high reset
	 input 		Sin_ce,						// input active high enable
	 
	 //DATA SIGNALS
    input 		[31:0] Freq,				// input frequency
    output 		[31:0] Sin_inc				// output phase increment 16Q.16N
    );
	 
	 // REGISTER DECLARATIONS
	 reg [31:0] frequency_i = 0;			// holds the value of the frequency
	 reg [63:0] increment_i = 0;			// output of the div32 module
	 
	 // MULTI32 declarations
	 // wire [31:0] a;							// constant assignment of freq in 16Q.16N
	 wire [63:0] p;							// product of the multiplication
	 reg [63:0] p_reg = 0;					// holds p on new output
	 
	 // DIV32 declarations
	 reg nd = 0;								// input active high new data flag
	 reg ce = 0;								// input active high clock enable
	 wire rdy;									// ouput data ready flag
	 wire rfd;									// output ready for data flag
	 wire [31:0] dividend;					// holds upper 32 bits of p for div32
	 wire [31:0] divisor;
	 wire signed [31:0] quotient;			// quotient portion of div32 output
	 wire [31:0] fractional;				// fractional portion of div32 output
    
	 // MODULE DECLARATIONS
	 // 32 BIT INPUT A X 32 BIT INPUT B = 64 BIT OUTPUT P 
	 //		16Q.16N	 X		16Q.16N		=		32Q.32N
	 Mul32 increment_multiplier (
	 .clk(Sys_clk), // input clk
	 .a(frequency_i), // input [31 : 0] a
	 .b(`PIx2), // input [31 : 0] b
	 .ce(Sin_ce), // input ce
	 .sclr(Sin_rst), // input sclr
	 .p(p) // output [63 : 0] p
	 );
		
	 // 32 BIT INPUT DIVIDEND / 32 BIT INPUT DIVISOR =
	 // 			32 BIT QUOTIENT . 32 BIT FRACTIONAL
	 Div32 increment_divider (
	.clk(Sys_clk), // input clk
	.ce(Sin_ce), // input ce
	.sclr(Sin_rst), // input sclr
	.nd(nd), // input nd
	.rdy(rdy), // output rdy
	.rfd(rfd), // output rfd
	.dividend(dividend), // input [31 : 0] dividend
	.divisor(divisor), // input [31 : 0] divisor
	.quotient(quotient), // output [31 : 0] quotient
	.fractional(fractional)); // output [31 : 0] fractional8

	 always @(posedge Sys_clk) begin
		 if (!Sin_ce) begin						// ENABLE CHECK
			 increment_i <= increment_i;
			 ce <= 0;
		 end											// END
		 else if (Sin_rst) begin				// RESET CHECK
			 frequency_i <= 0;
			 increment_i <= 0;
			 p_reg <= 0;
			 ce <= 0;
		 end											// END
		 else begin									// NOMINAL
			 if (rdy) begin			 			// DATA READY CHECK 
				 increment_i <= {quotient[15:0],fractional[31:16]};
				 ce <= 0;
			 end										// END
			 // FREQUENCY CHANGE CHECK
			 if (Freq != frequency_i [31:16]) begin
				 frequency_i <= Freq <<< 16;
			 end										// END
			 if (p != p_reg) begin	 			// MULTI32 OUTPUT CHANGE			
				 if (rfd) begin					
					 p_reg <= p;
					 ce <= 1;
					 nd <= 1;
				 end									// END RFD
			 end										// END OUTPUT CAHNGE
			 else if (nd) nd <=0;				// NEW DATA FLAG CHECK
		 end 											// END NOMINAL
	 end 												// END BLOCK
	 
	 // WIRE ASSIGNMENTS
	 // assign a = frequency_i;				// shifted frequency value
	 assign dividend = p_reg[47:16];					// integer portion of p
	 assign divisor = `SYN_CLK_RATE;
	 assign Sin_inc = increment_i[47:16];
	 
endmodule
