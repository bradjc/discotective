#include "linked_list.h"
#include <stdio.h>
#include "flex_array.h"
#include <stdint.h>
#include <stdlib.h>
#include "global.h"
#include "image_functions.h"
#include "general_functions.h"
#include "platform_specific.h"

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>

flex_array_t* flex_array_create (uint16_t length) {
	return flex_array_create_main(length, 1, 0);
}

flex_array_t* flex_array_create_noinit (uint16_t length) {
	return flex_array_create_main(length, 0, 0);
}

flex_array_t* flex_array_create_init_zeros (uint16_t length) {
	return flex_array_create_main(length, 1, 0);
}

flex_array_t* flex_array_create_init_ones (uint16_t length) {
	return flex_array_create_main(length, 1, 1);
}


flex_array_t* flex_array_create_main (uint16_t length, uint8_t init, int16_t init_val) {
	uint16_t		i;
	flex_array_t*	arr;

	if (length == 0) array_length_fail();

	arr			= (flex_array_t*) malloc(sizeof(flex_array_t));
	arr->data	= (int16_t*) malloc(length * sizeof(int16_t));

	if (arr->data == NULL) {
		array_create_fail(length);
	}

	arr->length	= length;

	// initialize
	if (init) {
		for (i=0; i<length; i++) {
			arr->data[i] = init_val;
		}
	}

	return arr;
}

void flex_array_delete (flex_array_t** arr) {
	free((*arr)->data);
	free(*arr);
	*arr	= NULL;
}

void flex_array_change_size(flex_array_t** arr_ptr, uint16_t new_length) {
	flex_array_t*	new_array;
	uint16_t		i;

	new_array	= flex_array_create(new_length);

	for (i=0; i<min_u16((*arr_ptr)->length, new_length); i++) {
		new_array->data[i]	= (*arr_ptr)->data[i];
	}

	flex_array_delete(arr_ptr);
	*arr_ptr	= new_array;
}

flex_array_t* flex_array_copy (const flex_array_t* arr) {
	flex_array_t*	new_arr;
	uint16_t		i;

	new_arr	= flex_array_create_noinit(arr->length);
	for (i=0; i<arr->length; i++) {
		new_arr->data[i]	= arr->data[i];
	}

	return new_arr;
}

// sets all values to zero
void flex_array_zero (flex_array_t* arr) {
	int	i;
	for (i=0; i<arr->length; i++) {
		arr->data[i]	= 0;
	}
}

int16_t flex_array_max (const flex_array_t *arr) {
	int16_t		maximum = INT16_MIN;
	uint16_t	i;

	for (i=0; i<arr->length; i++) {
		if (arr->data[i] > maximum) {
			maximum = arr->data[i];
		}
	}
	return maximum;
}

int16_t flex_array_min (const flex_array_t *arr) {
	int16_t		minimum = INT16_MAX;
	uint16_t	i;

	for (i=0; i<arr->length; i++) {
		if (arr->data[i] < minimum) {
			minimum = arr->data[i];
		}
	}
	return minimum;
}

uint16_t flex_array_max_index (const flex_array_t *arr) {
	int16_t		maximum	= INT16_MIN;
	uint16_t	index;
	uint16_t	i;

	index	= 0;
	for (i=0; i<arr->length; i++) {
		if (arr->data[i] > maximum){
			maximum	= arr->data[i];
			index	= i;
		}
	}
	return index;
}

uint16_t flex_array_min_index (const flex_array_t *arr) {
	int16_t		minimum	= INT16_MAX;
	uint16_t	index;
	uint16_t	i;

	index	= 0;
	for (i=0; i<arr->length; i++) {
		if (arr->data[i] < minimum){
			minimum	= arr->data[i];
			index	= i;
		}
	}
	return index;
}

// finds the abs of the greatest difference between two values in the array
uint16_t flex_array_range (const flex_array_t* arr) {
	int16_t	max, min;
	max	= flex_array_max(arr);
	min	= flex_array_min(arr);

	return (uint16_t) (max - min);
}

 uint8_t flexa_greater (int16_t a, int16_t b) {			return a > b; }
 uint8_t flexa_less (int16_t a, int16_t b) {			return a < b; }
 uint8_t flexa_equal (int16_t a, int16_t b) {			return a == b; }
 uint8_t flexa_greater_equal (int16_t a, int16_t b) {	return a >= b;}
 uint8_t flexa_less_equal (int16_t a, int16_t b) {		return a <= b; }
 uint8_t flexa_not_equal (int16_t a, int16_t b) {		return a != b; }

