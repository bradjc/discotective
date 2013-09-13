#include "global.h"
#include "jtag.h"

// send 2 data bytes to the JTAG UART console
void send_jtag (short data) {
	
	// busy wait for the jtag to be ready
	while (!(*JTAG_control_ptr & 0xFFFF0000));
	// send the first byte
	*JTAG_data_ptr = 0x00008000 | (data & 0x00FF);
	
	while (!(*JTAG_control_ptr & 0xFFFF0000));
	// send the second byte
	*JTAG_data_ptr = 0x00008000 | ((data >> 8) & 0x00FF);
}
