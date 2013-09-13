#include "preprocessing.h"
#include "allocate.h"
#include "image_functions.h"
#include "general_functions.h"
#include "math.h"
#include "linked_list.h"
#include "platform_specific.h"
#include "scanning.h"


// Converts a height*width long array of RGBA data to a grayscale image.
// Uses gray = 0.2126*red + 0.7152*green + 0.0722*blue
// out_img: you give it a pointer to a grayimage_t, it allocates it
void convert_rgb_to_grayscale (uint8_t* rgbaData, uint16_t height, uint16_t width, grayimage_t** out_img) {
	int	i;
	int	size;
	
	size = height * width;
	
	// allocate the grayscale image
	*out_img = (grayimage_t*) malloc(sizeof(grayimage_t));
	(*out_img)->height	= height;
	(*out_img)->width	= width;
	(*out_img)->image	= (uint8_t*) malloc(sizeof(uint8_t) * size);
	
	// convert the rgb values to a single 2d array of 8 bit grayscale values
	for (i=0; i<size; i++) {
		(*out_img)->image[i] = (uint8_t) (0.2126*rgbaData[4*i] + 0.7152*rgbaData[4*i+1] + 0.0722*rgbaData[4*i+2]);
	}
}


// Binarize an image using quadratic linear regression
// Allocates the necessary space for the binary image
void binarizeIMG (const grayimage_t* gray_img, image_t** binIMG) {

	float		**X;
	float		**covMatrix;
	float		*intermediate;
	float		*W;
	float		**covMatrixINV;
	float		*Bias;
	float		threshold;
	float		sum;
	uint32_t	i, j, k;
	uint32_t	height, width;
	uint32_t	size;
	uint32_t	counter;

	threshold	= -20;

	height		= (uint32_t) gray_img->height;
	width		= (uint32_t) gray_img->width;
	
	size		= gray_img->height * gray_img->width;

	// initlize X and Y for quadratic linear regression
	X			= (float**) multialloc(sizeof(float), 2, size, 6);
	
	// create the image
	*binIMG	= binary_image_create((uint16_t) height, (uint16_t) width);

	counter = 0;
	for (i=0; i<height; i++) {
		for (j=0; j<width; j++) {
			X[counter][0] = 1.0F;
			X[counter][1] = (float) i;
			X[counter][2] = (float) j;
			X[counter][3] = (float) i*j;
			X[counter][4] = (float) i*i;
			X[counter][5] = (float) j*j;
			counter++;
		}
	}

	// solve for the weights W of the quadratic linear regression
	intermediate = (float*) get_spc(6, sizeof(float));
	for (i=0; i<6; i++) {
		sum = 0;
		for (j=0; j<size; j++) {
			sum += X[j][i] * (float) gray_img->image[j];	
		}
		intermediate[i] = sum;
	}

	covMatrix = (float**) multialloc(sizeof (float), 2, 6, 6);
	for (k=0; k<6; k++) {
		for (i=0; i<6; i++) {
			sum = 0;
			for (j=0; j<size; j++) {
				sum += (X[j][k] * X[j][i]);
			}
			covMatrix[k][i] = sum;
		}
	}

	covMatrixINV = (float**) multialloc(sizeof (float), 2, 6, 6);
	myMatrixInverse(covMatrix, 6, covMatrixINV);


	W = (float*) get_spc(6, sizeof(float));
	for (i=0; i<6; i++) {
		sum = 0;
		for (j=0; j<6; j++) {
			sum += covMatrixINV[i][j] * intermediate[j];
		}
		W[i] = sum;
	}

	// transform image using determined weights
	Bias = (float*) get_spc(size, sizeof(float));
	for (i=0; i<size; i++) {
		sum = 0;
		for(j=0; j<6; j++) {
			sum += X[i][j] * W[j];
		}
		Bias[i] = sum;
	}

	// binarize image
	counter = 0;
	for(i=0; i<height; i++){
		for(j=0; j<width; j++){
			if ((float) (gray_img->image[counter] - Bias[counter]) > threshold) {
				setPixel(*binIMG, (uint16_t) j, (uint16_t) i, WHITE); 
			} else {
				setPixel(*binIMG, (uint16_t) j, (uint16_t) i, BLACK);
			}
			counter++;
		}
	}

	multifree(X, 2); 
	multifree(covMatrix, 2);
	free(intermediate);
	free(W);
	multifree(covMatrixINV, 2);
	free(Bias);
}

