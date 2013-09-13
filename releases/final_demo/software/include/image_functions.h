#ifndef __IMAGE_FUNCTIONS_H__
#define __IMAGE_FUNCTIONS_H__


#include "alt_types.h"
#include "global.h"


// Returns the number of black pixels in the specified column of the image.
alt_u32 project_on_X_single (const image16_t *img, alt_u32 column);

alt_u32 project_on_Y_single (const image16_t *img, alt_u32 row);

flex_array_t* project_on_X (const image16_t *img);

// Returns a flex array of the the numbers of black pixels in the rows of the image.
flex_array_t* project_on_Y (const image16_t *img);

inline uint8_t getPixel (const image16_t *img, alt_u16 x, alt_u16 y);

inline void setPixel (image16_t *img, uint16_t x, uint16_t y, uint8_t value);

void crop (const image16_t* img, image16_t* out_img, alt_u32 left_crop, alt_u32 right_crop, alt_u32 top_crop, alt_u32 bottom_crop);

void get_sub_img (const image16_t* img, image16_t* out_img, int16_t h_start, int16_t h_end, int16_t w_start, int16_t w_end);

uint8_t all_black (const image16_t* img);


#endif
