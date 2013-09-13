#include "general_functions.h"
#include <stdint.h>


float max (float a, float b) {
	if (a > b) return a;
	return b;
}

float min (float a, float b) {
	if (a < b) return a;
	return b;
}

uint16_t max_uint16 (uint16_t a, uint16_t b) {
	if (a > b) return a;
	return b;
}

uint16_t min_uint16 (uint16_t a, uint16_t b) {
	if (a < b) return a;
	return b;
}

void quickSort( uint32_t* a, uint16_t l, uint16_t r) {
	uint16_t j;

	if(l < r) {
		// divide and conquer
		j = partition(a, l, r);
		if (j-1>l) quickSort(a, l, j-1);
		if (j+1<r) quickSort(a, j+1, r);
	}

}

uint32_t partition( uint32_t* a, uint16_t l, uint16_t r) {
	uint32_t pivot, t;
	uint16_t i, j;

	pivot	= a[l];
	i		= l;
	j		= r+1;

	while (1) {
		do ++i; while( a[i] <= pivot && i <= r );
		do --j; while( a[j] > pivot );
		if( i >= j ) break;
		t = a[i];
		a[i] = a[j];
		a[j] = t;
	}
	t = a[l];
	a[l] = a[j];
	a[j] = t;
	return j;
}

int16_t abs_int16 (int16_t input) {
	if (input >= 0) return input;
	return -1 * input;
}

int32_t abs_int32 (int32_t input) {
	if (input >=0) return input;
	return -1 * input;
}
