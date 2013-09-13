#ifndef CLASSIFY_H
#define CLASSIFY_H

#include <stdint.h>
#include "disco_types.h"
#include "image_data.h"

//input image of note-head output 1 if open, 0 if filled
uint8_t is_note_open(const image_t* img);



#endif
