// Watches the FRAME_VALID and LINE_VALID inputs to get pixels
// from the camera


module ccd_capture_fast (
	// Inputs
	iF_valid,
	iL_valid,
	iCam_data,
	iRun,
	iStop,
	iSDRAM_busy_in,
	iCLK,
	iRST,
	switches,
	// Outputs
	oXCLKIN,
	oSDRAM_data,
	oSDRAM_addr,
	oSDRAM_valid
);

input				iF_valid;			// FRAME_VALID signal from camera
input				iL_valid;			// LINE_VALID signal from camera
input		[11:0]	iCam_data;			// data bits from the camera
input				iRun;				// if stopped, asserting this will start storing images again
input				iStop;				// stop getting more images from the camera
input				iSDRAM_busy_in;		// whether or not the sdram is busy sending data and can't accept new data
input				iCLK;
input				iRST;
input		[1:0]	switches;

output				oXCLKIN;			// clk to drive the camera, 1/4 of iCLK
output	reg	[15:0]	oSDRAM_data;
output	reg	[22:0]	oSDRAM_addr;
output	reg			oSDRAM_valid;

reg					frame_valid;
reg					line_valid;
reg			[15:0]	x_count;
reg			[15:0]	x_count_next;
reg			[15:0]	y_count;
reg			[15:0]	y_count_next;
reg			[11:0]	CAM_data;
reg			[11:0]	CAM_data_old;
reg					stop;				// set to one after iCapture is asserted
reg					stop_image;


parameter	COLUMN_WIDTH	= 16'd2592;

assign oXCLKIN	= iCLK;

always@(negedge iCLK or negedge iRST) begin
	if (!iRST) begin
		CAM_data		<= 12'b0;
		CAM_data_old	<= 12'b0;
		line_valid		<= 1'b0;
		frame_valid		<= 1'b0;
		stop			<= 1'b0;
		stop_image		<= 1'b0;
		x_count			<= 16'b0;
		y_count			<= 16'b0;
		
	end else begin
		// Always save the information from the camera on the negedge.
		CAM_data		<= iCam_data;
		CAM_data_old	<= CAM_data;
		line_valid		<= iL_valid;
		frame_valid		<= iF_valid;
		
		x_count			<= x_count_next;
		
		if (line_valid && !iL_valid) begin
			// We hit a falling edge of LINE_VALID. Now is the time to update
			// y_count.
			y_count		<= y_count_next;
		end else if (!iF_valid) begin
			// We need a reset for y_count and this is where it has to be.
			// If we're not in a frame then reset y_count.
			y_count		<= 16'b0;
			if (stop) begin
				stop_image	<= 1'b1;
			end else begin
				stop_image	<= 1'b0;
			end
		end
		
		if (iRun) begin
			stop	<= 1'b0;
		end else if (iStop) begin
			stop	<= 1'b1;
		end
		
	end
	
end

