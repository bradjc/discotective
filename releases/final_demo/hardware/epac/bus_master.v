
module bus_master (
	iACK,
	iData,
	iCLK,
	iRST,
	
	oAddr,
	oRead,
	oWrite,
	oBE,
	oData
);

parameter	ST_SEND	= 1'b0;
parameter	ST_DONE	= 1'b1;

input				iACK;
input		[15:0]	iData;
input				iCLK;
input				iRST;

output	reg	[23:0]	oAddr;
output	reg			oRead;
output	reg			oWrite;
output	reg	[1:0]	oBE;
output	reg	[15:0]	oData;

reg			[1:0]	state;
reg			[1:0]	next_state;
reg			[23:0]	sdram_addr;
reg			[23:0]	next_sdram_addr;
reg			[15:0]	saving_data;
reg			[15:0]	next_saving_data;

reg					ack;

	
always @(posedge iCLK or negedge iRST) begin
	
	if (!iRST) begin
		state		<= ST_SEND;
		sdram_addr	<= 24'h800000;
		saving_data	<= 16'h1111;
	
	end else begin
		ack		<= iACK;
		state	<= next_state;
		
		if (ack) begin
			// if we got an ack last cycle update addr and data
			saving_data	<= next_saving_data;
			sdram_addr	<= next_sdram_addr;
		end
		
	end
	
end

always @* begin

	oAddr	= sdram_addr;
	oRead	= 1'b0;
	oWrite	= 1'b1;
	oBE		= 2'b11;
	oData	= saving_data;
	
	next_saving_data	= saving_data + 16'h1;
	next_sdram_addr		= sdram_addr + 24'h2;
	
	next_state	= ST_SEND;
	

	if (state == ST_SEND) begin
		if (ack) begin
			// wait a cycle
			oWrite		= 1'b0;
			if (sdram_addr >= 24'h800FFF) begin
				next_state	= ST_DONE;
			end
		end
		
	end else begin
		oWrite		= 1'b0;
		next_state	= ST_DONE;
	end
	
end

endmodule
		