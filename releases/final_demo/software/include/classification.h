#ifndef CLASSIFICATION_H_
#define CLASSIFICATION_H_

#include "global.h"
#include <stdint.h>
#include "linked_list.h"

uint8_t check_line_is_not_rest (const image16_t* img, const uint32_t *staff_lines, uint16_t topCut, uint16_t xbegin, const staff_info* staff);

uint8_t check_for_eighth_connector_on_top (image16_t* img, image16_t* temp_img, uint16_t xend, const staff_info *staff);

uint8_t check_for_eighth_connector_on_bottom (image16_t* img, image16_t* temp_img, uint16_t xend, const staff_info *staff);

uint8_t check_eighth_note (const image16_t* img, image16_t* temp_img, uint16_t xbegin);

uint8_t is_note_open (const image16_t* img);

void identify_note_pitches (const image16_t* img, staff_info* staff, uint32_t* stafflines, linked_list* notes);

void remove_notes_measures(image16_t* img, linked_list* stems, linked_list* measures_list, staff_info* staff, uint32_t* stafflines);

void update_notes_with_key_signature (linked_list* notes, staff_info *staff);

void classify_symbols (linked_list *symbols, linked_list *notes, linked_list *measures, staff_info* staff, image16_t *img, image16_t* temp_img, uint32_t* staff_lines);

symbol_type classify_accidental (image16_t* img);

void contextualizer_other(linked_list* notes, linked_list* measures, linked_list* symbols);

uint16_t contextualizer_notes_rests(linked_list *notes, linked_list *symbols);

#endif
