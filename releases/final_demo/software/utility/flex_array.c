#include "utility_functions.h"
#include "linked_list.h"
#include <stdio.h>
#include "flex_array.h"
#include "alt_types.h"
#include <stdint.h>
#include <stdlib.h>
#include "ssd.h"
#include "global.h"


flex_array_t* flex_array_create (uint16_t length) {
	uint16_t i;
	flex_array_t* flex_array;

	if (length == 0) array_length_fail();

	flex_array			= malloc(sizeof(flex_array_t));
	flex_array->data	= malloc(length * sizeof(int16_t));

	if (flex_array->data == NULL) {
		array_create_fail(length);
	}

	flex_array->length	= length;
	for (i=0; i<length; i++) {
		flex_array->data[i] = 0;
	}
	return flex_array;
}

// doesn't set values to zero
flex_array_t* flex_array_create_noinit (uint16_t length) {
	flex_array_t* flex_array;

	if (length == 0) array_length_fail();

	flex_array			= malloc(sizeof(flex_array_t));
	flex_array->data	= malloc(length * sizeof(int16_t));

	if (flex_array->data == NULL) array_create_fail(length);

	flex_array->length	= length;

	return flex_array;
}

void flex_array_delete (flex_array_t* flex_array) {
	free(flex_array->data);
	flex_array->data	= NULL;
	free(flex_array);
	flex_array			= NULL;
}

int16_t flex_array_max (const flex_array_t *proj) {
	alt_16 maximum = 0x8000;
	alt_u16 i;

	for (i=0; i<proj->length; i++) {
//		ssd_write_value(maximum);
		if (proj->data[i] > maximum) {
			maximum = proj->data[i];
		}
	}
	return maximum;
}

int16_t flex_array_min (const flex_array_t *proj) {
	alt_16 minimum = 0x7FFF;
	alt_u16 i;

	for (i=0; i<proj->length; i++) {
//		ssd_write_value(maximum);
		if (proj->data[i] < minimum) {
			minimum = proj->data[i];
		}
	}
	return minimum;
}

uint16_t flex_array_index_of_max (const flex_array_t *array) {
	int16_t		maximum;
	uint16_t	index;
	uint16_t	i;

	if (array->length < 1) {
		return 0xFFFF;
	}
	maximum	= array->data[0];
	index	= 0;
	for (i=0; i<array->length; i++) {
		if (array->data[i] > maximum){
			maximum	= array->data[i];
			index	= i;
		}
	}
	return index;
}

inline alt_u8 flexa_greater (int16_t a, int16_t b) {
	return a > b;
}

inline alt_u8 flexa_less (int16_t a, int16_t b) {
	return a < b;
}

inline alt_u8 flexa_equal (int16_t a, int16_t b) {
	return a == b;
}

inline alt_u8 flexa_greater_equal (int16_t a, int16_t b) {
	return a >= b;
}

inline alt_u8 flexa_less_equal (int16_t a, int16_t b) {
	return a <= b;
}

inline alt_u8 flexa_not_equal (int16_t a, int16_t b) {
	return a != b;
}

flex_array_t* flex_array_find_function (const flex_array_t *array, int16_t threshold, alt_u8 (*compare)(int16_t, int16_t)) {
	uint16_t length = 0;
	flex_array_t *found_array;
	uint16_t i, j;

	// find the number of items that are greater
	for (i=0; i<array->length; i++) {
		if ((*compare)(array->data[i], threshold)) {
			length++;
		}
	}

//	if (length == 0) flex_array_find_length_fail();

	if (length == 0) return NULL;

	// create a new array to hold all of the numbers that are greater
	found_array = flex_array_create_noinit(length);

	// copy all elements that are greater into the new array
	j=0;
	for (i=0; i<array->length; i++) {
		if ((*compare)(array->data[i], threshold)) {
			found_array->data[j] = i;
			j++;
		}
	}
	return found_array;
}

flex_array_t* flex_array_find (const flex_array_t *array, int16_t threshold, find_flags flag) {
	if (flag==greater)				return flex_array_find_function(array, threshold, &flexa_greater);
	else if(flag==less)				return flex_array_find_function(array, threshold, &flexa_less);
	else if(flag==greater_equal)	return flex_array_find_function(array, threshold, &flexa_greater_equal);
	else if(flag==less_equal)		return flex_array_find_function(array, threshold, &flexa_less_equal);
	else if(flag==equal)			return flex_array_find_function(array, threshold, &flexa_equal);
	else							return flex_array_find_function(array, threshold, &flexa_not_equal);
}

