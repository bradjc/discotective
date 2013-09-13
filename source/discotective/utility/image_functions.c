#include "global.h"
#include "image_functions.h"
#include "general_functions.h"
#include "flex_array.h"
#include "linked_list.h"
#include "allocate.h"
#include <stdlib.h>
#include "platform_specific.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


// Returns 1 if the pixel is black, 0 if it is white
pixel_color_e getPixel (const image_t *img, uint16_t x, uint16_t y) {
	uint32_t binary_pixels;

	binary_pixels = *(img->pixels + y*(img->word_width) + (x>>5));

	return (pixel_color_e) (((binary_pixels >> (x & 0x1F)) & 0x1) == BIN_COLOR_BLACK);
}

void setPixel (image_t *img, uint16_t x, uint16_t y, pixel_color_e value) {
	uint32_t binary_pixels;

	binary_pixels = *(img->pixels + y*(img->word_width) + (x>>5));

	if (value == WHITE)	*(img->pixels + y*(img->word_width) + (x>>5)) =	(binary_pixels | (0x1 << (x & 0x1F)));
	else				*(img->pixels + y*(img->word_width) + (x>>5)) =	(binary_pixels & ~(0x1 << (x & 0x1F)));
}

flex_array_t* project_on_X (const image_t* img) {
	return project_on_X_main(img, 0, img->height-1);
}

// projects the full x axis, but only uses rows between the indicies you provide
flex_array_t* project_on_X_partial (const image_t* img, uint16_t start_y, uint16_t end_y) {
	// bounds checking
	if (end_y < start_y || end_y >= img->height) {
		return NULL;
	}

	return project_on_X_main(img, start_y, end_y);
}

// Returns a flex array of the the numbers of black pixels in the columns of the image.
flex_array_t* project_on_X_main (const image_t* img, uint16_t start_y, uint16_t end_y) {
	uint16_t		i, j, k;
	uint32_t		binary_pixels;
	int16_t			pix_count[32] = {0};	// the number of black pixels in the column
	flex_array_t*	pix_count_array;

	// create the output array
	pix_count_array = flex_array_create_noinit(img->width);

	// loop through columns grouped by bytes
	for (i=0; i<img->word_width; i++) {
		// loop through all of the rows
		for (j=start_y; j<=end_y; j++) {
			binary_pixels = *(img->pixels + j*img->word_width + i);
			for (k=0; k<32; k++) {
				// count black pixels for 32 columns at a time
				if (((binary_pixels & (0x1 << k)) >> k) == BIN_COLOR_BLACK) {
					pix_count[k]++;
				}
			}
		}

		for (k=0; k<32; k++) {
			// record the 32 columns in the flex array
			if (i*32 + k < pix_count_array->length) {
				pix_count_array->data[i*32 + k] = pix_count[k];
			}
			// reset for the next 32 columns
			pix_count[k] = 0;
		}
	}

	return pix_count_array;
}

