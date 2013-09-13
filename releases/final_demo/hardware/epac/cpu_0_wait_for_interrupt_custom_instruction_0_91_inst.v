// cpu_0_wait_for_interrupt_custom_instruction_0_91_inst.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module cpu_0_wait_for_interrupt_custom_instruction_0_91_inst (
		input  wire        reset,     // nios_custom_instruction_slave_0.reset
		input  wire        start,     //                                .start
		output wire        done,      //                                .done
		output wire [31:0] result,    //                                .result
		input  wire        clk,       //                                .clk
		input  wire        clk_en,    //                                .clk_en
		input  wire        interrupt  //                    interrupt_in.export
	);

	wait_for_interrupt_custom_instruction cpu_0_wait_for_interrupt_custom_instruction_0_91_inst (
		.reset     (reset),     // nios_custom_instruction_slave_0.reset
		.start     (start),     //                                .start
		.done      (done),      //                                .done
		.result    (result),    //                                .result
		.clk       (clk),       //                                .clk
		.clk_en    (clk_en),    //                                .clk_en
		.interrupt (interrupt)  //                    interrupt_in.export
	);

endmodule
