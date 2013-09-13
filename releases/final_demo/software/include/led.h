#ifndef __LED_H_
#define __LED_H_

#include "altera_up_avalon_parallel_port.h"


extern alt_up_parallel_port_dev* LED_parallel_port;

// Whether or not the LEDs have been initialized
extern int LED_initialized;

// Initalize the leds
// Call before using other functions
int led_init ();

// Turn off all LEDs
void led_clear ();

// Write 16 bits to the LEDs
void led_write (unsigned data);

// Turn an individual LED on, numbered 0-17
void led_turn_on (int led_num);

void led_turn_off (int led_num);


#endif
