#include "vga.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "alt_types.h"
#include "io.h"
#include "global.h"
#include "ssd.h"
#include "flex_array.h"
#include "image_functions.h"

int VGA_initialized = 0;
alt_up_pixel_buffer_dma_dev* VGA_port;
alt_u8 vga_using_back_buffer = 0;

int vga_init () {
	if (!VGA_initialized) {
		VGA_port = alt_up_pixel_buffer_dma_open_dev("/dev/video_pixel_buffer_dma_0");
		if (VGA_port != NULL) {
			VGA_initialized = 1;
		}
	}
	return VGA_initialized;
}

void vga_clear () {
	if (!vga_init()) return;

	alt_up_pixel_buffer_dma_draw_box(VGA_port, 0, 0, 639, 479, 0xFF, 1);
}

void vga_clear_black () {
	if (!vga_init()) return;

	alt_up_pixel_buffer_dma_draw_box(VGA_port, 0, 0, 639, 479, 0x00, 1);
}

void vga_draw_pixel (unsigned int color, unsigned int x, unsigned int y) {
	if (!vga_init()) return;
	if (!vga_bounds_ok(x, y)) return;

	alt_up_pixel_buffer_dma_draw(VGA_port, color, x, y);
}

void vga_draw_pixel_fast (unsigned int color, unsigned int x, unsigned int y) {
	unsigned int base = VGA_BASE;
	if (!vga_using_back_buffer) base = VGA_BASE_BACK;

	IOWR_8DIRECT(base, x + (y*640), color);
}

void vga_draw_box (int color, int x0, int y0, int x1, int y1) {
	if (!vga_init()) return;
	if (!vga_bounds_ok(x0, y0)) return;
	if (!vga_bounds_ok(x1, y1)) return;

	alt_up_pixel_buffer_dma_draw_box(VGA_port, x0, y0, x1, y1, color, 0);
}

void vga_change_back_buffer_address (unsigned int address) {
	if (!vga_init()) return;

	alt_up_pixel_buffer_dma_change_back_buffer_address(VGA_port, address);
}

void vga_swap_buffer () {
	if (!vga_init()) return;

	vga_using_back_buffer ^= 0x1;

	alt_up_pixel_buffer_dma_swap_buffers(VGA_port);
}

int vga_bounds_ok (int x, int y) {
	if (x < 0 || x >= VGA_WIDTH) return 0;
	if (y < 0 || y >= VGA_HEIGHT) return 0;
	return 1;
}

// Draw a binary pixel image to the VGA.
// Only works if the image is 3199x2399 or less. Although it won't work very well for those super large images.
void vga_draw_binary_img (const image16_t *img) {
	alt_u32 i, j, k, l, m;
	alt_u32 l_loop_start;
	alt_u16	binary_pixels;
	alt_u8	color;

	alt_u32 horizontal_skip;
	alt_u32 vertical_skip;
	alt_u32 horizontal_size = VGA_WIDTH;	// the display size of the image to be drawn
	alt_u32 vertical_size = VGA_HEIGHT;		// how tall to draw
	alt_u32 pixels_per_iteration;			// how many pixels will be written per 1 iteration of the 'i' for loop
	alt_u8	row_predone;					// in case we need to write some bytes to get 16 bit alignment
	alt_u32 pixel_counter;					// keeps track of the number of pixels in a row that have been written to the VGA


	// Start by blacking the display in case we don't fill it all
	vga_clear_black();

	if (img->width <= VGA_WIDTH && img->height <= VGA_HEIGHT) {
		horizontal_skip	= 1;
		vertical_skip	= 1;
	} else {
		horizontal_skip	= 4;
		vertical_skip	= 4;
	}

	// Modify the output image size if the downsampled image is
	// smaller than the VGA.
	if (VGA_WIDTH > img->width / horizontal_skip) {
		horizontal_size = img->width / horizontal_skip;
	}
	if (VGA_HEIGHT > img->height / vertical_skip) {
		vertical_size = img->height / vertical_skip;
	}

	// This is for the case when it needs to be downsampled by 3.
	// By display 3 16 bit words worth of pixels each time the next iteration starts at the
	// first bit of the 16 bit word in all cases.
	pixels_per_iteration = 48 / horizontal_skip;

	for (j=0; j<vertical_size; j++) {

		pixel_counter = 0;

		row_predone = 0;
		// Check to see if the image is not hword aligned in its width.
		// If it isn't we need to write 3 bytes to the screen before continuing.
		if ((j*img->byte_width*vertical_skip) & 0x1) {
			row_predone = 3;
			m = 0;

			for (k=0; k<3; k++) {
				binary_pixels = IORD_8DIRECT(img->pixels, (j*img->byte_width*vertical_skip) + k);

				l_loop_start = 0;
				if (horizontal_skip == 3) {
					// special case here
					if (k == 0) 		l_loop_start = 0;
					else if (k == 1)	l_loop_start = 2;
					else 				l_loop_start = 1;
				}

				for (l=l_loop_start; l<8; l+=horizontal_skip) {
					color = 0x0;
					if ((binary_pixels & (0x1 << l)) == (BIN_COLOR_WHITE << l)) color = 0xFF;
					if (pixel_counter < img->width) {
						vga_draw_pixel_fast(color, m++, j);
						pixel_counter += horizontal_skip;
					}
				}
			}
		}

		// display the row to the vga
		for (i=0; i<horizontal_size; i+=pixels_per_iteration) {
			// m is an easy way to keep track of which VGA pixel we happen
			// to be writing at any point
			m = 0;
			for (k=0; k<3; k++) {
				// y coord: pixels are packed 8 to a byte and we want to skip rows
				// x coord: the 16 bit hword we want is at i/pix_per_iter * 3. Byte addressing, *2
				binary_pixels = IORD_16DIRECT(img->pixels, (j*img->byte_width*vertical_skip) + ((i/pixels_per_iteration)*6) + k*2 + row_predone);

				// We need to set the starting point in the 16 bit hword since 16/3 is not an integer
				l_loop_start = 0;
				if (horizontal_skip == 3) {
					// special case here
					if (k == 0) 		l_loop_start = 0;
					else if (k == 1)	l_loop_start = 2;
					else 				l_loop_start = 1;
				}
				// Now write the pixels to the VGA
				for (l=l_loop_start; l<16; l+=horizontal_skip) {
					color = 0x0;
					if ((binary_pixels & (0x1 << l)) == (BIN_COLOR_WHITE << l)) color = 0xFF;
					if (pixel_counter < img->width) {
						vga_draw_pixel_fast(color, i+(row_predone*(pixels_per_iteration/6))+m, j);
						m++;
						pixel_counter += horizontal_skip;
					}
				}
			}
		}
	}

	// And make it appear!
	vga_swap_buffer();
}

