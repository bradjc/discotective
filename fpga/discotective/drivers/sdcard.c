#include "sdcard.h"
#include "altera_up_sd_card_avalon_interface.h"
#include "../src/altera_up_sd_card_avalon_interface.c"
#include <priv/alt_file.h>
#include <io.h>

int SDCARD_initialized = 0;
alt_up_sd_card_dev* SDCARD_port;

int sdcard_init () {
	if (!SDCARD_initialized) {
		SDCARD_port = alt_up_sd_card_open_dev("/dev/sd_card_0");
		if (SDCARD_port != NULL) {
			SDCARD_initialized = 1;
		}
	}
	return SDCARD_initialized;
}

bool sdcard_is_card () {
	if (!sdcard_init()) return false;

	return alt_up_sd_card_is_Present();
}

// Buffer must be at least 512 bytes
void sdcard_read_block (int block_num, unsigned int *buf) {
	short int reg_state;
	int i;

	if (!sdcard_init()) return;

	// tell it where we want to read and that we want to do a read
	IOWR_32DIRECT(command_argument_register, 0, block_num*512);
	IOWR_16DIRECT(command_register, 0, CMD_READ_BLOCK);
	// wait for the read to finish
	do {
		reg_state = (short int) IORD_16DIRECT(aux_status_register,0);
	} while ((reg_state & 0x04)!=0);

	// get the data
	for (i=0; i<128; i++) {
		buf[i] = (unsigned int) IORD_32DIRECT(buffer_memory, i);
	}

}