// Returns a flex array of the the numbers of black pixels in the rows of the image.
flex_array_t* project_on_Y (const image_t *img) {
	uint32_t		i, j, k;
	uint32_t		binary_pixels;
	uint16_t		pixel_count = 0;		// the number of black pixels in the column
	uint16_t		pixels_read;
	flex_array_t*	pix_count_array;

	pix_count_array = flex_array_create_noinit(img->height);

	// Loop through all of the rows
	for (j=0; j<img->height; j++) {
		pixel_count = 0;
		pixels_read	= 0;

		// Count the black pixels in the row
		for (i=0; i<img->word_width; i++) {
			binary_pixels = *(img->pixels + j*img->word_width + i);
			for (k=0; k<32; k++) {
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

// do a projection of only a column of the image
// you give the bounds that it includes in the image
flex_array_t* project_on_Y_partial (const image_t *img, uint16_t start_x, uint16_t end_x) {
	uint16_t		h, w;
	uint32_t		i, j, k;
	uint16_t		start_word, start_index;
	uint16_t		end_word, end_index;
	uint32_t		binary_pixels;
	uint16_t		pixel_count = 0;		// the number of black pixels in the column
	flex_array_t*	pix_count_array;

	h	= img->height;
	w	= img->width;

	// bounds checking
	if (start_x >= w || start_x > end_x) {
		return NULL;
	}
	if (end_x >= w) {
		end_x	= w - 1;
	}

	pix_count_array = flex_array_create_noinit(h);

	// find starting byte
	start_word	= start_x >> 5;
	start_index	= start_x & 0x1F;
	// find ending byte
	end_word	= end_x >> 5;
	end_index	= end_x & 0x1F;

	// Loop through all of the rows
	for (j=0; j<h; j++) {
		pixel_count = 0;

		// Count the black pixels in the row
		for (i=start_word; i<=end_word; i++) {
			binary_pixels = *(img->pixels + j*img->word_width + i);
			for (k=0; k<32; k++) {
				if ((binary_pixels & (0x1 << k)) == BIN_COLOR_BLACK) {
					pixel_count++;
				}
			}
		}
		
		// subtract off any pixels we may have counted that we weren't supposed to
		// this is because above we read the whole byte, and that may not be right
		binary_pixels = *(img->pixels + j*img->word_width + start_word);
		for (k=0; k<start_index; k++) {
			if ((binary_pixels & (0x1 << k)) == BIN_COLOR_BLACK) {
				pixel_count--;
			}
		}
		binary_pixels = *(img->pixels + j*img->word_width + end_word);
		for (k=end_index+1; k<32; k++) {
			if ((binary_pixels & (0x1 << k)) == BIN_COLOR_BLACK) {
				pixel_count--;
			}
		}

		// set value in array
		pix_count_array->data[j] = pixel_count;
	}

	return pix_count_array;
}

// wrapper function that deletes the old image
void crop (image_t** img, uint16_t left_crop, uint16_t right_crop, uint16_t top_crop, uint16_t bottom_crop) {
	image_t*	new_img;

	new_img = crop_main(*img, left_crop, right_crop, top_crop, bottom_crop);

	binary_image_delete(img);
	*img	= new_img;
}

// main crop function
image_t* crop_main (const image_t* img, uint16_t left_crop, uint16_t right_crop, uint16_t top_crop, uint16_t bottom_crop) {
	uint32_t	i, j, k, start;
	uint32_t	binary_pixels1, binary_pixels2;
	uint16_t	new_width, new_height, new_word_width;
	uint32_t	shift;
	image_t*	out_img = NULL;

	k				= 0;
	start			= left_crop>>5;
	new_width		= img->width - (right_crop + left_crop);
	new_height		= img->height - (top_crop + bottom_crop);
	new_word_width	= (new_width + 31)/32;

	shift			= (uint32_t) left_crop & 0x1F;

	// create a new image to put the output in
	out_img	= binary_image_create(new_height, new_width);

	// check if we can just copy the image
	if (left_crop == 0 && right_crop == 0 && top_crop == 0 && bottom_crop == 0) {
		binary_image_whiteout(out_img);
		binary_image_copy(img, out_img, 0, 0);
		return out_img;
	}

	if (shift > 0) {
		// do the fancy crop with bit shifting
		for (j=top_crop; j<(uint32_t)(img->height-bottom_crop); j++) {
			// get the first byte that has pixels we want to save
			// basically an initial setup
			binary_pixels1 = *(img->pixels + j*(img->word_width) + start);
			for (i=start + 1; i<=(new_word_width + start); i++) {
				// get the next 8 bit value
				binary_pixels2 = *(img->pixels + j*img->word_width + i);
				// shift over bin1 to save the pixels we care about
				binary_pixels1 = binary_pixels1 >> shift;
				// replace the pixels we just got rid of with the proper pixels from bin2
				binary_pixels1 |= (binary_pixels2 << (32 - shift));
				// write bin1 back to memory
				*(out_img->pixels + k++) = binary_pixels1;
				// save bin2 as bin1 for the next iteration
				binary_pixels1 = binary_pixels2;
			}
		}
	} else {
		// just copy rows to the new image
		for (j=top_crop; j<(uint32_t)(img->height-bottom_crop); j++) {
			for (i=start; i<(new_word_width + start); i++) {
				binary_pixels1 = *(img->pixels + j*img->word_width + i);
				*(out_img->pixels + k++) = binary_pixels1;
			}
		}
	}
	
	// assign the output image to the old image
	return out_img;
}

// get a smaller image and put it at new_img
// you give it the coordinates of the corners essentially
image_t* get_sub_img (const image_t* img, int16_t h_start, int16_t h_end, int16_t w_start, int16_t w_end) {
	uint16_t	left_crop;
	uint16_t	right_crop;
	uint16_t	top_crop;
	uint16_t	bottom_crop;

	// bounds checking
	if (	h_start < -1 || h_start >= img->height ||
			h_end < -1 || h_end >= img->height || (h_start > h_end && h_end >= 0) ||
			w_start < -1 || w_start >= img->width ||
			w_end < -1 || w_end >= img->width || (w_start > w_end && w_end >= 0)
		) {
			trigger_error();
	}

	if (h_start == -1)	top_crop = 0;
	else				top_crop = h_start;
	if (h_end == -1)	bottom_crop = 0;
	else				bottom_crop = img->height - h_end - 1;
	if (w_start == -1)	left_crop = 0;
	else				left_crop = w_start;
	if (w_end == -1)	right_crop = 0;
	else				right_crop = img->width - w_end - 1;
	
	return crop_main(img, left_crop, right_crop, top_crop, bottom_crop);
}

// Crops the whitespace off the edges
// only crops a row/col if it is entirely white
void pure_white_crop (image_t** img) {
	uint16_t	a;

	white_crop(img, 0.5, 0.5, 0, 0, 0, 0, &a, &a, &a, &a);
}

// Again only crops if the row is entirely white, but also returns
// how much was cropped
void pure_white_crop_returns (image_t** img, uint16_t* left_cropped, uint16_t* right_cropped, uint16_t* top_cropped, uint16_t* bottom_cropped) {
	white_crop(img, 0.5, 0.5, 0, 0, 0, 0, left_cropped, right_cropped, top_cropped, bottom_cropped);
}

// The master white crop. Has all the bells and whistles.
// the thresholds determine what is white. A count less than the passed in threshold is white.
// paddings will be added in if they can
// the pointers to direction_cropped are return values on how much was cropped off each dimension
void white_crop (	image_t** in_img,
					float h_threshold, float w_threshold,
					uint16_t left_padding, uint16_t right_padding, uint16_t top_padding, uint16_t bottom_padding,
					uint16_t* left_cropped, uint16_t* right_cropped, uint16_t* top_cropped, uint16_t* bottom_cropped) {

	flex_array_t*	x_proj;
	flex_array_t*	y_proj;
	uint16_t		left_crop;		// number of lines/columns to crop off each dimension
	uint16_t		right_crop;
	uint16_t		top_crop;
	uint16_t		bottom_crop;
	image_t*		img;

	// get the projections
	img		= *in_img;
	x_proj	= project_on_X(img);
	y_proj	= project_on_Y(img);
	
	// determine how much to crop
	left_crop	= 0;
	right_crop	= 0;
	top_crop	= 0;
	bottom_crop	= 0;
	
	while (left_crop < img->width-1		&& (float) x_proj->data[left_crop] < h_threshold)					left_crop++;
	while (right_crop < img->width-1	&& (float) x_proj->data[img->width-1-right_crop] < h_threshold)		right_crop++;
	while (top_crop < img->height-1		&& (float) y_proj->data[top_crop] < h_threshold)					top_crop++;
	while (bottom_crop < img->height-1	&& (float) y_proj->data[img->height-1-bottom_crop] < h_threshold)	bottom_crop++;

	flex_array_delete(&x_proj);
	flex_array_delete(&y_proj);
	
	// leave in some padding
	left_crop	= subtract_u16(left_crop, left_padding);
	right_crop	= subtract_u16(right_crop, right_padding);
	top_crop	= subtract_u16(top_crop, top_padding);
	bottom_crop	= subtract_u16(bottom_crop, bottom_padding);

	// check to make sure crops don't overlap
	if (left_crop + right_crop >= img->width) {
		left_crop	= 0;
		right_crop	= img->width - 1;
	}
	if (top_crop + bottom_crop >= img->height) {
		top_crop	= 0;
		bottom_crop	= img->height - 1;
	}
	
	// do the crop
	crop(in_img, left_crop, right_crop, top_crop, bottom_crop);

	// set the return values on how much was cropped
	*left_cropped	= left_crop;
	*right_cropped	= right_crop;
	*top_cropped	= top_crop;
	*bottom_cropped	= bottom_crop;
}

// only deletes in the bounding box
void blob_kill (image_t* img, uint16_t start_x, uint16_t start_y, int16_t left_bound, int16_t right_bound, int16_t top_bound, int16_t bottom_bound) {
	pixel_t**		stack		= NULL;
	uint32_t		stack_ptr	= 0;	// points to the first empty position on stack
	pixel_t*		new_pixel	= NULL;
	pixel_t*		curr_pixel	= NULL;
	int16_t			x_coord;
	int16_t			y_coord;
	static int16_t	offsets[16]	= {0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0, -1, -1};
	uint16_t		h, w;
	int				i;
	uint16_t		l_bound, r_bound, t_bound, b_bound;

	h	= img->height;
	w	= img->width;

	// set bounds
	if (left_bound == -1)	l_bound	= 0;
	else					l_bound = (uint16_t) left_bound;
	if (right_bound == -1)	r_bound	= w-1;
	else					r_bound = (uint16_t) right_bound;
	if (top_bound == -1)	t_bound	= 0;
	else					t_bound = (uint16_t) top_bound;
	if (bottom_bound == -1)	b_bound	= h-1;
	else					b_bound = (uint16_t) bottom_bound;

	// check that the starting point is in the image and bounds
	if (start_x >= w || start_y >= h || start_x > r_bound || start_y > b_bound) {
		return;
	}

	// create the largest array we could need
	stack = (pixel_t**) malloc(sizeof(pixel_t*) * (uint32_t) w * (uint32_t) h);

	// clear starting point and put it on the stack
	setPixel(img, start_x, start_y, WHITE);
	new_pixel			= (pixel_t*) malloc(sizeof(pixel_t));
	new_pixel->x		= start_x;
	new_pixel->y		= start_y;
	stack[stack_ptr++]	= new_pixel;

	// keep looping until the stack is empty
	while (1) {
		if (stack_ptr == 0) {
			// theres nothing on the stack and it's time to stop
			break;
		}

		// get the current center pixel
		curr_pixel	= stack[--stack_ptr];

		// loop through the 8 pixels surrounding it
		for (i=0; i<15; i+=2) {

			x_coord		= (int16_t) curr_pixel->x + offsets[i];
			y_coord		= (int16_t) curr_pixel->y + offsets[i+1];

			if (	x_coord >= 0 && x_coord < w && y_coord >= 0 && y_coord < h &&
					getPixel(img, x_coord, y_coord) &&
					x_coord >= l_bound && x_coord <= r_bound &&
					y_coord >= t_bound && y_coord <= b_bound
				) {
				setPixel(img, x_coord, y_coord, WHITE);
				new_pixel			= (pixel_t*) malloc(sizeof(pixel_t));
				new_pixel->x		= x_coord;
				new_pixel->y		= y_coord;
				stack[stack_ptr++]	= new_pixel;
			}

		}
		free(curr_pixel);
	}

	free(stack);
}

// Works like blob kill does, but instead of erasing the pixels it copies them to the second image

// start_x:	x location in img to start looking for black
// start_y:	y location in img to start looking for black
// offset_x:	distance between the left side of img and the left side of img2
// offset_x:	distance between the top of img and the top of img2
// The offsets let you have a smaller image that doesn't extend all the way back to the origin of the 
// original image. (offsets are basically used for a coordinate transform)
// The arguments are uint32_t because they are often multiplied together and need to be large
// enough to handle that.
void blob_copy (const image_t* img, image_t* img2, uint32_t start_x, uint32_t start_y, uint32_t offset_x, uint32_t offset_y) {
	pixel_t**	stack;
	uint8_t*	seen;
	uint32_t	stack_ptr = 0;	// points to the first empty position on stack
	pixel_t*	new_pixel;
	pixel_t*	curr_pixel;
	int32_t		x_coord;
	int32_t		y_coord;
	uint32_t	arr_ind;
	int32_t		offsets[16] = {0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0, -1, -1};
	uint32_t	h, w, h2, w2;
	uint32_t	small_img_size;
	uint32_t	i;

	h				= (uint32_t) img->height;
	w				= (uint32_t) img->width;
	h2				= (uint32_t) img2->height;
	w2				= (uint32_t) img2->width;
	small_img_size	= w2 * h2;

	// check that the offsets are not larger than the starting point
	// (the small image includes where we need to start)
	if (offset_x > start_x || offset_y > start_y) {
		return;
	}

	// check that the starting point is in the image
	if (start_x-offset_x >= w2 || start_y-offset_y >= h2) {
		return;
	}

	// create the largest array for the stack we could need
	// the stack locations are indexed into the small img (img2)
	stack	= (pixel_t**) malloc(sizeof(pixel_t*) * small_img_size);

	// create an array to keep track of where we've been
	// in blob kill this is done by erasing pixels
	seen	= (uint8_t*) malloc(sizeof(uint8_t*) * small_img_size);
	// initialize that array to 0 (meaning nothing has been seen
	for (i=0; i<small_img_size; i++) {
		seen[i] = 0;
	}

	// mark starting point and put it on the stack
	setPixel(img2, (uint16_t) (start_x-offset_x), (uint16_t) (start_y-offset_y), BLACK);
	seen[(start_y-offset_y)*w2 + (start_x-offset_x)] = 1;
	new_pixel			= (pixel_t*) malloc(sizeof(pixel_t));
	new_pixel->x		= (uint16_t) (start_x-offset_x);
	new_pixel->y		= (uint16_t) (start_y-offset_y);
	stack[stack_ptr++]	= new_pixel;

	// keep looping until the stack is empty
	while (1) {
		if (stack_ptr == 0) {
			// theres nothing on the stack and it's time to stop
			break;
		}

		// get the current center pixel
		curr_pixel	= stack[--stack_ptr];

		// loop through the 8 pixels surrounding it
		for (i=0; i<16; i+=2) {

			x_coord		= (int32_t) curr_pixel->x + offsets[i];
			y_coord		= (int32_t) curr_pixel->y + offsets[i+1];
			arr_ind		= (y_coord*w2) + x_coord;

			if (	x_coord > 0 && x_coord < (int32_t) w2 &&
					y_coord > 0 && y_coord < (int32_t) h2 &&
					getPixel(img, (uint16_t) (x_coord+offset_x), (uint16_t) (y_coord+offset_y)) &&
					!seen[arr_ind]
			   ) {
				setPixel(img2, (uint16_t) x_coord, (uint16_t) y_coord, BLACK);
				seen[arr_ind]		= 1;
				new_pixel			= (pixel_t*) malloc(sizeof(pixel_t));
				new_pixel->x		= (uint16_t) x_coord;
				new_pixel->y		= (uint16_t) y_coord;
				stack[stack_ptr++]	= new_pixel;
			}

		}
		free(curr_pixel);
	}

	free(stack);
	free(seen);

}

// Works like blob kill and blob copy. It both erases the blob from the original image
// and copies it to the new image
void blob_copy_and_kill (image_t* img, image_t* img2, uint32_t start_x, uint32_t start_y, uint32_t offset_x, uint32_t offset_y) {
	pixel_t**	stack;
	uint32_t	stack_ptr = 0;	// points to the first empty position on stack
	pixel_t*	new_pixel;
	pixel_t*	curr_pixel;
	int32_t		x_coord;
	int32_t		y_coord;
	int32_t		offsets[16] = {0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0, -1, -1};
	uint32_t	h, w, h2, w2;
	uint32_t	small_img_size;
	uint32_t	i;

	h				= (uint32_t) img->height;
	w				= (uint32_t) img->width;
	h2				= (uint32_t) img2->height;
	w2				= (uint32_t) img2->width;
	small_img_size	= w2 * h2;

	// check that the offsets are not larger than the starting point
	// (the small image includes where we need to start)
	if (offset_x > start_x || offset_y > start_y) {
		return;
	}

	// check that the starting point is in the image
	if (start_x-offset_x >= w2 || start_y-offset_y >= h2) {
		return;
	}

	// create the largest array for the stack we could need
	// the stack locations are indexed into the small img (img2)
	stack	= (pixel_t**) malloc(sizeof(pixel_t*) * small_img_size);

	// mark starting point and put it on the stack
	setPixel(img2, (uint16_t) (start_x-offset_x), (uint16_t) (start_y-offset_y), BLACK);
	setPixel(img, (uint16_t) start_x, (uint16_t) start_y, WHITE);
	new_pixel			= (pixel_t*) malloc(sizeof(pixel_t));
	new_pixel->x		= (uint16_t) (start_x-offset_x);
	new_pixel->y		= (uint16_t) (start_y-offset_y);
	stack[stack_ptr++]	= new_pixel;

	// keep looping until the stack is empty
	while (1) {
		if (stack_ptr == 0) {
			// theres nothing on the stack and it's time to stop
			break;
		}

		// get the current center pixel
		curr_pixel	= stack[--stack_ptr];

		// loop through the 8 pixels surrounding it
		for (i=0; i<16; i+=2) {

			x_coord		= (int32_t) curr_pixel->x + offsets[i];
			y_coord		= (int32_t) curr_pixel->y + offsets[i+1];

			if (	x_coord >= 0 && x_coord < (int32_t) w2 &&
					y_coord >= 0 && y_coord < (int32_t) h2 &&
					getPixel(img, (uint16_t) (x_coord+offset_x), (uint16_t) (y_coord+offset_y))
			   ) {
				setPixel(img2, (uint16_t) x_coord, (uint16_t) y_coord, BLACK);
				setPixel(img, (uint16_t) (x_coord+offset_x), (uint16_t) (y_coord+offset_y), WHITE);
				new_pixel			= (pixel_t*) malloc(sizeof(pixel_t));
				new_pixel->x		= (uint16_t) x_coord;
				new_pixel->y		= (uint16_t) y_coord;
				stack[stack_ptr++]	= new_pixel;
			}

		}
		free(curr_pixel);
	}

	free(stack);

}

// returns a flex array of the runs in a given column/row of an image
linked_list* find_runs (const image_t* img, uint16_t index, direction_e direction, uint16_t start_index, uint16_t end_index) {
	linked_list*	runs;
	pixel_color_e	pixel = WHITE;
	pixel_color_e	prev_pixel;
	uint16_t		i;
	uint16_t		length;
	uint16_t		num_runs;
	uint16_t		run_length;
	uint16_t		run_start;
	run_t*			run;



	if (direction == LEFT_TO_RIGHT || direction == RIGHT_TO_LEFT) {
		if (index >= img->height) return NULL;

		length	= img->width;

	} else if (direction == TOP_TO_BOTTOM || direction == BOTTOM_TO_TOP) {
		if (index >= img->width) return NULL;

		length	= img->height;

	} else {
		return NULL;
	}

	// check start end index
	if (start_index > end_index || start_index >= length) {
		return NULL;
	}

	// create a linked list
	runs	= linked_list_create();

	num_runs	= 0;
	run_length	= 0;
	run_start	= 0;
	prev_pixel	= WHITE;
	for (i=start_index; i<=end_index+1; i++) {
		if (i != end_index+1) {
			if (direction == LEFT_TO_RIGHT) {
				pixel	= getPixel(img, i, index);
			} else if (direction == RIGHT_TO_LEFT) {
				pixel	= getPixel(img, length-1-i, index);
			} else if (direction == TOP_TO_BOTTOM) {
				pixel	= getPixel(img, index, i);
			} else {
				pixel	= getPixel(img, index, length-1-i);
			}
		}

		if ((pixel != prev_pixel && i != 0) || i == end_index+1) {
			run	= (run_t*) malloc(sizeof(run_t));
			run->color	= prev_pixel;
			run->length	= run_length;
			run->start	= run_start;
			run->end	= i - 1;
			linked_list_push_bottom(runs, (void**) &run);

			run_length	= 0;
			run_start	= i;
		}
		
		run_length++;
		prev_pixel	= pixel;
	}

	return runs;
}

// returns 1 if the runs match the specifications
uint8_t parse_runs (const linked_list* runs, uint16_t num_white, uint16_t num_black, pixel_color_e first, uint16_t white_min, uint16_t white_max, uint16_t black_min, uint16_t black_max) {
	flex_array_t*	out_arr	= NULL;
	uint8_t			ret;

	ret	= parse_runs_main(runs, num_white, num_black, first, white_min, white_max, black_min, black_max, &out_arr);
	if (out_arr != NULL) {
		flex_array_delete(&out_arr);
	}
	return ret;
}

// returns 1 if the runs match the specifications
// also returns a flex array of which runs matched the reqs
uint8_t parse_runs_main (const linked_list* runs, uint16_t num_white, uint16_t num_black, pixel_color_e first, uint16_t white_min, uint16_t white_max, uint16_t black_min, uint16_t black_max, flex_array_t** out_arr) {
	run_t*			run;
	pixel_color_e	looking_for;
	uint16_t		num_white_found;
	uint16_t		num_black_found;
	uint16_t		i;
	pixel_color_e	color;
	uint16_t		length;


	// initial check
	if (num_white == 0 && num_black == 0)	return 1;

	if (runs->length < (num_white + num_black)) {
		// aren't enough runs to fulfill this
		return 0;
	}

	// set up flex array
	*out_arr	= flex_array_create(num_white + num_black);

	looking_for		= first;
	num_white_found	= 0;
	num_black_found	= 0;

	for (i=0; i<runs->length; i++) {

		run		= (run_t*) linked_list_getIndexData(runs, i);
		color	= run->color;
		length	= run->length;

		if (color == looking_for && ((color == WHITE && length >= white_min && length <= white_max) || (color == BLACK && length >= black_min && length <= black_max))) {
			// we found the first
			if (color == WHITE) {
				num_white_found++;
				looking_for	= BLACK;
			} else {
				num_black_found++;
				looking_for	= WHITE;
			}
			// mark it in the flex array
			(*out_arr)->data[num_white_found + num_black_found - 1]	= i;
		} else {
			// this run didn't fit
			// the runs have to be consequtive, so since this one breaks it, start over
			num_white_found	= 0;
			num_black_found	= 0;
		}

		if (num_white_found == num_white && num_black_found == num_black) {
			return 1;
		}
	}

	flex_array_delete(out_arr);
	return 0;
}

// Finds the indicies of the bounds of the black in the image
// returns 0 if no black
uint8_t find_bounds (const image_t* img, uint16_t* left_bound, uint16_t* right_bound, uint16_t* top_bound, uint16_t* bottom_bound) {
	flex_array_t*	proj;
	int32_t			top_b, bot_b, lef_b, rig_b;
	int				i;

	proj	= project_on_Y(img);
	top_b	= -1;
	bot_b	= -1;
	lef_b	= -1;
	rig_b	= -1;

	// do top and bottom
	for (i=0; i<img->height; i++) {
		if (top_b == -1 && proj->data[i] > 0)				top_b	= i;
		if (bot_b == -1 && proj->data[img->height-1-i] > 0)	bot_b	= img->height-1-i;
		if (top_b > -1 && bot_b > -1)	break;
	}
	flex_array_delete(&proj);

	if (top_b == -1) {
		return 0;
	}

	// do the left and right
	proj	= project_on_X_partial(img, (uint16_t) top_b, (uint16_t) bot_b);
	for (i=0; i<img->width; i++) {
		if (lef_b == -1 && proj->data[i] > 0)				lef_b	= i;
		if (rig_b == -1 && proj->data[img->width-1-i] > 0)	rig_b	= img->width-1-i;
		if (lef_b > -1 && rig_b > -1)	break;
	}
	flex_array_delete(&proj);

	if (lef_b == -1) {
		return 0;
	}

	*left_bound		= (uint16_t) lef_b;
	*right_bound	= (uint16_t) rig_b;
	*top_bound		= (uint16_t) top_b;
	*bottom_bound	= (uint16_t) bot_b;

	return 1;
}

// Takes an image and treats it like a canvas. It moves the pixels on the image
//	with respect to the canvas. It takes 0,0 (upper left corner) and maps it to
//	x_new,y_new.
void binary_image_move (image_t* img, int16_t x_new, int16_t y_new) {
	int16_t		i, j;
	int16_t		x_old, y_old;
	int16_t		x_cur, y_cur;
	int16_t		h, w;
	uint8_t		left_shift;
	uint8_t		up_shift;


	h	= (int16_t) img->height;
	w	= (int16_t) img->width;

	// check if there is any movement to do
	if (x_new == 0 && y_new == 0) {
		return;
	}

	// determine which ways were moving this image
	left_shift	= 0;
	up_shift	= 0;
	if (x_new < 0)	left_shift	= 1;
	if (y_new < 0)	up_shift	= 1;

	// loop through the canvas and find the old pixel to copy there
	for (j=0; j<h; j++) {
		if (up_shift)		y_cur	= j;
		else				y_cur	= h - 1 - j;
		
		y_old	= (-1 * y_new) + y_cur;

		if (y_old < 0 || y_old >= h)
			continue;
		
		for (i=0; i<w; i++) {
			if (left_shift)	x_cur	= i;
			else			x_cur	= w - 1 - i;

			x_old	= (-1 * x_new) + x_cur;

			if (x_old < 0 || x_old >= w)
				continue;

			setPixel(img, x_cur, y_cur, getPixel(img, x_old, y_old));
		}
	}
}

// copies a smaller image (img1) into a larger image (img2) starting at offset_x, offset_y
// only copies black pixels
void binary_image_copy (const image_t* img1, image_t* img2, uint16_t offset_x, uint16_t offset_y) {
	uint16_t	h1, w1;
	uint16_t	h2, w2;
	int			i, j;

	h1	= img1->height;
	w1	= img1->width;
	h2	= img2->height;
	w2	= img2->width;

	// check that the starting point is in the image
	if (offset_x >= w2 || offset_y >= h2) {
		return;
	}

	// traverse the small image and copy the black pixels
	for (j=0; j<h1; j++) {
		for (i=0; i<w1; i++) {
			if (getPixel(img1, i, j)) {
				if (i+offset_x < w2 && j+offset_y < h2) {
					setPixel(img2, i+offset_x, j+offset_y, BLACK);
				}
			}
		}
	}
}

uint32_t count_black (const image_t* img) {
	flex_array_t*	proj_y;
	uint32_t		accum;
	
	proj_y	= project_on_Y(img);
	accum	= (uint32_t) flex_array_sum(proj_y);

	flex_array_delete(&proj_y);

	return  accum;
}

uint8_t all_black (const image_t* img) {
	return ((uint32_t) img->width * (uint32_t) img->height) == count_black(img);
}

// set an image as all white
void binary_image_whiteout (image_t* img) {
	uint16_t	i, j;
	uint32_t	k;

	k = 0;
	for (j=0; j<img->height; j++) {
		for (i=0; i<img->word_width; i++) {
			*(img->pixels + k++) = BIN_WHITE_WORD;
		}
	}
}

image_t* binary_image_create (uint16_t height, uint16_t width) {
	image_t*	img;

	img				= (image_t*) malloc(sizeof(image_t));
	img->height		= height;
	img->width		= width;
	img->word_width	= (width+31)/32;
	img->pixels		= (uint32_t*) malloc(sizeof(uint32_t) * (uint32_t) height * (uint32_t) img->word_width);

	return img;
}

void binary_image_display (const image_t* img) {
	uint8_t*		data;
	uint32_t		outheight;
	uint32_t		outwidth;
	uint32_t		i, j;

	outheight	= img->height;
	outwidth	= img->width;
	
	data = (uint8_t*) malloc(sizeof(uint8_t) * outheight * outwidth);
	
    // copy img to output images
	for (i=0; i<outheight; i++) {
        for (j=0; j<outwidth; j++) {
            data[i*outwidth + j] = 255 * (1-getPixel(img, (uint16_t) j, (uint16_t) i));
        }
    }
	display_image(data, (uint16_t) outheight, (uint16_t) outwidth);
}

void binary_image_delete (image_t** img) {
	free((*img)->pixels);
	free(*img);
	*img = NULL;
}

// creates a 256 element array with the number of pixels with that
//	grayscale value in each element
uint32_t* grayscale_image_histogram (const grayimage_t* img) {
	uint32_t*	histo_arr	= NULL;
	uint32_t	num_pixels;
	uint32_t	i;

	histo_arr	= (uint32_t*) malloc(sizeof(uint32_t) * 256);
	num_pixels	= (uint32_t) img->height * (uint32_t) img->width;

	// clear array
	for (i=0; i<256; i++) {
		histo_arr[i]	= 0;
	}

	// create histogram
	for (i=0; i<num_pixels; i++) {
		histo_arr[img->image[i]]++;
	}

	return histo_arr;
}

void grayscale_image_display (const grayimage_t* img) {
	uint8_t*	data;
	uint32_t	length;
	uint32_t	i;

	length	= (uint32_t) img->width * (uint32_t) img->height;

	data	= (uint8_t*) malloc(sizeof(uint8_t) * length);

	for (i=0; i<length; i++) {
		data[i]	= img->image[i];
	}
	display_image(data, img->height, img->width);
}

void grayscale_image_delete (grayimage_t** img) {
	free((*img)->image);
	free(*img);
	*img	= NULL;
}
