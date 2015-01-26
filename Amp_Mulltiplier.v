`timescale 1ns / 1ps
`default_nettype wire
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:44 10/22/2013 
// Design Name: 
// Module Name:    Amp_Mulltiplier 
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
module Amp_Multiplier(
    input Sys_clk,					// input sys clk
	 input Amp_ce,
	 input Amp_rst,
	 input [31:0] Amplitude,			
    input [31:0] Oscillator,
    output wire [63:0] Value
    );	 
	 
	 Mul32 amplifier_multiplier (
	 .clk(Sys_clk), // input clk
	 .a(Amplitude), // input [31 : 0] a
	 .b(Oscillator), // input [31 : 0] b
	 .ce(Amp_ce), // input ce
	 .sclr(Amp_rst), // input sclr
	 .p(Value) // output [63 : 0] p
	 );

endmodule
