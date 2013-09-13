#ifndef PREPROCESSING_H
#define PREPROCESSING_H

#include <stdint.h>

#include "image_data.h"
#include "linked_list.h"
#include "algorithms.h"

void myMatrixInverse(float **A, int32_t n, float **B);
void binarizeIMG(uint8_t **img, int32_t height, int32_t width, image_t *binIMG, float fudge);
void tbCrop(const image_t *img, int32_t height, int32_t width, int32_t *crop_top, int32_t *newHeight);
void lrCrop(const image_t *img, int32_t height, int32_t width, int32_t *crop_lef, int32_t *newWidth);
float max(float a, float b);
float min(float a, float b);
void ver_deskew(const image_t *img, int32_t h, int32_t w, image_t *new_img);
void hor_deskew(const image_t *img, int32_t h, int32_t w, image_t *new_img);
void w_crop(const image_t *img, int32_t h, int32_t w, int32_t strict, int32_t *crop_t, int32_t *newHeight, int32_t *crop_l, int32_t *newWidth);

#endif
