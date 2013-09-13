#include "alt_types.h"
#include "global.h"
#include "image_functions.h"
#include "io.h"
#include "utility_functions.h"
#include "flex_array.h"
#include "ssd.h"


// Returns the number of black pixels in the specified column of the image.
alt_u32 project_on_X_single (const image16_t *img, alt_u32 column) {
	alt_u32	j;
	alt_u32	byte_number;
	alt_u32	bit_offset;
	alt_u8	binary_pixels;
	alt_u32	pixel_count = 0;		// the number of black pixels in the column


	// Determine which byte the column is in
	byte_number = column / 8;

	// Determine which bit the column is in a byte
	bit_offset = column & 0x7;

	// Loop through all of the necessary bytes of the column data and determine if the
	// pixel is black.
	for (j=0; j<img->height; j++) {
		binary_pixels = IORD_8DIRECT(img->pixels, j*img->byte_width + byte_number);
		if (((binary_pixels & (0x1 << bit_offset)) >> bit_offset) == BIN_COLOR_BLACK) {
			pixel_count++;
		}
	}

	return pixel_count;
}

// Returns the number of black pixels in the specified row of the image.
alt_u32 project_on_Y_single (const image16_t *img, alt_u32 row) {
	alt_u32	i, k;
	alt_u16	binary_pixels;
	alt_u32	pixel_count = 0;		// the number of black pixels in the column


	// Count the black pixels in the row
	for (i=0; i<(img->width)/16; i++) {
		binary_pixels = IORD_16DIRECT(img->pixels, row*(img->width/8) + i*2);
		for (k=0; k<16; k++) {
			if ((binary_pixels & (0x1 << k)) == BIN_COLOR_BLACK) {
				pixel_count++;
			}
		}
	}

	// Check to see if we missed a byte since we used 16 bit words above
	binary_pixels = 0;
	if (img->width & 0x7) {
		binary_pixels = IORD_8DIRECT(img->pixels, row*(img->width/8) + (img->width)/8);
		for (k=0; k<8; k++) {
			if ((binary_pixels & (0x1 << k)) == BIN_COLOR_BLACK) {
				pixel_count++;
			}
		}
	}

	return pixel_count;
}

// Returns a flex array of the the numbers of black pixels in the columns of the image.
flex_array_t* project_on_X (const image16_t *img) {
	alt_u16			i, j, k;
	alt_u8			binary_pixels;
	alt_16			pix_count[8] = {0, 0, 0, 0, 0, 0, 0, 0};	// the number of black pixels in the column
	flex_array_t*	pix_count_array;

	// create the output array
	pix_count_array = flex_array_create_noinit(img->width);

	// loop through columns grouped by bytes
	for (i=0; i<img->byte_width; i++) {
		// loop through all of the rows
		for (j=0; j<img->height; j++) {
			binary_pixels = IORD_8DIRECT(img->pixels, j*img->byte_width + i);
			for (k=0; k<8; k++) {
				// count black pixels for 8 columns at a time
				if (((binary_pixels & (0x1 << k)) >> k) == BIN_COLOR_BLACK) {
					pix_count[k]++;
				}
			}
		}

		for (k=0; k<8; k++) {
			// record the 8 columns in the flex array
			if (i*8 + k < pix_count_array->length) {
				pix_count_array->data[i*8 + k] = pix_count[k];
			}
			// reset for the next 8 columns
			pix_count[k] = 0;
		}
	}

	return pix_count_array;
}

// Returns a flex array of the the numbers of black pixels in the rows of the image.
flex_array_t* project_on_Y (const image16_t *img) {
	alt_u32			i, j, k;
	alt_u8			binary_pixels;
	alt_u16			pixel_count = 0;		// the number of black pixels in the column
	alt_u16			pixels_read;
	flex_array_t*	pix_count_array;

	pix_count_array = flex_array_create_noinit(img->height);

	// Loop through all of the rows
	for (j=0; j<img->height; j++) {
		pixel_count = 0;
		pixels_read	= 0;

		// Count the black pixels in the row
		for (i=0; i<img->byte_width; i++) {
			binary_pixels = IORD_8DIRECT(img->pixels, j*img->byte_width + i);
			for (k=0; k<8; k++) {
				if ((pixels_read < img->width) && (binary_pixels & (0x1 << k)) == BIN_COLOR_BLACK) {
					pixel_count++;
				}
				pixels_read++;
			}
		}

		pix_count_array->data[j] = pixel_count;
	}

	return pix_count_array;
}