void vga_draw_small_portion (const image16_t* img, alt_u8 x_box, alt_u8 y_box) {
	alt_u32 i, j, k, x, y;
	alt_u16	binary_pixels;
	alt_u8	color;
	alt_u16 width_displayed;

	alt_u32 x_start, y_start;

	// Start by blacking the display in case we don't fill it all
	vga_clear_black();

	x_start = x_box*640;
	y_start = y_box*480;

	y=0;
	for (j=y_start; j<480+y_start && j<img->height; j++) {
		x=0;
		width_displayed = 0;
		for (i=x_start/8; i<80+x_start/8 && i<img->byte_width; i++) {
			binary_pixels = IORD_8DIRECT(img->pixels, (j*img->byte_width) + i);

			for (k=0; k<8; k++) {
				color = 0x0;
				if ((binary_pixels & (0x1 << k)) == (BIN_COLOR_WHITE << k)) color = 0xFF;
				if (width_displayed < img->width) {
					vga_draw_pixel_fast(color, x, y);
					width_displayed++;
				}
				x++;
			}

		}
		y++;
	}

	// And make it appear!
	vga_swap_buffer();
}

void pan_image (const image16_t* img) {
	alt_u16		x;
	alt_u16		y;
	alt_u16		i, j;

	x = (img->width + VGA_WIDTH - 1)/VGA_WIDTH;
	y = (img->height + VGA_HEIGHT - 1)/VGA_HEIGHT;

	for (j=0; j<y; j++) {
		for (i=0; i<x; i++) {
			vga_draw_small_portion(img, i, j);
			WAIT_FOR_INTERRUPT;
		}
	}
}

void vga_draw_histogram (flex_array_t* histo) {
alt_u32 i, j, max;


	vga_clear_black();

	max = flex_array_max(histo);

	for (i=0; i<histo->length; i++) {
		for (j=max; j>max-histo->data[i]; j--) {
			vga_draw_pixel_fast(0, i, j);
		}
		for (j=max-histo->data[i]; j>0; j--) {
			vga_draw_pixel_fast(0xff, i, j);
		}
		vga_draw_pixel_fast(0xff, i, 0);
		vga_draw_pixel_fast(0xff, i, max+1);
	}
	vga_swap_buffer();
}

void vga_draw_img_border (const image16_t* img) {
	alt_u32 i, j;
	alt_u8	pixel;

	// Start by blacking the display in case we don't fill it all
	vga_clear_black();

	if (img->width >= VGA_WIDTH-2 || img->height >= VGA_HEIGHT-2) {
		vga_swap_buffer();
		return;
	}

	for (j=0; j<img->height+2; j++) {

		for (i=0; i<img->width+2; i++) {

			if (i==0 || i==img->width+1 || j==0 || j==img->height+1) {
				// draw the bounding box
				if (i & 0x1 || j & 0x1) {
					vga_draw_pixel_fast(0x00, i, j);
				} else {
					vga_draw_pixel_fast(0xFF, i, j);
				}
			} else {
				// draw the image
				pixel = getPixel(img, i-1, j-1);
				if (pixel) {
					vga_draw_pixel_fast(0x00, i, j);
				} else {
					vga_draw_pixel_fast(0xFF, i, j);
				}

			}
		}
	}

	// And make it appear!
	vga_swap_buffer();
}
