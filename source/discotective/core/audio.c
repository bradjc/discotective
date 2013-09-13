#include "audio.h"
#include "platform_specific.h"
#include "global.h"
#include "linked_list.h"

void display_notes (sheet_t* sheet, linked_list* notes) {

	int					i;
	music_element_t*	note;
	int					midi_index;

	int16_t				j;
	int16_t				accum;
	int16_t				mod, loc, lmi = 0;	// mod, lock, and locked_midi
	int16_t				loc_mod = 0;

	int8_t				note_lookup[12] = {0};
	// A A# B C C# D D# E F F# G  G#
	// 0 1  2 3 4  5 6  7 8 9  10 11

	static char* note_durations[] = {	"UNKNOWN",
										"SIXTEENTH",
										"EIGHTH",
										"QUARTER",
										"HALF",
										"WHOLE",
										"SIXTEENTH_DOT",
										"EIGHTH_DOT",
										"QUARTER_DOT",
										"HALF_DOT",
										"WHOLE_DOT",
										"SIXTEENTH_DDOT",
										"EIGHTH_DDOT",
										"QUARTER_DDOT",
										"HALF_DDOT",
										"WHOLE_DDOT"
									};

	static char* midi_values[] = {		"C",
										"C#",
										"D",
										"D#",
										"E",
										"F",
										"F#",
										"G",
										"G#",
										"A",
										"A#",
										"B",
										"Rest",
										"Error"
									};

	static char* articulations[]	= {	"",
										" STACCATO",
										" STACCATISSIMO",
										" MARCATO",
										" TENUTO",
										" MARTELLATO",
										" LEFT_PIZZICATO",
										" SNAP_PIZZICATO",
										" NAT_HARMONIC",
										" FERMATA",
										" UP_BOW",
										" DOWN_BOW"
									};

	static char* measure_types[]	= { "NOT_MEASURE",
										"NORMAL",
										"THICK",
										"REPEAT_START",
										"REPEAT_END",
										"REPEAT_BOTH",
										"STAFF_END",
										"REPEAT_STAFF_END",
										"SHEET_END"
									};


	// set up: set corresponding array values
	// to 1 for sharp and -1 for flat
	accum = 8;
	for (j=0; j<sheet->ks; j++) {
		note_lookup[accum] = 1;
		accum = (accum + 7) % 12;
	}
	accum = 2;
	for (j=0; j>sheet->ks; j--) {
		note_lookup[accum] = -1;
		accum = (accum + 5) % 12;
	}
	loc	= 0;

	// first write the time signature and key sig
	disco_log("@\tTIME SIG: %d/%d", sheet->ts_num, sheet->ts_den);
	disco_log("@\tKEY SIG: %d", sheet->ks);

	for (i=0; i<notes->length; i++) {
		note	= (music_element_t*) linked_list_getIndexData(notes, i);

		if (note->type == MEASURE) {
			loc	= 0;
			disco_log("@\tMEASURE: %s", measure_types[note->measure_type]);
			continue;
		}

		// handle key sig
		if (!loc) {
			mod	= note_lookup[(note->midi-57) % 12];
		} else if (note->midi != lmi) {
			// this is not the same as the note with the accidental
			mod = 0;
		} else {
			mod	= loc_mod;
		}

		// apply accidental
		if (note->accidental != NONE_AC) {
			loc	= 1;
			lmi	= note->midi;
			if (note->accidental == SHARP) {
				mod	= 1;
			} else if (note->accidental == FLAT) {
				mod	= -1;
			} else if (note->accidental == NATURAL) {
				mod = 0;
			}
			loc_mod	= mod;
		}

		// set midi
		midi_index	= (note->midi + mod) % 12;

		// check if rest
		if (note->type == REST) {
			midi_index	= 12;
		}

		disco_log("@\t%s\t\t%s%s", midi_values[midi_index], note_durations[note->duration], articulations[note->articulation]);

	}
}

void print_abc_format (sheet_t* sheet, linked_list* music) {

	int					n;
	music_element_t*	element;

	static char* key_sigs[]			= {"B", "Gb", "Db", "Ab", "Eb", "Bb", "F", "C", "G", "D", "A", "E",  "B", "F", "D"};
	static char* abc_notes[]		= {	"C,", "", "D,", "", "E,", "F,", "", "G,", "", "A,", "", "B,", "C", "", "D",
										"", "E", "F", "", "G", "", "A", "", "B", "c", "", "d", "", "e", "f",
										"", "g", "", "a", "", "b", "c'", "", "d'", "", "e'", "f'", "", "g'", "",
										"a'", "", "b'"};
	static char* articulations[]	= {"", ".", "", ">", "M", "", "", "", "", "H", "", ""};

	// print header
	disco_log("@@\tX: %d", 1);									// sequence number
	disco_log("@@\tT: %s", "test title");						// title
	disco_log("@@\tM: %d/%d", sheet->ts_num, sheet->ts_den);	// meter
	disco_log("@@\tL: %d/%d", 1, 8);							// default note length, set to EIGHTH
	disco_log("@@\tK: %s", key_sigs[(uint16_t)(sheet->ks+7)]);	// the key
	disco_log("@@\tQ: 160");									// the tempo
	disco_log("@@\tN: Created by the Discotective");			// notes
	
	disco_log_nol("@@\t");
	for (n=0; n<music->length; n++) {
		element	= (music_element_t*) linked_list_getIndexData(music, n);

		switch (element->type) {

			case NOTE:
				// display accidental
				switch (element->accidental) {
					case SHARP:		disco_log_nol("^");	break;
					case FLAT:		disco_log_nol("_");	break;
					case NATURAL:	disco_log_nol("=");	break;
					default: break;		// NEED TO ADD IN MORE HERE!!
				}
				// display actual note
				disco_log_nol("%s%s%d/%d", articulations[element->articulation], abc_notes[element->midi-48], element->duration_num, element->duration_den);
				// put in spacing for beams
				switch (element->beam_type) {
					case SINGLE:
					case END:		disco_log_nol(" ");	break;
					default: break; //NEED MORE HERE TOO
				}
				break;

			case REST:
				disco_log_nol("z%d/%d ", element->duration_num, element->duration_den);
				break;

			case MEASURE:
				switch (element->measure_type) {
					case NORMAL:			disco_log_nol(" | ");		break;
					case THICK:				disco_log_nol(" | ");		break;
		//			case REPEAT:			disco_log_nol(" |: ");	break;		// for now
					case REPEAT_START:		disco_log_nol(" |: ");		break;
					case REPEAT_END:		disco_log_nol(" :| ");		break;
					case REPEAT_BOTH:		disco_log_nol(" :|: ");		break;
					case STAFF_END:			disco_log_nol(" |\n@@\t");	break;
					case REPEAT_STAFF_END:	disco_log_nol(" :|\n@@\t");	break;
					case SHEET_END:			disco_log_nol(" |]\n@@\t");	break;
					default:	break;
				}
				break;
		}

	}
}
