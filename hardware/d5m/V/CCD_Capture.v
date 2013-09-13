// Watches the FRAME_VALID and LINE_VALID inputs to get pixels
// from the camera


module CCD_Capture(
	// Inputs
	iF_valid,
	iL_valid,
	iCam_data,
	iCapture,
	iSRAM_data_in,
	iCLK,
	iRST,
	// Outputs
	oXCLKIN,
	oSRAM_addr,
	oSRAM_rd_Nwr,
	oSRAM_data_out,
	oSDRAM_data,
	oSDRAM_addr,
	oSDRAM_valid
);

input			iF_valid;
input			iL_valid;
input	[11:0]	iCam_data;
input			iCapture;			// stop getting more images from the camera
input	[15:0]	iSRAM_data_in;
input			iCLK;
input			iRST;

output	reg			oXCLKIN;			// clk to drive the camera, 1/4 of iCLK
output	reg	[17:0]	oSRAM_addr;
output	reg			oSRAM_rd_Nwr;
output	reg	[15:0]	oSRAM_data_out;
output	reg	[15:0]	oSDRAM_data;
output	reg	[22:0]	oSDRAM_addr;
output	reg			oSDRAM_valid;

reg				clk_count;
reg		[2:0]	state;
reg		[2:0]	next_state;
reg				frame_valid;
reg				line_valid;
reg		[15:0]	x_count;
reg		[15:0]	x_count_next;
reg		[15:0]	y_count;
reg		[15:0]	y_count_next;
reg		[11:0]	CAM_data1;
reg		[11:0]	CAM_data2;
reg		[11:0]	CAM_data3;
reg		[15:0]	SRAM_data_n0;		// registers for the previous rows of camera data
reg		[15:0]	SRAM_data_n1;
reg		[15:0]	SRAM_data_n2;
reg		[15:0]	SRAM_data_n3;
reg		[15:0]	SRAM_data_n4;
reg		[15:0]	SRAM_data_n5;
reg		[7:0]	old_gray;			// saved value of previous converted pixel
reg				stop;				// set to one after iCapture is asserted

wire	[7:0]	gray_fr2g;

parameter 	ST_A	= 3'h0;
parameter 	ST_B	= 3'h1;
parameter 	ST_C	= 3'h2;
parameter 	ST_D	= 3'h3;
parameter	ST_STOP	= 3'h4;

parameter	COLUMN_WIDTH	= 16'd2592;

