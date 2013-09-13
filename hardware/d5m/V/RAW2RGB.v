// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	RAW2RGB
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny FAN        :| 07/07/09  :| Initial Revision
// --------------------------------------------------------------------

module RAW2RGB(	oRed,
				oGreen,
				oBlue,
				oDVAL,
				iX_Cont,
				iY_Cont,
				iDATA,
				iDVAL,
				iCLK,
				iRST
				);

input	[10:0]	iX_Cont;
input	[10:0]	iY_Cont;
input	[11:0]	iDATA;
input			iDVAL;
input			iCLK;
input			iRST;
output	[11:0]	oRed;
output	[11:0]	oGreen;
output	[11:0]	oBlue;
output			oDVAL;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[11:0]	mCCD_R;
reg		[12:0]	mCCD_G;
reg		[11:0]	mCCD_B;
reg				mDVAL;

reg				valid_section_x;
reg				valid_section_y;

reg		[11:0]	x_count;
reg		[11:0]	y_count;

assign	oRed	=	mCCD_R[11:0];
assign	oGreen	=	mCCD_G[12:1];
assign	oBlue	=	mCCD_B[11:0];
assign	oDVAL	=	mDVAL;


Line_Buffer 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_1),
						.taps1x(mDATA_0)	);

/*						
Line_Buffer 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_0),
						.taps1x(mDATA_1)	);*/

always@(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		valid_section_x	<=	1'b0;
		valid_section_y	<=	1'b0;
		y_count	<=	12'b0;
		
	end else begin
		if (iY_Cont == 11'b0 && iX_Cont == 11'b0) begin
			// were at the beginning of a frame
			valid_section_x	<=	1'b1;
			valid_section_y	<=	1'b1;
		
		end else begin
			if (x_count >= 12'd640) begin
				// were done with this line
				valid_section_x	<=	1'b0;
				y_count	<=	y_count + 1;
				
			end else if (x_count == 12'b0) begin
				// new line, so lets get converting!
				valid_section_x	<=	1'b1;
				
			end
			
			if (y_count >= 12'd480) begin
				// were done with this frame
				valid_section_y	<=	1'b0;
			end
		end
	end
end
			
						
always@(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		mCCD_R	<=	12'b0;
		mCCD_G	<=	13'b0;
		mCCD_B	<=	12'b0;
		mDATAd_0<=	12'b0;
		mDATAd_1<=	12'b0;
		mDVAL	<=	12'b0;
		
		x_count	<=	12'b0;
	
	end else begin
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		
		// this is where it gets downsampled
		// the valid out is set low every odd row and odd column
		mDVAL		<=	{iY_Cont[0] | iX_Cont[0] | !valid_section_x | !valid_section_y}	?	1'b0	:	iDVAL;
		
		if({iY_Cont[0], iX_Cont[0]} == 2'b10) begin
			// odd row, even column
			mCCD_R	<=	mDATA_0;
			mCCD_G	<=	mDATAd_0 + mDATA_1;
			mCCD_B	<=	mDATAd_1;
		
		end else if({iY_Cont[0], iX_Cont[0]} == 2'b11) begin
			mCCD_R	<=	mDATAd_0;
			mCCD_G	<=	mDATA_0+mDATAd_1;
			mCCD_B	<=	mDATA_1;
		
		// this is the only block that matters
	/*	end else if({iY_Cont[0], iX_Cont[0]} == 2'b00) begin
			mCCD_R	<=	mDATA_1;
			mCCD_G	<=	mDATA_0 + mDATAd_1;
			mCCD_B	<=	mDATAd_0;*/
		
		end else if({iY_Cont[0], iX_Cont[0]} == 2'b00) begin
			mCCD_R	<=	mDATA_1;
			mCCD_G	<=	mDATA_0 + mDATAd_1;
			mCCD_B	<=	mDATAd_0;
			x_count	<=	x_count + 1;
		
	/*	end else if({iY_Cont[0], iX_Cont[0]} == 2'b00) begin
			mCCD_R	<=	12'h1D0;
			mCCD_G	<=	13'h710;
			mCCD_B	<=	12'h2A0;*/
		
		end else if({iY_Cont[0], iX_Cont[0]} == 2'b01) begin
			mCCD_R	<=	mDATAd_1;
			mCCD_G	<=	mDATAd_0+mDATA_1;
			mCCD_B	<=	mDATA_0;
		end
	end
end

endmodule
