#ifndef CLASSIFY_H
#define CLASSIFY_H

#include <stdint.h>
#include "disco_types.h"
#include "image_data.h"
#include "segmentation.h"

/*input: image of note-head 
output: 1 if open, 0 if filled*/
uint8_t is_note_open(const image_t* img);

void get_key_sig(const image_t* img,staff_info* staff, params* parameters);

/*checks for an eight note tail 1 if found
should be converted, can't test just yet*/
uint8_t check_eighth_tail(const image_t* img, const params* parameters,uint16_t row,uint16_t col);

uint8_t  check_eighth_note(const image_t* img,uint16_t xbegin);

uint8_t  check_line_is_not_rest_new(const image_t* img,const uint32_t *staff_lines,uint16_t topCut,uint16_t xbegin,const params* parameters);


void  find_lines(image_t* img, const params* parameters, uint16_t staffNumber, uint32_t* staff_lines, linked_list* stems_list, linked_list* measures_list);

void get_MIDI(const image_t* img,uint32_t h,uint32_t w, params* parameters, uint32_t* stafflines, linked_list* notes);

void remove_notes_measures(image_t* img,uint32_t h,uint32_t w,linked_list* stems, linked_list* measures_list, params* parameters, uint32_t* stafflines);

void combineSymbols(linked_list *symbols, params* parameters);

void classify_symbols(linked_list *symbols, linked_list *notes, linked_list *measures, params* parameters, image_t *lineless_img, uint32_t* staff_lines);

int16_t  classify_accidental(image_t* img);

void contextualizer_other(linked_list* notes, linked_list* measures, linked_list* symbols);

void update_with_key_signature( linked_list* notes, int key_sig);
#endif