always@(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		clk_count		<= 1'b0;
		oXCLKIN			<= 1'b0;
		state			<= ST_A;
		x_count			<= 16'b0;
		y_count			<= 16'b0;
		SRAM_data_n0	<= 16'b0;
		SRAM_data_n1	<= 16'b0;
		SRAM_data_n2	<= 16'b0;
		SRAM_data_n3	<= 16'b0;
		SRAM_data_n4	<= 16'b0;
		SRAM_data_n5	<= 16'b0;
		old_gray		<= 8'b0;
		stop			<= 1'b0;
	end else begin
		// clock divider
		if (clk_count == 1'd1) begin
			clk_count	<= 1'b0;
			oXCLKIN		<= ~oXCLKIN;
		end else begin
			clk_count	<= clk_count + 1'b1;
		end
		
		if (state == ST_A) begin
			// This is the transistion from A to B
			// We need to save the data from the camera on this edge
		
			// Here we latch the current data from the camera and shift
			// the previous camera data values.
			// This allows us to save the three most recent samples for
			// converting to RGB and grayscale.
			CAM_data1	<= iCam_data;
			CAM_data2	<= CAM_data1;
			CAM_data3	<= CAM_data2;
			
			// We also need to save the values of the LINE_VALID
			// and FRAME_VALID signals.
			line_valid		<= iL_valid;
			frame_valid		<= iF_valid;
			
			// We also need to save the first response from the SRAM
			// and to shift the older values so we end up with 9
			SRAM_data_n2	<= iSRAM_data_in;
			SRAM_data_n1	<= SRAM_data_n2;
			SRAM_data_n0	<= SRAM_data_n1;
			
		end else if (state == ST_B) begin
			// This is the transition from B to C
			// We need to save another value from SRAM
			
			SRAM_data_n5	<= iSRAM_data_in;
			SRAM_data_n4	<= SRAM_data_n5;
			SRAM_data_n3	<= SRAM_data_n4;
			
		end else if (state == ST_C) begin
			// This is the transition from C to D
			
		end else if (state == ST_D) begin
			// This is the transition from D back to A
			old_gray		<= gray_fr2g;
		
		end
		
		if (iCapture) begin
			stop	<= 1'b1;
		end
		
			
		
		// Update the state.
		state		<= next_state;
		
		// Update the counters
		x_count		<= x_count_next;
		y_count		<= y_count_next;
	end
end

always @* begin
	
	// defaults
	oSRAM_addr		= 18'b0;
	oSRAM_rd_Nwr	= 1'b1;
	oSRAM_data_out	= 16'b0;
	oSDRAM_data		= 16'b0;
	oSDRAM_addr		= 23'b0;
	oSDRAM_valid	= 1'b0;
	x_count_next	= x_count;
	y_count_next	= y_count;
	next_state		= ST_A;
	
	if (state == ST_A) begin
	
		// SRAM
		// Calculate the address and tell the SRAM that it is a read.
		// x_count and y_count are the old values from the previous pixel input
		if (y_count >= 16'd1) begin
			// Read pixel number "2" according to the raw2gray diagram
			oSRAM_addr		= ((y_count - 16'd1) * 16'd2592) + x_count + 16'd1;
			oSRAM_rd_Nwr	= 1'b1;							// this is a read
		
		end
		
		next_state		= ST_B;
		
	end else if (state == ST_B) begin
	
		// SRAM
		// Calculate the address and tell the SRAM that it is a read.
		// x_count and y_count are the old values from the previous pixel input
		if (y_count >= 16'd1) begin
			// Read pixel number "5" according to the raw2gray diagram
			oSRAM_addr		= (y_count * 16'd2592) + x_count + 16'd1;
			oSRAM_rd_Nwr	= 1'b1;							// this is a read
		
		end
	
		// Determine if we have received a valid and usable pixel from the
		// camera.
		if (frame_valid) begin
			// We are receiving a frame from the camera
			if (line_valid) begin
				// We are receiving a line of that frame
				if (x_count < (COLUMN_WIDTH-1)) begin
					// We are still within the valid portion of that line
					x_count_next	= x_count + 16'b1;
					next_state		= ST_C;
					
				end else begin
					// We are now into the portion of the line that is padding
					// that we don't want to worry about.
					x_count_next	= 16'b0;
					y_count_next	= y_count + 16'b1;
					next_state		= ST_A;
				
				end
			end
		
		end else begin
			// FRAME_VALID is low, so we're in between images.
			// Basically a reset.
			x_count_next	= 16'b0;
			y_count_next	= 16'b0;
			next_state		= ST_A;
			
		end
		
		
		
	end else if (state == ST_C) begin
	
		// SRAM
		// Need to save the incoming value from the camera to the SRAM.
		// x_count and y_count are now the valid counts for the current pixel
		// Write pixel number "8" according to the raw2gray diagram
		oSRAM_addr		= (y_count * 16'd2592) + x_count;
		oSRAM_rd_Nwr	= 1'b0;
		oSRAM_data_out	= CAM_data1;
		
		next_state	= ST_D;
		
	end else if (state == ST_D) begin
	
		// SDRAM
		// Need to save the converted pixel value to the SDRAM
		// However we only save it when we are dealing with odd numbered
		// pixels in the x direction so we can combine 2 8 bit values
		if (x_count[0]) begin
			// This is an odd pixel so save it
			oSDRAM_data		= {gray_fr2g, old_gray};
			oSDRAM_addr		= (y_count * 16'd2592) + x_count;
			oSDRAM_valid	= 1'b1;
	
		end
		
		if (stop) begin
			next_state	= ST_STOP;
		end else begin
			next_state	= ST_A;
		end
	
	end else if (state == ST_STOP) begin
		next_state = ST_STOP;
	
	end
	
end


raw2gray raw_to_gray (
	// Inputs
	.iP_0	(SRAM_data_n0[11:0]),
	.iP_1	(SRAM_data_n1[11:0]),
	.iP_2	(SRAM_data_n2[11:0]),
	.iP_3	(SRAM_data_n3[11:0]),
	.iP_4	(SRAM_data_n4[11:0]),
	.iP_5	(SRAM_data_n5[11:0]),
	.iP_6	(CAM_data3[11:0]),
	.iP_7	(CAM_data2[11:0]),
	.iP_8	(CAM_data1[11:0]),
	.iX_LSB	(x_count[0]),
	.iY_LSB	(y_count[0]),
	// Outputs
	.oGray	(gray_fr2g)
);


endmodule
