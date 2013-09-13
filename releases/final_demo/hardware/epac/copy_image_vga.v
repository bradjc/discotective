
module copy_image_vga (
	iGo,
	iACK,
	iCLK,
	iRST,
	oSDRAM_data,
	oSDRAM_addr,
	oSDRAM_
	oSDRAM_valid
);

input				iGo;
input				iACK;
input				iCLK;
input				iRST;

output	reg	[15:0]	oSDRAM_data;
output	reg	[22:0]	oSDRAM_addr;
output	reg			oSDRAM_valid;

reg			[1:0]	state;
reg			[1:0]	next_state;

always @(posedge iCLK or negedge iRST) begin

	if (!iRST) begin
		go	<= 1'b0;
		x_count	<= 16'b0;
		y_count	<= 16'b0;
		state	<= ST_READ;
	end else begin
	
		// wait for iGo to be high
		if (iGo) begin
			go	<= 1'b1;
		end
		
		x_count	<= x_count_next;
		y_count	<= y_count_next;
		
	end
	
end

always @* begin
	
	oSDRAM_data		= 16'b0;
	oSDRAM_addr		= 23'b0;
	oSDRAM_valid	= 1'b0;
	x_count_next	= x_count + 16'd4;
	y_count_next	= y_count + 16'd4;
	next_state		= ST_READ;
	
	if (go) begin
	
		if (state == ST_READ) begin
			
		
		
		