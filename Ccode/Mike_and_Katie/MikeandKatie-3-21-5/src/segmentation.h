/*
Segmenting Functions
*/

#ifndef SEGMENTATION_H
#define SEGMENTATION_H

#include "image_data.h"
#include "linked_list.h"
#include "allocate.h"
#include "utility_functions.h"


/*Trims excess pixels off edge of staff, adds 2 pixels of padding to each side*/
image_t*  trim_staff(image_t *img);

/*Used to get information about the staff lines and spacing
staff is an output parameter that contains the info about staff lines
params is the return value, a struct containing staff height, and line thickness and spacing
staff must be allocated prior to calling*/
params* staff_segment(const image_t *img, staff_info *staff);

/*removes staff lines*/
image_t* remove_lines(image_t* img, params* staff_params, uint16_t numCuts, uint16_t **STAFFLINES);

/*returns a trimmed a cleaned staff*/
image_t* get_staff(const image_t* img, const staff_info* staff,uint16_t count,params* parameters);


/*finds verical lines, stems, measure markers*/
linked_list* find_top_bottom(const image_t* img,uint16_t height_min,uint16_t leftCutoff,linked_list* groupings);


/*cuts out small image around stem/measure marker*/
image_t* mini_img_cut(const image_t* img,uint16_t top,uint16_t bottom,uint16_t xbegin,uint16_t xend,const params* parameters, note_cuts* cuts);

struct pixel {
  int row,col;
};

void ConnectedSet(struct pixel s,uint8_t T,const image_t *imgGy,int32_t width,int32_t height,int32_t *ClassLabel,uint8_t **seg,int32_t *NumConPixels, symbol_t *symbol);

void ConnectedNeighbors(struct pixel s,uint8_t T,const image_t *imgGy,int32_t width,int32_t height,int32_t *M,struct pixel c[4]);

linked_list* connComponents(const image_t *imgGy,int32_t minNumPixels);

void remove_lines_2(image_t* img,params* parameters,uint32_t numCuts,image_t* lineless_img, uint32_t* stafflines, staff_info* staff);

void fix_lines_and_remove(image_t* img,params* parameters, uint32_t** last_STAFFLINES, uint32_t *previous_start, uint32_t cutNum);

#endif
