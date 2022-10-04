`timescale 1ns / 1ps
module TB_GPIO;

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
			if( r_cnt_2 >= 100) begin
				r_cnt_2 <= 0;
				r_trig_2 <= ~r_trig_2;
				if( r_cnt_3 >= 100) begin
					r_cnt_3 <= 0;
					r_trig_3 <= ~r_trig_3;
				end else begin
					r_cnt_3 <= r_cnt_3 + 1;
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

wire [15:0] io_dsp_gpio              ;
wire [15:0] o_dsp_gpio               ;
wire [15:0] i_dsp_gpio               = 16'h160D;
wire [15:0] i_dsp_gpio_dir_by_dsp_re = r_trig_3;
wire        i_dsp_bootconfig_done    = r_trig_4;
wire        i_pri_pulse              = r_trig_2;
wire        i_gps_pps                = 0;



	gpio_top gpio_top_inst(
		.mainclkdiv8              (	clk			) ,	// 
		.nreset                   (	rstn     			) ,	// 
		.io_dsp_gpio              (	io_dsp_gpio             	) ,	// 
		.o_dsp_gpio               (	o_dsp_gpio              	) ,	// 
		.i_dsp_gpio               (	i_dsp_gpio              	) ,	// DSP_BOOTMODE->GPIO
		.i_dsp_gpio_dir_by_dsp_re (	i_dsp_gpio_dir_by_dsp_re	) ,	// IRA_CONFIG->GPIO
		.i_dsp_bootconfig_done    (	i_dsp_bootconfig_done   	) ,	// 
		.i_pri_pulse              (	i_pri_pulse             	) ,	// SYNC->preprocessor, GPIO...
		.i_gps_pps                (	i_gps_pps               	)	//
	);


endmodule
