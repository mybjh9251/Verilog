`timescale 1ns / 1ps

module TB_Code_Test;

reg clk, rstn, clk2;
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
always begin
	#10 clk2 = 1;
	#10 clk2 = 0;
end

reg [31:0] r_cnt_1;
reg [31:0] r_cnt_2;
reg r_trig_1;
reg r_trig_2;
always @(posedge clk or negedge rstn) begin
	if(!rstn) begin
		r_cnt_1 <= 0;
		r_cnt_2 <= 0;
		r_trig_1 <= 0;
		r_trig_2 <= 0;
	end else begin
		if( r_cnt_1 >= 100) begin
			r_cnt_1 <= 0;
			r_trig_1 <= ~r_trig_1;
			if( r_cnt_2 >= 100) begin
				r_cnt_2 <= 0;
				r_trig_2 <= ~r_trig_2;
			end else begin
				r_cnt_2 <= r_cnt_2 + 1;				
			end
		end else begin
			r_cnt_1 <= r_cnt_1 + 1;
		end
	end
end

wire w_xpm_pulse1;
wire w_xpm_pulse2;
wire w_xpm_pulse3;
wire w_xpm_pulse4;
	xpm_cdc_pulse #(
		.DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
		.INIT_SYNC_FF(1),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
		.REG_OUTPUT(0),     // DECIMAL; 0=disable registered output, 1=enable registered output
		.RST_USED(0),       // DECIMAL; 0=no reset, 1=implement reset
		.SIM_ASSERT_CHK(0)  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	)
	xpm_cdc_pulse_inst1 (
		.dest_pulse(w_xpm_pulse1), // 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse
								// transfer is correctly initiated on src_pulse input. This output is
								// combinatorial unless REG_OUTPUT is set to 1.
		.dest_clk(clk),     // 1-bit input: Destination clock.
		.dest_rst(!rstn),
		.src_clk(clk),       // 1-bit input: Source clock.
		.src_pulse(r_trig_2),   // 1-bit input: Rising edge of this signal initiates a pulse transfer to the
								// destination clock domain. The minimum gap between each pulse transfer must be
								// at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured
								// between the falling edge of a src_pulse to the rising edge of the next
								// src_pulse. This minimum gap will guarantee that each rising edge of src_pulse
								// will generate a pulse the size of one dest_clk period in the destination
								// clock domain. When RST_USED = 1, pulse transfers will not be guaranteed while
								// src_rst and/or dest_rst are asserted.
		.src_rst(!rstn)
	);
	xpm_cdc_pulse #(
		.DEST_SYNC_FF(3),   // DECIMAL; range: 2-10
		.INIT_SYNC_FF(1),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
		.REG_OUTPUT(0),     // DECIMAL; 0=disable registered output, 1=enable registered output
		.RST_USED(0),       // DECIMAL; 0=no reset, 1=implement reset
		.SIM_ASSERT_CHK(0)  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	)
	xpm_cdc_pulse_inst2 (
		.dest_pulse(w_xpm_pulse2), // 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse
								// transfer is correctly initiated on src_pulse input. This output is
								// combinatorial unless REG_OUTPUT is set to 1.
		.dest_clk(clk),     // 1-bit input: Destination clock.
		.dest_rst(!rstn),
		.src_clk(clk),       // 1-bit input: Source clock.
		.src_pulse(r_trig_2),   // 1-bit input: Rising edge of this signal initiates a pulse transfer to the
								// destination clock domain. The minimum gap between each pulse transfer must be
								// at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured
								// between the falling edge of a src_pulse to the rising edge of the next
								// src_pulse. This minimum gap will guarantee that each rising edge of src_pulse
								// will generate a pulse the size of one dest_clk period in the destination
								// clock domain. When RST_USED = 1, pulse transfers will not be guaranteed while
								// src_rst and/or dest_rst are asserted.
		.src_rst(!rstn)
	);
	xpm_cdc_pulse #(
		.DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
		.INIT_SYNC_FF(1),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
		.REG_OUTPUT(0),     // DECIMAL; 0=disable registered output, 1=enable registered output
		.RST_USED(0),       // DECIMAL; 0=no reset, 1=implement reset
		.SIM_ASSERT_CHK(0)  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	)
	xpm_cdc_pulse_inst3 (
		.dest_pulse(w_xpm_pulse3), // 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse
								// transfer is correctly initiated on src_pulse input. This output is
								// combinatorial unless REG_OUTPUT is set to 1.
		.dest_clk(clk2),     // 1-bit input: Destination clock.
		.dest_rst(!rstn),
		.src_clk(clk),       // 1-bit input: Source clock.
		.src_pulse(r_trig_2),   // 1-bit input: Rising edge of this signal initiates a pulse transfer to the
								// destination clock domain. The minimum gap between each pulse transfer must be
								// at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured
								// between the falling edge of a src_pulse to the rising edge of the next
								// src_pulse. This minimum gap will guarantee that each rising edge of src_pulse
								// will generate a pulse the size of one dest_clk period in the destination
								// clock domain. When RST_USED = 1, pulse transfers will not be guaranteed while
								// src_rst and/or dest_rst are asserted.
		.src_rst(!rstn)
	);
	xpm_cdc_pulse #(
		.DEST_SYNC_FF(3),   // DECIMAL; range: 2-10
		.INIT_SYNC_FF(1),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
		.REG_OUTPUT(0),     // DECIMAL; 0=disable registered output, 1=enable registered output
		.RST_USED(0),       // DECIMAL; 0=no reset, 1=implement reset
		.SIM_ASSERT_CHK(0)  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	)
	xpm_cdc_pulse_inst4 (
		.dest_pulse(w_xpm_pulse4), // 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse
								// transfer is correctly initiated on src_pulse input. This output is
								// combinatorial unless REG_OUTPUT is set to 1.
		.dest_clk(clk2),     // 1-bit input: Destination clock.
		.dest_rst(!rstn),
		.src_clk(clk),       // 1-bit input: Source clock.
		.src_pulse(r_trig_2),   // 1-bit input: Rising edge of this signal initiates a pulse transfer to the
								// destination clock domain. The minimum gap between each pulse transfer must be
								// at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured
								// between the falling edge of a src_pulse to the rising edge of the next
								// src_pulse. This minimum gap will guarantee that each rising edge of src_pulse
								// will generate a pulse the size of one dest_clk period in the destination
								// clock domain. When RST_USED = 1, pulse transfers will not be guaranteed while
								// src_rst and/or dest_rst are asserted.
		.src_rst(!rstn)
	);

endmodule
