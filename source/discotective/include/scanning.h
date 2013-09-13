#ifndef SCANNING_H_
#define SCANNING_H_


#include "classification.h"
#include "linked_list.h"
#include <stdint.h>
#include "global.h"

#define TIME_SIGNATURE_BLACK_WIDTH			10
#define MIN_ACCIDENTAL_WIDTH				5
#define MIN_SPACE_BETWEEN_STEMS				24
#define	MIN_SPACE_BETWEEN_MEASURES			50
#define	MIN_NOTE_WIDTH						12
#define	MIN_NOTEHEAD_WIDTH					10
#define	MIN_EIGHTH_CONN_THICKNESS			2

// for find measure line
#define	MEASURE_LINE_VARIATION_THRESHOLD	3
#define	X_SKEW_MAXIMUM						75	// the most number of pixels the top of a skewed line can be from the bottom
#define	MEASURE_LINE_SLOPE_VARIATION		2

void parse_notes_with_lines (image_t* img, const staff_t* staff, linked_list* notes, linked_list* measures);

linked_list* find_all_vertical_lines (const image_t* img, uint16_t height_min);

void get_key_signature (image_t** img, sheet_t* sheet);

void find_first_measure_line (const image_t* img, const staff_t* staff, uint16_t* x1_ret, uint16_t* y1_ret, uint16_t* x2_ret, uint16_t* y2_ret);
void find_last_measure_line (const image_t* img, const staff_t* staff, uint16_t* x1_ret, uint16_t* y1_ret, uint16_t* x2_ret, uint16_t* y2_ret);
void find_measure_line (const image_t* img, const staff_t* staff, uint8_t find_first, uint16_t* x1_ret, uint16_t* y1_ret, uint16_t* x2_ret, uint16_t* y2_ret);

void find_symbols (image_t* img, linked_list *symbols);

void find_measure_markers_around_point (const linked_list* measures, uint16_t x_index, uint16_t* mm_left_index, uint16_t* mm_right_index);
uint16_t get_center_x_of_measure (const linked_list* measures, uint16_t x_index);
uint16_t count_note_in_measure (const linked_list* notes, const linked_list* measures, uint16_t x_index);

#endif
