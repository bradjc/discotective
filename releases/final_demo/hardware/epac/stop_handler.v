
// oStop is low to start
// if iStop, oStop goes high
// if iGo, oStop goes back low

module stop_handler (
	iStop,
	iGo,
	iInterrupt,
	iCLK,
	iRST,
	oStop
);

input		iStop;
input		iGo;
input		iInterrupt;
input		iCLK;
input		iRST;

output	reg	oStop;

reg			permanent;


always @(posedge iCLK or negedge iRST) begin
	
	if (!iRST) begin
		oStop		<= 1'b0;
		permanent	<= 1'b0;
	end else begin
		if (iStop || permanent) begin
			oStop	<= 1'b1;
		end else if (iGo) begin
			oStop	<= 1'b0;
		end
		
		// if the interrupt is triggered, you're not allowed to
		// start taking images again.
		if (iInterrupt) begin
			permanent	<= 1'b1;
		end
	end
end

endmodule
