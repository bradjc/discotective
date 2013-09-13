#ifndef MUSIC_FUNCTIONS_H_
#define MUSIC_FUNCTIONS_H_

#include "global.h"
#include <stdint.h>
#include "linked_list.h"

//
//	Functions that do work on our linked list of music elements
//

void combine_symbols (linked_list *symbols, const staff_t* staff);

void contextualizer_notes_rests (linked_list *notes, linked_list *symbols);
void contextualizer_other (linked_list* notes, linked_list* measures, linked_list* symbols);

void concat_notes_measures (linked_list* notes, linked_list* measures, linked_list* music);

void guess_time_signature (const linked_list* music, sheet_t* sheet);

void clean_up_music_elements ();

#endif