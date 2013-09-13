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
reg		[12:0]	gray;

wire	[12:0]	P0;
wire	[12:0]	P1;
wire	[12:0]	P2;
wire	[12:0]	P3;
wire	[12:0]	P4;
wire	[12:0]	P5;
wire	[12:0]	P6;
wire	[12:0]	P7;
wire	[12:0]	P8;

assign P0	= {1'b0, iP_0};
assign P1	= {1'b0, iP_1};
assign P2	= {1'b0, iP_2};
assign P3	= {1'b0, iP_3};
assign P4	= {1'b0, iP_4};
assign P5	= {1'b0, iP_5};
assign P6	= {1'b0, iP_6};
assign P7	= {1'b0, iP_7};
assign P8	= {1'b0, iP_8};


always @* begin
	
	// there are a few cases depending on which color is in the center of the square
	// we can handle this by looking at whether we are in an odd or even column and row

	if (iX_LSB == 1'b0 && iY_LSB == 1'b0) begin
		// green is in the center, red in top middle
		red		= (P1 >> 1) + (P7 >> 1);
		green	= P4;
		blue	= (P3 >> 1) + (P5 >> 1);
		
	end else if (iX_LSB == 1'b1 && iY_LSB == 1'b0) begin
		// blue is in the middle
		red		= (P0 >> 2) + (P2 >> 2) + (P6 >> 2) + (P8 >> 2);
		green	= (P1 >> 2) + (P3 >> 2) + (P5 >> 2) + (P7 >> 2);
		blue	= P4;
		
	end else if (iX_LSB == 1'b0 && iY_LSB == 1'b1) begin
		// red is in the middle
		red		= P4;
		blue	= (P0 >> 2) + (P2 >> 2) + (P6 >> 2) + (P8 >> 2);
		green	= (P1 >> 2) + (P3 >> 2) + (P5 >> 2) + (P7 >> 2);
		
	end else begin
		// green is in the middle, blue in top middle
		red		= (P3 >> 1) + (P5 >> 1);
		green	= P4;
		blue	= (P1 >> 1) + (P7 >> 1);
	
	end
	
	gray = (red >> 3) + (green >> 2) + (green >> 1) + (blue >> 3);
	
	oGray = gray[11:4];
		
end

endmodule