flex_array_t* flex_array_find_function (const flex_array_t *arr, int16_t threshold, uint8_t (*compare)(int16_t, int16_t)) {
	uint16_t length = 0;
	flex_array_t *found_array;
	uint16_t i, j;

	// find the number of items that are greater
	for (i=0; i<arr->length; i++) {
		if ((*compare)(arr->data[i], threshold)) {
			length++;
		}
	}

	if (length == 0) return NULL;

	// create a new array to hold all of the numbers that are greater
	found_array = flex_array_create_noinit(length);

	// copy all elements that are greater into the new array
	j=0;
	for (i=0; i<arr->length; i++) {
		if ((*compare)(arr->data[i], threshold)) {
			found_array->data[j++] = i;
		}
	}
	return found_array;
}

flex_array_t* flex_array_find (const flex_array_t *arr, int16_t threshold, find_flag_e flag) {
	if (flag==greater)				return flex_array_find_function(arr, threshold, &flexa_greater);
	else if(flag==less)				return flex_array_find_function(arr, threshold, &flexa_less);
	else if(flag==greater_equal)	return flex_array_find_function(arr, threshold, &flexa_greater_equal);
	else if(flag==less_equal)		return flex_array_find_function(arr, threshold, &flexa_less_equal);
	else if(flag==equal)			return flex_array_find_function(arr, threshold, &flexa_equal);
	else							return flex_array_find_function(arr, threshold, &flexa_not_equal);
}

uint16_t flex_array_find_count_function (const flex_array_t *arr, int16_t threshold, uint8_t (*compare)(int16_t, int16_t)) {
	uint16_t		length = 0;
	uint16_t		i;

	// find the number of items that are greater
	for (i=0; i<arr->length; i++) {
		if ((*compare)(arr->data[i], threshold)) {
			length++;
		}
	}

	return length;
}

// returns the number of elements that match, not which elements they are
uint16_t flex_array_find_count (const flex_array_t *arr, int16_t threshold, find_flag_e flag) {
	if (flag==greater)				return flex_array_find_count_function(arr, threshold, &flexa_greater);
	else if(flag==less)				return flex_array_find_count_function(arr, threshold, &flexa_less);
	else if(flag==greater_equal)	return flex_array_find_count_function(arr, threshold, &flexa_greater_equal);
	else if(flag==less_equal)		return flex_array_find_count_function(arr, threshold, &flexa_less_equal);
	else if(flag==equal)			return flex_array_find_count_function(arr, threshold, &flexa_equal);
	else							return flex_array_find_count_function(arr, threshold, &flexa_not_equal);
}

uint32_t flex_array_absolute_difference_from_mean (const flex_array_t* arr) {
	int32_t		mean;
	uint32_t	diff;
	int			i;

	mean	= flex_array_mean_rounded(arr);
	diff	= 0;

	for (i=0; i<arr->length; i++) {
		diff	+= abs_32((int32_t) arr->data[i] - mean);
	}

	return diff;
}

// make a new array that is pairwise subtraction of an array
flex_array_t* flex_array_diff (const flex_array_t *arr) {
	uint16_t		i;
	flex_array_t*	difference;

	if (arr->length < 2) {
		flex_array_diff_length_fail();
	}

	difference = flex_array_create(arr->length - 1);

	for (i=0; i<arr->length-1; i++){
		difference->data[i] = arr->data[i+1] - arr->data[i];
	}
	return difference;
}

flex_array_t* flex_array_abs_diff (const flex_array_t *arr) {
	uint16_t		i;
	flex_array_t*	difference;

	if (arr->length < 2) {
		flex_array_abs_diff_length_fail();
	}

	difference = flex_array_create(arr->length-1);

	for (i=0; i<arr->length-1; i++) {
		difference->data[i] = (int16_t) abs_16(arr->data[i+1] - arr->data[i]);
	}
	return difference;
}

