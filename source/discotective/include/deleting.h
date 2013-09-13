#ifndef DELETING_H_
#define DELETING_H_

#include "global.h"
#include <stdint.h>
#include "linked_list.h"

void remove_cleff (image_t* img, staff_t* staff);
void crop_off_cleff_key_signature (image_t** img, const sheet_t *sheet, uint16_t staff_num);

void remove_staff_lines (image_t* img, staff_t* staff);

void remove_notes_measures (image_t* img, const linked_list* notes, const linked_list* measures, const staff_t* staff);

void reconnect_half_note (image_t* img, const note_t* note, uint16_t left_bound, uint16_t right_bound);

void delete_sheet (sheet_t** sheet);

#endif