void binarize_threshold (const grayimage_t* gray_img, image_t** bin_img, binarize_threshold_e threshold_type) {
	uint16_t	i, j;
	uint32_t	counter;
	uint32_t*	gray_histogram;
	uint8_t		threshold;
	double		dummy;

	// create the binary image
	*bin_img	= binary_image_create(gray_img->height, gray_img->width);

	// get the threshold
	gray_histogram	= grayscale_image_histogram(gray_img);
	switch (threshold_type) {
		case FIXED:
			threshold	= 0x7F;
			break;
		case OTSU:
			threshold	= calculate_binarize_threshold_otsu(gray_histogram, (uint32_t) gray_img->height * (uint32_t) gray_img->width, &dummy);
			break;
		case ENTROPY:
			threshold	= calculate_binarize_threshold_entropy(gray_histogram, (uint32_t) gray_img->height * (uint32_t) gray_img->width);
			break;
		default:
			threshold	= 0;
			break;
	}
	free(gray_histogram);

	counter = 0;
	for (j=0; j<gray_img->height; j++) {
		for (i=0; i<gray_img->width; i++) {
			if (gray_img->image[counter] > threshold) {
				setPixel(*bin_img, i, j, WHITE); 
			} else {
				setPixel(*bin_img, i, j, BLACK);
			}
			counter++;
		}
	}
}

// square size is the height and width of the square the image will be divided into
image_t* binarize_threshold_adaptive_otsu (const grayimage_t* gray_img, uint16_t square_size) {
	image_t*	bin_img		= NULL;
	uint32_t	h, w;
	uint32_t	s_size;
	uint32_t	squares_x;
	uint32_t	squares_y;
	uint32_t	i, j, k;
	uint32_t	x, y;
	uint32_t	row, col;
	uint32_t	total_pixels;
	double		var_sq;
	uint8_t		threshold;
	uint32_t*	histo_arr	= NULL;

	// create the image and white it out so we don't have to copy white
	bin_img	= binary_image_create(gray_img->height, gray_img->width);
	binary_image_whiteout(bin_img);

	if (square_size > gray_img->width || square_size > gray_img->height) {
		trigger_error();
		return bin_img;
	}

	w			= (uint32_t) gray_img->width;
	h			= (uint32_t) gray_img->height;
	s_size		= (uint32_t) square_size;

	squares_x	= (w + (s_size-1)) / s_size;
	squares_y	= (h + (s_size-1)) / s_size;

	// create the needed arrays
	histo_arr	= (uint32_t*) malloc(sizeof(uint32_t) * 256);

	// loop through all of the squares
	for (j=0; j<squares_y; j++) {
		for (i=0; i<squares_x; i++) {

			// clear array
			for (k=0; k<256; k++) histo_arr[k]	= 0;
			total_pixels	= 0;

			// calculate the histogram of the square
			for (y=0; y<s_size; y++) {
				for (x=0; x<s_size; x++) {
					row	= (j * s_size) + y;
					col	= (i * s_size) + x;
					
					if (row >= h || col >= w) {
						// not in the image
						continue;
					}

					histo_arr[gray_img->image[(row * w) + col]]++;
					total_pixels++;
				}
			}

			// calculate the threshold of that square
			threshold	= calculate_binarize_threshold_otsu(histo_arr, total_pixels, &var_sq);

//#ifdef DEBUG_BINARIZE_ADAPTIVE_OTSU
//disco_log("thresh: %f", var_sq);
//#endif

			// check to see if the variance squared is above our threshold
			if (var_sq > 999000000) {
	//		if (var_sq > 1800000000) {
				// this square has good data in it

				// use the threshold to fill in the binary image
				for (y=0; y<s_size; y++) {
					for (x=0; x<s_size; x++) {
						row	= (j * s_size) + y;
						col	= (i * s_size) + x;
						
						if (row >= h || col >= w) {
							// not in the image
							continue;
						}

						if (gray_img->image[(row * w) + col] <= threshold + 10) {
							setPixel(bin_img, (uint16_t) col, (uint16_t) row, BLACK);
						}
					}
				}
			}
		
		}
	}

	free(histo_arr);

	return bin_img;
}





