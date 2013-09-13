#ifndef UTILITY_FUNCTIONS_H
#define UTILITY_FUNCTIONS_H
#include <stdlib.h>
#include <stdint.h>
#include "linked_list.h"
#include "image_data.h"

#include "disco_types.h"

float max(float a, float b);
float min(float a, float b);

/*flex array of ints*/
flex_array_t* make_flex_array(uint16_t length);

int16_t int_abs(int16_t input);

/*Used to delete a flexible array flex_array_t*/
void delete_flex_array(flex_array_t* proj);

/*Delete params struct*/
void delete_params(params* p);

/*Used to delete a staff info struct*/
void delete_staff_info(staff_info *staff);

/*Get the values for the staff lines at the index given ie get_line_at_index(staff,1) gives a flex_array_t 
of the top staff_line values for each staff*/
flex_array_t* get_line_at_index(const staff_info *staff,uint8_t index);

/*finds max within an array*/
int16_t max_array(const flex_array_t *proj);

/*returns an array of ones of length length*/
flex_array_t* array_ones(uint16_t length);

/*Used to find the indices or array that are greater,less,equal to etc the threshold,
the comparison is determined by the flag parameter (see find_flags for possible values) */                           
flex_array_t* find(const flex_array_t *array, float threshold, find_flags flag); 

/*Running difference, diff(i)=array(i+1)-array(i);*/
flex_array_t* diff(const flex_array_t *array);

/*Made this separately to save memory use abs value of diff*/
flex_array_t* abs_diff(const flex_array_t *array);

/*minus functions to mimic those of matlab, for the one w/ 2 arrays if length diff
returns null*/
flex_array_t* minus_array(const flex_array_t *array, const flex_array_t *array2);
flex_array_t* minus(const flex_array_t *array, int16_t number);


/*sum elements*/
int16_t sum(const flex_array_t *array);

/*mean rounded to nearest integer*/
int16_t rounded_mean(const flex_array_t *array);

/*median*/
int16_t median(const flex_array_t *array);

/*find a sub array similar to array(begin:end) in matlab*/
flex_array_t* sub_array(const flex_array_t *array, uint16_t begin, uint16_t end);

/*Removes indices from array, array is deleted following execution. In place assignment recommended.*/
flex_array_t* kill_array_indices(flex_array_t *array, const flex_array_t *indices);

/*A histogram of the input array*/
flex_array_t* hist(const flex_array_t *array);

/*Returns the index of the maximum value in the array, if the maximum value is 
present multiple times, returns the index of the first maximum present*/
uint16_t index_of_max(const flex_array_t *array);


/*groups an array of locations into groups of 2, items must be at least space apart*/
/*returned value is a linked list of arrays of length2 with int16_t's*/
linked_list*  group(const flex_array_t* in, uint16_t space);

void fill_group_indices(linked_list *list, const flex_array_t*, uint16_t space);

/*for a making a group if the pointer to the linked list already exists*/
void fill_group(linked_list* list,const flex_array_t* in, uint16_t space);

/*sorts a flex array of elements*/
void flex_mergesort(flex_array_t* array, uint16_t low, uint16_t high);

/*Y = FILTER(B,A,X) filters the data in vector X with the
   filter described by vectors A and B to create the filtered
   data Y.  The filter is a "Direct Form II Transposed"
   implementation of the standard difference equation:

   a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
                         - a(2)*y(n-1) - ... - a(na+1)*y(n-na)

   If a(1) is not equal to 1, FILTER normalizes the filter
   coefficients by a(1).

The array returned by filter must be freed by user when finished.*/
flex_array_t* filter(const flex_array_t *B,const flex_array_t *A,const flex_array_t *X);

/*flex array of pointers*/
flex_pointer_array_t* make_flex_pointer_array(uint16_t length,uint16_t size_of_element);

/*Used to delete a flexible array flex_array_t*/
void delete_flex_pointer_array(flex_pointer_array_t* proj);

flex_array_t* get_sub_array(const flex_array_t* array, int16_t start1, int16_t end1, int16_t start2, int16_t end2);

void quickSort( uint32_t* a, uint16_t l, uint16_t r);
uint32_t partition( uint32_t* a, uint16_t l, uint16_t r);
#endif
