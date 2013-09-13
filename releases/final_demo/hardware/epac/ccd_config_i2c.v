
module ccd_config_i2c (
	//	Host Side
	iCLK,
	iRST_N,
	switches,
	restart,
	//	I2C Side
	I2C_SCLK,
	I2C_SDAT,
	done
);
						
//	Host Side
input			iCLK;
input			iRST_N;
input	[15:0]	switches;
input			restart;

//	I2C Side
output			I2C_SCLK;
inout			I2C_SDAT;
output			done;

//	Internal Registers/Wires
reg		[15:0]	mI2C_CLK_DIV;
reg		[31:0]	mI2C_DATA;
reg				mI2C_CTRL_CLK;
reg				mI2C_GO;
wire			mI2C_END;
wire			mI2C_ACK;
reg		[23:0]	LUT_DATA;
reg		[5:0]	LUT_INDEX;
reg		[3:0]	mSetup_ST;


wire			i2c_reset;


assign i2c_reset = iRST_N & ~restart;

assign done = (!(LUT_INDEX < LUT_SIZE)) ? 1'b1 : 1'b0;


//	Clock Setting
parameter	CLK_Freq	= 50000000;	//	50	MHz
parameter	I2C_Freq	= 20000;	//	20	KHz
//	LUT Data Number
parameter	LUT_SIZE	= 25;

/////////////////////	I2C Control Clock	////////////////////////
always@(posedge iCLK or negedge iRST_N) begin
	if (!iRST_N) begin
		mI2C_CTRL_CLK	<= 0;
		mI2C_CLK_DIV	<= 0;
	
	end else begin
		if (mI2C_CLK_DIV < (CLK_Freq/I2C_Freq))
			mI2C_CLK_DIV	<= mI2C_CLK_DIV+16'd1;
		
		else begin
			mI2C_CLK_DIV	<= 0;
			mI2C_CTRL_CLK	<= ~mI2C_CTRL_CLK;
		
		end
	end
end

////////////////////////////////////////////////////////////////////
i2c_controller i2c (
	.CLOCK		(mI2C_CTRL_CLK),	//	Controller Work Clock
	.I2C_SCLK	(I2C_SCLK),			//	I2C CLOCK
	.I2C_SDAT	(I2C_SDAT),			//	I2C DATA
	.I2C_DATA	(mI2C_DATA),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
	.GO			(mI2C_GO),      	//	GO transfor
	.END		(mI2C_END),			//	END transfor 
	.ACK		(mI2C_ACK),			//	ACK
	.RESET		(iRST_N)
);

////////////////////////////////////////////////////////////////////
//////////////////////	Config Control	////////////////////////////
always @(posedge mI2C_CTRL_CLK or negedge i2c_reset) begin
	if (!i2c_reset) begin
		LUT_INDEX	<= 0;
		mSetup_ST	<= 0;
		mI2C_GO		<= 0;
	
	end else if (LUT_INDEX < LUT_SIZE) begin
		case (mSetup_ST)
		0:	begin
				mI2C_DATA	<= {8'hBA,LUT_DATA};
				mI2C_GO		<= 1;
				mSetup_ST	<= 1;
			end
		1:	begin
				if (mI2C_END) begin
					mSetup_ST	<= 2;
					mI2C_GO		<= 0;
				end
			end
		2:	begin
				LUT_INDEX	<= LUT_INDEX + 6'b1;
				mSetup_ST	<= 0;
			end
		endcase
	end
end
////////////////////////////////////////////////////////////////////
/////////////////////	Config Data LUT	  //////////////////////////		
always @* begin
	case(LUT_INDEX)
	0	:	LUT_DATA	<=	24'h000000;
	1	:	LUT_DATA	<=	24'h20C000;				//	Mirror Row and Columns
	2	:	LUT_DATA	<=	{8'h09, switches};		//	Exposure arbitrarily set
	3	:	LUT_DATA	<=	24'h050000;				//	H_Blanking
	4	:	LUT_DATA	<=	24'h060019;				//	V_Blanking	
	5	:	LUT_DATA	<=	24'h0A0000;				//	don't change latch
	6	:	LUT_DATA	<=	24'h2B000b;				//	Green 1 Gain
	7	:	LUT_DATA	<=	24'h2C000d;				//	Blue Gain
	8	:	LUT_DATA	<=	24'h2D000f;				//	Red Gain
	9	:	LUT_DATA	<=	24'h2E000b;				//	Green 2 Gain
	10	:	LUT_DATA	<=	24'h100000;				//	do not use PLL
	11	:	LUT_DATA	<=	24'h111000;				//	PLL_m_Factor<<8+PLL_n_Divider
	12	:	LUT_DATA	<=	24'h120000;				//	PLL_p1_Divider
	13	:	LUT_DATA	<=	24'h100000;				//	do not use PLL	 
	14	:	LUT_DATA	<=	24'h980000;				//	disble calibration 	
//`ifdef ENABLE_TEST_PATTERN
//	15	:	LUT_DATA	<=	24'hA00009;				//	Test pattern control 	
//	16	:	LUT_DATA	<=	24'hA10123;				//	Test green pattern value
//	17	:	LUT_DATA	<=	24'hA20456;				//	Test red pattern value
//`else
	15	:	LUT_DATA	<=	24'hA00000;				//	Test pattern control 
	16	:	LUT_DATA	<=	24'hA10000;				//	Test green pattern value
	17	:	LUT_DATA	<=	24'hA20FFF;				//	Test red pattern value
//`endif
	18	:	LUT_DATA	<=	24'h010000;				//	set start row
	19	:	LUT_DATA	<=	24'h020000;				//	set start column

	20	:	LUT_DATA	<=	24'h030797;				//	set row size	
	21	:	LUT_DATA	<=	24'h040A1F;				//	set column size
	22	:	LUT_DATA	<=	24'h220000;				//	set row mode in bin mode
	23	:	LUT_DATA	<=	24'h230000;				//	set column mode	 in bin mode
	24	:	LUT_DATA	<=	24'h4901A8;				//	row black target		
	default:LUT_DATA	<=	24'h000000;
	endcase
	
end

endmodule
