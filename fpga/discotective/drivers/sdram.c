#include "sdram.h"
#include <stdint.h>

// sdram pointer
volatile uint8_t* SDRAM_ptr = (uint8_t*) 0x00800000;
volatile uint16_t* SDRAM16_ptr = (uint16_t*) 0x00800000;
