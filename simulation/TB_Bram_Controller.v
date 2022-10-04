module TB_Bram_Controller #(
	parameter ADDR_SIZE = 16
	parameter WEN_SIZE = 3
)(
	input         			clk     	,
	input         			rstn    	,
	input  [ADDR_SIZE-1:0]	i_Length	,
	input         			i_Mode  	,
	input         			i_Trig		,
	output [ADDR_SIZE-1:0]	o_Addr		,
	output        			o_EN    	,
	output [WEN_SIZE-1 :0]	o_WEN   	
);

reg [ADDR_SIZE-1:0] r_Addr	;
reg        r_EN    	;
reg 	   r_WEN   	;



reg [2:0] r_clk;
wire w_clk_div2 = r_clk[2];
always @(posedge clk or negedge rstn) begin
	if(!rstn ) begin
		r_clk <= 0;
	end else begin
		r_clk <= r_clk + 1;
	end
end

reg [2:0] r_Trig;
wire w_Trig;
always @(posedge w_clk_div2 or negedge rstn) begin
	if( !rstn) begin
		r_Trig <= 0;
	end else begin
		r_Trig <= {r_Trig[1:0], i_Trig};
	end
end
assign w_Trig = (!r_Trig[2]) & r_Trig[1];

reg [7:0] r_State;
always @(posedge w_clk_div2 or negedge rstn) begin
	if(!rstn) begin
		r_State <= 0;
	end else begin
		case (r_State)
			0:begin
				if( w_Trig ) begin
					r_State <= r_State + 1;
				end
			end
			1:begin
				if(r_Addr < i_Length) begin
					r_State <= r_State + 1;
				end else begin
					r_State <= 0;
				end
			end
			10:begin
				r_State <= 1;
			end
			default: begin
				r_State <= r_State + 1;
			end
		endcase
	end
end

always @(posedge w_clk_div2 or negedge rstn) begin
	if(!rstn)begin
		r_Addr	<= 0;
		r_EN  	<= 0;
		r_WEN 	<= 0;
	end else begin
		case (r_State)
			0:begin
				if(w_Trig) begin
					r_Addr <= 0;
				end
				r_EN  	<= 0;
				r_WEN 	<= 0;
			end 
			2:begin
				r_EN  	<= 1;
				if( i_Mode == 1) begin
					r_WEN 	<= 1;					
				end else begin
					r_WEN 	<= 0;
				end
			end 

			10:begin
				r_EN  	<= 0;
				r_WEN 	<= 0;
				r_Addr  <= r_Addr + 1;
			end
			default: begin
				r_EN  	<= r_EN ;
				r_WEN 	<= r_WEN;
			end
		endcase
	end
end



assign o_Addr = r_Addr;
assign o_EN   = r_EN  ;
assign o_WEN  = {WEN_SIZE{r_WEN}} ;


endmodule