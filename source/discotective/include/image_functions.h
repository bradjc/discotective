#ifndef __IMAGE_FUNCTIONS_H__
#define __IMAGE_FUNCTIONS_H__

#include "global.h"
#include "linked_list.h"


pixel_color_e getPixel (const image_t *img, uint16_t x, uint16_t y);
void setPixel (image_t *img, uint16_t x, uint16_t y, pixel_color_e value);

flex_array_t* project_on_X (const image_t* img);
flex_array_t* project_on_X_partial (const image_t* img, uint16_t start_y, uint16_t end_y);
flex_array_t* project_on_X_main (const image_t* img, uint16_t start_y, uint16_t end_y);
flex_array_t* project_on_Y (const image_t *img);
flex_array_t* project_on_Y_partial (const image_t *img, uint16_t start_x, uint16_t end_x);

void crop (image_t** img, uint16_t left_crop, uint16_t right_crop, uint16_t top_crop, uint16_t bottom_crop);
image_t* crop_main (const image_t* img, uint16_t left_crop, uint16_t right_crop, uint16_t top_crop, uint16_t bottom_crop);

image_t* get_sub_img (const image_t* img, int16_t h_start, int16_t h_end, int16_t w_start, int16_t w_end);

void pure_white_crop (image_t** img);
void pure_white_crop_returns (image_t** img, uint16_t* left_cropped, uint16_t* right_cropped, uint16_t* top_cropped, uint16_t* bottom_cropped);
void white_crop (	image_t** in_img,
					float h_threshold, float w_threshold,
					uint16_t left_padding, uint16_t right_padding, uint16_t top_padding, uint16_t bottom_padding,
					uint16_t* left_cropped, uint16_t* right_cropped, uint16_t* top_cropped, uint16_t* bottom_cropped);

void blob_kill (image_t* img, uint16_t start_x, uint16_t start_y, int16_t left_bound, int16_t right_bound, int16_t top_bound, int16_t bottom_bound);
void blob_copy (const image_t* img, image_t* img2, uint32_t start_x, uint32_t start_y, uint32_t offset_x, uint32_t offset_y);
void blob_copy_and_kill (image_t* img, image_t* img2, uint32_t start_x, uint32_t start_y, uint32_t offset_x, uint32_t offset_y);

linked_list* find_runs (const image_t* img, uint16_t index, direction_e direction, uint16_t start_index, uint16_t end_index);
uint8_t parse_runs (const linked_list* runs, uint16_t num_white, uint16_t num_black, pixel_color_e first, uint16_t white_min, uint16_t white_max, uint16_t black_min, uint16_t black_max);
uint8_t parse_runs_main (const linked_list* runs, uint16_t num_white, uint16_t num_black, pixel_color_e first, uint16_t white_min, uint16_t white_max, uint16_t black_min, uint16_t black_max, flex_array_t** out_arr);

uint8_t find_bounds (const image_t* img, uint16_t* left_bound, uint16_t* right_bound, uint16_t* top_bound, uint16_t* bottom_bound);

image_t* binary_image_create (uint16_t height, uint16_t width);
void binary_image_delete (image_t** img);
void binary_image_whiteout (image_t* img);
void binary_image_move (image_t* in_img, int16_t x_new, int16_t y_new);
void binary_image_copy (const image_t* img1, image_t* img2, uint16_t offset_x, uint16_t offset_y);
void binary_image_display (const image_t* img);

uint32_t* grayscale_image_histogram (const grayimage_t* img);
void grayscale_image_display (const grayimage_t* img);
void grayscale_image_delete (grayimage_t** img);

uint32_t count_black (const image_t* img);
uint8_t all_black (const image_t* img);

#endif