void vertical_deskew_staff (image_t** in_img, staff_t* staff) {
	//deskew(in_img, 0, staff);

	uint16_t	a_x1, a_y1, a_x2, a_y2;
	uint16_t	b_x1, b_y1, b_x2, b_y2;
#ifdef DEBUG_DESKEW
image_t*	test_img;
int			i;
int16_t		mid_1;
#endif


#ifdef DEBUG_DESKEW
test_img	= binary_image_create((*in_img)->height, (*in_img)->width);
binary_image_whiteout(test_img);
binary_image_copy(*in_img, test_img, 0, 0);
#endif

	// find the lines to use
	find_first_measure_line(*in_img, staff, &a_x1, &a_y1, &a_x2, &a_y2);
	find_last_measure_line(*in_img, staff, &b_x1, &b_y1, &b_x2, &b_y2);

#ifdef DEBUG_DESKEW
// draw on the best chosen line
for (i=a_y1; i<a_y2; i++) {
	mid_1	= ((((int16_t) a_x2 - (int16_t) a_x1) * i) / (*in_img)->height) + (int16_t) a_x1;
	if (mid_1 >= 0 && mid_1 < (*in_img)->width) {
		setPixel(test_img, (uint16_t) mid_1, i, (pixel_color_e) (i & 0x2));
	}
}
for (i=b_y1; i<b_y2; i++) {
	mid_1	= ((((int16_t) b_x2 - (int16_t) b_x1) * i) / (*in_img)->height) + (int16_t) b_x1;
	if (mid_1 >= 0 && mid_1 < (*in_img)->width) {
		setPixel(test_img, (uint16_t) mid_1, i, (pixel_color_e) (i & 0x2));
	}
}
binary_image_display(test_img);
binary_image_delete(&test_img);
#endif

	perform_deskew (in_img, a_x1, a_y1, a_x2, a_y2, b_x1, b_y1, b_x2, b_y2, 0);

}