// make a new array that is pairwise subtraction of an array
flex_array_t* flex_array_diff (const flex_array_t *array) {
	uint16_t i;
	flex_array_t* difference;

	if (array->length < 2) {
		flex_array_diff_length_fail();
	}

	difference = flex_array_create(array->length - 1);
	for (i=0; i<array->length-1; i++){
		difference->data[i] = array->data[i+1] - array->data[i];
	}
	return difference;
}

flex_array_t* flex_array_abs_diff (const flex_array_t *array) {
	uint16_t i;
	int16_t new_diff;
	flex_array_t* difference;

	if (array->length < 2) {
		flex_array_abs_diff_length_fail();
	}

	difference = flex_array_create(array->length-1);
	for (i=0; i<array->length-1; i++) {
		new_diff = array->data[i+1] - array->data[i];
		if (new_diff < 0) {
			new_diff *= -1;
		}
		difference->data[i] = new_diff;
	}
	return difference;
}

int16_t flex_array_sum (const flex_array_t *array) {
	int16_t sum = 0;
	uint16_t i;

	for (i=0; i<array->length; i++) {
		sum += array->data[i];
	}
	return sum;
}

int16_t flex_array_rounded_mean(const flex_array_t *array) {
	uint16_t	length;
	int16_t		sum_var;

	length	= array->length;
	sum_var	= flex_array_sum(array);
	sum_var	+= length>>1;
	return sum_var/length;
}

int16_t flex_array_median (const flex_array_t *array) {
	flex_array_t*	dummy;
	uint16_t		i;
	int16_t			return_val;

	if (array->length == 0) {
		flex_array_median_length_fail();
	}

	// make a copy of the array
	dummy = flex_array_create(array->length);
	for (i=0;i<(array->length);i++){
		dummy->data[i]=array->data[i];
	}

	// sort the array
	flex_array_mergesort(dummy, 0, dummy->length);

	// pick out the median
	if (dummy->length % 2) {
		return_val= dummy->data[dummy->length/2];
	} else {
		return_val=(dummy->data[dummy->length/2]+ dummy->data[dummy->length/2 - 1] + 1)/2;
	}
	flex_array_delete(dummy);
	return return_val;
}

flex_array_t* flex_array_get_sub_array (const flex_array_t *array, uint16_t begin, uint16_t end) {
	flex_array_t *new_array;
	uint16_t i;

	if (end < begin || array == NULL) {
		flex_array_get_sub_array_length_fail();
	}

	if (end >= array->length) {
		end = array->length - 1;
	}

	new_array = flex_array_create(end + 1 - begin);
	for (i=begin; i<=end; i++){
	  new_array->data[i-begin] = array->data[i];
	}
	return new_array;
}

// can get up to 2 sections, if don't want second section pass -1 to last two
flex_array_t* flex_array_get_sub_array_double (const flex_array_t* array, int16_t start1, int16_t end1, int16_t start2, int16_t end2) {
	flex_array_t* new_array;
	uint16_t i;
	if (start1 == -1)	start1	= 0;
	if (end1 == -1)		end1	+= array->length;
	if (start1 < 0 || end1 >= array->length || start1>end1) {
//		printf("Error(1) in get_sub_array, indices out of bounds\n");
//		bad_exit();
		flex_array_get_sub_array_double_length_fail();
	}
	if(start2 == -1 || end2 == -1) {
		new_array = flex_array_create(end1 + 1 - start1);
		for (i=start1; i<=end1; i++) {
			new_array->data[i-start1] = array->data[i];
		}
	} else {
		if (start2 > end2 ||end1 >= start2) {
//			printf("Error(2) in get_sub_array, indices overlapped\n");
			bad_exit();
		}
		new_array = flex_array_create(end1 + 2 + end2 - start1 - start2);
		for (i=start1; i<=end1; i++) {
			new_array->data[i-start1] = array->data[i];
		}
		for (i=start2; i<=end2; i++){
			new_array->data[i + end1 + 1 - start1 - start2] = array->data[i];
		}
	}
	return new_array;
}

flex_array_t* flex_array_minus (const flex_array_t *array, int16_t number) {
	flex_array_t *new_array;
	uint16_t i;

	if (array->length == 0) {
		flex_array_minus_length_fail();
	}

	new_array = flex_array_create(array->length);
	for (i=0; i<array->length; i++){
		new_array->data[i] = array->data[i]-number;
	}
	return new_array;
}

