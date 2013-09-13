#ifndef SEGMENTATION_H
#define SEGMENTATION_H

#include "global.h"
#include "linked_list.h"

#define		NUM_X_SAMPLES	16

sheet_t* staff_segment_simple (const image_t *img);

void trim_staff (image_t** img); 

void get_staff_img (const image_t* img, image_t** out_img, staff_t* staff);

void set_line_width_and_spacing (const image_t *img, staff_t* staff);

image_t* note_cutout (const image_t* img, uint16_t top, uint16_t bottom, uint16_t xbegin, uint16_t xend, const staff_t* staff, note_cuts_t* cuts);

#endif