void horizontal_deskew (image_t** in_img) {
//		this code works by first choosing
//		the points d1, d2, b1, and b2.
//		b2|-----\       |
//		  |      \------|b1
//		  |             |
//		  |             |
//		  |             |d1
//		d2|             |
//		  |             |
//		the points are chosen so that the line
//		that connects them passes through many
//		dark pixels (a staffline hopefully).
//
//		next the vanishing point is calculated
//		using algebra, and a simple map is
//		created to adjust for any skew

	int16_t			h, w;
	image_t*		img;

	flex_array_t*	proj;
	uint16_t		start1, start2;
	uint16_t		proj_max_ind1, proj_max_ind2, proj_max_ind3;
	uint16_t		proj_max1, proj_max2;

	uint16_t		tweak_dist_ind;
	int16_t			tweak_dist_horiz_arr[NUM_HORIZ_TWEAK_DISTANCES]	= {50, 10, 1};
	int16_t			tweak_dist;
	int16_t			start_1a, start_1b, start_2a, start_2b;
	int16_t			check_1a, check_1b, check_2a, check_2b;
	int16_t			best_1a, best_1b, best_2a, best_2b;
	uint16_t		line_count_1, line_count_2;
	uint16_t		best_line_count_1, best_line_count_2;
	int16_t			mid_1, mid_2;

	int16_t			img_iter;
	int16_t			iter_a, iter_b;
	int				i;

#ifdef DEBUG_DESKEW
image_t*		test_img;
#endif

	// variable naming conventions
	// horizontal skew:
	//	1 = top set or line
	//	2 = bottom points
	//	a = left
	//	b = right
	
	// SETUP
	img	= *in_img;
	h	= img->height;
	w	= img->width;

#ifdef DEBUG_DESKEW
test_img	= binary_image_create((uint16_t) h, (uint16_t) w);
binary_image_whiteout(test_img);
binary_image_copy(img, test_img, 0, 0);
#endif
	

	// first, lets find some reasonable places to start
	// do this by taking a projection and looking for maximums
	// do a cool thing for horizontal skew
	// for vertical skew, much more simple
	proj			= project_on_Y(img);

#ifdef DEBUG_DESKEW
flex_array_display(proj, 1);
#endif

	proj_max_ind1	= flex_array_max_index(proj);
	proj_max1		= proj->data[proj_max_ind1];
	proj->data[proj_max_ind1]	= 0;
	proj_max_ind2	= flex_array_max_index(proj);

	// now try to get two maximums that aren't in the same staff line
	proj_max_ind3	= proj_max_ind2;
	i				= 0;
	while (1) {
		i++;
		if (abs_16((int16_t) proj_max_ind2 - (int16_t) proj_max_ind1) < 200 && i < proj->length) {
			proj->data[proj_max_ind2]	= 0;
			proj_max_ind2				= flex_array_max_index(proj);
		} else {
			break;
		}
	}
//	if (proj->data[proj_max_ind2] < (75*proj_max1)/100) {
		// if the next max that was far enough away is too low, reset it to the second best
//		proj_max_ind2	= proj_max_ind3;
//	}
	proj_max2	= proj->data[proj_max_ind2];

	flex_array_delete(&proj);

	// reorganize
	start1	= min_u16(proj_max_ind1, proj_max_ind2);
	start2	= max_u16(proj_max_ind1, proj_max_ind2);
//	if (proj_max_ind2 > proj_max_ind1) {
//		start1	= proj_max_ind1;
//		start2	= proj_max_ind2;
//	} else {
//		start1	= proj_max_ind2;
//		start2	= proj_max_ind1;
//	}


#ifdef DEBUG_DESKEW
// mark the starting guess on the test img
for (i=0; i<w; i++) {
	setPixel(test_img, (uint16_t) i, start1, BLACK);
	setPixel(test_img, (uint16_t) i, start2, BLACK);
}
binary_image_display(test_img);
#endif

	// check to see if the starting points are too close.
	// if so, deskew doesn't seem to work ever
//	if (start2 - start1 < 90) {
//		disco_log("horizontal_deskew starting points are too close");
//#ifdef DEBUG_DESKEW
//binary_image_delete(&test_img);
//#endif
//		return;
//	}

	// set the starting variables for finding a good line
	// 1=top or left, 2=bottom or right
	best_1a				= start1;
	best_1b				= start1;
	best_line_count_1	= proj_max1;
	best_2a				= start2;
	best_2b				= start2;
	best_line_count_2	= proj_max2;

	// now adjust b1, b2 to find a line that hits a lot of black
	for (tweak_dist_ind=0; tweak_dist_ind<NUM_HORIZ_TWEAK_DISTANCES; tweak_dist_ind++) {
		
		// the tweak distance is the amount to move the current b1 and b2 up and down
		tweak_dist	= tweak_dist_horiz_arr[tweak_dist_ind];

		start_1a	= best_1a;
		start_1b	= best_1b;
		start_2a	= best_2a;
		start_2b	= best_2b;

		// do each tweak distance 10 times below and 10 times above
		// do so by starting at 0 and oscillating around zero, trying to prioritize our first guess
		for (iter_a=0; iter_a<=20; iter_a++) {
			check_1a	= (int16_t) start_1a + (((iter_a & 0x1)?(iter_a/-2):(iter_a/2)) * tweak_dist);
			check_2a	= (int16_t) start_2a + (((iter_a & 0x1)?(iter_a/-2):(iter_a/2)) * tweak_dist);

			for (iter_b=0; iter_b<=20; iter_b++) {
				check_1b	= (int16_t) start_1b + (((iter_b & 0x1)?(iter_b/-2):(iter_b/2)) * tweak_dist);
				check_2b	= (int16_t) start_2b + (((iter_b & 0x1)?(iter_b/-2):(iter_b/2)) * tweak_dist);

				// count the number of pixels between the two test points
				line_count_1	= 0;
				line_count_2	= 0;
				// create a line and count the number of black pixels on that line
				for (img_iter=0; img_iter<w; img_iter++) {
					mid_1	= (((check_1b - check_1a) * img_iter) / w) + check_1a;
					mid_2	= (((check_2b - check_2a) * img_iter) / w) + check_2a;
					if (mid_1 >= 0 && mid_1 < h) {
						line_count_1	+= (uint16_t) getPixel(img, img_iter, (uint16_t) mid_1);
					}
					if (mid_2 >= 0 && mid_2 < h) {
						line_count_2	+= (uint16_t) getPixel(img, img_iter, (uint16_t) mid_2);
					}

				}
				// check to see if this is the best line we have yet
				if (line_count_1 > best_line_count_1) {
					best_line_count_1	= line_count_1;
					best_1a				= check_1a;
					best_1b				= check_1b;
#ifdef DEBUG_DESKEW
// draw on the best line choice so far (top)
for (img_iter=0; img_iter<w; img_iter++) {
	mid_1	= (((check_1b - check_1a) * img_iter) / w) + check_1a;
	if (mid_1 >= 0 && mid_1 < h) {
		setPixel(test_img, img_iter, (uint16_t) mid_1, BLACK);
	}
}
binary_image_display(test_img);
#endif
				}

				if (line_count_2 > best_line_count_2) {
					best_line_count_2	= line_count_2;
					best_2a				= check_2a;
					best_2b				= check_2b;
#ifdef DEBUG_DESKEW
// draw on the best line choice so far (bottom)
for (img_iter=0; img_iter<w; img_iter++) {
	mid_2	= (((check_2b - check_2a) * img_iter) / w) + check_2a;
	if (mid_2 >= 0 && mid_2 < h) {
		setPixel(test_img, img_iter, (uint16_t) mid_2, BLACK);
	}
}
binary_image_display(test_img);
#endif
				}
			}
		}
	}

#ifdef DEBUG_DESKEW
// draw on the best chosen line
for (img_iter=0; img_iter<w; img_iter++) {
	mid_1	= (((best_1b - best_1a) * img_iter) / w) + best_1a;
	if (mid_1 >= 0 && mid_1 < h) {
		setPixel(test_img, img_iter, (uint16_t) mid_1, (pixel_color_e) (img_iter & 0x2));
	}
	mid_2	= (((best_2b - best_2a) * img_iter) / w) + best_2a;
	if (mid_2 >= 0 && mid_2 < h) {
		setPixel(test_img, img_iter, (uint16_t) mid_2, (pixel_color_e) (img_iter & 0x2));
	}
}
binary_image_display(test_img);
binary_image_delete(&test_img);
#endif


	// do the actual transformation
	perform_deskew(in_img, 0, (uint16_t) best_1a, w-1, (uint16_t) best_1b, 0, (uint16_t) best_2a, w-1, (uint16_t) best_2b, 1);

}

