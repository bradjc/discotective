#ifndef __GENERAL_FUNCTIONS_H
#define __GENERAL_FUNCTIONS_H

#include <stdint.h>


float max (float a, float b);

float min (float a, float b);

uint16_t max_uint16 (uint16_t a, uint16_t b);

uint16_t min_uint16 (uint16_t a, uint16_t b);

void quickSort( uint32_t* a, uint16_t l, uint16_t r);

uint32_t partition( uint32_t* a, uint16_t l, uint16_t r);

int16_t abs_int16 (int16_t input);

int32_t abs_int32 (int32_t input);

#endif
