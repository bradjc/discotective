#ifndef ALGORITHMS_H
#define ALGORITHMS_H
#include "image_data.h"

//Trims excess pixels off edge of staff, adds 2 pixels of padding to each side
image_t*  trim_staff(image_t *img);

//Used to get information about the staff lines and spacing
//staff is an output parameter that contains the info about staff lines
//params is the return value, a struct containing staff height, and line thickness and spacing
//staff must be allocated prior to calling
params* staff_segment(const image_t *img, staff_info *staff);

//Removes any black images from around the image border using a depth first search
void blob_kill(image_t* img, uint8_t lr, uint8_t tb);

//returns a trimmed a cleaned staff
image_t* get_staff(const image_t* img, const staff_info* staff,uint16_t count);
#endif
