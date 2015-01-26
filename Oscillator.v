`timescale 1ns / 1ps
`default_nettype wire 
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Shippensburg University
// Engineer: 		Joshua Lowe, Class 2014
// 
// Create Date:    15:40:37 09/26/2013 
// Design Name: 
// Module Name:    Oscillator 
// Project Name:   Synthesizer
// Target Devices: 
// Tool versions: 
// Description: 
//				generates sine waveform at the specififed frequency.
//				
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
//				1.00 - It's A Working Title.
//				1.01 - The Journey Continues.
//				3.01 - Back to the Future
// Additional Comments:
//		All reset signals used in this block are active low.
// 
//		0	  0    0    3	  2	 4	   3    E
//		0000 0000 0000 0011 0010 0100 0011 1110
//		1111 1111 1111 1100 1101 1011 1100 0001	
//		f	  f    f    c    d    a    c    1
//
// 	PI_ & _PI are used as  range limiters for Sine_Wave
//		`define PIx2 					0006_487E
//		`define PI_						0003_243E		//  3.141592 in signed 16Q.N
//		`define _PI						FFFC_dac1		// -3.141592 in signed 16Q.N
//		`define _PIx2 					FFF9_B782		//  6.28318 in 16Q.N
//		
//		`define SYSTEM_SPEED			100 000 000		// define sysem clock			100 Mhz
//		`define OSC_CLK_RATE			  1 000 000		// defines oscillator clock	  1 Mhz
//
//		An oscillation is drawn waveform
//		in	-> frequency
//		out -> wave in 16Q.16N -> range b/w [-1,1]
//
//////////////////////////////////////////////////////////////////////////////////

module Oscillator(
	 // CONTROL PARAMETERS
    input 	Sys_clk,					// input sys clk
	 input 	Syn_clk,					// output oscillator update clk @ 1Mhz
	 input 	Osc_rst,					// input active high reset signal 
	 input 	Osc_ce,					// input active high osc_enable
	
	 // INPUT PARAMETER
    input 	[31:0] Freq,			// input frequency
		
	 // OUTPUT PARAMETERS 
    output 	[31:0] Waveform		// output waveform
    );
	
	//reg [31:0] waveform_i = 0;
    
	 // SINE WAVE GENERATION MODULE
	 Sinusoid sine (	
    .Sys_clk(Sys_clk),					// input sys clk
	 .Syn_clk(Syn_clk),					// input osc clk
	 .Sin_rst(Osc_rst),					// input enable
    .Sin_ce(Osc_ce), 					// input active low reset
    .Freq(Freq), 							// input [31:0] frequency
    .Sine_wave(Waveform)				// output [31:0] sinusoid waveform 
    );
	 	 
	// always @(posedge Syn_clk)	waveform_i <= Waveform;
	 
endmodule