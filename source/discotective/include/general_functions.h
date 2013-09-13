#ifndef __GENERAL_FUNCTIONS_H
#define __GENERAL_FUNCTIONS_H

#include <stdint.h>


float max_float (float a, float b);
float min_float (float a, float b);

int16_t max_16 (int16_t a, int16_t b);
int16_t min_16 (int16_t a, int16_t b);
uint16_t max_u16 (uint16_t a, uint16_t b);
uint16_t min_u16 (uint16_t a, uint16_t b);
int32_t min_32 (int32_t a, int32_t b);

int8_t round_8 (float a);
int16_t round_16 (float a);
int32_t round_32 (float a);
uint8_t round_u8 (float a);
uint16_t round_u16 (float a);
uint32_t round_u32 (float a);

int16_t floor_16 (float a);

uint16_t subtract_u16 (uint16_t minuend, uint16_t subtrahend);
uint32_t subtract_u32 (uint32_t minuend, uint32_t subtrahend);
uint16_t subtract_min_u16 (uint16_t minuend, uint16_t subtrahend, uint16_t min);

uint8_t about_float (float a, float b);

void quickSort (uint32_t* a, uint16_t l, uint16_t r);

uint32_t partition (uint32_t* a, uint16_t l, uint16_t r);

uint16_t abs_diff_u16 (uint16_t a, uint16_t b);

uint16_t abs_16 (int16_t input);
uint32_t abs_32 (int32_t input);

float abs_float (float a);

void myMatrixInverse (float **A, int32_t n, float **B);

uint8_t calculate_binarize_threshold_otsu (uint32_t* gray_histogram, uint32_t total_pixels, double* var_sq);
uint8_t calculate_binarize_threshold_entropy (uint32_t* gray_histogram, uint32_t total_pixels);

#endif
