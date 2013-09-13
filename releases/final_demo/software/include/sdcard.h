#ifndef __SDCARD_H_
#define __SDCARD_H_

#include "altera_up_sd_card_avalon_interface.h"

extern alt_up_sd_card_dev* SDCARD_port;
extern int SDCARD_initialized;

int sdcard_init ();

bool sdcard_is_card ();

void sdcard_read_block (int block, unsigned int *buf);

#endif
