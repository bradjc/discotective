#ifndef IMAGE_DATA_H
#define IMAGE_DATA_H

#include <stdint.h>
#include "allocate.h"
#include "disco_types.h"

/*Used to make a binary image (image_t) */
image_t*  make_image(uint16_t arraySizeX, uint16_t arraySizeY);

/*Used to delete a binary image (image_t)*/
void delete_image(image_t* img);


/*These allow easy accessing of pixels of the image while allowing for efficient storage
h and w are pixel values, the actual index values of the array should not be used directly.*/
uint8_t getPixel(const image_t *img,uint16_t h,uint16_t  w);
void setPixel(image_t *img, uint16_t h, uint16_t  w, uint8_t value);

/*Used to make a projection from an image, imitates matlab sum function
passing 1 to the second parameter causes an x projection, 2 a y projection*/
projection_t* project(const image_t *img,int xOrY);  

/*Used to retrieve a new image from the image and bounds provided. Passing -1 to any argument indicates the end of the matrix
For instance get_sub_img(img, 5,10,-1,-1) will create an image from rows index 5 through 10 inclusive, and all columns*/
image_t* get_sub_img(const image_t* img, int16_t h_start, int16_t h_end,int16_t w_start,int16_t w_end);


void print_image(const image_t* img);
#endif
