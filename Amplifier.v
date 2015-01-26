`timescale 1ns / 1ps
`default_nettype wire
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:35 10/07/2013 
// Design Name: 
// Module Name:    Amplifier 
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
//		envelope input range is [0,MAX_SIGNED_16]
//		oscillator input range is [-1,1]
//
// 
//////////////////////////////////////////////////////////////////////////////////
module Amplifier(
	 input 	Sys_clk,										// input system clk
	 input 	Amp_ce,
	 input 	Amp_rst,									// input active high reset
    input 	[31:0] Amplitude,						// input [15:0] envelope_level 
    input 	[31:0] Oscillator,						// input [31:0] oscillator_in
    output 	[31:0] Amp_out							// VAL_out is PCM 16
    );
  
	// ====== REGISTER DECLARATIONS ===== //
	 reg signed [31:0] amp_shift_i = 0;					// level of the input envelop		
	 reg signed [63:0] amplitude_i = 0;					// output 
	 
	 wire signed [31:0] amplitude_w;
	 wire signed [31:0] oscillator_w;
	 wire signed [63:0] p_out;
	 
	// Multi32x32 performs a 32*32 bit multiplication	
	Amp_Multiplier amp_multiplier (
    .Sys_clk(Sys_clk), 
    .Amp_ce(Amp_ce), 
    .Amp_rst(Amp_rst), 
    .Amplitude(amplitude_w), 
    .Oscillator(oscillator_w), 
    .Value(p_out)
    );

	always @(posedge Sys_clk) begin
		if (!Amp_ce) begin
			 amplitude_i <= amplitude_i;
			 amp_shift_i <= amp_shift_i;
		end
		else if (Amp_rst) begin 
			 amplitude_i <= 0;
			 amp_shift_i <= 0;
		end
		else begin
			amp_shift_i <= Amplitude <<< 16;
			amplitude_i <= p_out; 
		end
	end
	
	assign amplitude_w 	= amp_shift_i;
	assign oscillator_w 	= Oscillator;
	assign Amp_out 		= amplitude_i [63:32];
	
endmodule
