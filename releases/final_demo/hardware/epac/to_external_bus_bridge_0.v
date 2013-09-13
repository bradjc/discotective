/******************************************************************************
 * License Agreement                                                          *
 *                                                                            *
 * Copyright (c) 1991-2010 Altera Corporation, San Jose, California, USA.     *
 * All rights reserved.                                                       *
 *                                                                            *
 * Any megafunction design, and related net list (encrypted or decrypted),    *
 *  support information, device programming or simulation file, and any other *
 *  associated documentation or information provided by Altera or a partner   *
 *  under Altera's Megafunction Partnership Program may be used only to       *
 *  program PLD devices (but not masked PLD devices) from Altera.  Any other  *
 *  use of such megafunction design, net list, support information, device    *
 *  programming or simulation file, or any other related documentation or     *
 *  information is prohibited for any other purpose, including, but not       *
 *  limited to modification, reverse engineering, de-compiling, or use with   *
 *  any other silicon devices, unless such use is explicitly licensed under   *
 *  a separate agreement with Altera or a megafunction partner.  Title to     *
 *  the intellectual property, including patents, copyrights, trademarks,     *
 *  trade secrets, or maskworks, embodied in any such megafunction design,    *
 *  net list, support information, device programming or simulation file, or  *
 *  any other related documentation or information provided by Altera or a    *
 *  megafunction partner, remains with Altera, the megafunction partner, or   *
 *  their respective licensors.  No other licenses, including any licenses    *
 *  needed under any third party's intellectual property, are provided herein.*
 *  Copying or modifying any file, or portion thereof, to which this notice   *
 *  is attached violates this copyright.                                      *
 *                                                                            *
 * THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *
 * FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS  *
 * IN THIS FILE.                                                              *
 *                                                                            *
 * This agreement shall be governed in all respects by the laws of the State  *
 *  of California and by the laws of the United States of America.            *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 *                                                                            *
 * This module connects the Avalon Switch Frabic to an External Bus           *
 *                                                                            *
 ******************************************************************************/

module to_external_bus_bridge_0 (
	// Inputs
	clk,
	reset,

	avalon_address,
	avalon_byteenable,
	avalon_chipselect,
	avalon_read,
	avalon_write,
	avalon_writedata,

	acknowledge,
	irq,
	read_data,

	// Bidirectionals

	// Outputs
	avalon_irq,
	avalon_readdata,
	avalon_waitrequest,

	address,
	bus_enable,
	byte_enable,
	rw,
	write_data
);


/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

parameter	ADDR_BITS		= 19;
parameter	DATA_BITS		= 16;

parameter	ADDR_LOW		= 1;
parameter	BYTE_EN_BITS	= 2;

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input									clk;
input									reset;

input		[(ADDR_BITS-1):0]			avalon_address;
input		[(BYTE_EN_BITS-1):0]		avalon_byteenable;
input									avalon_chipselect;
input									avalon_read;
input									avalon_write;
input		[(DATA_BITS-1):0]			avalon_writedata;

input									acknowledge;
input									irq;
input		[(DATA_BITS-1):0]			read_data;

// Bidirectionals

// Outputs
output									avalon_irq;
output	reg	[(DATA_BITS-1):0]			avalon_readdata;
output									avalon_waitrequest;

output	reg	[(ADDR_BITS+ADDR_LOW-1):0]	address;
output	reg								bus_enable;
output	reg	[(BYTE_EN_BITS-1):0]		byte_enable;
output	reg								rw;
output	reg	[(DATA_BITS-1):0]			write_data;


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires

// Internal Registers
reg			[ 7: 0]	time_out_counter;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge clk)
begin
	if (reset == 1'b1)
	begin
		avalon_readdata <= {DATA_BITS{1'b0}};
	end
	else if (acknowledge | (&(time_out_counter)))
	begin
		avalon_readdata <= read_data;
	end
end

always @(posedge clk)
begin
	if (reset == 1'b1)
	begin
		address		<= {ADDR_BITS+ADDR_LOW{1'b0}};
		bus_enable	<= 1'b0;
		byte_enable	<= {BYTE_EN_BITS{1'b0}};
		rw			<= 1'b1;
		write_data	<= {DATA_BITS{1'b0}};
	end
	else
	begin
		address		<= {avalon_address, {ADDR_LOW{1'b0}}};

		if (avalon_chipselect & (|(avalon_byteenable)))
		begin
			bus_enable	<= avalon_waitrequest;
		end
		else
		begin
			bus_enable	<= 1'b0;
		end

		byte_enable	<= avalon_byteenable;
		rw			<= avalon_read | ~avalon_write;
		write_data	<= avalon_writedata;
	end
end

always @(posedge clk)
begin
	if (reset == 1'b1)
	begin
		time_out_counter <= 8'h00;
	end
	else if (avalon_waitrequest == 1'b1)
	begin
		time_out_counter <= time_out_counter + 8'h01;
	end
	else
	begin
		time_out_counter <= 8'h00;
	end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign avalon_irq = irq;
assign avalon_waitrequest =
		avalon_chipselect & (|(avalon_byteenable)) & 
		~acknowledge & ~(&(time_out_counter));

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

endmodule

