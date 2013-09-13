#ifndef __SSD_H_
#define __SSD_H_

/* It appears that this driver works active high. */

#include "altera_up_avalon_parallel_port.h"


extern alt_up_parallel_port_dev* SSD_parallel_port;

// Whether or not the seven segment displays have been initialized
extern int SSD_initialized;

extern int ssd_segs[15];


// Initalize the ssd
// Call before using other functions
int ssd_init ();

void ssd_write_digit (int location, int value);

void ssd_write_value (int value);

void ssd_clear_all ();


#endif