always @* begin
	
	oSDRAM_valid	= 1'b0;
	x_count_next	= x_count;
	y_count_next	= y_count + 16'b1;
	oSDRAM_data		= 16'b0;
	oSDRAM_addr		= 23'b0;
	
	// Determine if we have received a valid and usable pixel from the
	// camera.
	if (frame_valid) begin
		// We are receiving a frame from the camera
		if (line_valid) begin
			// We are receiving a line of that frame
			if (x_count < COLUMN_WIDTH) begin
				// We are still within the valid portion of that line
				// This makes x_count 1 greater than the actual pixel value
				// for states ST_C and ST_D
				x_count_next	= x_count + 16'b1;
				
			end else begin
				// We are now into the portion of the line that is padding
				// that we don't want to worry about.
				// Set in_image to false so we don't keep handling bad
				// pixels. When we get a rising edge of line_valid set in_image
				// back high.
				x_count_next	= 16'b0;
			
			end
		end else begin
			// LINE_VALID is low
			x_count_next	= 16'b0;
		end
	
	end else begin
		// FRAME_VALID is low, so we're in between images.
		// Basically a reset.
		x_count_next	= 16'b0;
		y_count_next	= 16'b0;
		
	end
	
	if (x_count[0] && !stop_image) begin
		// This is an odd pixel so save it
		oSDRAM_data		= {CAM_data[11:4], CAM_data_old[11:4]};

		oSDRAM_addr		= ({7'b0, y_count} * 23'd2592) + ({7'b0, x_count} - 23'd1);
		oSDRAM_valid	= 1'b1;
	end
end
/*
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
		line_valid_ed	<= 1'b0;
		in_image		<= 1'b0;
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
			CAM_data1		<= iCam_data;
			CAM_data2		<= CAM_data1;
			CAM_data3		<= CAM_data2;
			
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
		
		// Handle stopping and starting
		if (iRun) begin
			stop	<= 1'b0;
		end else if (iStop) begin
			stop	<= 1'b1;
		end
		
		// Check for LINE_VALID edges and other conditions.
		if (!line_valid_ed && iL_valid) begin
			// We hit a rising edge of LINE_VALID.
			in_image	<= 1'b1;
			
		end else if (line_valid_ed && !iL_valid) begin
			// We hit a falling edge of LINE_VALID.
			// Update y_count
			in_image	<= 1'b0;
			
		end else if (!next_in_image) begin
			// We reached the end of the valid pixels in a line. Set in_image
			// low until we hit the next rising edge.
			in_image	<= 1'b0;
			
		end
		
		if (line_valid_ed && !iL_valid) begin
			// We hit a falling edge of LINE_VALID. Now is the time to update
			// y_count.
			y_count		<= y_count_next;
		end else if (!iF_valid) begin
			// We need a reset for y_count and this is where it has to be.
			// If we're not in a frame then reset y_count.
			y_count		<= 16'b0;
		end
		
		// save line_valid for edge detector
		line_valid_ed	<= iL_valid;
		
		// Update the state.
		state		<= next_state;
		
		// Update the counters
		x_count		<= x_count_next;
	//	y_count		<= y_count_next;
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
	y_count_next	= y_count + 16'd1;
	next_in_image	= in_image;
	next_state		= ST_A;
	
	if (state == ST_A) begin
	
		// SRAM
		// READ0
		// Calculate the address and tell the SRAM that it is a read.
		// x_count and y_count are correct for the current pixel input
		// Read pixel number "2" according to the raw2gray diagram.
		// This is a little complicated. Basically the last 4 rows of RAW
		// data from the camera is stored in SRAM, although we only want to
		// save the current row and look up the two before that. The reason
		// for storing four rows instead of three is it is easy to just use
		// the lowest 2 bits to index the rows. The rows are stored in a
		// circular fashion. Based on the current row we can determine which
		// row we need to look up. The "row" is distinguished by bits [17:16]
		// of the SRAM address.
		// CURRENT_ROW	WRITE_TO	READ0	READ1
		// 00			00			10		11
		// 01			01			11		00
		// 10			10			00		01
		// 11			11			01		10
		//
		// CURRENT_ROW	= bits [1:0] of y_count
		// WRITE_TO		= which "row" in sram to write the current RAW data to
		// READ0		= which "row" to use for pixel number "2"
		// READ1		= which "row" to use for pixel number "5"
		
		oSRAM_addr		= {~y_count[1], y_count[0], x_count};
		oSRAM_rd_Nwr	= 1'b1;
		
		next_state		= ST_B;
		
	end else if (state == ST_B) begin
	
		// SRAM
		// READ1
		// Calculate the address and tell the SRAM that it is a read.
		// x_count and y_count are correct for the current pixel
		// See ST_A's comments for a description of what is going on.
		// Read pixel number "5" according to the raw2gray diagram
		
		oSRAM_addr		= {(y_count[0] ~^ y_count[1]), ~y_count[0], x_count};
		oSRAM_rd_Nwr	= 1'b1;
		
	
		// Determine if we have received a valid and usable pixel from the
		// camera.
		if (frame_valid) begin
			// We are receiving a frame from the camera
			if (line_valid) begin
				// We are receiving a line of that frame
				if (x_count < COLUMN_WIDTH && in_image) begin
					// We are still within the valid portion of that line
					// This makes x_count 1 greater than the actual pixel value
					// for states ST_C and ST_D
					x_count_next	= x_count + 16'b1;
					next_state		= ST_C;
					
				end else begin
					// We are now into the portion of the line that is padding
					// that we don't want to worry about.
					// Set in_image to false so we don't keep handling bad
					// pixels. When we get a rising edge of line_valid set in_image
					// back high.
					x_count_next	= 16'b0;
				//	y_count_next	= y_count + 16'b1;
					next_in_image	= 1'b0;
					next_state		= ST_A;
				
				end
			end else begin
				// LINE_VALID is low
				x_count_next	= 16'b0;
			end
		
		end else begin
			// FRAME_VALID is low, so we're in between images.
			// Basically a reset.
			x_count_next	= 16'b0;
			y_count_next	= 16'b0;
			
			if (stop) begin
				// Stop gets set whenever key2 is pressed and stays high.
				// Since we're at the end of frame now is the time to stop.
				next_state	= ST_STOP;
			end else begin
				// Otherwise just start the loop over again.
				next_state	= ST_A;
			end
			
		end
		
		
		
	end else if (state == ST_C) begin
	
		// SRAM
		// Need to save the incoming value from the camera to the SRAM.
		// x_count is one greater than the current pixel.
		// y_count is correct.
		// Write pixel number "8" according to the raw2gray diagram
		// Use the lower 2 bits of y_count to pick the row.
		// The previous raw data is somewhat scattered in SRAM.
		oSRAM_addr		= {y_count[1:0], (x_count - 16'd1)};
		oSRAM_rd_Nwr	= 1'b0;
		oSRAM_data_out	= {4'b0, CAM_data1};
		
		next_state	= ST_D;
		
	end else if (state == ST_D) begin
	
		// SDRAM
		// Need to save the converted pixel value to the SDRAM.
		// However we only save it when we are dealing with odd numbered
		// pixels in the x direction so we can combine 2 8 bit values.
		// At this point x_count is 1 greater than the 0 indexed pixel we're on.
		// Use x_count-2 because x_count is set to 1 on the first pixel, not 0, and
		// we want to do byte addressing
		if (!x_count[0]) begin
			// This is an odd pixel so save it
			oSDRAM_data		= {gray_fr2g, old_gray};
		//	if (x_count > 16'd255) begin
		//		oSDRAM_data	= 16'b0;
		//	end else begin
		//		oSDRAM_data		= {x_count[7:1], 1'b1, x_count[7:0]};
		//	end
		//	oSDRAM_data		= 16'd3000;
			oSDRAM_addr		= ({7'b0, y_count} * 23'd2592) + ({7'b0, x_count} - 23'd2);
			oSDRAM_valid	= 1'b1;
	
		end
		
		
	
	end else if (state == ST_STOP) begin
		if (stop) begin
			// Just loop here to stop
			next_state = ST_STOP;
		
		end else begin
			next_state		= ST_A;
			x_count_next	= 16'b0;
			y_count_next	= 16'b0;
			next_in_image	= 1'b0;
		end
	
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
	.iX_LSB	(!x_count[0]),
	.iY_LSB	(y_count[0]),
	.switches (switches),
	// Outputs
	.oGray	(gray_fr2g)
);

*/
endmodule
