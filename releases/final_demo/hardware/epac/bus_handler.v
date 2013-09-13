
module bus_handler (
	iAddr,
	iBus_en,
	iByte_en,
	iRd_Nwr,
	iData,
	iSRAM_arbited,
	iSRAM_data,
	iSwitches,
	iCLK,
	iRST,
	oACK,
	oData,
	oSRAM_data,
	oSRAM_addr,
	oSRAM_rd_Nwr,
	oSRAM_byte_en,
	oSRAM_valid
);

input		[19:0]	iAddr;
input				iBus_en;
input		[1:0]	iByte_en;
input				iRd_Nwr;
input		[15:0]	iData;
input		[15:0]	iSRAM_data;
input				iSRAM_arbited;
input		[1:0]	iSwitches;
input				iCLK;
input				iRST;

output	reg			oACK;
output	reg	[15:0]	oData;
output	reg	[15:0]	oSRAM_data;
output	reg	[17:0]	oSRAM_addr;
output	reg			oSRAM_rd_Nwr;
output	reg	[1:0]	oSRAM_byte_en;
output	reg			oSRAM_valid;

reg			[19:0]	addr;
reg			[1:0]	byte_en;
reg					rd_Nwr;
reg			[15:0]	data;
reg			[15:0]	temp_SRAM_data;
reg			[15:0]	temp_SRAM_data2;

reg			[2:0]	state;
reg			[2:0]	next_state;

parameter	ST_IDLE			= 3'h0;
parameter	ST_START		= 3'h1;
parameter	ST_SRAM_MISA	= 3'h2;
parameter	ST_SRAM_DONE	= 3'h3;
parameter	ST_DONE			= 3'h4;
parameter	ST_SWITCHES		= 3'h5;

parameter	SRAM_ADDR_START	= 20'h00000;
parameter	SRAM_ADDR_END	= 20'h80000;
parameter	SWITCHES_ADDR	= 20'h90000;


always @(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		addr			<= 20'b0;
		byte_en			<= 2'b0;
		rd_Nwr			<= 1'b0;
		data			<= 16'b0;
		temp_SRAM_data	<= 16'b0;
		temp_SRAM_data2	<= 16'b0;
		state			<= ST_IDLE;

	end else begin
		if (state == ST_IDLE) begin
			addr	<= iAddr[17:0];
			byte_en	<= iByte_en;
			rd_Nwr	<= iRd_Nwr;
			data	<= iData;
			if (iBus_en == 1'b1 && iByte_en != 2'b00) begin
				state	<= ST_START;
			end
		
		end else if (state == ST_START) begin
			// During ST_START we prepared the outputs to SRAM.
			// Now this is the transition from ST_START and we need to
			// save what we are getting back from SRAM.
		
			temp_SRAM_data		<= iSRAM_data;
			
			if (next_state == ST_IDLE) begin
				// don't need to go through the SRAM steps
				state	<= ST_IDLE;
			end else if (next_state == ST_SWITCHES) begin
				state	<= ST_SWITCHES;
			end else if (iSRAM_arbited == 1'b1) begin
				// move on
				state	<= next_state;
			end else begin
				// we need to repeat this
				state	<= ST_START;
			end
				
			
		end else if (state == ST_SRAM_MISA) begin
			// We had to a misaligned access and just sent the outputs for
			// the second half.
			// Save the first half of the data (yes this could have been a
			// write, but this will work just fine
			temp_SRAM_data2		<= iSRAM_data;
			
			// arbitration check
			if (iSRAM_arbited == 1'b1) begin
				// move on
				state	<= ST_SRAM_DONE;
			end else begin
				// we need to repeat this
				state	<= ST_SRAM_MISA;
			end
			
		end else if (state == ST_SRAM_DONE) begin
			state			<= ST_IDLE;
			
		end else if (state == ST_SWITCHES) begin
			state			<= ST_IDLE;
			
		end else if (state == ST_DONE) begin
			state			<= ST_IDLE;
			
		end else begin
			// basically a reset/catch
			state			<= ST_IDLE;
		end
		
	end
end

always @* begin
	
	oSRAM_data		= 16'b0;
	oSRAM_rd_Nwr	= 1'b0;
	oSRAM_addr		= 18'b0;
	oSRAM_byte_en	= 2'b0;
	oSRAM_valid		= 1'b0;
	oACK			= 1'b0;
	oData			= 16'b0;

	next_state		= ST_IDLE;
	
	
	if (state == ST_START) begin
		// We got in valid data from the bus or lost arbitration and need to repeat
		
		if (addr >= SRAM_ADDR_START && addr <= SRAM_ADDR_END) begin	
			// This is an SRAM transaction
			
			oSRAM_data		= data;
			oSRAM_rd_Nwr	= rd_Nwr;
			oSRAM_valid		= 1'b1;
			
			if (addr[0] == 1'b1) begin
				// not word aligned
				
				if (byte_en[1:0] == 2'b01) begin
					// bytes: 01 23
					// they want byte 1
					oSRAM_addr		= {addr[17:1], 1'b0};
					oSRAM_byte_en	= 2'b10;
					
					next_state		= ST_DONE;
					
				end else if (byte_en[1:0] == 2'b10) begin
					// bytes: 01 23
					// this gave us the address of byte 1, but they want byte 2
					oSRAM_addr		= addr[17:0] + 18'b1;
					oSRAM_byte_en	= 2'b01;
					
					next_state		= ST_DONE;
					
				end else if (byte_en[1:0] == 2'b11) begin
					// bytes: 01 23
					// They want bytes 1 and 2.
					// This requires two reads.
					oSRAM_addr		= {addr[17:1], 1'b0};
					oSRAM_byte_en	= 2'b10;
					oSRAM_data		= {data[7:0], 8'b0};
					
					next_state		= ST_SRAM_MISA;
					
				end
			
			end else begin
				// word aligned
				// We can just pass through the request.
				oSRAM_addr		= addr[17:0];
				oSRAM_byte_en	= byte_en;
				
				next_state		= ST_DONE;
			end
			
		end else if (addr == SWITCHES_ADDR) begin
			// respond with the switch values
		//	oData		= {6'b0, iSwitches};
		//	oACK		= 1'b1;
			next_state	= ST_SWITCHES;
		end
		
	end else if (state == ST_SRAM_MISA) begin
		// We need to set up the second half of the misaligned SRAM
		// access.
		oSRAM_addr		= addr[17:0] + 18'b1;
		oSRAM_byte_en	= 2'b01;
		oSRAM_data		= {8'b0, data[15:8]};
		oSRAM_rd_Nwr	= rd_Nwr;
		oSRAM_valid		= 1'b1;
		
	end else if (state == ST_SRAM_DONE) begin
		// set the outputs for the misaligned SRAM access.
		oACK	= 1'b1;
		oData	= {temp_SRAM_data2[7:0], temp_SRAM_data[15:8]};
		
	end else if (state == ST_SWITCHES) begin
		oData	= {14'b0, iSwitches};
		oACK	= 1'b1;
		
	end else if (state == ST_DONE) begin
		// set the outputs
		oACK	= 1'b1;
		oData	= temp_SRAM_data;
		
	end
	
end		
	
endmodule
