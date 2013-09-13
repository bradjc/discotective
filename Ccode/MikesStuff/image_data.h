#ifndef IMAGE_DATA_H
#define IMAGE_DATA_H

#include <stdint.h>
#include "allocate.h"


typedef uint8_t** image_data;
enum flag1{
     greater,
     less,
     equal,
     greater_equal,
     less_equal,
     not_equal
};
typedef enum flag1 find_flags;
//A binary image type, height and width are in terms of pixels, not elements
//As such pixels should only be used with the get and set functions below
typedef struct{
        uint16_t height;
        uint16_t width;
        image_data pixels;
} image_t;
//Parameters
typedef struct{
        uint8_t staff_h;
        uint8_t thickness;
        uint8_t spacing;
        uint8_t ks;
} params;

typedef struct{
        uint16_t number_staffs;
        uint16_t **staff_bounds;
        uint16_t **staff_lines;
        
} staff_info;

//A projection type which works alongside the image type
typedef struct{
        uint16_t length;
        int16_t data[];
} flex_array_t;

//For more intuitiveness
typedef flex_array_t projection_t;

//Used to make a binary image (image_t) 
image_t*  make_image(uint16_t arraySizeX, uint16_t arraySizeY);

//Used to delete a binary image (image_t)
void delete_image(image_t* img);
//Used to delete a flexible array flex_array_t
void delete_flex_array(flex_array_t* proj);

//Delete params struct
void delete_params(params* p);

//Used to delete a staff info struct
void delete_staff_info(staff_info *staff);

//Get the values for the staff lines at the index given ie get_line_at_index(staff,1) gives a flex_array_t 
//of the top staff_line values for each staff
flex_array_t* get_line_at_index(const staff_info *staff,uint8_t index);

//These allow easy accessing of pixels of the image while allowing for efficient storage
//h and w are pixel values, the actual index values of the array should not be used directly.
uint8_t getPixel(const image_t *img,uint16_t h,uint16_t  w);
void setPixel(image_t *img, uint16_t h, uint16_t  w, uint8_t value);

//Used to make a projection from an image, imitates matlab sum function
//passing 1 to the second parameter causes an x projection, 2 a y projection
projection_t* project(const image_t *img,int xOrY);  

//finds max
int16_t max_array(const flex_array_t *proj);

//returns an array of ones of length length
flex_array_t* array_ones(uint16_t length);

//Used to find the indices or array that are greater,less,equal to etc the threshold,
//the comparison is determined by the flag parameter (see find_flags for possible values)                            
flex_array_t* find(const flex_array_t *array, float threshold, find_flags flag); 

//Running difference, diff(i)=array(i+1)-array(i);
flex_array_t* diff(const flex_array_t *array);

//Made this separately to save memory use abs value of diff
flex_array_t* abs_diff(const flex_array_t *array);

//minus functions to mimic those of matlab, for the one w/ 2 arrays if length diff
//returns null
flex_array_t* minus_array(const flex_array_t *array, const flex_array_t *array2);
flex_array_t* minus(const flex_array_t *array, int16_t number);

//sum elements
int16_t sum(const flex_array_t *array);

//mean rounded to nearest integer
int16_t rounded_mean(const flex_array_t *array);

//median
int16_t median(const flex_array_t *array);

//find a sub array similar to array(begin:end) in matlab
flex_array_t* sub_array(const flex_array_t *array, uint16_t begin, uint16_t end);

//Removes indices from array, array is deleted following execution. In place assignment recommended.
flex_array_t* kill_array_indices(flex_array_t *array, const flex_array_t *indices);

//A histogram of the input array
flex_array_t* hist(const flex_array_t *array);

//Returns the index of the maximum value in the array, if the maximum value is 
//present multiple times, returns the index of the first maximum present
uint16_t index_of_max(const flex_array_t *array);

//Used to retrieve a new image from the image and bounds provided. Passing -1 to any argument indicates the end of the matrix
//For instance get_sub_img(img, 5,10,-1,-1) will create an image from rows index 5 through 10 inclusive, and all columns
image_t* get_sub_img(const image_t* img, int16_t h_start, int16_t h_end,int16_t w_start,int16_t w_end);


//Y = FILTER(B,A,X) filters the data in vector X with the
//   filter described by vectors A and B to create the filtered
//   data Y.  The filter is a "Direct Form II Transposed"
//   implementation of the standard difference equation:
//
//   a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
//                         - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
//
//   If a(1) is not equal to 1, FILTER normalizes the filter
//   coefficients by a(1).
//
//The array returned by filter must be freed by user when finished.
flex_array_t* filter(const flex_array_t *B,const flex_array_t *A,const flex_array_t *X);


#endif
