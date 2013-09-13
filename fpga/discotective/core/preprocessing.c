#include <stdio.h>
#include "preprocessing.h"
#include "global.h"
#include "alt_types.h"
#include "io.h"
#include "image_functions.h"
#include "ssd.h"
#include "led.h"
#include "allocate.h"
#include "general_functions.h"
#include "flex_array.h"


// Converts a gray scale image to binary using a simple threshold.
// Assumes the standard 2592x1944 8 bit grayscale image
// Uses 16 bit data movement.
void binarize_threshold (unsigned int gray_scale_img_start, image16_t *out_img) {
	alt_u32		i, j, k, l;
	alt_u16		two_pixels;
	alt_u16		binary_pixels;
	
	l = 0;
	for (j=0; j<1944; j++) {
		for (i=0; i<2592; i=i+16) {
			binary_pixels = 0;
			for (k=0; k<16; k=k+2) {
				// get the next 16 bytes
				two_pixels = IORD_16DIRECT(gray_scale_img_start, (j*2592) + i + k);
				// check if the byte should be white
				if ((two_pixels & 0xFF) > THRESHOLD) {
					binary_pixels |= (0x1 << k);
				}
				// check the next byte
				if (((two_pixels >> 8) & 0xFF) > THRESHOLD) {
					binary_pixels |= (0x1 << (k + 1));
				}
			}
			// write the converted pixel back
			IOWR_16DIRECT(out_img->pixels, l, binary_pixels);
			l += 2;
		}
	}

	// Set up return image.
	out_img->height		= 1944;
	out_img->width		= 2592;
	out_img->byte_width	= 324;
}

// Uses a simple transform to move bytes of pixels at a time to fix the
// fisheye.
void correct_fish_eye (image16_t* img, image16_t* out_img) {
	alt_32			height, width, i, j;
	alt_32			l;
	alt_32			m_x, m_y, scaler;
	alt_32			old_row;
	flex_array_t	*y_scalers;
	alt_u8			binary_pixels = 0;

	height		= img->height;
	width		= img->width;

	m_x			= width/2;
	m_y			= height/2;
	y_scalers	= flex_array_create_noinit(img->byte_width);

	// set up a horizontal array of parabola values
	// this is used to skew the image
	for (l=-m_x/8; l<m_x/8; l++) {
		y_scalers->data[l+m_x/8] = l*l;
	}

	for (j=0; j<height; j++) {
		for (i=0; i<img->byte_width; i++) {

			scaler = y_scalers->data[i];

			old_row = j + (scaler*(m_y-j)/637729);
			if (old_row < 0)			old_row = 0;
			else if (old_row >= height)	old_row = height-1;

			binary_pixels = IORD_8DIRECT(img->pixels, old_row*img->byte_width + i);

			IOWR_8DIRECT(out_img->pixels, j*img->byte_width + i, binary_pixels);
		}
	}

	flex_array_delete(y_scalers);

	out_img->width		= 2592;
	out_img->height		= 1944;
	out_img->byte_width	= 324;
}

// Crop the left and right sides off of an image.
// Does it in place.
void initial_crop_image (image16_t *img) {

	alt_u16 i, j;
	alt_u32 pixel_count;			// the number of pixels in a row/column
	alt_u32 left_crop	= 8;		// number of columns to remove from left
	alt_u32 right_crop	= 0;		// number of columns to remove from right
	alt_u32 top_crop	= 0;
	alt_u32 bottom_crop	= 0;
	alt_u8	in_black;				// when 1, we are still eliminating black rows/columns

	// Determine the number of rows to chop off of the bottom
	// Do this first and actually crop the image before doing the other
	// crops. This is easy to crop.
	in_black = 1;
	for (j=img->height; j>0; j--) {
		pixel_count = project_on_Y_single(img, j-1);

		if (in_black) {
			// We are eliminating black pixels from the edge
			bottom_crop++;
			if (pixel_count <= CROP_ROW_BLACK_MAX) {
				in_black = 0;
			}
		} else {
			// We are now eliminating the whitespace before hitting the staffs
			if (pixel_count < CROP_ROW_BLACK_MIN) {
				bottom_crop++;
			} else {
				break;
			}
		}
	}
	img->height -= bottom_crop;
	bottom_crop = 0;

	// Determine the number of columns to chop off on the left
	in_black = 1;
	for (i=8; i<img->width; i++) {
		pixel_count = project_on_X_single(img, i);

		if (in_black) {
			// We are eliminating black pixels from the edge
			left_crop++;
			if (pixel_count <= CROP_COL_BLACK_MAX) {
				in_black = 0;
			}
		} else {
			// We are now eliminating the whitespace before hitting the staffs
			if (pixel_count < CROP_COL_BLACK_MIN) {
				left_crop++;
			} else {
				break;
			}
		}
	}

	// Determine the number of columns to chop off on the right
	in_black = 1;
	for (i=img->width; i>0; i--) {
		pixel_count = project_on_X_single(img, i-1);

		if (in_black) {
			// We are eliminating black pixels from the edge
			right_crop++;
			if (pixel_count <= CROP_COL_BLACK_MAX) {
				in_black = 0;
			}
		} else {
			// We are now eliminating the whitespace before hitting the staffs
			if (pixel_count < CROP_COL_BLACK_MIN) {
				right_crop++;
			} else {
				break;
			}
		}
	}

	// Determine the number of rows to chop off of the top
	in_black = 1;
	for (j=0; j<img->height; j++) {
		pixel_count = project_on_Y_single(img, j);

		if (in_black) {
			// We are eliminating black pixels from the edge
			top_crop++;
			if (pixel_count <= CROP_ROW_BLACK_MAX) {
				in_black = 0;
			}
		} else {
			// We are now eliminating the whitespace before hitting the staffs
			if (pixel_count < CROP_ROW_BLACK_MIN) {
				top_crop++;
			} else {
				break;
			}
		}
	}

	//leave 2 padding in each dimension
//	if (left_crop <= 1) 	left_crop	= 0;
//	else					left_crop	-= 2;
//	if (right_crop <= 1)	right_crop	= 0;
//	else					right_crop	-= 2;
//	if (top_crop <= 1)		top_crop	= 0;
//	else					top_crop	-= 2;
//	if (bottom_crop <= 1)	bottom_crop	= 0;
//	else					bottom_crop	-= 2;

	left_crop = 0;

	top_crop	= (2 * top_crop) / 3;
	bottom_crop	= (2 * bottom_crop) / 3;

	// do the actual crop
	crop(img, img, left_crop, right_crop, top_crop, bottom_crop);
}
