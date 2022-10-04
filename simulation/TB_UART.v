module TB_UART;
    reg clk,rstn;
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
    reg i_Trig_Bram_Start;
    reg i_Trig_Set_Valid;
    reg i_Trig_Tx_Start;
    reg i_Trig_Rx_Read;

    initial begin
        i_Trig_Set_Valid = 0;
        i_Trig_Bram_Start= 0;
        i_Trig_Tx_Start  = 0;
        i_Trig_Rx_Read   = 1;
        #4000 
        i_Trig_Set_Valid = 1;
        #500 
        i_Trig_Set_Valid = 0; 
        i_Trig_Bram_Start = 1;
        #2500
        i_Trig_Bram_Start = 0;
        i_Trig_Tx_Start = 1;
        #5000
        i_Trig_Rx_Read  = 0;
        i_Trig_Bram_Start = 1;
    end

    //////////////////////////////////////////////////////////////////////////


        wire  [15:0] i_EMIF_BRAM_Addr ;	//
        wire 		 i_EMIF_BRAM_EN	  ;
        wire  [1 :0] i_EMIF_BRAM_WE   ;
        wire [15:0]  i_EMIF_BRAM_Din  ;	//
        wire [15:0]  o_EMIF_BRAM_Dout ;	// 

        TB_Bram_Controller #(
            .ADDR_SIZE(16)
        )bram_cotrol(
            /*input         */.clk     	(clk  ),
            /*input         */.rstn    	(rstn ),
            /*input  [31:0] */.i_Length	(16'hA	),
            /*input         */.i_Mode  	(i_Trig_Rx_Read	),
            /*input         */.i_Trig	(i_Trig_Bram_Start	),
            /*output [31:0] */.o_Addr	(i_EMIF_BRAM_Addr	),
            /*output        */.o_EN    	(i_EMIF_BRAM_EN	 	),
            /*output [2:0]  */.o_WEN   	(i_EMIF_BRAM_WE  	) 
        );
        blk_mem_gen_0_simulation bram(
            .addra	(	/*NC*/	),
            .clka	(	/*NC*/	),
            .ena	(	/*NC*/	),
            .wea	(	/*NC*/	),
            .addrb	(	i_EMIF_BRAM_Addr	),
            .clkb	(	clk	),
            .doutb	(	i_EMIF_BRAM_Din	)
        );

        wire          o_UART0_TXD              ;	// 
        wire [7 :0]   o_UART0_TX_OPCode_ERR    ;	// 
        wire [7 :0]   o_UART0_TX_Data_Size_ERR ;	// 


    TOP_UART #(
        .MSB_FIRST_MODE (0), //inside interface    // '1' : MSB FIRST, '0' : LSB_FIRST
        .CH0_ENABLE     (1), //enable or disable UART Channel0
        .CH1_ENABLE     (0), //enable or disable UART Channel1
        .CH2_ENABLE     (0), //enable or disable UART Channel2
        .CH3_ENABLE     (0) //enable or disable UART Channel3  
    )top_uart_i (
        .clk                      (	clk                      ) ,	// reg          
        .nrst                     (	rstn                     ) ,	// reg          
        .i_EMIF_BRAM_Clk          (	clk 		          ) ,	// reg          
        .i_EMIF_BRAM_RST          (	!rstn		          ) ,	// reg          
        .i_EMIF_BRAM_EN           (	i_EMIF_BRAM_EN           ) ,	// reg          
        .i_EMIF_BRAM_WE           (	i_EMIF_BRAM_WE           ) ,	// reg  [1 :0]  
        .i_EMIF_BRAM_Addr         (	i_EMIF_BRAM_Addr         ) ,	// reg  [15:0]  
        .i_EMIF_BRAM_Din          (	i_EMIF_BRAM_Din          ) ,	// reg  [15:0]  
        .o_EMIF_BRAM_Dout         (	o_EMIF_BRAM_Dout         ) ,	// wire [15:0]  

        .o_UART0_TXD              (	o_UART0_TXD              ) ,	// wire         
        .i_UART_Tx_Bram_Valid     (	4'b1111     ) ,	// reg  [3:0]   
        .i_UART0_Period_Num       (	32'h36	       ) ,	// reg  [31:0]  
        .o_UART0_TX_OPCode_ERR    (	o_UART0_TX_OPCode_ERR    ) ,	// wire [7 :0]  
        .o_UART0_TX_Data_Size_ERR (	o_UART0_TX_Data_Size_ERR ) ,	// wire [7 :0]  
        .i_UART0_Send             (	i_Trig_Tx_Start             ) ,	// reg          
        .i_U0_Set_VLD             (	i_Trig_Set_Valid             ) ,	// reg          
        .i_U1_Set_VLD             (	0             ) ,	// reg          
        .i_U2_Set_VLD             (	0             ) ,	// reg          
        .i_U3_Set_VLD             (	0             ) ,	// reg          
        
        .i_UART0_RXD              (	o_UART0_TXD ) ,	// reg          
        .i_UART_Rx_Bram_Valid     (	 ) ,	// reg  [3:0]   
        .o_UART0_RX_OPCode_ERR    (	 ) ,	// wire [7 :0]  
        .o_UART0_RX_Data_Size_ERR (	 ) ,	// wire [7 :0]  
        .i_RX0_MEM_RST            (	0 ) ,	// reg          
        .o_RX_Done                (	 ) ,	// wire [3:0]   

        .i_Debug_BRAM_ENA         (	 ) ,	// reg          
        .i_Debug_BRAM_WEA         (	 ) ,	// reg  [ 1 :0] 
        .o_Debug_BRAM_PortA_rData (	 ) ,	// wire [ 15 :0]
        .o_Debug_BRAM_PortB_rData (	 ) 	// wire [ 15 :0]
    );  

endmodule