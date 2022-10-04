`timescale 1ns / 1ps

module TB_HSC_IP( );

reg clk, rstn;
initial begin
	clk = 0;
	rstn = 1;
	#100 rstn = 0;
	#100 rstn = 1;
end
always begin
	#3 clk = 1;
	#3 clk = 0;
end

reg [31:0] r_cnt_1;
reg [31:0] r_cnt_2;
reg [31:0] r_cnt_3;
reg r_trig_1;
reg r_trig_2;
reg r_trig_3;
reg r_trig_4;

reg [15:0] i_PRI_Width		= 130;
reg [15:0] i_CPI_Width		= 5;
reg [2:0]  i_Waveform_Type = 0;
wire o_SRIO_Mem_Sel;
wire o_First_PRI	;
wire o_CPI_Internal;
wire o_PRI_Internal;
wire o_PRI_p       ;
wire o_CPI_p       ;



reg  [15:0]	adc_in_ch0 = 0;
reg  [15:0]	adc_in_ch1 = 0;
reg  [15:0]	adc_in_ch2 = 0;
reg  [31:0]	comp_phase_inc = 0;
reg  [31:0]	ddc_phase_inc  = 0;
reg  [15:0]	npw            = 16'd4;
reg  [15:0]	nsample_pri    = 16'd19;
reg  [15:0]	pri_clk        = 0;
reg  [1:0]	rsp_path       = 2'd0;
reg	 [15:0] Valid_Start_Idx = 0;
always @(posedge clk or negedge rstn) begin
	if(!rstn) begin
		r_cnt_1 <= 0;
		r_cnt_2 <= 0;
		r_cnt_3 <= 0;
		r_trig_1 <= 0;
		r_trig_2 <= 0;
		r_trig_3 <= 0;
		r_trig_4 <= 0;
		i_Waveform_Type <= 0;
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
