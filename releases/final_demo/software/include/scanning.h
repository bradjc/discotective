#ifndef SCANNING_H_
#define SCANNING_H_


#include "classification.h"
#include "linked_list.h"
#include <stdint.h>
#include "global.h"

#define LINE_WIDTH_THRESHOLD		6
#define TIME_SIGNATURE_BLACK_WIDTH	10
#define MIN_ACCIDENTAL_WIDTH		5

void parse_notes_with_lines (	image16_t* img,
								image16_t* img_temp1,
								image16_t* img_temp2,
								const staff_info* staff,
								uint16_t staffNumber,
								uint32_t* staff_lines,
								linked_list* stems_list,
								linked_list* measures_list
							);

linked_list* find_all_vertical_lines (const image16_t* img, uint16_t height_min, uint16_t leftCutoff, linked_list* vert_lines);

void get_key_signature (image16_t* img, image16_t* temp_img1, staff_info* staff, uint32_t* staff_lines);

void find_symbols_simple (image16_t* img, image16_t* temp_img, linked_list *symbols);

void combine_symbols (linked_list *symbols, staff_info* staff);

#endif
