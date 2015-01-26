`timescale 1ns / 1ps
`default_nettype wire
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Shippensburg University
// Engineer: 		Joshua Lowe, Class 2014
// 
// Create Date:    12:31:53 10/23/2013 
// Design Name: 
// Module Name:    Synth 
// Project Name: 	 AC97SYNTH
// Target Devices: 
// Tool versions: 
// Description: 
//					Main unit of Synthesizer proect
//					Uses DSP to create a waveform of frequency f
//					Uses envelope module as an amplidue envelope
//					Amplitude module takes waveform and envelope and creates 2 channels
//						of 20-bit PCM for ac97 (in seperate module)
//
// Dependencies: 
//
// Revision: 
// Revision 1.01 - File Created
//				3.01 - Back To the Future
// Additional Comments: 
//				Naming Conventions:
//  					generics:                           "C_*"
//						level Parameter: 							"*_lvl"
//						timing Parameter:						 	"*_len"
//						clock enable signals:  				 	"*_ce"
//						internal version of output port:  	"*_i"
//   					clock signals:                      "*_clk"
//  					reset signals:                      "rst"
//////////////////////////////////////////////////////////////////////////////////
`define C_REG_WIDTH				 32
`define C_OUT_WIDTH				 32

module synthesizer(
    input 	Sys_clk,					// input system clk
	 output 	Syn_clk,				// 1MHz update clock for synth
	 
	 input 	Syn_ce,				// input active high synth_enable
	 input 	Syn_rst,				// input active high reset
	 input 	Syn_key,			// input button simulates key trigger		
	 
    input 	[`C_REG_WIDTH-1:0] Freq,	// input [31:0] frequency of the wave to be generated
	 
    input	[`C_REG_WIDTH-1:0] A_lvl,		// input [31:0] envelope attack stage start level
	 input 	[`C_REG_WIDTH-1:0] D_lvl,		// input [31:0] envelope delay stage start level
	 input 	[`C_REG_WIDTH-1:0] S_lvl,		// input [31:0] envelope sustain stage level
	 
	 input 	[`C_REG_WIDTH-1:0] A_len,		// input [31:0] envelope attack stage length
	 input 	[`C_REG_WIDTH-1:0] D_len,		// input [31:0] envelope delay stage length
	 input 	[`C_REG_WIDTH-1:0] R_len,		// input [31:0] envelope release stafe length
	 
	 output 	[`C_OUT_WIDTH-1:0] Env,
	 output 	[`C_OUT_WIDTH-1:0] Osc,
	 output 	[`C_OUT_WIDTH-1:0] Amp,

    output 	[`C_OUT_WIDTH-1:0] PCM_L,			// output 16 bit PCM left channel
	 output 	[`C_OUT_WIDTH-1:0] PCM_R			//	output 16 bit PCM right channel
    );
	 
	// wire declaration
	 wire [`C_OUT_WIDTH-1:0] env_w;
	 wire [`C_OUT_WIDTH-1:0] osc_w;
	 wire [`C_OUT_WIDTH-1:0] amp_w;
	 
	 // output registers
	 reg [`C_REG_WIDTH-1:0] env_i = 0;
	 reg [`C_REG_WIDTH-1:0] osc_i = 0;
	 reg [`C_REG_WIDTH-1:0] amp_i = 0;
	 reg [`C_REG_WIDTH-1:0] freq_i = 0;

	 // resets signals
	 // reg Osc_rst;
	 reg Env_rst = 0;
	 reg Amp_rst = 0;
	
	// 1 MHz oscillator update clock
	 Synth_clk synth_clk (
    .Sys_clk(Sys_clk), 
    .Syn_ce(Syn_ce), 
    .Syn_rst(Syn_rst), 
    .Syn_clk(Syn_clk)
    );
	 		 
	 Oscillator oscillator (
    .Sys_clk(Sys_clk), 
    .Syn_clk(Syn_clk), 
	 .Osc_rst(Syn_rst), 
    .Osc_ce(Syn_ce), 
    .Freq(Freq), 
    .Waveform(osc_w)
    );

	 Envelope envelope (
    .Sys_clk(Sys_clk), 
    .Syn_clk(Syn_clk),	
	 .Env_ce(Syn_ce),
    .Env_rst(Syn_rst | Env_rst), 
    .Syn_key(Syn_key), 
    .A_lvl(A_lvl), 
    .D_lvl(D_lvl), 
    .S_lvl(S_lvl), 
    .A_len(A_len), 
    .D_len(D_len), 
    .R_len(R_len), 
    .Env_lvl(env_w)
    );

	 Amplifier amplifier (
    .Sys_clk(Sys_clk), 	// input system clk
    .Amp_ce(Syn_ce), // input active high enable
    .Amp_rst(Syn_rst | Amp_rst), // input active high reset
    .Amplitude(env_w), // input [31:0] envelope input
    .Oscillator(osc_w), // input [31:0] oscillator output 
    .Amp_out(amp_w)	// output [15:0] 16 bit PCM.
    );
	
	always @ (posedge Syn_clk) begin
		env_i <= env_w;
		osc_i <= osc_w;
		amp_i <= amp_w;
		if (Freq != freq_i) begin
			freq_i <= Freq;
			Env_rst <= 1;
		end
		else Env_rst <= 0;
	end	
		
	assign Osc = osc_i;
   assign Env = env_i;
	assign Amp = amp_i;
	assign PCM_L = amp_i;
	assign PCM_R = amp_i;
	
endmodule
