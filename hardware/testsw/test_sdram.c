
#include "global.h"
#include "jtag.h"

	
int main () {

	int i;
	
	// write words to the sdram
	for (i = 0; i < 52; i++) {
		*(SDRAM_ptr + (i * 2)) = (short) (i + 0x3041);
	}
	
	// read back the values and write them to the console
	for (i = 0; i < 52; i++) {
		send_jtag(*(SDRAM_ptr + (i * 2)));
	}
	
	
	while (1);
	
	return 0;
	
}
