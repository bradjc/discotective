// cpu_0_wait_for_interrupt_custom_instruction_inst.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module cpu_0_wait_for_interrupt_custom_instruction_inst (
		input  wire  clk,       // nios_custom_instruction_slave_0.clk
		input  wire  reset,     //                                .reset
		input  wire  clk_en,    //                                .clk_en
		input  wire  start,     //                                .start
		output wire  done,      //                                .done
		input  wire  interrupt  //                                .multi_writerc
	);

	wait_for_interrupt_custom_instruction cpu_0_wait_for_interrupt_custom_instruction_inst (
		.clk       (clk),       // nios_custom_instruction_slave_0.clk
		.reset     (reset),     //                                .reset
		.clk_en    (clk_en),    //                                .clk_en
		.start     (start),     //                                .start
		.done      (done),      //                                .done
		.interrupt (interrupt)  //                                .multi_writerc
	);

endmodule
