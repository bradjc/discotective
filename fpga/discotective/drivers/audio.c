#include "audio.h"
#include "altera_up_avalon_audio.h"
#include "alt_types.h"

int AUD_initialized = 0;
alt_up_audio_dev* AUD_port;

int audio_init () {
	if (!AUD_initialized) {
		AUD_port = alt_up_audio_open_dev("/dev/audio_0");
		if (AUD_port != NULL) {
			AUD_initialized = 1;
		}
	}
	return AUD_initialized;
}

// returns how much space is available in the write (output) audio FIFO
int audio_get_write_fifo_space () {
	if (!audio_init()) return -1;

	return alt_up_audio_write_fifo_space(AUD_port, ALT_UP_AUDIO_LEFT);
}

void audio_play (alt_16 *samples, int num_samples) {
	unsigned int samples_played;

	if (!audio_init()) return;

	while (num_samples > 0) {
		samples_played = alt_up_audio_write_fifo(AUD_port, samples, num_samples, ALT_UP_AUDIO_LEFT);
		alt_up_audio_write_fifo(AUD_port, samples, num_samples, ALT_UP_AUDIO_RIGHT);
		num_samples -= samples_played;
		samples += samples_played;
	}
}

void audio_test () {
	unsigned int l_buf;
	unsigned int r_buf;
	int fifospace;

	if (!audio_init()) return;
	while (1) {
		fifospace = alt_up_audio_read_fifo_avail(AUD_port, ALT_UP_AUDIO_RIGHT);

		if (fifospace > 0) {
			// read audio buffer
			alt_up_audio_read_fifo(AUD_port, &(r_buf), 1, ALT_UP_AUDIO_RIGHT);
			alt_up_audio_read_fifo(AUD_port, &(l_buf), 1, ALT_UP_AUDIO_LEFT);

			// write audio buffer
			alt_up_audio_write_fifo(AUD_port, &(r_buf), 1, ALT_UP_AUDIO_RIGHT);
			alt_up_audio_write_fifo(AUD_port, &(l_buf), 1, ALT_UP_AUDIO_LEFT);
		}
	}
}
