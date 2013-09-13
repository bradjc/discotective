
module sram_arbiter (
	iSRAM_addr_fccd,
	iSRAM_data_fccd,
	iSRAM_rd_Nwr_fccd,
	iSRAM_valid_fccd,
	iSRAM_addr_fbus,
	iSRAM_data_fbus,
	iSRAM_rd_Nwr_fbus,
	iSRAM_byte_en_fbus,
	iSRAM_valid_fbus,
	oSRAM_data_in,
	oSRAM_addr,
	oSRAM_Nwr_en,
	oSRAM_Nout_en,
	oSRAM_Nchip_en,
	oSRAM_Nbyte_en,
	oArb_CCD,
	oArb_bus
);

input		[17:0]	iSRAM_addr_fccd;
input		[15:0]	iSRAM_data_fccd;
input				iSRAM_rd_Nwr_fccd;
input				iSRAM_valid_fccd;
input		[17:0]	iSRAM_addr_fbus;
input		[15:0]	iSRAM_data_fbus;
input				iSRAM_rd_Nwr_fbus;
input		[1:0]	iSRAM_byte_en_fbus;
input				iSRAM_valid_fbus;

output	reg	[15:0]	oSRAM_data_in;
output	reg	[17:0]	oSRAM_addr;
output	reg			oSRAM_Nwr_en;
output	reg			oSRAM_Nout_en;
output	reg			oSRAM_Nchip_en;
output	reg	[1:0]	oSRAM_Nbyte_en;
output	reg			oArb_CCD;
output	reg			oArb_bus;

always @* begin
	
	oSRAM_data_in	= 16'b0;
	oSRAM_addr		= 18'b0;
	oSRAM_Nwr_en	= 1'b1;
	oSRAM_Nout_en	= 1'b1;
	oSRAM_Nchip_en	= 1'b1;
	oSRAM_Nbyte_en	= 2'b11;
	oArb_CCD		= 1'b0;
	oArb_bus		= 1'b0;
	
	// Just give priority to ccd
	
	if (iSRAM_valid_fccd == 1'b1) begin
		oSRAM_data_in	= iSRAM_data_fccd;
		oSRAM_addr		= iSRAM_addr_fccd;
		oSRAM_Nwr_en	= iSRAM_rd_Nwr_fccd;
		oSRAM_Nout_en	= ~iSRAM_rd_Nwr_fccd;
		oSRAM_Nchip_en	= 1'b0;
		oSRAM_Nbyte_en	= 2'b0;
		oArb_CCD		= 1'b1;
		
	end else if (iSRAM_valid_fbus == 1'b1) begin
		oSRAM_data_in	= iSRAM_data_fbus;
		oSRAM_addr		= iSRAM_addr_fbus;
		oSRAM_Nwr_en	= iSRAM_rd_Nwr_fbus;
		oSRAM_Nout_en	= ~iSRAM_rd_Nwr_fbus;
		oSRAM_Nchip_en	= 1'b0;
		oSRAM_Nbyte_en	= ~iSRAM_byte_en_fbus;
		oArb_bus		= 1'b1;
		
	end
	
end

endmodule
