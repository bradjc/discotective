
module wait_for_interrupt_custom_instruction (
	clk,
	reset,
	clk_en,
	start,
	interrupt,
	result,
	done
);


input				clk;
input				reset;
input				clk_en;
input				start;
input				interrupt;
output		[31:0]	result;
output				done;

reg					got_interrupt;

assign done	= got_interrupt;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		got_interrupt		<= 1'b0;
	end else begin
		if (!clk_en) begin
			got_interrupt	<= 1'b0;
		end else if (got_interrupt) begin
			got_interrupt	<= 1'b0;
		end else if (interrupt) begin
			got_interrupt	<= 1'b1;
		end
	end
end

endmodule
