
module sdram_write (
	idata,
	iaddr,
	ivalid,
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

input		[15:0]	idata;			// data to write
input		[23:0]	iaddr;			// where to write the data
input				ivalid;			// data and addr are valid
input				iACK;			// ack bit from the bus/slave
input				iCLK;
input				iRST;

output	reg	[23:0]	oAddr;			// outputs for the bus
output	reg			oRead;
output	reg			oWrite;
output	reg	[1:0]	oBE;
output	reg	[15:0]	oData;
output	reg			obusy;			// we are currently doing a write, can't handle another

reg			[1:0]	state;
reg			[1:0]	next_state;
reg			[23:0]	addr;
reg			[15:0]	data;
reg					ack;

	
always @(posedge iCLK or negedge iRST) begin
	
	if (!iRST) begin
		state	<= ST_IDLE;
		data	<= 16'b0;
		addr	<= 24'b0;

	end else begin
		ack		<= iACK;
		
		if (state != ST_BUSY && ivalid) begin
			// we are not currently sending a request and we got data from the outside
			// latch our inputs
			data	<= idata;
			addr	<= iaddr;
			state	<= ST_BUSY;
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
		oWrite		= 1'b1;
		oAddr		= addr;
		oData		= data;
		obusy		= 1'b1;
		next_state	= ST_BUSY;
		
	end else if (state == ST_BUSY && ack) begin
		// so we were sending the outputs and then we got an ack
		// the defaults are fine, we no longer want to do a transaction
		// but we need to still set busy high for this last cycle
		obusy		= 1'b1;
		next_state	= ST_IDLE;
	
	end else if (state == ST_IDLE) begin
		// defaults are fine
	end
	
end

endmodule
		