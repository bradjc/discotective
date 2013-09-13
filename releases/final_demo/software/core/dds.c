#include "global.h"
#include "audio.h"
#include "dds.h"
#include "linked_list.h"
#include <stdint.h>
#include <stdlib.h>
#include "char_display.h"


const alt_u16 FREQS[33] = {
	0xa4d,  0xaea,  0xb90,  0xc40,  0xcfa,  0xdc0,  0xe91,  0xf6f,
	0x105a, 0x1153, 0x125b, 0x1372, 0x149a, 0x15d4, 0x1720, 0x1880,
	0x19f5, 0x1b80, 0x1d23, 0x1ede, 0x20b4, 0x22a6, 0x24b5, 0x26e4,
	0x2934, 0x2ba7, 0x2e40, 0x3100, 0x33ea, 0x3700, 0x3a45, 0x3dbc,
	0x4168
};

void play_sine_wave () {
	int i;
	int *ptr;


	ptr = &sine_samples;

	i=0;
	while (1) {
		// sound_note(52, 1);
		for (i = 0; i < 33; i++) {
			sound_note(MIDI_OFFSET + i, 1);
		}
		for (i = 32; i >=0; i--) {
			sound_note(MIDI_OFFSET + i, 1);
		}
	}
}

void sound_note(uint16_t midi, note_duration duration){

	// outputs note at midi frequency for counts beats
	// counts = 1 => eighth note, counts = 2 => quarter note
	// counts = 4 => half note, etc.

	uint16_t frequency, fs_slowdown;
    int16_t i, j;
	alt_16 *ptr;
	int sixteenth_length, adjusted_f_s;
	int duration_in_samples, smooth_num, ftv;
	alt_u16 table_ind1, table_ind2, table_ind3, table_ind4, table_ind5;
	alt_16 sample1, sample2, sample3, sample;
	alt_32 sample_amplitude;
	uint16_t note_lengths[8]={2, 4, 8, 16, 3, 6, 12, 24};
	// uint16_t h_coef[5] = {1, 3, 1, 0, 0}; // trumpet
	uint16_t h_coef[5] = {2, 0, 1, 0, 2}; // clarinet
	// uint16_t h_coef[5] = {7, 1, 0, 0, 0}; // smooth
	// uint16_t h_coef[5] = {4, 2, 1, 5, 0}; // organ

	fs_slowdown = 4;
	adjusted_f_s = F_S/fs_slowdown;

	sixteenth_length = (adjusted_f_s *15) / BPM;
	ptr = &sine_samples;
	
	duration_in_samples = sixteenth_length * note_lengths[duration] / 2;  // idk, something is messed

	smooth_num = duration_in_samples / 5;

	// check if note is a rest
	if (midi > 0xE000){
	   frequency=0;
	} else {
        frequency = FREQS[midi - MIDI_OFFSET];
	}

  	ftv = (frequency * SINE_TABLE_SIZE) / adjusted_f_s / 16; // frequency is in Q4

   	table_ind1 = table_ind2 = table_ind3 = table_ind4 = table_ind5 = 0;
   	for (i = 0; i < duration_in_samples; i++) {

   		sample1 = *(ptr+table_ind1);
   		sample2 = *(ptr+table_ind2);
		sample3 = *(ptr+table_ind3);

		sample_amplitude = sample1*h_coef[0] + sample2*h_coef[1] +	sample3*h_coef[2];

   		if (i < smooth_num) {
			sample_amplitude = i * (sample_amplitude / smooth_num);
   		}
   		if (i > duration_in_samples - smooth_num){
   			sample_amplitude = (duration_in_samples - i) * (sample_amplitude / smooth_num);
   		}

   		sample = (alt_16) sample_amplitude;

   		for (j = 0; j < fs_slowdown; j++) {
   			audio_play(&sample, 1);
   		}

   		table_ind1 = (table_ind1 + ftv) % SINE_TABLE_SIZE;
   		table_ind2 = (table_ind2 + 2*ftv) % SINE_TABLE_SIZE;
   		table_ind3 = (table_ind3 + 3*ftv) % SINE_TABLE_SIZE;

   	}

}

void play_song(linked_list* notes_list){
	stems_t* current_note;
	uint16_t i;

	for (i=0; i<notes_list->length; i++) {
		current_note = (stems_t*)linked_list_getIndexData(notes_list,i);
		char_display_note_info(current_note);
		sound_note(current_note->midi + current_note->mod, current_note->duration);
	}
}