int32_t flex_array_sum (const flex_array_t *arr) {
	int32_t		sum = 0;
	uint16_t	i;

	for (i=0; i<arr->length; i++) {
		sum += (int32_t) arr->data[i];
	}
	return sum;
}

int32_t flex_array_mean_rounded (const flex_array_t *arr) {
	uint32_t	length;
	int32_t		sum_var;

	length	= (uint32_t) arr->length;
	sum_var	= flex_array_sum(arr);
	sum_var	+= length>>1;
	return sum_var / length;
}

// calcuates the mean of a portion of a flex array
// returns a float
// if the element is 0 it pretends its not there
// starts at the start index and works back until it finds num_elements num valid (nonzero)
//	elements with which to average
float flex_array_mean_float_pastx_skipzeros (const flex_array_t* arr, uint16_t start_index, uint16_t num_elements) {
	int32_t		total	= 0;
	uint16_t	count	= 0;
	int16_t		i;

	if (start_index >= arr->length) {
		return 0.0F;
	}

	for (i=start_index; i>=0; i--) {
		if (arr->data[i] != 0) {
			total	+= arr->data[i];
			count++;
		}
		if (count == num_elements) break;
	}

	return (float) total / (float) count;
}

int16_t flex_array_median (const flex_array_t *arr) {
	flex_array_t*	dummy;
	int16_t			return_val;

	if (arr->length == 0) {
		flex_array_median_length_fail();
	}

	// make a copy of the array
	dummy = flex_array_copy(arr);

	// sort the array
	flex_array_bubblesort(dummy);

	// pick out the median
	if (dummy->length % 2) {
		return_val= dummy->data[dummy->length/2];
	} else {
		return_val=(dummy->data[dummy->length/2] + dummy->data[dummy->length/2 - 1] + 1)/2;
	}
	flex_array_delete(&dummy);
	return return_val;
}

flex_array_t* flex_array_get_sub_array (const flex_array_t *arr, uint16_t begin, uint16_t end) {
	flex_array_t *new_array;
	uint16_t i;

	if (end < begin || arr == NULL) {
		flex_array_get_sub_array_length_fail();
	}

	if (end >= arr->length) {
		end = arr->length - 1;
	}

	new_array = flex_array_create(end + 1 - begin);
	for (i=begin; i<=end; i++){
	  new_array->data[i-begin] = arr->data[i];
	}
	return new_array;
}

// can get up to 2 sections, if don't want second section pass -1 to last two
flex_array_t* flex_array_get_sub_array_double (const flex_array_t* arr, int16_t start1, int16_t end1, int16_t start2, int16_t end2) {
	flex_array_t* new_array;
	uint16_t i;
	if (start1 == -1)	start1	= 0;
	if (end1 == -1)		end1	+= arr->length;
	if (start1 < 0 || end1 >= arr->length || start1>end1) {
//		printf("Error(1) in get_sub_array, indices out of bounds\n");
//		bad_exit();
		flex_array_get_sub_array_double_length_fail();
	}
	if(start2 == -1 || end2 == -1) {
		new_array = flex_array_create(end1 + 1 - start1);
		for (i=start1; i<=end1; i++) {
			new_array->data[i-start1] = arr->data[i];
		}
	} else {
		if (start2 > end2 ||end1 >= start2) {
//			printf("Error(2) in get_sub_array, indices overlapped\n");
			bad_exit();
		}
		new_array = flex_array_create(end1 + 2 + end2 - start1 - start2);
		for (i=start1; i<=end1; i++) {
			new_array->data[i-start1] = arr->data[i];
		}
		for (i=start2; i<=end2; i++){
			new_array->data[i + end1 + 1 - start1 - start2] = arr->data[i];
		}
	}
	return new_array;
}

flex_array_t* flex_array_minus (const flex_array_t *arr, int16_t number) {
	flex_array_t *new_array;
	uint16_t i;

	if (arr->length == 0) {
		flex_array_minus_length_fail();
	}

	new_array = flex_array_create(arr->length);
	for (i=0; i<arr->length; i++){
		new_array->data[i] = arr->data[i] - number;
	}
	return new_array;
}

