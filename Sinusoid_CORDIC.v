`timescale 1ns / 1ps
`default_nettype wire
///////////////////////////////////////////////////////////////////////////////
// Company: Shippensburg University, Computer Science Department
// Engineer: Joshua Lowe, Class of 2014
// 
// Create Date:    21:38:50 10/21/2013 
// Design Name: 
// Module Name:    Sine_CORDIC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:	 coreIP CORDIC wrapper for sinusoid wave generation	 
//					
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
//				2.00 - introduction of registers
// Additional Comments: 
//    CORDIC module performs the sin() caluculation	
//		Domain (phase): [-pi,pi]
//		Range (wave):  [-1,1]
//		
///////////////////////////////////////////////////////////////////////////////
module Sinusoid_CORDIC(
	 // CONTROL SIGNALS
    input 	Sys_clk,					// input system clk
	 input	Syn_clk,					// input synth clk
	 input 	Sin_rst,					// input active high reset
	 input 	Sin_ce,					// input update clk
	 
	 // DATA REGISTERS
    input 	signed [31:0] Phase,			// input phase	16Q.16N in radians
    output 	signed [31:0] Wave	// output value of the wave 16Q.16N
    );	
    
	 // REGISTER DECLARATIONS
	 reg signed [18:0] phase_i = 0;	
	 // reg signed [17:0] cordic_i = 0;
	 reg signed [17:0] wave_i = 0;
	 
	 // WIRE DECLARATIONS
	 wire signed [18:0] phase_in;
	 wire signed [17:0] cordic_out;		// output of the CORDIC	 
    
	 // CORDIC CONTROL SIGNALS
	 reg nd = 0;								// new data indicator
	 wire rdy;									// new output data ready flag	 
	  
	 // CoreIP CORDIC v4.0
	 CORDIC cordic(
	 .phase_in(phase_in), // input [18 : 0] phase_in
	 .nd(nd), 					// input nd
	 .x_out(), 					// output [17 : 0] x_out
	 .y_out(cordic_out), 	// output [17 : 0] y_out
	 .rdy(rdy), 				// output rdy
	 .clk(Sys_clk), 			// input clk
	 .ce(Sin_ce), 				// input ce
	 .sclr(Sin_rst) 			// input sclr
	 );
	
	 always @(posedge Sys_clk) begin				// update logic
		 if (!Sin_ce)	begin							// enable logic
			phase_i <= phase_i;
			// cordic_i <= cordic_i;
			wave_i <= wave_i;
		 end												// end enable
		 else if (Sin_rst) begin					// reset logic
			 nd <= 0;
			 phase_i <= 0;
			 // cordic_i <= 0;
			 wave_i <= 0;
		 end 												// end reset
		 else begin										// nominal logic			 
			 if (Phase [18:0] != phase_i) begin	// new input data check
				 phase_i <= Phase [18:0];
				 nd <= 1;
			 end								// end input check
			 else if (rdy) begin 							// new output data check 
				 wave_i <= cordic_out;
			 end											// end output chekc
			 else	if (nd) nd <= ~nd;				// nd flag reset 
		 end											// end nominal
	 end												// end update
	 
	 assign phase_in = phase_i;
	 assign Wave = $signed(wave_i);
	 
endmodule
