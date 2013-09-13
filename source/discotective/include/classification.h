#ifndef CLASSIFICATION_H_
#define CLASSIFICATION_H_

#include "global.h"
#include <stdint.h>
#include "linked_list.h"

// beam checking
#define	BEAM_CHECK_LINE_THICKNESS_MULTIPLIER	1.5F

// notehead check if open constants
#define	NOTEHEAD_CHECK_BLACK_MIN		2
#define	NOTEHEAD_CHECK_BLACK_MAX		11
#define	NOTEHEAD_CHECK_WHITE_MIN		2
#define	NOTEHEAD_CHECK_OPEN_FLAGS_MIN	4
#define	NOTEHEAD_CHECK_MIN_TOTAL_WHITE	14	// at least 4 rows of 4 on average

// single eighth check
#define	SINGLE_EIGHTH_CHECK_BLACK_MIN	2
#define	SINGLE_EIGHTH_CHECK_BLACK_MAX	10
#define	SINGLE_EIGHTH_CHECK_WHITE_MIN	3

// block checking for valid symbol
#define	BLOB_CHECK_MIN_HEIGHT			5
#define	BLOB_CHECK_MIN_WIDTH			5
#define	BLOB_CHECK_MIN_TOTAL_BLACK		19


uint8_t check_for_beam_on_top (const image_t* img, const staff_t *staff, uint16_t xend);
uint8_t check_for_beam_on_bottom (const image_t* img, const staff_t *staff, uint16_t xend);
uint8_t check_for_beam (const image_t* img, const staff_t *staff, uint16_t xend, uint8_t check_top);

uint8_t check_for_double_beam_right (const image_t* img, const staff_t *staff, uint16_t xbegin, uint16_t xend, uint8_t check_top);
uint8_t check_for_double_beam_left (const image_t* img, const staff_t *staff, uint16_t xbegin, uint16_t xend, uint8_t check_top);
uint8_t check_for_double_beam_both (const image_t* img, const staff_t *staff, uint16_t xbegin, uint16_t xend, uint8_t check_top);
uint8_t check_for_double_beam (const image_t* img, const staff_t* staff, uint16_t xbegin, uint16_t xend, uint8_t check_top, uint8_t check_left, uint8_t check_right);

measure_t* check_if_measure_line (const image_t* img, const staff_t* staff, const linked_list* measures, uint16_t xbegin, uint16_t xend, uint16_t left_offset);
uint8_t check_if_single_eighth_note (const image_t* img, uint16_t xbegin, notehead_pos_e notehead_pos);
uint8_t check_if_rest (const image_t* img, const staff_t* staff, uint16_t topCut, uint16_t xbegin);
uint8_t check_if_note_is_open (const image_t* img);
uint8_t check_if_blob_is_symbol (const image_t* img);

accidental_e classify_accidental (const image_t* img);

flex_array_t* create_midi_lines (const staff_t* staff);
void identify_note_pitches (linked_list* notes, const staff_t* staff);

//void update_notes_with_key_signature (linked_list* notes, sheet_t *sheet);

void classify_symbols (linked_list *symbols, const linked_list *notes, const linked_list *measures, const staff_t* staff);


#endif
