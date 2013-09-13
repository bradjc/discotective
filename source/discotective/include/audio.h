#ifndef AUDIO_H_
#define AUDIO_H_

#include "global.h"
#include <stdint.h>
#include "linked_list.h"

void display_notes (sheet_t* sheet, linked_list* notes);

void print_abc_format (sheet_t* sheet, linked_list* music);

#endif