// Returns 1 if the pixel is black, 0 if it is white
inline uint8_t getPixel (const image16_t *img, alt_u16 x, alt_u16 y) {
	uint8_t binary_pixels;

	binary_pixels = IORD_8DIRECT(img->pixels, y*(img->byte_width) + x/8);

	return ((binary_pixels >> (x & 0x7)) & 0x1) == BIN_COLOR_BLACK;
}

inline void setPixel (image16_t *img, uint16_t x, uint16_t y, uint8_t value) {
	uint8_t binary_pixels;

	binary_pixels = IORD_8DIRECT(img->pixels, y*(img->byte_width) + x/8);

	if (!value) {
		IOWR_8DIRECT(img->pixels, y*(img->byte_width) + x/8, binary_pixels | (0x1 << (x & 0x7)));
	} else {
		IOWR_8DIRECT(img->pixels, y*(img->byte_width) + x/8, binary_pixels & ~(0x1 << (x & 0x7)));
	}
}

void crop (const image16_t* img, image16_t* out_img, alt_u32 left_crop, alt_u32 right_crop, alt_u32 top_crop, alt_u32 bottom_crop) {
	alt_u32		i, j, k, start;
	alt_u8		binary_pixels1, binary_pixels2;
	uint16_t	new_width, new_height, new_byte_width;

	k = 0;

	start			= left_crop/8;
	new_width		= img->width - (right_crop + left_crop);
	new_height		= img->height - (top_crop + bottom_crop);
	new_byte_width	= (new_width + 7)/8;

	for (j=top_crop; j<img->height-bottom_crop; j++) {

		// get the first byte that has pixels we want to save
		// basically an initial setup
		binary_pixels1 = IORD_8DIRECT(img->pixels, j*(img->byte_width) + start);
		for (i = start + 1; i < (new_byte_width + start + 1); i++) {
			// get the next 8 bit value
			binary_pixels2 = IORD_8DIRECT(img->pixels, j*(img->byte_width) + i);
			// shift over bin1 to save the pixels we care about
			binary_pixels1 = binary_pixels1 >> (left_crop & 0x7);
			// replace the pixels we just got rid of with the proper pixels from bin2
			binary_pixels1 |= (binary_pixels2 << (8 - (left_crop & 0x7)));
			// write bin1 back to memory
			IOWR_8DIRECT(out_img->pixels, k++, binary_pixels1);
			// save bin2 as bin1 for the next iteration
			binary_pixels1 = binary_pixels2;
		}
	}

	out_img->width		= new_width;
	out_img->height		= new_height;
	out_img->byte_width = new_byte_width;
}

// get a smaller image and put it at new_img
// you give it the coordinates of the corners essentially
void get_sub_img (const image16_t* img, image16_t* out_img, int16_t h_start, int16_t h_end, int16_t w_start, int16_t w_end) {
	alt_u16 left_crop;
	alt_u16 right_crop;
	alt_u16 top_crop;
	alt_u16 bottom_crop;

	if (h_start == -1) {
		top_crop = 0;
	} else {
		top_crop = h_start;
	}
	if (h_end == -1) {
		bottom_crop = 0;
	} else {
		bottom_crop = img->height - h_end + 1;
	}
	if (w_start == -1) {
		left_crop = 0;
	} else {
		left_crop = w_start;
	}
	if (w_end == -1) {
		right_crop = 0;
	} else {
		right_crop = img->width - w_end - 1;
	}

	crop (img, out_img, left_crop, right_crop, top_crop, bottom_crop);
}

uint8_t all_black (const image16_t* img) {
	uint16_t i, j;

	for (i=0; i<img->height; i++) {
		for (j=0; j<img->width; j++) {
			if (!getPixel(img, j, i)) {
				return 0;
			}
		}
	}
	return 1;
}