void perform_deskew (image_t** in_img, uint16_t ax1, uint16_t ay1, uint16_t ax2, uint16_t ay2, uint16_t bx1, uint16_t by1, uint16_t bx2, uint16_t by2, uint8_t horizontal_skew) {
	int32_t			h, w;

	int32_t			a_x1, a_y1;
	int32_t			a_x2, a_y2;
	int32_t			b_x1, b_y1;
	int32_t			b_x2, b_y2;

	int32_t			img_dim_end;
	int32_t			img_dim_end_other;

	int32_t			A1, B1, C1;
	int32_t			A2, B2, C2;
	int32_t			p;
	float			a_slope;
	float			b_slope;
	float			slope;

	int32_t			img_iter;

	float			vp_x, vp_y;
	float			vp_val;
	float			theta;
	float*			r;
	float			val;
	int32_t			m_x, m_y;
	int32_t			row, col;
	int32_t			old_val;
	int32_t			old_x, old_y;

	int32_t			y_mid;
	int32_t			x_shift;

	image_t*		img;
	image_t*		new_img;

	img	= *in_img;
	h	= img->height;
	w	= img->width;

	// change variable types so subtraction works
	a_x1	= (int32_t) ax1;
	a_y1	= (int32_t) ay1;
	a_x2	= (int32_t) ax2;
	a_y2	= (int32_t) ay2;

	b_x1	= (int32_t) bx1;
	b_y1	= (int32_t) by1;
	b_x2	= (int32_t) bx2;
	b_y2	= (int32_t) by2;

	// create new image for output
	new_img	= binary_image_create((uint16_t) h, (uint16_t) w);

	// set up some variables based on which skew correction were doing
	if (horizontal_skew) {
		img_dim_end			= w;
		img_dim_end_other	= h;
	} else {
		img_dim_end			= h;
		img_dim_end_other	= w;
	}

	// calculate slopes
	if (horizontal_skew) {
		if (a_x2 - a_x1 == 0)	a_slope	= 1000000.0F;
		else					a_slope	= (float) (a_y2-a_y1) / (float) (a_x2-a_x1);
		if (b_x2 - b_x1 == 0)	b_slope	= 1000000.0F;
		else					b_slope	= (float) (b_y2-b_y1) / (float) (b_x2-b_x1);
	} else {
		if (a_y2 - a_y1 == 0)	a_slope	= 100000.0F;
		else					a_slope	=  (float) (a_x2-a_x1) / (float) (a_y2-a_y1);
		if (b_y2 - b_y1 == 0)	b_slope	= 100000.0F;
		else					b_slope	=  (float) (b_x2-b_x1) / (float) (b_y2-b_y1);
	}

	// do the actual transformation

	// check to see if the lines are parallel
	// slope == (y2-y1)/(x2-x1)
	// check the slop of each line to see if they are parallel
	// multiply the slope equation out to avoid division
	if ((a_y2-a_y1)*(b_x2-b_x1) != (b_y2-b_y1)*(a_x2-a_x1)) {
		// lines are not parallel

		// calculate the intersection point

		// get lines in Ax+By=C format
		A1	= a_y2 - a_y1;
		B1	= a_x1 - a_x2;
		C1	= (A1*a_x1) + (B1*a_y1);

		A2	= b_y2 - b_y1;
		B2	= b_x1 - b_x2;
		C2	= (A2*b_x1) + (B2*b_y1);

		// calculate the vanishing intersection point
		// http://www.topcoder.com/tc?module=Static&d1=tutorials&d2=geometry2
		vp_y	= (float) (A1*C2 - A2*C1) / (float) (A1*B2 - A2*B1);
		vp_x	= ((float) C1 - ((float) B1 * vp_y)) / (float) A1;

		// create a float array for coefficients
		r	= (float*) malloc(sizeof(float) * img_dim_end);

		// set the correct vanishing point value based on which direction were doing
		if (horizontal_skew) {
			vp_val	= vp_y;
			if (abs_float(b_slope) < abs_float(a_slope)) {
				slope	= a_slope;
				p		= a_y2;
			} else {
				slope	= b_slope;
				p		= b_y2;
			}
		} else {
			vp_val	= vp_x;
			if (abs_float(b_slope) < abs_float(a_slope)) {
				slope	= a_slope;
				p		= a_x2;
			} else {
				slope	= b_slope;
				p		= b_x2;
			}
		}
		
		// use line with largest slope to calculate ratio for transformation:
		for (img_iter=0; img_iter<img_dim_end; img_iter++) {
			// I don't know what val is actually calculating
			val			= slope * (float) (img_iter - (img_dim_end-1)) + (float) p;
			r[img_iter]	= ((float) p - vp_val) / (val - vp_val);
		}
		
		// perform transformation
		for (row=0; row<h; row++) {
		    for (col=0; col<w; col++) {
				//calculate coordinate from which to take pixel:
				old_val	= round_32((vp_val + ((float) ((horizontal_skew)?row:col)-vp_val) / r[((horizontal_skew)?col:row)]));
				if (old_val < 0)						old_val	= 0;
				else if (old_val >= img_dim_end_other)	old_val	= img_dim_end_other-1;
				
				//assign pixel in new image:
				setPixel(new_img, (uint16_t) col, (uint16_t) row, getPixel(img, (uint16_t) ((horizontal_skew)?col:old_val), (uint16_t) ((horizontal_skew)?old_val:row)));
		    }
		}

		free(r);
	} else {
		// just do a rotation
		
		if (horizontal_skew) {
   	 		theta	= -1.0F * (float) atan(((float) a_y1 - (float) a_y2) / (float) w);
  	  		m_y		= (int32_t) h / 2;
			m_x		= (int32_t) w / 2;
			
			// PERFORM TRANSFORMATION
			for (row=0; row<h; row++) {
				for (col=0; col<w; col++) {
					
					//calculate coordinate from which to take pixel:
					old_y = round_32((float) m_y + (float) (row - m_y) * (float) cos(theta) + (float) (col - m_x) * (float) sin(theta));
					old_x = round_32((float) m_x + (float) (m_y - row) * (float) sin(theta) + (float) (col - m_x) * (float) cos(theta));
					
					//boundary checking
					if (old_x < 0)			old_x	= 0;
					else if (old_x >= w)	old_x	= w-1;
					if (old_y < 0)			old_y	= 0;
					else if (old_y >= h)	old_y	= h-1;
				
					// assign pixel in new image
					setPixel(new_img, (uint16_t) col, (uint16_t) row, getPixel(img, (uint16_t) old_x, (uint16_t) old_y));
				}
			}
		} else {
			// Here we have two lines that are parallel
			// If those lines are slanted, we want to shift the image so that those lines become vertical
			if (a_slope != 0.0F) {
				// the lines are slanted and need to be fixed

				// find the y midpoint of the lines
				// pixels above this point will be shifted one way, below will be shifted the other way
				y_mid	= (a_y2 + a_y1) / 2;

				// create a flex array that will hold the shift amounts for each row in the image
		//		x_shifts	= flex_array_create_noinit(h);

				// go through the height of the image and calculate the amount that row needs to be shifted
				// then shift it
				for (row=0; row<h; row++) {
					x_shift	= round_32(a_slope * (row - y_mid));

					for (col=0; col<w; col++) {
						if (col + x_shift < 0 || col + x_shift >= w) {
							// pixel we need is off the page
							setPixel(new_img, (uint16_t) col, (uint16_t) row, WHITE);
						} else {
							setPixel(new_img, (uint16_t) col, (uint16_t) row, getPixel(img, (uint16_t) (col + x_shift), (uint16_t) row));
						}
					}
				}
				binary_image_display(new_img);

			} else {
				// they are already vertical
				binary_image_whiteout(new_img);
				binary_image_copy(img, new_img, 0, 0);
			}
		}
	}
	
	// delete old image
	binary_image_delete(&img);

	// assign output
	*in_img = new_img;
}


