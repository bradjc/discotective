#ifndef PREPROCESSING_H
#define PREPROCESSING_H

#include <stdint.h>
#include "global.h"

// Threshold for binarization
#define THRESHOLD	0x5F

// Constants for cropping rows and columns
#define CROP_COL_BLACK_MAX			100		// the maximum number of black pixels on an outside column before it must be scrapped
#define CROP_COL_BLACK_MIN			60		// the minimum number of black pixels in a column to consider it not whitespace
#define CROP_ROW_BLACK_MAX			100
#define CROP_ROW_BLACK_MIN			60


void binarize_threshold (unsigned int gray_scale_img_start, image16_t *out_img);

void correct_fish_eye (image16_t* img, image16_t* out_img);

// Crop the left and right sides off of an image.
// Does it in place.
void initial_crop_image (image16_t *img);

#endif
