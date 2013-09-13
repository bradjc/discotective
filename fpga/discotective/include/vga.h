#ifndef __VGA_H_
#define __VGA_H_

#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "alt_types.h"
#include "global.h"
#include "flex_array.h"

#define VGA_WIDTH	640
#define VGA_HEIGHT	480

extern alt_up_pixel_buffer_dma_dev* VGA_port;

// Whether or not the LEDs have been initialized
extern int VGA_initialized;

extern alt_u8 vga_using_back_buffer;

// Initialize the vga
// Call before using other functions
int vga_init ();

void vga_clear ();

void vga_clear_black ();

void vga_draw_pixel (unsigned int color, unsigned int x, unsigned int y);

void vga_draw_pixel_fast (unsigned int color, unsigned int x, unsigned int y);

void vga_draw_box (int color, int x0, int y0, int x1, int y1);

void vga_change_back_buffer_address (unsigned int address);

void vga_swap_buffer ();

int vga_bounds_ok (int x, int y);

void vga_draw_binary_img (const image16_t *img);

void vga_draw_small_portion (const image16_t* img, alt_u8 x_box, alt_u8 y_box);

void pan_image (const image16_t* img);

void vga_draw_histogram (flex_array_t* histo);

void vga_draw_img_border (const image16_t* img);

#endif
