
module avalon_ram (
	iSRAM_data,
	iSRAM_addr,
	iSRAM_rd_Nwr,
	iSRAM_valid,
	iSDRAM_data,
	iSDRAM_addr,
	iSDRAM_rd_Nwr,
	iSDRAM_valid,
	iACK,
	iCLK,
	iRST,
	
	oAddr,
	oRead,
	oWrite,
	oBE,
	oData,
	obusy
);

parameter	ST_BUSY	= 1'b0;
parameter	ST_IDLE	= 1'b1;

input		[17:0]	iSRAM_addr;
input				iSRAM_rd_Nwr;
input		[15:0]	iSRAM_data;
input				iSRAM_valid;
input		[15:0]	iSDRAM_data;		// data to write
input		[22:0]	iSDRAM_addr;		// where to write the data
input				iSDRAM_rd_Nwr;
input				iSDRAM_valid;		// data and addr are valid
input				iACK;				// ack bit from the bus/slave
input				iCLK;
input				iRST;

output	reg	[23:0]	oAddr;				// outputs for the bus
output	reg			oRead;
output	reg			oWrite;
output	reg	[1:0]	oBE;
output	reg	[15:0]	oData;
output	reg			obusy;				// we are currently doing a write, can't handle another

reg			[1:0]	state;
reg			[1:0]	next_state;
reg			[17:0]	SRAM_addr;
reg			[15:0]	SRAM_data;
reg					SRAM_rd_Nwr;
reg					SRAM_valid;
reg			[22:0]	SDRAM_addr;
reg			[15:0]	SDRAM_data;
reg					SDRAM_rd_Nwr;
reg					SDRAM_valid;
reg					ack;

	
always @(posedge iCLK or negedge iRST) begin
	
	if (!iRST) begin
		state	<= ST_IDLE;
		data	<= 16'b0;
		addr	<= 23'b0;

	end else begin
		ack		<= iACK;
		
		if (state == ST_IDLE && (iSRAM_valid || iSDRAM_valid) && !iACK) begin
			// We had a request in the last cycle, and we haven't
			// gotten an ack yet.
		
		if (state != ST_BUSY && (iSRAM_valid || iSDRAM_valid)) begin
			// We are not currently sending a request, and
			// we need to do an SRAM or SDRAM transaction.
			// Latch our inputs.
			SRAM_data		<= iSRAM_data;
			SRAM_addr		<= iSRAM_addr;
			SRAM_rd_Nwr		<= iSRAM_rd_Nwr;
			SRAM_valid		<= iSRAM_valid;
			SDRAM_data		<= iSDRAM_data;
			SDRAM_addr		<= iSDRAM_addr;
			SDRAM_rd_Nwr	<= iSDRAM_rd_Nwr;
			SDRAM_valid		<= iSDRAM_valid;

			state	<= ST_BUSY;
			iSRAM_data,

		end else begin
			state	<= next_state;
		end
	end
	
end

always @* begin
	
	// defaults
	oRead		= 1'b0;
	oWrite		= 1'b0;
	oBE			= 2'b11;
	obusy		= 1'b0;
	oAddr		= 24'b0;
	oData		= 16'b0;
	next_state	= ST_IDLE;
	
	if (state == ST_BUSY && !ack) begin
		// set up or keep the outputs for write operation
		if (SDRAM_valid == 1'b1) begin
			// SDRAM gets precedence
		
			// Check for a read or a write
			if (SDRAM_rd_Nwr == 1'b1) begin
				oRead	= 1'b1;
			end else begin
				oWrite	= 1'b1;
			end
			
			oAddr		= {1'b1, SDRAM_addr};		// prepend the 1'b1 to offset the addresses in the sdram
			oData		= SDRAM_data;
			
		end else if (SRAM_valid == 1'b1) begin
			// Check for a read or write
			if (SRAM_rd_Nwr == 1'b1) begin
				oRead	= 1'b1;
			end else begin
				oWrite	= 1'b1;
			end
			
			oAddr		= SRAM_addr;
			oData		= SRAM_data;
		
		end
			
		obusy		= 1'b1;
		next_state	= ST_BUSY;
		
	end else if (state == ST_BUSY && ack) begin
		// so we were sending the outputs and then we got an ack
		// the defaults are fine, we no longer want to do a transaction
		// but we need to still set busy high for this last cycle
		obusy		= 1'b1;
		next_state	= ST_IDLE;
	
	end else if (state == ST_IDLE) begin
		// The module is basically combinational here
		
		if (iSDRAM_valid == 1'b1) begin
			// SDRAM gets precedence
		
			// Check for a read or a write
			if (iSDRAM_rd_Nwr == 1'b1) begin
				oRead	= 1'b1;
			end else begin
				oWrite	= 1'b1;
			end
			
			oAddr		= {1'b1, iSDRAM_addr};		// prepend the 1'b1 to offset the addresses in the sdram
			oData		= iSDRAM_data;
			oBusy		= 1'b1;
			
		end else if (iSRAM_valid == 1'b1) begin
			// Check for a read or write
			if (iSRAM_rd_Nwr == 1'b1) begin
				oRead	= 1'b1;
			end else begin
				oWrite	= 1'b1;
			end
			
			oAddr		= iSRAM_addr;
			oData		= iSRAM_data;
		
		end
			
		obusy		= 1'b1;
		
		
	end
	
end

endmodule
		