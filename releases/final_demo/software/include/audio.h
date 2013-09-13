#ifndef __AUDIO_H_
#define __AUDIO_H_

#include "altera_up_avalon_audio.h"
#include "alt_types.h"

extern alt_up_audio_dev* AUD_port;
extern int AUD_initialized;


int audio_init ();

// returns how much space is available in the write (output) audio FIFO
int audio_get_write_fifo_space ();

void audio_play (alt_16 *samples, int num_samples);

void audio_test ();

#endif
