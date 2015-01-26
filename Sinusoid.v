`timescale 1ns / 1ps
`default_nettype wire
//////////////////////////////////////////////////////////////////////////////////
// Company: Shippensburg University, Computer Science Department
// Engineer: Joshua Lowe, Class of 2014
// 
// Create Date:    21:21:17 10/21/2013 
// Design Name: 	
// Module Name:    Sine_Gen 
// Project Name: 	 Synth
// Target Devices: Virtex-5
// Tool versions: 
// Description: 	 Generates a sinusoid wave
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 
// SYSTEM_SPEED			100 000 000		// define sysem clock
// OSC_CLK_RATE			  1 000 000		// defines the rate wave calculation
//
///////////////////////////////////////////////////////////////////////////////
`define PI_						'h0003_243E		// 3.141592 in signed 16Q.16N
`define PI2 					'h0006_487E		// 6.283185 in signed 16Q.16N

module Sinusoid(
	 // CONTROL SIGNALS 
    input 	Sys_clk,					// input system clk
	 input 	Syn_clk,					// input internal oscillator clk
	 input 	Sin_rst,					// input active high reset
	 input 	Sin_ce,					// input active high enable flag 
	 // DATA SIGNALS
    input 	[31:0] Freq,			// frequency of desired sinusoid wave
    output 	[31:0] Sine_wave		// sine waveform of frequency @ 1mhz update
    );
    
	 // WIRE DECLARATIONS
	 wire signed [31:0] CORDIC_2_wave;		// connects the wave output to its register
	 wire signed [31:0] phase_increment;	// 2 * pi * frequency / osc_clk_rate
	 
	 // REGISTER DECLARATIONS
	 reg signed [31:0] phase_i = 32'b0;				// sin(phase) = wave
	 reg signed [31:0] wave_i = 32'b0;			// intermediate to hold wave
	 
	 // Generates the value of the phase increment
	 Sinusoid_Increment sinusoid_increment (
    .Sys_clk(Sys_clk), 
    .Sin_rst(Sin_rst), 
    .Sin_ce(Sin_ce), 
    .Freq(Freq), 
    .Sin_inc(phase_increment)
    );			
	 
	 Sinusoid_CORDIC sinusoid_CORDIC (
    .Sys_clk(Sys_clk), 
	 .Syn_clk(Syn_clk),
    .Sin_rst(Sin_rst), 
    .Sin_ce(Sin_ce),
    .Phase(phase_i), 
    .Wave(CORDIC_2_wave)
    );
	 
	 always @ (posedge Syn_clk) begin 		// internal update arithmatic	
		 if (!Sin_ce) wave_i <= wave_i;		// ENABLE CHECK
		 else if (Sin_rst) begin					// RESET CHECK
			wave_i <= 32'b0;
			phase_i <= 32'b0;
		 end
		 else begin							 		// NOMINAL
			 wave_i <= CORDIC_2_wave;
			 if (phase_i > $signed(`PI_))					// wave_gen is limited to range:[-PI,PI] 		
				 phase_i <= $signed(phase_i - `PI2);			// if phase>PI wrap around to -PI
			 else 												// else add increment to the phase
				 phase_i <= phase_i + phase_increment;	
		 end 											//END NOMINAL
	 end 												// END BLOCK
	 
	 assign Sine_wave = wave_i;
endmodule