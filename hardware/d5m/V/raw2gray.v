// raw2rgb.v
//
// A combinational module that computes the gray scale value for a pixel
// when given the 9 pixel square around it.
//
// 1.	Converts to RGB by using bilinear interpolation
// 2.	Converts to 8 bit grayscale by using Y = 0.2989 * R + 0.5870 * G + 0.1140 * B
//
// input raw pixels:
//  2 | 1 | 0  
// -----------
//  5 | 4 | 3
// -----------
//  8 | 7 | 6
//

module raw2gray(
	// Inputs
	iP_0,
	iP_1,
	iP_2,
	iP_3,
	iP_4,
	iP_5,
	iP_6,
	iP_7,
	iP_8,
	iX_LSB,
	iY_LSB,
	// Outputs
	oGray
);

input	[11:0]	iP_0;
input	[11:0]	iP_1;
input	[11:0]	iP_2;
input	[11:0]	iP_3;
input	[11:0]	iP_4;
input	[11:0]	iP_5;
input	[11:0]	iP_6;
input	[11:0]	iP_7;
input	[11:0]	iP_8;
input			iX_LSB;
input			iY_LSB;

output	reg	[7:0]	oGray;

reg		[12:0]	red;
reg		[12:0]	green;
reg		[12:0]	blue;
reg		[11:0]	gray;


always @* begin
	
	// there are a few cases depending on which color is in the center of the square
	// we can handle this by looking at whether we are in an odd or even column and row
	
	if (iX_LSB == 1'b0 && iY_LSB == 1'b0) begin
		// green is in the center, red in top middle
		red		= (iP_1 + iP_7) / 13'd2;
		green	= (iP_0 + iP_2 + iP_4 + iP_6 + iP_8) / 13'd5;
		blue	= (iP_3 + iP_5) / 13'd2;
		
	end else if (iX_LSB == 1'b1 && iY_LSB == 1'b0) begin
		// blue is in the middle
		red		= (iP_0 + iP_2 + iP_6 + iP_8) / 13'd4;
		green	= (iP_1 + iP_3 + iP_5 + iP_7) / 13'd4;
		blue	= iP_4;
		
	end else if (iX_LSB == 1'b0 && iY_LSB == 1'b1) begin
		// red is in the middle
		red		= iP_4;
		blue	= (iP_0 + iP_2 + iP_6 + iP_8) / 13'd4;
		green	= (iP_1 + iP_3 + iP_5 + iP_7) / 13'd4;
		
	end else begin
		// green is in the middle, blue in top middle
		red		= (iP_3 + iP_5) / 13'd2;
		green	= (iP_0 + iP_2 + iP_4 + iP_6 + iP_8) / 13'd5;
		blue	= (iP_1 + iP_7) / 13'd2;
	
	end
	
	// now convert to gray scale
	gray = (red[11:0] >> 2) + (green[11:0] >> 1) + (blue[11:0] >> 2);
	
	oGray = gray[11:4];
	
end

endmodule
