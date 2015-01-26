`timescale 1ns / 1ps
`default_nettype wire
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:04 11/30/2013 
// Design Name: 
// Module Name:    Envelope 
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
//		assumes 100 mHz system clk
//		assumes   1 MHz update clk						
//////////////////////////////////////////////////////////////////////////////////
`define C_REG_WIDTH 32

module Envelope(
	 // CONTROL SIGNALS
	 input 	Sys_clk,							// input system clk
	 input 	Syn_clk,							// input update clk
	 input 	Env_rst,							// input active high reset
	 input	Env_ce,							// input active high envelope enable
	 input 	Syn_key,							// input key position.
			
	 // DATA SIGNALS
	 // LEVEL PARAMETERS
    input 	[`C_REG_WIDTH-1:0] A_lvl,		// starting level of the attack stage
    input 	[`C_REG_WIDTH-1:0] D_lvl,		// starting level of the delay stage
	 input 	[`C_REG_WIDTH-1:0] S_lvl,		// starting level of the sustain (also its mainatain level)	
    // LENGTH PARAMETERS
	 input 	[`C_REG_WIDTH-1:0] A_len,		// length of the attack stage
    input 	[`C_REG_WIDTH-1:0] D_len,		// length of the delay stage
    input 	[`C_REG_WIDTH-1:0] R_len,		// length of the release stage
	 
    output 	[`C_REG_WIDTH-1:0] Env_lvl	// output level
    );
	 
	 reg signed [31:0] level_i = 0;				// summation register for level calculations
	 reg [31:0] cnt = 0;						// counts ticks over time.
	 
	 wire signed [31:0] a_delta, d_delta ,r_delta; 
	 wire signed [31:0] a_slope, d_slope, r_slope;
	 
	 reg signed [`C_REG_WIDTH-1:0] a_slope_i = 0;
	 reg signed [`C_REG_WIDTH-1:0] d_slope_i = 0;
	 reg signed [`C_REG_WIDTH-1:0] r_slope_i = 0;
	 
	 always @(a_slope or d_slope or r_slope) begin
		 a_slope_i <= a_slope;
		 d_slope_i <= d_slope;
		 r_slope_i <= r_slope;
	 end
	 
	 reg signed [`C_REG_WIDTH-1:0] a_delta_i = 0;
	 reg signed [`C_REG_WIDTH-1:0] d_delta_i = 0;
	 reg signed [`C_REG_WIDTH-1:0] r_delta_i = 0;
	 
	 always @(A_lvl or D_lvl or S_lvl) begin 			 
		 a_delta_i <= $signed(D_lvl - A_lvl)	<<< 16;
		 d_delta_i <= $signed(S_lvl - D_lvl)	<<< 16;
		 r_delta_i <= $signed(-S_lvl) 			<<< 16;
	 end
	 
	 // MODULE DECLARATIONS
	 Slope_Calc attack_slope_clk (
    .Sys_clk(Sys_clk), 
    .Env_ce(Env_ce), 
    .Env_rst(Env_rst), 
    .Rise(a_delta), 
    .Run(A_len), 
    .Slope(a_slope)
    );
	 
	 Slope_Calc delay_slope_calc (
    .Sys_clk(Sys_clk), 
    .Env_ce(Env_ce), 
    .Env_rst(Env_rst), 
    .Rise(d_delta), 
    .Run(D_len), 
    .Slope(d_slope)
    );
	 
	 Slope_Calc release_slope_calc (
    .Sys_clk(Sys_clk), 
    .Env_ce(Env_ce), 
    .Env_rst(Env_rst), 
    .Rise(r_delta), 
    .Run(R_len), 
    .Slope(r_slope)
    );
	 
	 // STATE DECLARATIONS
	 reg [3:0] state = 0;
	 reg [3:0] next_state = 0;
	 `define IDLE			'b0000
	 `define ATTACK		'b0001
	 `define DELAY			'b0010
	 `define SUSTAIN 		'b0100
	 `define RELEASE		'b1000
	 
	 // state register block
	 always @(posedge Sys_clk) state <= next_state;
	 
	 // next state register block
	 always @(posedge Syn_clk) begin
		 if (!Env_ce) begin 					// enable logic
			 level_i <= level_i;
			 cnt <= cnt;	
		 end										// end enable
		 else if (Env_rst) begin			// reset logic
			 next_state <= 0;			
			 cnt <= 0;
		 end										// reset logic
		 else begin		 						// nominal logic
			 case (state) 						// state logic
				 `IDLE: begin 					// idle state
				    if (Syn_key) next_state <= `ATTACK;
					 cnt <= 0;
				 end 								// end idle
				 `ATTACK: begin 				// attack state
					 if (!Syn_key) begin
						 next_state <= `SUSTAIN;
						 cnt <=0; 	end
					 if (cnt < A_len) cnt <= cnt + 1;
					 else begin
						 next_state <= `DELAY;
						 cnt <= 0;		end
				 end								// END ATTACK
				 `DELAY:	begin					// DELAY STATE
				    if (!Syn_key) begin
						 next_state <= `SUSTAIN;
						 cnt <=0; 	end
					 if (cnt < D_len) cnt <= cnt + 1;
					 else begin
						 next_state <= `SUSTAIN;
						 cnt <= 0;		end
				 end								// END DELAY
				 `SUSTAIN: begin				// SUSTAIN STATE
					 if (Syn_key) cnt <= cnt + 1;			
					 else begin 
						next_state <= `RELEASE;
						cnt <= 0;	end 
				 end 								// END SUSTAIN
				 `RELEASE:	begin				// RELEASE STATE
					 if (cnt < R_len) cnt <= cnt + 1;
					 else next_state <= `IDLE;
				 end  							// END RELEASE
				 default: next_state <= `IDLE;
			 endcase
		 
		 // OUTPUT LOGIC
		 if (state == `IDLE)			level_i <= 32'b0;
		 if (state == `ATTACK) begin 
			 if (cnt == 1) level_i <= A_lvl <<< 16;
			 else level_i <= level_i + a_slope;	end
		 if (state == `DELAY)		level_i <= level_i + d_slope_i;				
		 if (state == `SUSTAIN) 	level_i <= S_lvl <<< 16;
		 if (state == `RELEASE) begin
			 level_i <= level_i + r_slope_i;
			 if ($signed(level_i < 0)) level_i <= 0; end
		 end // NOMINAL
	 end // SYSCLK
	 
	 // WIRE ASSIGNMENTS
	 assign a_delta = a_delta_i;
	 assign d_delta = d_delta_i;
	 assign r_delta = r_delta_i;
	 assign Env_lvl = level_i[31:16];
endmodule