void white_crop_preprocess (image_t** img) {
	float		h_threshold;
	float		w_threshold;
	uint16_t	a;
	
	// calculate the threshold
	h_threshold	= HORIZONTAL_THRSH_MULT * (*img)->height;
	w_threshold	= VERTICAL_THRSH_MULT * (*img)->width;
	
	white_crop(img, h_threshold, w_threshold, LEFT_RIGHT_PADDING, LEFT_RIGHT_PADDING, TOP_BOTTOM_PADDING, TOP_BOTTOM_PADDING, &a, &a, &a, &a);
}

void edge_blob_kill (image_t* img) {
	uint16_t	i;

	// start on the left
	// scan down until we hit a black pixel. then run blob kill.
	// then continue scanning incase the blobs aren't connected
	for (i=0; i<img->height; i++) {
		if (getPixel(img, 0, i)) {
			blob_kill(img, 0, i, -1, -1, -1, -1);
#ifdef DEBUG_EDGE_BLOB_KILL
disco_log("left %d", i);
//binary_image_display(img);
#endif
		}
	}

	// do the right
	for (i=0; i<img->height; i++) {
		if (getPixel(img, img->width-1, i)) {
			blob_kill(img, img->width-1, i, -1, -1, -1, -1);
#ifdef DEBUG_EDGE_BLOB_KILL
disco_log("righ %d", i);
//binary_image_display(img);
#endif
		}
	}

	// do the top
	for (i=0; i<img->width; i++) {
		if (getPixel(img, i, 0)) {
			blob_kill(img, i, 0, -1, -1, -1, -1);
#ifdef DEBUG_EDGE_BLOB_KILL
disco_log("top  %d", i);
//binary_image_display(img);
#endif
		}
	}

	// do the bottom
	for (i=0; i<img->width; i++) {
		if (getPixel(img, i, img->height-1)) {
			blob_kill(img, i, img->height-1, -1, -1, -1, -1);
#ifdef DEBUG_EDGE_BLOB_KILL
disco_log("bot  %d", i);
//binary_image_display(img);
#endif
		}
	}

}