flex_array_t* flex_array_minus_array (const flex_array_t *array, const flex_array_t *array2) {
	flex_array_t *new_array;
	uint16_t i;

	if (array->length != array2->length) {
		flex_array_minus_array_length_fail();
	}

	new_array = flex_array_create(array->length);
	for (i=0; i<array->length; i++){
		new_array->data[i] = array->data[i] - array2->data[i];
	}
	return new_array;
}

flex_array_t* flex_array_kill_array_indices (flex_array_t *array, const flex_array_t *indices) {
	uint16_t i, j = 0;
	uint16_t end, length = 0;
	flex_array_t *new_array;

	end = indices->length;
	if (array->length < indices->length) {
		end = array->length;
	}

	for (i=0; i<end; i++) {
		if (indices->data[i] == 0) {
			length++;
		}
	}

	if (length == 0) {
		flex_array_kill_array_indices_length_fail();
	}

	new_array = flex_array_create(length);
	for (i=0; i<length; i++) {
		if (!indices->data[i]) {
			new_array->data[j] = array->data[i];
			j++;
		}
	}
	flex_array_delete(array);
	return new_array;
}

// input array must be only positive
flex_array_t* flex_array_histogram (const flex_array_t *array) {
	flex_array_t* output_array;
	int16_t max_var;
	uint16_t i;

	max_var = flex_array_max(array) + 1;

	// for this values must be non-negative
	if (max_var < 1) {
		flex_array_histogram_length_fail();
	}

	output_array = flex_array_create(max_var);

	for (i=0;i<array->length;i++){
		output_array->data[array->data[i]]++;
	}
	return output_array;
}

// returns the index of the maximum value
uint16_t flex_array_get_max_index (const flex_array_t *array) {
	int16_t maximum = -32768;
	uint16_t index = 0;
	uint16_t i;

	if (array->length < 1) {
	//	return 0xFFFF;
		flex_array_get_max_index_length_fail();
	}

	for (i=0; i<array->length; i++) {
		if (array->data[i] > maximum) {
			maximum = array->data[i];
			index=i;
		}
	}
	return index;
}

flex_array_t* flex_array_create_init_ones (uint16_t length) {
	flex_array_t* new_array;
	uint16_t i;

	if (length == 0) {
		flex_array_create_init_ones_length_fail();
	}

	new_array = flex_array_create_noinit(length);
	for (i=0; i<length; i++){
		new_array->data[i] = 1;
	}
	return new_array;
}

flex_array_t* filter (const flex_array_t *B, const flex_array_t *A, const flex_array_t *X) {
	flex_array_t* Y;
	uint16_t i, j;

	if (X->length == 0) {
		flex_array_filter_length_fail();
	}

	Y = flex_array_create(X->length);
	for (i=0; i<Y->length; i++) {
		j=0;
		Y->data[i]=0;
		while (j < B->length && i >= j) {
			Y->data[i] = Y->data[i] + B->data[j] * X->data[i-j];
			j++;
		}
		j=1;
		while (j < A->length && i >= j) {
			Y->data[i]= Y->data[i] - (A->data[j] * Y->data[i-j]);
			j++;
		}
		Y->data[i] =(Y->data[i] + A->data[0]/2) / A->data[0];
	}
	return Y;
}

void flex_array_merge (flex_array_t* array,uint16_t low,uint16_t high, uint16_t mid) {
	flex_array_t* temp_array;
	uint16_t i, j, k;

	if (mid + 1 - low == 0) {
		flex_array_merge_length_fail();
	}

	temp_array = flex_array_create(mid + 1 - low);

	i=0;
	j=low;
	while (j <= mid) {
		temp_array->data[i++] = array->data[j++];
	}
	i = 0;
	k = low;
	while (k<j && j<=high) {
		if (temp_array->data[i] <= array->data[j]) {
			array->data[k++] = temp_array->data[i++];
		} else {
			array->data[k++] = array->data[j++];
		}
	}
	while (k<j) {
		array->data[k++] = temp_array->data[i++];
	}
	flex_array_delete(temp_array);
}

void flex_array_mergesort (flex_array_t* array, uint16_t low, uint16_t high) {
     uint16_t mid;
     if (low < high) {
        mid = (low + high)/2;
        flex_array_mergesort(array, low, mid);
        flex_array_mergesort(array, mid+1, high);
        flex_array_merge(array, low, high, mid);
     }
}

