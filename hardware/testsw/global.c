
#include "global.h"

// global pointers
volatile int* JTAG_data_ptr		= (int*) 0x01011000;
volatile int* JTAG_control_ptr	= (int*) 0x01011004;
volatile int* SDRAM_ptr			= (int*) 0x00800000;
