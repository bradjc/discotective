#include "general_functions.h"
#include <stdint.h>
#include <math.h>
#include "allocate.h"
#include <stdio.h>


float max_float (float a, float b) {
	if (a > b) return a;
	return b;
}

float min_float (float a, float b) {
	if (a < b) return a;
	return b;
}

uint16_t max_u16 (uint16_t a, uint16_t b) {
	if (a > b) return a;
	return b;
}

uint16_t min_u16 (uint16_t a, uint16_t b) {
	if (a < b) return a;
	return b;
}

int16_t max_16 (int16_t a, int16_t b) {
	if (a > b) return a;
	return b;
}

int16_t min_16 (int16_t a, int16_t b) {
	if (a < b) return a;
	return b;
}

int32_t min_32 (int32_t a, int32_t b) {
	if (a < b) return a;
	return b;
}

int8_t round_8 (float a) {
	if (a >= 0)	return (int8_t) (a + 0.49999F);
	else		return (int8_t) (a - 0.49999F);
}

int16_t round_16 (float a) {
	if (a >= 0)	return (int16_t) (a + 0.49999F);
	else		return (int16_t) (a - 0.49999F);
}

int32_t round_32 (float a) {
	if (a >= 0)	return (int32_t) (a + 0.49999F);
	else		return (int32_t) (a - 0.49999F);
}


uint8_t round_u8 (float a) {
	if (a >= 0)	return (uint8_t) (a + 0.49999F);
	else		return (uint8_t) 0;
}

uint16_t round_u16 (float a) {
	if (a >= 0)	return (uint16_t) (a + 0.49999F);
	else		return (uint16_t) 0;
}

uint32_t round_u32 (float a) {
	if (a >= 0)	return (uint32_t) (a + 0.49999F);
	else		return (uint32_t) 0;
}

int16_t floor_16 (float a) {
	return (int16_t) a;
}

// subtract the subtrahend from the minuend, but return 0 if 
//	the result would have been negative
uint16_t subtract_u16 (uint16_t minuend, uint16_t subtrahend) {
	if (subtrahend > minuend)	return 0;
	return minuend - subtrahend;
}

uint32_t subtract_u32 (uint32_t minuend, uint32_t subtrahend) {
	if (subtrahend > minuend)	return 0;
	return minuend - subtrahend;
}

uint16_t subtract_min_u16 (uint16_t minuend, uint16_t subtrahend, uint16_t min) {
	if (subtrahend + min > minuend)	return min;
	return minuend - subtrahend;
}

uint16_t abs_diff_u16 (uint16_t a, uint16_t b) {
	int32_t		c, d;
	c	= (int32_t) a;
	d	= (int32_t) b;

	if (c - d < 0)	return (uint16_t) (d - c);
	return (uint16_t) (c - d);
}

uint16_t abs_16 (int16_t input) {
	if (input >= 0) return (uint16_t) input;
	return (uint16_t) (-1 * input);
}

uint32_t abs_32 (int32_t input) {
	if (input >=0) return (uint32_t) input;
	return (uint32_t) (-1 * input);
}

float abs_float (float a) {
	if (a >= 0.0F) return a;
	return -1.0F * a;
}

// checks to see if a is close to b
uint8_t about_float (float a, float b) {
	if (a - 0.25F < b && a + 0.25F) return 1;
	return 0;
}

