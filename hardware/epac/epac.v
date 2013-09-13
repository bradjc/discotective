// MAIN HARDWARE FILE FOR THE DISCOTECTIVE

// epac = Embedded Processor And Camera


module epac (
	////////////////////	Clock Input	 	////////////////////	 
	CLOCK_27,						//	27 MHz
	CLOCK_50,						//	50 MHz
	EXT_CLOCK,						//	External Clock
	////////////////////	Push Button		////////////////////
	KEY,							//	Pushbutton[3:0]
	////////////////////	DPDT Switch		////////////////////
	SW,								//	Toggle Switch[17:0]
	////////////////////	7-SEG Dispaly	////////////////////
	HEX0,							//	Seven Segment Digit 0
	HEX1,							//	Seven Segment Digit 1
	HEX2,							//	Seven Segment Digit 2
	HEX3,							//	Seven Segment Digit 3
	HEX4,							//	Seven Segment Digit 4
	HEX5,							//	Seven Segment Digit 5
	HEX6,							//	Seven Segment Digit 6
	HEX7,							//	Seven Segment Digit 7
	////////////////////////	LED		////////////////////////
	LEDG,							//	LED Green[8:0]
	LEDR,							//	LED Red[17:0]
	////////////////////////	UART	////////////////////////
	UART_TXD,						//	UART Transmitter
	UART_RXD,						//	UART Receiver
	////////////////////////	IRDA	////////////////////////
	IRDA_TXD,						//	IRDA Transmitter
	IRDA_RXD,						//	IRDA Receiver
	/////////////////////	SDRAM Interface		////////////////
	DRAM_DQ,						//	SDRAM Data bus 16 Bits
	DRAM_ADDR,						//	SDRAM Address bus 12 Bits
	DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
	DRAM_UDQM,						//	SDRAM High-byte Data Mask
	DRAM_WE_N,						//	SDRAM Write Enable
	DRAM_CAS_N,						//	SDRAM Column Address Strobe
	DRAM_RAS_N,						//	SDRAM Row Address Strobe
	DRAM_CS_N,						//	SDRAM Chip Select
	DRAM_BA_0,						//	SDRAM Bank Address 0
	DRAM_BA_1,						//	SDRAM Bank Address 0
	DRAM_CLK,						//	SDRAM Clock
	DRAM_CKE,						//	SDRAM Clock Enable
	////////////////////	Flash Interface		////////////////
	FL_DQ,							//	FLASH Data bus 8 Bits
	FL_ADDR,						//	FLASH Address bus 22 Bits
	FL_WE_N,						//	FLASH Write Enable
	FL_RST_N,						//	FLASH Reset
	FL_OE_N,						//	FLASH Output Enable
	FL_CE_N,						//	FLASH Chip Enable
	////////////////////	SRAM Interface		////////////////
	SRAM_DQ,						//	SRAM Data bus 16 Bits
	SRAM_ADDR,						//	SRAM Address bus 18 Bits
	SRAM_UB_N,						//	SRAM High-byte Data Mask 
	SRAM_LB_N,						//	SRAM Low-byte Data Mask 
	SRAM_WE_N,						//	SRAM Write Enable
	SRAM_CE_N,						//	SRAM Chip Enable
	SRAM_OE_N,						//	SRAM Output Enable
	////////////////////	ISP1362 Interface	////////////////
	OTG_DATA,						//	ISP1362 Data bus 16 Bits
	OTG_ADDR,						//	ISP1362 Address 2 Bits
	OTG_CS_N,						//	ISP1362 Chip Select
	OTG_RD_N,						//	ISP1362 Write
	OTG_WR_N,						//	ISP1362 Read
	OTG_RST_N,						//	ISP1362 Reset
	OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
	OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
	OTG_INT0,						//	ISP1362 Interrupt 0
	OTG_INT1,						//	ISP1362 Interrupt 1
	OTG_DREQ0,						//	ISP1362 DMA Request 0
	OTG_DREQ1,						//	ISP1362 DMA Request 1
	OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
	OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
	////////////////////	LCD Module 16X2		////////////////
	LCD_ON,							//	LCD Power ON/OFF
	LCD_BLON,						//	LCD Back Light ON/OFF
	LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
	LCD_EN,							//	LCD Enable
	LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
	LCD_DATA,						//	LCD Data bus 8 bits
	////////////////////	SD_Card Interface	////////////////
	SD_DAT,							//	SD Card Data
	SD_DAT3,						//	SD Card Data 3
	SD_CMD,							//	SD Card Command Signal
	SD_CLK,							//	SD Card Clock
	////////////////////	USB JTAG link	////////////////////
	TDI,  							// CPLD -> FPGA (data in)
	TCK,  							// CPLD -> FPGA (clk)
	TCS,  							// CPLD -> FPGA (CS)
	TDO,  							// FPGA -> CPLD (data out)
	////////////////////	I2C		////////////////////////////
	I2C_SDAT,						//	I2C Data
	I2C_SCLK,						//	I2C Clock
	////////////////////	PS2		////////////////////////////
	PS2_DAT,						//	PS2 Data
	PS2_CLK,						//	PS2 Clock
	////////////////////	VGA		////////////////////////////
	VGA_CLK,   						//	VGA Clock
	VGA_HS,							//	VGA H_SYNC
	VGA_VS,							//	VGA V_SYNC
	VGA_BLANK,						//	VGA BLANK
	VGA_SYNC,						//	VGA SYNC
	VGA_R,   						//	VGA Red[9:0]
	VGA_G,	 						//	VGA Green[9:0]
	VGA_B,  						//	VGA Blue[9:0]
	////////////	Ethernet Interface	////////////////////////
	ENET_DATA,						//	DM9000A DATA bus 16Bits
	ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
	ENET_CS_N,						//	DM9000A Chip Select
	ENET_WR_N,						//	DM9000A Write
	ENET_RD_N,						//	DM9000A Read
	ENET_RST_N,						//	DM9000A Reset
	ENET_INT,						//	DM9000A Interrupt
	ENET_CLK,						//	DM9000A Clock 25 MHz
	////////////////	Audio CODEC		////////////////////////
	AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
	AUD_ADCDAT,						//	Audio CODEC ADC Data
	AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
	AUD_DACDAT,						//	Audio CODEC DAC Data
	AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
	AUD_XCK,						//	Audio CODEC Chip Clock
	////////////////	TV Decoder		////////////////////////
	TD_DATA,    					//	TV Decoder Data bus 8 bits
	TD_HS,							//	TV Decoder H_SYNC
	TD_VS,							//	TV Decoder V_SYNC
	TD_RESET,						//	TV Decoder Reset
	////////////////////	GPIO	////////////////////////////
	GPIO_0,							//	GPIO Connection 0
	GPIO_1							//	GPIO Connection 1
);

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
output	[17:0]	LEDR;					//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
output			UART_TXD;				//	UART Transmitter
input			UART_RXD;				//	UART Receiver
////////////////////////////	IRDA	////////////////////////////
output			IRDA_TXD;				//	IRDA Transmitter
input			IRDA_RXD;				//	IRDA Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output	[21:0]	FL_ADDR;				//	FLASH Address bus 22 Bits
output			FL_WE_N;				//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;				//	FLASH Output Enable
output			FL_CE_N;				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask 
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	ISP1362 Interface	////////////////////////
inout	[15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
output	[1:0]	OTG_ADDR;				//	ISP1362 Address 2 Bits
output			OTG_CS_N;				//	ISP1362 Chip Select
output			OTG_RD_N;				//	ISP1362 Write
output			OTG_WR_N;				//	ISP1362 Read
output			OTG_RST_N;				//	ISP1362 Reset
output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
input			OTG_INT0;				//	ISP1362 Interrupt 0
input			OTG_INT1;				//	ISP1362 Interrupt 1
input			OTG_DREQ0;				//	ISP1362 DMA Request 0
input			OTG_DREQ1;				//	ISP1362 DMA Request 1
output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
inout	[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
inout			SD_DAT;					//	SD Card Data
inout			SD_DAT3;				//	SD Card Data 3
inout			SD_CMD;					//	SD Card Command Signal
output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 	PS2_DAT;				//	PS2 Data
input			PS2_CLK;				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;					//	CPLD -> FPGA (data in)
input  			TCK;					//	CPLD -> FPGA (clk)
input  			TCS;					//	CPLD -> FPGA (CS)
output 			TDO;					//	FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
output			ENET_CS_N;				//	DM9000A Chip Select
output			ENET_WR_N;				//	DM9000A Write
output			ENET_RD_N;				//	DM9000A Read
output			ENET_RST_N;				//	DM9000A Reset
input			ENET_INT;				//	DM9000A Interrupt
output			ENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
inout			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data
inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			TD_HS;					//	TV Decoder H_SYNC
input			TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1


// basically just the CLOCK_50, but is the same clock as all of the SOPC stuff uses
wire			SYSTEM_CLK;

// from the bridge_to_avalon
wire			bridge_ack;
wire	[15:0]	bridge_data;
// to the bridge_to_avalon
wire	[23:0]	tbridge_addr;
wire			tbridge_read;
wire			tbridge_write;
wire	[1:0]	tbridge_be;
wire	[15:0]	tbridge_data;

//	CCD
wire	[11:0]	CCD_DATA;
wire			CCD_SDAT;
wire			CCD_SCLK;
wire			CCD_FLASH;
wire			CCD_FVAL;
wire			CCD_LVAL;
//wire			CCD_PIXCLK;
wire			CCD_XCLKIN;				//	CCD Master Clock

wire			CCD_CONFIG_done;

// camera capture outputs
wire	[16:0]	CCD_SRAM_addr;
wire			CCD_SRAM_rd_Nwr;
wire	[15:0]	CCD_SRAM_data;
wire			CCD_SRAM_valid;
wire	[15:0]	CCD_SDRAM_data;
wire	[23:0]	CCD_SDRAM_addr;
wire			CCD_SDRAM_valid;

// External Bus Out
wire			bush_ACK_texbus;
wire	[15:0]	bush_data_texbus;
wire	[15:0]	data_fexbus;
wire	[19:0]	addr_fexbus;
wire			rw_fexbus;
wire			bus_en_fexbus;
wire	[1:0]	byte_en_fexbus;

// Bus handler out
wire			fbush_ACK_texbus;
wire	[15:0]	fbush_data_texbus;
wire	[15:0]	fbush_SRAM_data;
wire	[17:0]	fbush_SRAM_addr;
wire			fbush_SRAM_rd_Nwr;
wire	[1:0]	fbush_SRAM_byte_en;
wire			fbush_SRAM_valid;

// SRAM arbiter out
wire	[15:0]	arb_data_tSRAM;
wire	[17:0]	arb_addr_tSRAM;
wire			arb_Nwr_en_tSRAM;
wire			arb_Nout_en_tSRAM;
wire			arb_Nchip_en_tSRAM;
wire	[1:0]	arb_Nbyte_en_tSRAM;
wire			arb_arbwin_tCCD;
wire			arb_arbwin_tbus;

// SRAM out
wire	[15:0]	SRAM_data_out;

// SDRAM write module output
wire			ram_busy;

// the camera campture is stopped
wire			stop;
wire			stop_interrupt;


// wire the camera up
assign	CCD_DATA[0]	= GPIO_1[13];
assign	CCD_DATA[1]	= GPIO_1[12];
assign	CCD_DATA[2]	= GPIO_1[11];
assign	CCD_DATA[3]	= GPIO_1[10];
assign	CCD_DATA[4]	= GPIO_1[9];
assign	CCD_DATA[5]	= GPIO_1[8];
assign	CCD_DATA[6]	= GPIO_1[7];
assign	CCD_DATA[7]	= GPIO_1[6];
assign	CCD_DATA[8]	= GPIO_1[5];
assign	CCD_DATA[9]	= GPIO_1[4];
assign	CCD_DATA[10]= GPIO_1[3];
assign	CCD_DATA[11]= GPIO_1[1];
assign	GPIO_1[16]	= CCD_XCLKIN;
assign	CCD_FVAL	= GPIO_1[22];
assign	CCD_LVAL	= GPIO_1[21];
//assign	CCD_PIXCLK	= GPIO_1[0];
assign	GPIO_1[19]	= 1'b1;				// tRIGGER
assign	GPIO_1[17]	= KEY[0];			// reset
assign	GPIO_1[23]	= CCD_SDAT;			// i2c
assign	GPIO_1[24]	= CCD_SCLK;			// i2c





// the main processor
main epac (
	.clk_27		(CLOCK_27),
	.clk_50		(CLOCK_50),
	.reset_n	(KEY[0]),
	.sdram_clk	(DRAM_CLK),
	.audio_clk	(AUD_XCK),
	.sys_clk	(SYSTEM_CLK),

	// Bridge to Avalon
	// from avalon
	.acknowledge_from_the_bridge_0					(bridge_ack),
	.read_data_from_the_bridge_0					(bridge_data),
	// to avalon
	.address_to_the_bridge_0						(tbridge_addr),
	.read_to_the_bridge_0							(tbridge_read),
	.write_to_the_bridge_0							(tbridge_write),
	.byte_enable_to_the_bridge_0					(tbridge_be),
	.write_data_to_the_bridge_0						(tbridge_data),
	
	// To SDRAM
	.zs_addr_from_the_sdram_0						(DRAM_ADDR),
	.zs_ba_from_the_sdram_0							({DRAM_BA_1, DRAM_BA_0}),
	.zs_cas_n_from_the_sdram_0						(DRAM_CAS_N),
	.zs_cke_from_the_sdram_0						(DRAM_CKE),
	.zs_cs_n_from_the_sdram_0						(DRAM_CS_N),
	.zs_dq_to_and_from_the_sdram_0					(DRAM_DQ),
	.zs_dqm_from_the_sdram_0						({DRAM_UDQM, DRAM_LDQM}),
	.zs_ras_n_from_the_sdram_0						(DRAM_RAS_N),
	.zs_we_n_from_the_sdram_0						(DRAM_WE_N),
	
	// To VGA
	.VGA_BLANK_from_the_video_vga_controller_0		(VGA_BLANK),
	.VGA_R_from_the_video_vga_controller_0			(VGA_R),
	.VGA_G_from_the_video_vga_controller_0			(VGA_G),
	.VGA_B_from_the_video_vga_controller_0			(VGA_B),
	.VGA_CLK_from_the_video_vga_controller_0		(VGA_CLK),
	.VGA_HS_from_the_video_vga_controller_0			(VGA_HS),
	.VGA_SYNC_from_the_video_vga_controller_0		(VGA_SYNC),
	.VGA_VS_from_the_video_vga_controller_0			(VGA_VS),
	
	// Bridge from Avalon
	.write_data_from_the_to_external_bus_bridge_0	(data_fexbus),
	.address_from_the_to_external_bus_bridge_0		(addr_fexbus),
	.rw_from_the_to_external_bus_bridge_0			(rw_fexbus),
	.bus_enable_from_the_to_external_bus_bridge_0	(bus_en_fexbus),
	.byte_enable_from_the_to_external_bus_bridge_0	(byte_en_fexbus),
	.irq_to_the_to_external_bus_bridge_0			(stop_interrupt),
	.acknowledge_to_the_to_external_bus_bridge_0	(fbush_ACK_texbus),
	.read_data_to_the_to_external_bus_bridge_0		(fbush_data_texbus),
	
	// Flash
	.data_to_and_from_the_cfi_flash_0				(FL_DQ),
	.address_to_the_cfi_flash_0						(FL_ADDR),
	.read_n_to_the_cfi_flash_0						(FL_OE_N),
	.select_n_to_the_cfi_flash_0					(FL_CE_N),
	.write_n_to_the_cfi_flash_0						(FL_WE_N),

	// Audio Codec
	.AUD_ADCDAT_to_the_audio_0						(AUD_ADCDAT),
	.AUD_ADCLRCK_to_and_from_the_audio_0			(AUD_ADCLRCK),
	.AUD_BCLK_to_and_from_the_audio_0				(AUD_BCLK),
	.AUD_DACDAT_from_the_audio_0					(AUD_DACDAT),
	.AUD_DACLRCK_to_and_from_the_audio_0			(AUD_DACLRCK),
	.I2C_SCLK_from_the_audio_and_video_config_0		(I2C_SCLK),
	.I2C_SDAT_to_and_from_the_audio_and_video_config_0	(I2C_SDAT),
	
	// LCD Character Display
	.LCD_BLON_from_the_character_lcd_0				(LCD_BLON),
	.LCD_DATA_to_and_from_the_character_lcd_0		(LCD_DATA),
	.LCD_EN_from_the_character_lcd_0				(LCD_EN),
	.LCD_ON_from_the_character_lcd_0				(LCD_ON),
	.LCD_RS_from_the_character_lcd_0				(LCD_RS),
	.LCD_RW_from_the_character_lcd_0				(LCD_RW),
	
	// SD Card
	.b_SD_cmd_to_and_from_the_sd_card_0				(SD_CMD),
	.b_SD_dat3_to_and_from_the_sd_card_0			(SD_DAT3),
	.b_SD_dat_to_and_from_the_sd_card_0				(SD_DAT),
	.o_SD_clock_from_the_sd_card_0					(SD_CLK),
	
	// Interrupt line to custom instruction
	.interrupt_to_the_cpu_0_wait_for_interrupt_custom_instruction_0_91_inst (stop_interrupt),

	// HEX and LED
	.HEX0_from_the_seven_seg_3_0					(HEX0),
	.HEX1_from_the_seven_seg_3_0					(HEX1),
	.HEX2_from_the_seven_seg_3_0					(HEX2),
	.HEX3_from_the_seven_seg_3_0					(HEX3),
	.HEX4_from_the_seven_seg_7_4					(HEX4),
	.HEX5_from_the_seven_seg_7_4					(HEX5),
	.HEX6_from_the_seven_seg_7_4					(HEX6),
	.HEX7_from_the_seven_seg_7_4					(HEX7),
	.LEDR_from_the_red_leds							(LEDR)
);

// camera module
ccd_capture camera_capture (
	// Inputs
	.iF_valid		(CCD_FVAL),
	.iL_valid		(CCD_LVAL),
	.iCam_data		(CCD_DATA),
	.iConfig_done	(CCD_CONFIG_done),
	.iStop			(stop),
	.iSRAM_data_in	(SRAM_data_out),
	.iSDRAM_busy_in	(ram_busy),
	.iCLK			(SYSTEM_CLK),
	.iRST			(KEY[0]),
	// Outputs
	.oXCLKIN		(CCD_XCLKIN),
	.oSRAM_addr		(CCD_SRAM_addr),
	.oSRAM_rd_Nwr	(CCD_SRAM_rd_Nwr),
	.oSRAM_data_out	(CCD_SRAM_data),
	.oSRAM_valid	(CCD_SRAM_valid),
	.oSDRAM_data	(CCD_SDRAM_data),
	.oSDRAM_addr	(CCD_SDRAM_addr),
	.oSDRAM_valid	(CCD_SDRAM_valid)
);

ccd_config_i2c camera_config (
	//	Host Side
	.iCLK			(SYSTEM_CLK),
	.iRST_N			(KEY[0]),
	.switches		(SW[15:0]),
	.restart		(!KEY[1]),
	//	I2C Side
	.I2C_SCLK		(CCD_SCLK),
	.I2C_SDAT		(CCD_SDAT),
	.done			(CCD_CONFIG_done)
);

stop_handler stopper (
	.iStop			(!KEY[2]),
	.iGo			(!KEY[1]),
	.iInterrupt		(stop_interrupt),
	.iCLK			(SYSTEM_CLK),
	.iRST			(KEY[0]),
	.oStop			(stop)
);

interrupt_trigger inter_trig (
	.iKey			(!KEY[3]),
	.iCLK			(SYSTEM_CLK),
	.iRST			(KEY[0]),
	.oInterrupt		(stop_interrupt)
);

bus_handler bus_interface (
	.iAddr			(addr_fexbus),
	.iBus_en		(bus_en_fexbus),
	.iByte_en		(byte_en_fexbus),
	.iRd_Nwr		(rw_fexbus),
	.iData			(data_fexbus),
	.iSRAM_data		(SRAM_data_out),
	.iSRAM_arbited	(arb_arbwin_tbus),
	.iSwitches		(SW[17:16]),
	.iCLK			(SYSTEM_CLK),
	.iRST			(KEY[0]),
	.oACK			(fbush_ACK_texbus),
	.oData			(fbush_data_texbus),
	.oSRAM_data		(fbush_SRAM_data),
	.oSRAM_addr		(fbush_SRAM_addr),
	.oSRAM_rd_Nwr	(fbush_SRAM_rd_Nwr),
	.oSRAM_byte_en	(fbush_SRAM_byte_en),
	.oSRAM_valid	(fbush_SRAM_valid)
);

sdram_write sdram_interface (
	.idata			(CCD_SDRAM_data),
	.iaddr			(CCD_SDRAM_addr),
	.ivalid			(CCD_SDRAM_valid),
	.iACK			(bridge_ack),
	.iCLK			(SYSTEM_CLK),
	.iRST			(KEY[0]),
	
	.oAddr			(tbridge_addr),
	.oRead			(tbridge_read),
	.oWrite			(tbridge_write),
	.oBE			(tbridge_be),
	.oData			(tbridge_data),
	.obusy			(ram_busy)
);

sram_arbiter sram_arbiter_ccd_bus (
	.iSRAM_addr_fccd	(CCD_SRAM_addr),
	.iSRAM_data_fccd	(CCD_SRAM_data),
	.iSRAM_rd_Nwr_fccd	(CCD_SRAM_rd_Nwr),
	.iSRAM_valid_fccd	(CCD_SRAM_valid),
	.iSRAM_addr_fbus	(fbush_SRAM_addr),
	.iSRAM_data_fbus	(fbush_SRAM_data),
	.iSRAM_rd_Nwr_fbus	(fbush_SRAM_rd_Nwr),
	.iSRAM_byte_en_fbus	(fbush_SRAM_byte_en),
	.iSRAM_valid_fbus	(fbush_SRAM_valid),
	.oSRAM_data_in		(arb_data_tSRAM),
	.oSRAM_addr			(arb_addr_tSRAM),
	.oSRAM_Nwr_en		(arb_Nwr_en_tSRAM),
	.oSRAM_Nout_en		(arb_Nout_en_tSRAM),
	.oSRAM_Nchip_en		(arb_Nchip_en_tSRAM),
	.oSRAM_Nbyte_en		(arb_Nbyte_en_tSRAM),
	.oArb_CCD			(arb_arbwin_tCCD),
	.oArb_bus			(arb_arbwin_tbus)
);

sram sram_interface (
	.oDATA			(SRAM_data_out),
	.iDATA			(arb_data_tSRAM),
	.iADDR			(arb_addr_tSRAM),
	.iWE_N			(arb_Nwr_en_tSRAM),
	.iOE_N			(arb_Nout_en_tSRAM),
	.iCE_N			(arb_Nchip_en_tSRAM),
	.iBE_N			(arb_Nbyte_en_tSRAM),
	//	SRAM
	.SRAM_DQ		(SRAM_DQ),
	.SRAM_ADDR		(SRAM_ADDR),
	.SRAM_UB_N		(SRAM_UB_N),
	.SRAM_LB_N		(SRAM_LB_N),
	.SRAM_WE_N		(SRAM_WE_N),
	.SRAM_CE_N		(SRAM_CE_N),
	.SRAM_OE_N		(SRAM_OE_N)
);

// led outputs
assign LEDG[0]		= stop;
assign LEDG[1]		= CCD_CONFIG_done;
assign LEDG[7]		= stop_interrupt;

// take care of some quartus warnings
assign GPIO_0[35:0] = 36'b0;
assign LEDG[6:2]	= 5'b0;
assign LEDG[8]		= 1'b0;
assign FL_RST_N		= 1'b1;
assign OTG_ADDR		= 2'b0;				//	ISP1362 Address 2 Bits
assign OTG_CS_N		= 1'b1;				//	ISP1362 Chip Select
assign OTG_RD_N		= 1'b1;				//	ISP1362 Write
assign OTG_WR_N		= 1'b1;				//	ISP1362 Read
assign OTG_RST_N	= 1'b1;				//	ISP1362 Reset
assign OTG_FSPEED	= 1'bz;				//	USB Full Speed,	0 = Enable, Z = Disable
assign OTG_LSPEED	= 1'bz;				//	USB Low Speed, 	0 = Enable, Z = Disable
assign OTG_DACK0_N	= 1'b1;				//	ISP1362 DMA Acknowledge 0
assign OTG_DACK1_N	= 1'b1;				//	ISP1362 DMA Acknowledge 1
assign UART_TXD		= 1'b0;				//	UART Transmitter
assign IRDA_TXD		= 1'b0;				//	IRDA Transmitter
assign TDO			= 1'b0;				//	FPGA -> CPLD (data out)
assign ENET_CMD		= 1'b0;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
assign ENET_CS_N	= 1'b1;				//	DM9000A Chip Select
assign ENET_WR_N	= 1'b1;				//	DM9000A Write
assign ENET_RD_N	= 1'b1;				//	DM9000A Read
assign ENET_RST_N	= 1'b1;				//	DM9000A Reset
assign ENET_CLK		= 1'b0;				//	DM9000A Clock 25 MHz
assign TD_RESET		= 1'b1;				//	TV Decoder Reset // enable the 27 MHz clock

endmodule
