`timescale 1ns / 1ps
`default_nettype wire
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Shippensburg University
// Engineer: 		Joshua Lowe, Class 2014
// 
// Create Date:    01:22:30 10/21/2013 
// Design Name: 	 
// Module Name:    Oscillator_clock 
// Project Name: 	 AC97SYNTH
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
//				2.01 - NCC1701D
// Additional Comments: 
//			The oscillator clock is used in the calculation of the output wave.
//			Calculation
//					system_clk					te			100Mhz
//					----------					->	-------------- -> 		100
//		how often do we ask the quesiton?		   1MHz
//
//////////////////////////////////////////////////////////////////////////////////
`define PERIOD 				100
`define PULSE_WIDTH			50

module Synth_clk(
    input Sys_clk,				// input system clk
	 input Syn_ce,					// input active high synth enable
	 input Syn_rst,				// input active high reset
    output Syn_clk				// output synthesizer update clock
    );
	 
	 reg state = 0;				// state clock
	 reg [7:0] cnt = 0;			// counter
	 
	 always @(posedge Sys_clk) begin		// state logic	
		 if (! Syn_ce) begin					// enable logic
			state <= state;
			cnt <= cnt;
		 end
		 else if (Syn_rst) begin			//	reset logic
			 state <= 0;			
			 cnt <= 0;
		 end
		 else begin								// nominal logic
			 if (cnt < `PULSE_WIDTH - 1) begin
			 	cnt <= cnt + 1;
			 end
			 else begin							// state switch logic
				state <= ~state;
				cnt <= 0;
			 end 									// end state switch
		 end 										// end nomial
	 end											// end state
	 
	 assign Syn_clk = state;
endmodule