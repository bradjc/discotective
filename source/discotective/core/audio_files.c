#include "audio_files.h"
#include "platform_specific.h"
#include "general_functions.h"

const uint32_t wave_sample_rate=44100;

const uint32_t bits_per_sample=16;
const uint32_t number_channels=1;
const uint32_t BPM=100;
const float SECONDS_PER_MIN =60.0f;

float midi_table[MAX_MIDI_VALUE+1]={ 8.1757989156,       8.6619572180,       9.1770239974,       10.3008611535,       10.3008611535,
	10.9133822323,      11.5623257097,      12.2498573744,      12.9782717994,       13.7500000000,
	14.5676175474,      15.4338531643,      16.3515978313,      17.3239144361,       18.3540479948,
	19.4454364826,      20.6017223071,      21.8267644646,      23.1246514195,       24.4997147489,
	25.9565435987,      27.5000000000,      29.1352350949,      30.8677063285,       32.7031956626,
	34.6478288721,      36.7080959897,      38.8908729653,      41.2034446141,       43.6535289291,
	46.2493028390,      48.9994294977,      51.9130871975,      55.0000000000,       58.2704701898,
	61.7354126570,      65.4063913251,      69.2956577442,      73.4161919794,       77.7817459305,
	82.4068892282,      87.3070578583,      92.4986056779,      97.9988589954,       103.8261743950,
	110.0000000000,     116.5409403795,     123.4708253140,     130.8127826503,      138.5913154884,
	146.8323839587,     155.5634918610,     164.8137784564,     174.6141157165,      184.9972113558,
	195.9977179909,     207.6523487900,     220.0000000000,     233.0818807590,      246.9416506281,
	261.6255653006,     277.1826309769,     293.6647679174,     311.1269837221,      329.6275569129,
	349.2282314330,     369.9944227116,     391.9954359817,     415.3046975799,      440.0000000000,
	466.1637615181,     493.8833012561,     523.2511306012,     554.3652619537,      587.3295358348,
	622.2539674442,     659.2551138257,     698.4564628660,     739.9888454233,      783.9908719635,
	830.6093951599,     880.0000000000,     932.3275230362,     987.7666025122,      1046.5022612024,
	1108.7305239075,    1174.6590716696,    1244.5079348883,    1318.5102276515,     1396.9129257320,
	1479.9776908465,    1567.9817439270,    1661.2187903198,    1760.0000000000,     1864.6550460724};

uint8_t midi_index_to_accidental_index(int midi_index){
        midi_index=(midi_index+12)%12;
        if(midi_index==0) return 0;
        if(midi_index ==2) return 1;
        if(midi_index ==3) return 2;
        if(midi_index ==5) return 3;
        if(midi_index ==7) return 4;
        if(midi_index ==8) return 5;
        if(midi_index ==10) return 6;
        else{
             disco_log("Error: midi index mapping error");
             return 0xFF;
        }
}
        

uint8_t* createAudioFileBytes(linked_list* song_list, uint32_t* outLength){
	//something wrong in header encoding i think...
         uint8_t* header;
         uint32_t offset=0;
         uint32_t num_samples_per_channel;
         num_samples_per_channel=song_list->length;
		 *outLength=44+num_samples_per_channel*number_channels*bits_per_sample/8;
         header=malloc(sizeof(uint8_t)*(*outLength));
         *((uint32_t*)header)=0x46464952;//RIFX
         *((uint32_t*)header+1)=36+num_samples_per_channel*number_channels*bits_per_sample/8;//chunk size
         *((uint32_t*)header+2)=0x45564157;//WAVE
         *((uint32_t*)header+3)=0x20746d66;//fmt
         *((uint32_t*)header+4)=16;//PCM=16
         *((uint16_t*)header+10)=1;//PCM=1
         *((uint16_t*)header+11)=number_channels;//number of channels
         *((uint32_t*)header+6)=wave_sample_rate;//sample rate
         *((uint32_t*)header+7)=wave_sample_rate*number_channels*bits_per_sample/8;//byte rate
         *((uint16_t*)header+16)=number_channels*bits_per_sample/8;
		 *((uint16_t*)header+17)=bits_per_sample;
         *((uint32_t*)header+9)=0x61746164;//data
         *((uint32_t*)header+10)=num_samples_per_channel*number_channels*bits_per_sample/8;
         while( linked_list_is_empty(song_list)==0){
               *((uint16_t*)header+22+offset)=*(int16_t*)linked_list_pop_bottom(song_list); 
               offset++;
         }
		for (int i=0; i<44; i++) {
			disco_log("%X",*(header+i));
		}
	disco_log("%c",*(header+1));
	
	
         return header;
}
//create a linked list of 16 bit int samples
//length is num_samples_per_channel 
//iterate/pop through adding to song