// Crop the left and right sides off of an image.
// Does it in place.
void initial_crop_image (image_t** in_img) {
	
	uint16_t		i, j;
	uint16_t		pixel_count;			// the number of pixels in a row/column
	uint16_t		left_crop	= 8;		// number of columns to remove from left
	uint16_t		right_crop	= 0;		// number of columns to remove from right
	uint16_t		top_crop	= 0;
	uint16_t		bottom_crop	= 0;
	uint8_t			in_black;				// when 1, we are still eliminating black rows/columns
	flex_array_t*	proj_x;
	flex_array_t*	proj_y;
	uint32_t		ten_percent_val[4] = {1};	// left, right, top, bot	// set at 1 to make sure each gets cropped at least a little
	uint32_t		largest;
	uint16_t		largest_index	= 0;
	uint16_t		direction_max	= 0;
	uint16_t		end_factor		= 0;
	uint16_t		crop_val;
	image_t*		img;

	img		= *in_img;

	// we need to determine which direction to crop first
	// do this by looking at the first 10% of each projection in both directions
	// do the largest first
	proj_x	= project_on_X(img);
	proj_y	= project_on_Y(img);

flex_array_display(proj_x, 0);
flex_array_display(proj_y, 1);

	for (i=0; i<img->width/10; i++) {
		ten_percent_val[0]	+= proj_x->data[i];
		ten_percent_val[1]	+= proj_x->data[img->width-1-i];
	}

	for (i=0; i<img->height/10; i++) {
		ten_percent_val[2]	+= proj_y->data[i];
		ten_percent_val[3]	+= proj_y->data[img->height-1-i];
	}

	flex_array_delete(&proj_x);
	flex_array_delete(&proj_y);

	// loop through all 4 directions
	for (i=0; i<4; i++) {

		// find largest direction
		largest = 0;
		for (j=0; j<4; j++) {
			if (ten_percent_val[j] > largest) {
				largest			= ten_percent_val[j];
				largest_index	= j;
			}
		}

		// mark this one as done
		ten_percent_val[largest_index] = 0;

		// choose which to delete
		switch (largest_index) {
			case 0:
				// left
				proj_x			= project_on_X(img);
				direction_max	= img->width;
				end_factor		= 0;
				break;

			case 1:
				// right
				proj_x			= project_on_X(img);
				direction_max	= img->width;
				end_factor		= img->width-1;
				break;

			case 2:
				// top
				proj_x			= project_on_Y(img);
				direction_max	= img->height;
				end_factor		= 0;
				break;

			case 3:
				// top
				proj_x			= project_on_Y(img);
				direction_max	= img->height;
				end_factor		= img->height-1;
				break;

			default:
				break;
		}

		// do main calculation loop
		in_black	= 1;
		crop_val	= 0;
		for (j=0; j<direction_max; j++) {
			if (end_factor == 0) {
				pixel_count = proj_x->data[j];
			} else {
				pixel_count = proj_x->data[end_factor - j];
			}

			// first determine if we should even crop this way at all
			if (j == 0) {
				if (pixel_count < 2) break;
			}
			
			if (in_black) {
				// We are eliminating black pixels from the edge
				crop_val++;
				if (pixel_count <= (4*flex_array_max(proj_x))/10) {
					in_black = 0;
				}
			} else {
				// We are now eliminating the whitespace before hitting the staffs
				if (pixel_count < (1*flex_array_max(proj_x))/10) {
					crop_val++;
				} else {
					break;
				}
			}
		}

		left_crop	= 0;
		right_crop	= 0;
		top_crop	= 0;
		bottom_crop	= 0;

		// set the proper crop and add smart padding on the left and right
		// do < 50*(3-i) so that the later the crop the stricter the black count must be
		//   the idea behind that is to make sure large black blobs are touching the edge
		//   so blob kill gets them
		switch (largest_index) {
			case 0:
				// left
				left_crop = crop_val;
				if (left_crop > 9 && proj_x->data[left_crop] < 50*(4-i)) {
					// there is room to add padding and there is a small enough black
					// on the edge that we don't need to remove that blob.
					left_crop	-= 10;
				}
				break;

			case 1:
				// right
				right_crop = crop_val;
				if (right_crop > 9 && proj_x->data[img->width-1-right_crop] < 50*(4-i)) {
					// there is room to add padding and there is a small enough black
					// on the edge that we don't need to remove that blob.
					right_crop	-= 10;
				}
				break;

			case 2:
				// top
				top_crop = crop_val;
				if (top_crop > 9 && proj_x->data[top_crop] < 50*(4-i)) {
					// there is room to add padding and there is a small enough black
					// on the edge that we don't need to remove that blob.
					top_crop	-= 10;
				}
				break;

			case 3:
				bottom_crop = subtract_u16(crop_val, 40);
	//			if (bottom_crop > 39) {
					// there is room to add padding and there is a small enough black
					// on the edge that we don't need to remove that blob.
	//				bottom_crop	-= 40;
	//			} else {
	//				bottom_crop = 0;
	///			}
				break;

			default:
				break;
		}

		flex_array_delete(&proj_x);

		// do the crop
		crop(in_img, left_crop, right_crop, top_crop, bottom_crop);
		img	= *in_img;

#ifdef DEBUG_PREPROCESS_CROP
binary_image_display(img);
#endif

	}

}

