
#include "global.h"
#include "jtag.h"

	
int main () {

	int i;
	
	// write (2592 * 1944) / 2 = 2519424 words to the sdram
//	for (i = 0; i < 2519424; i++) {
	for (i = 0; i < 1000; i++) {
		*(SDRAM_ptr + (i * 1)) = (short) (i % 65535);
	}
	
	// read back random values and write them to the console
	send_jtag(*(SDRAM_ptr + 500));
//	send_jtag(*(SDRAM_ptr + 2519424));
//	send_jtag(*(SDRAM_ptr + (2519424 * 2)));
//	send_jtag(*(SDRAM_ptr + 465750));
//	send_jtag(*(SDRAM_ptr + 101010));
	
	while (1);
	
	return 0;
	
}