void quickSort(uint32_t* a, uint16_t l, uint16_t r) {
	int32_t j;

	if(l < r) {
		// divide and conquer
		j = (int32_t) partition(a, l, r);
		if (j-1>l) quickSort(a, l, (uint16_t) (j-1));
		if (j+1<r) quickSort(a, (uint16_t) (j+1), r);
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

/* matrix inversion*/
/* the result is put in B*/
void myMatrixInverse (float **A, int32_t n, float **B) {
	float s, t;
	int32_t i,j,k,L;
	
	/******DEFINE IDENTITY MATRIX****/
	for(i=0; i<n; i++){
		for(j=0; j<n; j++){
			B[i][j] = 0;
		}
	}
	for(i=0; i<n; i++){
		B[i][i] = 1;
	}
	
	/***INVERT USING GAUSSIAN ELIMINATION***/
	for (j=0;j<n;j++) {
		for (i=j;i<n;i++) {
			if (A[i][j] != 0) {
				for (k=0;k<n;k++) {
					s = A[j][k];
					A[j][k] = A[i][k];
					A[i][k] = s;
	
					s = B[j][k];
					B[j][k] = B[i][k];
					B[i][k] = s;	
				}
				t = 1/A[j][j];	
				for (k=0;k<n;k++) {
					A[j][k] = t*A[j][k];
					B[j][k] = t*B[j][k];
				}
				for (L=0;L<n;L++) {
					if(L != j){
						t = -A[L][j];
						for(k=0;k<n;k++){
							A[L][k] = A[L][k] + t*A[j][k];
							B[L][k] = B[L][k] + t*B[j][k];
						}
					}
				}		
			}
			break;		
		}
		if (A[i][j] == 0){
			printf("Singular Matrix");
			return;		
		}	
	}
}

// from http://jefftechblog.posterous.com/otsus-method-image-thresholding-binarization
uint8_t calculate_binarize_threshold_otsu (uint32_t* gray_histogram, uint32_t total_pixels, double* var_sq) {
	uint32_t	i;
	uint32_t	n1, n2;
	uint32_t	sum;
	uint32_t	csum;
	double		m1, m2;
	double		result;
	double		fmax;
	uint8_t		thresh_index = 0;
	
	sum	= 0;
	for (i=0; i<256; i++) {
		sum += i * gray_histogram[i];
	}

	n1		= 0;
	n2		= 0;
	csum	= 0;
	fmax	= -1.0;

	for (i=0; i<256; i++) {
		
		n1	+= gray_histogram[i];
		if (n1 == 0) {
			// skip the beginning gray colors that don't have any pixels
			continue;
		}
		
		n2	= total_pixels - n1;
		if (n2 == 0) {
			// we can finish when we are out of colors with pixels
			break;
		}
		
		// do the calculations
		csum	+= i * gray_histogram[i];
		m1		= (double) csum / (double) n1;
		m2		= (double) (sum - csum) / (double) n2;
		result	= (double) n1 * (double) n2 * (m1 - m2) * (m1 - m2);

		if (result > fmax) {
			fmax			= result;
			thresh_index	= (uint8_t) i;
		}
	}

	*var_sq	= fmax;

	return thresh_index;
}

// from http://jefftechblog.posterous.com/entropy-based-image-thresholding-binarization
uint8_t calculate_binarize_threshold_entropy (uint32_t* gray_histogram, uint32_t total_pixels) {
	int			i, j;
	uint32_t	n1, n2;
	double		hb;
	double		hw;
	double		pj;
	double		fmax;
	uint8_t		thresh_index;


	fmax			= -1.0;
	thresh_index	= 0;

	for (i=0; i<256; i++) {
		n1	= 0;
		for (j=0; j<=i; j++) {
			n1 += gray_histogram[j];
		}

		if (n1 == 0) {
			continue;
		}

		n2	= total_pixels - n1;
		if (n2 == 0) {
			break;
		}

		hb	= 0.0;
		for (j=0; j<=i; j++) {
			if (gray_histogram[j] == 0) {
				continue;
			}
			pj	= (double) gray_histogram[j] / (double) n1;
			hb	-= pj * log(pj);
		}
		
		hw	= 0.0;
		for(; j<256; j++) {
			if (gray_histogram[j] == 0) {
				continue;
			}
			pj	= (double) gray_histogram[j] / (double) n2;
			hw	-= pj * log(pj);
		}

		if ((hb + hw) > fmax) {
			fmax			= hb + hw;
			thresh_index	= (uint8_t) i;
		}
	}

	return thresh_index;
}