void inside_outside_crop (image_t** in_img) {
	image_t*		img;
	uint16_t		top_q, bot_q;
	uint16_t		center;
	uint16_t		thresh;
	uint16_t		left_crop;
	uint16_t		right_crop;
	flex_array_t*	proj_x;
	int				i;

	
	img		= *in_img;
	top_q	= img->height / 4;
	bot_q	= (3 * img->height) / 4;
	center	= img->width / 2;
	thresh	= (9 * img->height) / 20;

	proj_x	= project_on_X_partial(img, top_q, bot_q);
//	flex_array_display(proj_x, 0);
	left_crop	= 0;
	right_crop	= 0;

	// find where we hit black
	for (i=0; i<img->width/2; i++) {
		if (left_crop == 0 && proj_x->data[center - i] > thresh) {
			left_crop	= center - i;
		}
		if (right_crop == 0 && proj_x->data[center + i] > thresh) {
			right_crop	= img->width - 1 - (center + i);
		}
	}

	// backtrack to white
	for (i=left_crop; i<img->width; i++) {
		if (proj_x->data[i] == 0) {
			left_crop	= i;
			break;
		}
	}
	for (i=right_crop; i<img->width; i++) {
		if (proj_x->data[img->width - 1 - i] == 0) {
			right_crop	= i;
			break;
		}
	}

	// check that this crop found what it was supposed to
	if (left_crop < img->width/2 && right_crop < img->width/2) {
		crop(in_img, left_crop, right_crop, 0, 0);
	}

	flex_array_delete(&proj_x);

}
