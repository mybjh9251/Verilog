`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2021 09:43:56 AM
// Design Name: 
// Module Name: TB_Signal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_Signal#(
	parameter CLOCK_PERIOD = 10
	parameter RESET_ENABLE = 1
)(

);

reg clk, rstn;
initial begin
	clk = 0;
	rstn = 1;
	#100 rstn = 0;
	#100 rstn = 1;
end
always begin
	#1 clk = 1;
	#1 clk = 0;
end

reg [31:0] r_cnt_1;
reg [31:0] r_cnt_2;
reg [31:0] r_cnt_3;
reg r_trig_1;
reg r_trig_2;
reg r_trig_3;
reg r_trig_4;

reg [15:0] i_PRI_Width		= 13000;
reg [15:0] i_CPI_Width		= 50;
reg [2:0]  i_Waveform_Type;
wire o_SRIO_Mem_Sel;
wire o_First_PRI	;
wire o_CPI_Internal;
wire o_PRI_Internal;
wire o_PRI_p       ;
wire o_CPI_p       ;
always @(posedge clk or negedge rstn) begin
	if(!rstn) begin
		r_cnt_1 <= 0;
		r_cnt_2 <= 0;
		r_cnt_3 <= 0;
		r_trig_1 <= 0;
		r_trig_2 <= 0;
		r_trig_3 <= 0;
		r_trig_4 <= 0;
	end else begin
		if( r_cnt_1 >= 100) begin
			r_cnt_1 <= 0;
			r_trig_1 <= ~r_trig_1;
			if( r_cnt_2 >= 1000) begin
				r_cnt_2 <= 0;
				r_trig_2 <= ~r_trig_2;
				if( r_cnt_3 >= 100) begin
					r_cnt_3 <= 0;
					r_trig_3 <= ~r_trig_3;
				end else begin
					r_cnt_3 <= r_cnt_3 + 1;
					i_Waveform_Type <= r_cnt_3[2:0];
				end
			end else begin
				r_cnt_2 <= r_cnt_2 + 1;
			end
		end else begin
			r_cnt_1 <= r_cnt_1 + 1;
		end
		if(r_trig_3 == 1) begin
			r_trig_4 <= 1;
		end
	end
end

endmodule
