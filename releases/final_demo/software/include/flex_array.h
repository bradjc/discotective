#ifndef FLEX_ARRAY_H_
#define FLEX_ARRAY_H_

#include <stdio.h>
#include <global.h>

flex_array_t* flex_array_create (uint16_t length);

// doesn't set values to zero
flex_array_t* flex_array_create_noinit (uint16_t length);

void flex_array_delete (flex_array_t* flex_array);

int16_t flex_array_max (const flex_array_t *proj);

int16_t flex_array_min (const flex_array_t *proj);

uint16_t flex_array_index_of_max (const flex_array_t *array);

inline alt_u8 flexa_greater (int16_t a, int16_t b);
inline alt_u8 flexa_less (int16_t a, int16_t b);
inline alt_u8 flexa_equal (int16_t a, int16_t b);
inline alt_u8 flexa_greater_equal (int16_t a, int16_t b);
inline alt_u8 flexa_less_equal (int16_t a, int16_t b);
inline alt_u8 flexa_not_equal (int16_t a, int16_t b);
flex_array_t* flex_array_find_function (const flex_array_t *array, int16_t threshold, alt_u8 (*compare)(int16_t, int16_t));
flex_array_t* flex_array_find (const flex_array_t *array, int16_t threshold, find_flags flag);

// make a new array that is pairwise subtraction of an array
flex_array_t* flex_array_diff (const flex_array_t *array);

flex_array_t* flex_array_abs_diff (const flex_array_t *array);

int16_t flex_array_sum (const flex_array_t *array);

int16_t flex_array_rounded_mean(const flex_array_t *array);

int16_t flex_array_median (const flex_array_t *array);

flex_array_t* flex_array_get_sub_array (const flex_array_t *array, uint16_t begin, uint16_t end);

flex_array_t* flex_array_get_sub_array_double (const flex_array_t* array, int16_t start1, int16_t end1, int16_t start2, int16_t end2);

flex_array_t* flex_array_minus (const flex_array_t *array, int16_t number);

flex_array_t* flex_array_minus_array (const flex_array_t *array, const flex_array_t *array2);

flex_array_t* flex_array_kill_array_indices (flex_array_t *array, const flex_array_t *indices);

// input array must be only positive
flex_array_t* flex_array_histogram (const flex_array_t *array);

// returns the index of the maximum value
uint16_t flex_array_get_max_index (const flex_array_t *array);

flex_array_t* flex_array_create_init_ones (uint16_t length);

flex_array_t* filter (const flex_array_t *B, const flex_array_t *A, const flex_array_t *X);

void flex_array_merge (flex_array_t* array,uint16_t low,uint16_t high, uint16_t mid);

void flex_array_mergesort (flex_array_t* array, uint16_t low, uint16_t high);

#endif
