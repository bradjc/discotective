/*
 *  audio_files.h
 *  Discotective
 *
 *  Created by Mike Hand on 6/27/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef AUDIO_FILES_H
#define AUDIO_FILES_H

#define MAX_MIDI_VALUE 94
extern float midi_table[MAX_MIDI_VALUE+1];

#include "linked_list.h"
#include <stdint.h>
#include "global.h"
// have song_size which is number of bytes of music

linked_list* create_song_list(sheet_t* sheet, linked_list* notes);
uint8_t* createAudioFileBytes(linked_list* song_list, uint32_t* outLength);

//platform specfic

#endif