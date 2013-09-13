#ifndef DDS_H_
#define DDS_H_

#include "linked_list.h"
#include <stdint.h>
#include "global.h"

#define	F_S			71000
#define	BPM			100
#define	SMOOTH_NUM	10
#define	MIDI_OFFSET	52

void play_sine_wave ();

extern const alt_u16 FREQS[33];
void sound_note(uint16_t midi, note_duration duration);
void play_song(linked_list* notes_list);

#endif
