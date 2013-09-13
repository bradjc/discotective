#ifndef PREPROCESSING_H
#define PREPROCESSING_H

#include <stdint.h>
#include "global.h"

// deskew
#define LENGTH_STEP_SIZES			8
#define DESKEW_STEPS				25
#define	NUM_HORIZ_TWEAK_DISTANCES	3
#define	NUM_VERT_TWEAK_DISTANCES	2

#define CROP_COL_BLACK_MAX			100		/* the maximum number of black pixels on an outside column before it must be scrapped */
#define CROP_COL_BLACK_MIN			10		/* the minimum number of black pixels in a column to consider it not whitespace */
#define CROP_ROW_BLACK_MAX			100
#define CROP_ROW_BLACK_MIN			10

// white crop threshold multipliers
#define	HORIZONTAL_THRSH_MULT		0.012F
#define	VERTICAL_THRSH_MULT			0.012F

// final crop padding targets
#define	LEFT_RIGHT_PADDING			40
#define	TOP_BOTTOM_PADDING			20

void convert_rgb_to_grayscale (uint8_t* rgbaData, uint16_t height, uint16_t width, grayimage_t** out_img);

void binarizeIMG (const grayimage_t* gray_img, image_t** binIMG);
void binarize_threshold (const grayimage_t* gray_img, image_t** bin_img, binarize_threshold_e threshold_type);
image_t* binarize_threshold_adaptive_otsu (const grayimage_t* gray_img, uint16_t square_size);

void horizontal_deskew (image_t** in_img);
void vertical_deskew_staff (image_t** in_img, staff_t* staff);
void perform_deskew (image_t** in_img, uint16_t ax1, uint16_t ay1, uint16_t ax2, uint16_t ay2, uint16_t bx1, uint16_t by1, uint16_t bx2, uint16_t by2, uint8_t horizontal_skew);

void white_crop_preprocess (image_t** img);

// Removes any black images from around the image border using a depth first search
void edge_blob_kill (image_t* img);

void initial_crop_image (image_t** img);

void inside_outside_crop (image_t** in_img);

#endif