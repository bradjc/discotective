#ifndef FLEX_ARRAY_H_
#define FLEX_ARRAY_H_

#include <stdio.h>
#include "global.h"

flex_array_t* flex_array_create (uint16_t length);
flex_array_t* flex_array_create_noinit (uint16_t length);
flex_array_t* flex_array_create_init_zeros (uint16_t length);
flex_array_t* flex_array_create_init_ones (uint16_t length);
flex_array_t* flex_array_create_main (uint16_t length, uint8_t init, int16_t init_val);

void flex_array_delete (flex_array_t** arr);

flex_array_t* flex_array_copy (const flex_array_t* arr);
void flex_array_change_size(flex_array_t** arr_ptr, uint16_t new_length);

void flex_array_zero (flex_array_t* arr);

int16_t flex_array_max (const flex_array_t *proj);
int16_t flex_array_min (const flex_array_t *proj);
uint16_t flex_array_max_index (const flex_array_t *arr);
uint16_t flex_array_min_index (const flex_array_t *arr);

uint16_t flex_array_range (const flex_array_t* arr);

uint8_t flexa_greater (int16_t a, int16_t b);
uint8_t flexa_less (int16_t a, int16_t b);
uint8_t flexa_equal (int16_t a, int16_t b);
uint8_t flexa_greater_equal (int16_t a, int16_t b);
uint8_t flexa_less_equal (int16_t a, int16_t b);
uint8_t flexa_not_equal (int16_t a, int16_t b);
flex_array_t* flex_array_find_function (const flex_array_t *arr, int16_t threshold, uint8_t (*compare)(int16_t, int16_t));
flex_array_t* flex_array_find (const flex_array_t *arr, int16_t threshold, find_flag_e flag);
uint16_t flex_array_find_count_function (const flex_array_t *arr, int16_t threshold, uint8_t (*compare)(int16_t, int16_t));
uint16_t flex_array_find_count (const flex_array_t *arr, int16_t threshold, find_flag_e flag);

// sums the absolute value of the difference of each element to the mean
uint32_t flex_array_absolute_difference_from_mean (const flex_array_t*);

// make a new array that is pairwise subtraction of an array
flex_array_t* flex_array_diff (const flex_array_t *arr);
flex_array_t* flex_array_abs_diff (const flex_array_t *arr);

int32_t flex_array_sum (const flex_array_t *arr);

int32_t flex_array_mean_rounded(const flex_array_t *arr);
float flex_array_mean_float_pastx_skipzeros (const flex_array_t* arr, uint16_t start_index, uint16_t num_elements);

int16_t flex_array_median (const flex_array_t *arr);

flex_array_t* flex_array_get_sub_array (const flex_array_t *arr, uint16_t begin, uint16_t end);
flex_array_t* flex_array_get_sub_array_double (const flex_array_t* array, int16_t start1, int16_t end1, int16_t start2, int16_t end2);

flex_array_t* flex_array_minus (const flex_array_t *arr, int16_t number);
flex_array_t* flex_array_minus_array (const flex_array_t *arr, const flex_array_t *arr2);

flex_array_t* flex_array_kill_array_indices (flex_array_t *arr, const flex_array_t *indices);

// input array must be only positive
flex_array_t* flex_array_histogram (const flex_array_t *arr);

flex_array_t* filter (const flex_array_t *B, const flex_array_t *A, const flex_array_t *X);

void flex_array_bubblesort (flex_array_t* arr);
void flex_array_merge (flex_array_t* array, uint16_t low, uint16_t high, uint16_t mid);
void flex_array_mergesort (flex_array_t* array, uint16_t low, uint16_t high);

void flex_array_smoother (flex_array_t* arr);
void flex_array_lowpass_filter (flex_array_t* arr);

void flex_array_print (const flex_array_t* arr);
void flex_array_display (const flex_array_t* arr, uint8_t on_y_axis);

#endif
