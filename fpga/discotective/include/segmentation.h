#ifndef SEGMENTATION_H_
#define SEGMENTATION_H_

#include "global.h"
#include "utility_functions.h"


#define		NUM_X_SAMPLES	16		// number of places to look at the staff

staff_info* staff_segment_simple (const image16_t *img) ;

staff_info* staff_segment (const image16_t *img);

void trim_staff (image16_t *img);

void get_staff_img (const image16_t* img, image16_t* out_img, staff_info* staff, uint16_t staff_index);

void set_line_width_and_spacing (const image16_t *img, staff_info* staff);

void remove_lines (image16_t* img, image16_t* lineless_img, uint32_t numCuts, uint32_t* stafflines, staff_info* staff);

void fix_lines_and_remove (image16_t* img, staff_info* staff, uint32_t** last_STAFFLINES, uint32_t *previous_start, uint32_t cutNum);

void mini_img_cut(const image16_t* img, image16_t* out_img, uint16_t top, uint16_t bottom, uint16_t xbegin, uint16_t xend, const staff_info* staff, note_cuts* cuts);

void crop_off_cleff_key_signature (image16_t* img, staff_info *staff);




#endif