flex_array_t* flex_array_minus_array (const flex_array_t *arr, const flex_array_t *array2) {
	flex_array_t *new_array;
	uint16_t i;

	if (arr->length != array2->length) {
		flex_array_minus_array_length_fail();
	}

	new_array = flex_array_create(arr->length);
	for (i=0; i<arr->length; i++){
		new_array->data[i] = arr->data[i] - array2->data[i];
	}
	return new_array;
}

flex_array_t* flex_array_kill_array_indices (flex_array_t *arr, const flex_array_t *indices) {
	uint16_t i, j = 0;
	uint16_t end, length = 0;
	flex_array_t *new_array;

	end = indices->length;
	if (arr->length < indices->length) {
		end = arr->length;
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
			new_array->data[j] = arr->data[i];
			j++;
		}
	}
	flex_array_delete(&arr);
	return new_array;
}

// input array must be only positive
flex_array_t* flex_array_histogram (const flex_array_t *arr) {
	flex_array_t* output_array;
	int16_t max_var;
	uint16_t i;

	max_var = flex_array_max(arr) + 1;

	// for this values must be non-negative
	if (max_var < 1) {
		flex_array_histogram_length_fail();
	}

	output_array = flex_array_create(max_var);

	for (i=0;i<arr->length;i++){
		output_array->data[arr->data[i]]++;
	}
	return output_array;
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

void flex_array_bubblesort (flex_array_t* arr) {
	uint16_t	i, j;
	int16_t		tmp;

	for (i=0; i<arr->length-1; i++) {
		for (j=0; j<arr->length-1; j++) {
			if (arr->data[j+1] < arr->data[j]) {
				tmp				= arr->data[j];
				arr->data[j]	= arr->data[j+1];
				arr->data[j+1]	= tmp;
			}
		}
	}

}

void flex_array_merge (flex_array_t* array, uint16_t low, uint16_t high, uint16_t mid) {
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
	flex_array_delete(&temp_array);
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

// looks five ahead and sets the current value to the mode of the current and the next 5
void flex_array_smoother (flex_array_t* arr) {
	uint16_t		lookahead_num;
	uint16_t		gap_width;
	int16_t			min, max;
	int16_t			start;
	int16_t			height;
	uint16_t		max_index;
	uint8_t			match;
	int16_t			match_to;
	int				i, j;
	flex_array_t*	mode_arr;

	lookahead_num	= 10;
	gap_width		= 25;

	max		= flex_array_max(arr);
	min		= min_16(flex_array_min(arr), 0);
	start	= -1*min;
	height	= max - min + 1;

	mode_arr	= flex_array_create_noinit(height);

	// smooth it out
	for (i=lookahead_num; i<arr->length-lookahead_num-1; i++) {
		flex_array_zero(mode_arr);
		for (j=-1*lookahead_num; j<=lookahead_num; j++) {
			mode_arr->data[arr->data[i+j] + start]++;
		}
		max			= flex_array_max(mode_arr);
		max_index	= flex_array_max_index(mode_arr);
	//	if (max != mode_arr->data[arr->data[i+j] + start]) {
			// the number of occurences of some value was not the same as the number of
			//	occurences of the value we already have. in this case, change it
			arr->data[i]	= max_index - start;
	//	}
	}

	// fill in gaps
	for (i=gap_width; i<arr->length-gap_width-1; i++) {
		match_to	= arr->data[i+gap_width];
		match		= 1;
		for (j=i-gap_width; j<i; j++) {
			if (arr->data[j] != match_to) {
				match	= 0;
				break;
			}
		}
		if (match) {
			arr->data[i]	= match_to;
		}
	}

	flex_array_delete(&mode_arr);

}


// doesn't seem to work
void flex_array_lowpass_filter (flex_array_t* arr) {

	int16_t			tmp[10000];
	int					i, j;
	float				total;
//	static const float	filter_coeff[21] = {	-0.0388639813482F,	0.002600887297775F,	0.0302244308397F,	-0.01809394077758F,
//												-0.0356920644948F,	0.03937860673126F,	0.04501323148935F,	-0.09232984718477F,
//												-0.04718168603421F,	0.3119197576877F,	0.5511950326613F,	0.3119197576877F,
//												-0.04718168603421F,	-0.09232984718477F,	0.04501323148935F,	0.03937860673126F,
//												-0.0356920644948F,	-0.01809394077758F,	0.0302244308397F,	0.002600887297775F,
//												-0.0388639813482F
//											};


//	static const float	filter_coeff[21] = {	-0.02766182646F,	0.08592651784F,	0.05209677294F,	0.04840182513F,	0.05255711451F,
//												0.0582119897F,		0.06371354312F,	0.06840061396F,	0.07186264545F,	0.07406699657F,
//												0.07486350089F,		0.07406699657F,	0.07186264545F,	0.06840061396F,	0.06371354312F,
//												0.0582119897F,		0.05255711451F,	0.04840182513F,	0.05209677294F,	0.08592651784F,
//												-0.02766182646F
//											};
	static const float	filter_coeff[51] = {	0.08529635519F,		-0.152974695F,		-0.06191151589F,	-0.01921040006F,	0.001869422151F,
												0.01319336239F,		0.01938328706F,		0.02213068865F,		0.02132818475F,		0.017371336F,
												0.009947551414F,	0.00004664763401F,	-0.01095896214F,	-0.02151876502F,	-0.02925909311F,
												-0.03221269697F,	-0.02894452587F,	-0.0186610613F,		-0.001270401292F,	0.02206011303F,
												0.04917764664F,		0.07755868137F,		0.1040466949F,		0.1255098432F,		0.139477849F,
												0.144318983F,		0.139477849F,		0.1255098432F,		0.1040466949F,		0.07755868137F,
												0.04917764664F,		0.02206011303F,		-0.001270401292F,	-0.0186610613F,		-0.02894452587F,
												-0.03221269697F,	-0.02925909311F,	-0.02151876502F,	-0.01095896214F,	4.664763401e-005F,
												0.009947551414F,	0.017371336F,		0.02132818475F,		0.02213068865F,		0.01938328706F,
												0.01319336239F,		0.001869422151F,	-0.01921040006F,	-0.06191151589F,	-0.152974695F,
												0.08529635519F
											};

	// array to hold the output in
//	tmp	= malloc(sizeof(int16_t) * arr->length);

	// loop through the entire array
	for (i=0; i<arr->length; i++) {
		total	= 0.0F;
		// convolve with the filter
		for (j=0; j<min_u16(i+1, 51); j++) {
			total	+= (float) arr->data[i-j] * filter_coeff[j];
		}
		// store the result
		tmp[i] = round_16(total);
	}

	// copy output back into original array
	for (i=0; i<arr->length; i++) {
		arr->data[i]	= tmp[i];
	}

//	free(tmp);
}

void flex_array_print (const flex_array_t* arr) {
	int	i;

	for (i=0; i<arr->length-1; i++) {
		disco_log_nol("%d,", arr->data[i]);
	}
	disco_log("%d", arr->data[arr->length-1]);
}

void flex_array_display (const flex_array_t* arr, uint8_t on_y_axis) {

	image_t*	out_img;
	int16_t		max, min;
	int			i, j;
	int16_t		start;
	int16_t		height;

	max		= flex_array_max(arr);
	min		= min_16(flex_array_min(arr), 0);
	start	= -1*min;
	height	= max - min;

	if (on_y_axis) {
		out_img	= binary_image_create(arr->length, height);
	} else {
		out_img	= binary_image_create(height, arr->length);
	}
	binary_image_whiteout(out_img);

	for (i=0; i<arr->length; i++) {
		if (arr->data[i] < 0) {

			for (j=0; j<abs_16(arr->data[i]); j++) {
				if (on_y_axis) {
					setPixel(out_img, start-j-1, i, BLACK);
				} else {
					setPixel(out_img, i, height-1-(start-j-1), BLACK);
				}
			}

		} else {
			for (j=0; j<arr->data[i]; j++) {
				if (on_y_axis) {
					setPixel(out_img, start+j, i, BLACK);
				} else {
					setPixel(out_img, i, height-1-(start+j), BLACK);
				}
			}
		}

	}

	binary_image_display(out_img);
	binary_image_delete(&out_img);
}