linked_list* create_song_list(sheet_t* sheet, linked_list* notes){
	float frequency;
	float beat_duration;
     linked_list*           song_list;
     int16_t                accum;
     int16_t i, j;
	 int16_t *ptr;
	 uint32_t duration_in_samples;
     int32_t smooth_num, ftv;
	 uint8_t previous_was_measure;
	 uint16_t table_ind1, table_ind2, table_ind3, table_ind4, table_ind5;
	 int16_t sample1, sample2, sample3, sample;
	uint32_t midi_index;
	 int32_t sample_amplitude;
	 int16_t *sample_for_list;
	int16_t				mod;
	 int32_t repeat_index;
	 music_element_t*	note;
     int8_t				    key_signature_modifiers[7] = {-1,-1,-1,-1,-1,-1,-1};
     int8_t                 measure_modifiers[7]={0};
     //                                1/16     1/8        1/4     1/2    1      1/16.       1/8.     1/4.   1/2.      1.     1/16..        1/8..    1/4..      1/2..     1..
	float note_lengths_in_beats[15]={.0625,     .125,     .25,     .5,    1,    .09375,    .1875,    .375,    .75,    1.5,    .109375,    .21875,    .4375,    .875,    1.75};
	// uint16_t h_coef[5] = {1, 3, 1, 0, 0}; // trumpet
	uint16_t h_coef[5] = {2, 0, 1, 0, 2}; // clarinet
	// uint16_t h_coef[5] = {7, 1, 0, 0, 0}; // smooth
	// uint16_t h_coef[5] = {4, 2, 1, 5, 0}; // organ
     
	// set up: set corresponding array values
	// to 1 for sharp and -1 for flat
	beat_duration = wave_sample_rate*SECONDS_PER_MIN/BPM;
	accum = 5;
	/*for (j=0; j<sheet->ks; j++) {
		key_signature_modifiers[accum] = 1;
		accum = (accum + 7) % 12;
	}
	accum = 2;
	for (j=0; j>sheet->ks; j--) {
		key_signature_modifiers[accum] = -1;
		accum = (accum + 5) % 12;
	}*/
	for (j=0; j< sheet->ks +7; j++){
        key_signature_modifiers[accum]+=1;
        accum=(accum+4)%7;
    }
    for (j=0; j< 7; j++){
        measure_modifiers[j]=key_signature_modifiers[j];
    }
	song_list=linked_list_create();
	ptr = sine_samples;
    
	locked_accidental=0;
	repeat_index=0;
	previous_was_measure=0;
	
	for (i=0; i<notes->length; i++) {
		note	= (music_element_t*) linked_list_getIndexData(notes, i);
		
        //handle repeat markers
		if (note->type == MEASURE) {
			for (j=0; j< 7; j++){
                measure_modifiers[j]=key_signature_modifiers[j];
            }
			previous_was_measure=1;
			if( note->measure_type==REPEAT_START){
                repeat_index=i+1;
            }else if(note->measure_type==REPEAT_END || note->measure_type==REPEAT_STAFF_END){
                  if( repeat_index>0){
                      i=repeat_index;
                      repeat_index=-1;
                  }
            }else if(note->measure_type==REPEAT_BOTH){
                  if(repeat_index>i) {} //have hit this before so keep going
                  else if( repeat_index>0){
                      i=repeat_index;
                      repeat_index=i+1;
                  }
            }
			continue;
		}
		duration_in_samples=round_u32(note_lengths[note->duration]*beat_duration);
		smooth_num = duration_in_samples / 5;
		// handle key sig
        mod	= measure_modifiers[midi_index_to_accidental_index(note->midi)];
        

		// apply accidental
		//What if two accidentals in same measure?--should be taken care of.
		if (note->accidental != NONE_AC) {
			if (note->accidental == SHARP) {
				mod	= 1;
			} else if (note->accidental == FLAT) {
				mod	= -1;
			} else if (note->accidental == NATURAL) {
				mod = 0;
			}
			measure_modifiers[midi_index_to_accidental_index(note->midi)]=mod;
		}

		// set midi
		midi_index	= (note->midi + mod);

		// check if rest
		if (note->type == REST) {
			frequency=0;
		}else{
            frequency=midi_table[midi_index];
        }
        ftv = (int)((frequency * SINE_TABLE_SIZE) / wave_sample_rate); 
        //needs checking down here.
   	    table_ind1 = table_ind2 = table_ind3 = table_ind4 = table_ind5 = 0;
   	    for (j = 0; j < duration_in_samples; j++) {

   		    sample1 = *(ptr+table_ind1);
   		    sample2 = *(ptr+table_ind2);
		    sample3 = *(ptr+table_ind3);

		    sample_amplitude = sample1*h_coef[0] + sample2*h_coef[1] +	sample3*h_coef[2];
            if( previous_was_measure){
                sample_amplitude*=1.1;
            }
   		    if (j < smooth_num) {
			   sample_amplitude = j * (sample_amplitude / smooth_num);
   		    }
   		    if (j > duration_in_samples - smooth_num){
   			   sample_amplitude = (duration_in_samples - j) * (sample_amplitude / smooth_num);
   		    }

   		    sample = (int16_t) sample_amplitude;
   		    sample_for_list=(int16_t*)malloc(sizeof(int16_t));
            *sample_for_list=sample;
            linked_list_push_top(song_list,(void**)&sample_for_list);

   		    table_ind1 = (table_ind1 + ftv) % SINE_TABLE_SIZE;
   		    table_ind2 = (table_ind2 + 2*ftv) % SINE_TABLE_SIZE;
   		    table_ind3 = (table_ind3 + 3*ftv) % SINE_TABLE_SIZE;
   		    previous_was_measure=0;
         }
     }
     return song_list;
}

