// Signal an interrupt if the 4th button (KEY[3]) is pressed

module interrupt_trigger (
	iKey,
	iCLK,
	iRST,
	oInterrupt
);

input			iKey;
input			iCLK;
input			iRST;

output	reg		oInterrupt;		// goes high for 1 clock cycle when stop is asserted

reg				key;
reg		[15:0]	btn_count;

always @(posedge iCLK or negedge iRST) begin
	
	if (!iRST) begin
		oInterrupt	<= 1'b0;
		key			<= 1'b0;
		btn_count	<= 16'b0;
	end else begin
	
		if (iKey && !key && (btn_count == 16'b0)) begin
			key			<= 1'b1;
			btn_count	<= 16'b1;
		end else if (btn_count != 16'b0) begin
			key			<= 1'b1;
			btn_count	<= btn_count + 16'b1;
		end else begin
			key			<= 1'b0;
		end			
	
		// trigger the interrupt when key goes high
		if (key) begin
			oInterrupt	<= 1'b1;
		end else begin
			oInterrupt	<= 1'b0;
		end
	
	
		// Trigger an interrupt on a rising edge of done OR
		// on the first rising edge of key
//		if ((!oInterrupt && iDone) || key) begin
//			oInterrupt	<= 1'b1;
//		end else begin
//			oInterrupt	<= 1'b0;
//		end
	end
end

endmodule
