#ifndef PREPROCESSING_H
#define PREPROCESSING_H

#include <stdint.h>

#include "image_data.h"
#include "linked_list.h"
#include "allocate.h"
#include "utility_functions.h"

void myMatrixInverse(float **A, int32_t n, float **B);
void binarizeIMG(uint8_t **img, int32_t height, int32_t width, image_t *binIMG, float fudge);
void tbCrop(const image_t *img, int32_t height, int32_t width, int32_t *crop_top, int32_t *newHeight);
void lrCrop(const image_t *img, int32_t height, int32_t width, int32_t *crop_lef, int32_t *newWidth);
void ver_deskew(const image_t *img, int32_t h, int32_t w, image_t *new_img);
void hor_deskew(const image_t *img, int32_t h, int32_t w, image_t *new_img);
void w_crop(const image_t *img, int32_t h, int32_t w, int32_t strict, int32_t *crop_t, int32_t *newHeight, int32_t *crop_l, int32_t *newWidth);

/*Removes any black images from around the image border using a depth first search*/
void blob_kill(image_t* img, uint8_t lr, uint8_t tb);

#endif
