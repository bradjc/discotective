#include "music_functions.h"
#include "global.h"
#include "general_functions.h"
#include "image_functions.h"
#include "platform_specific.h"
#include <stdint.h>


void combine_symbols (linked_list *symbols, const staff_t* staff) {
	symbol_t	*symbol1;
	symbol_t	*symbol2;
//	symbol_t	*closestSymbol;
	int16_t		s1_lef, s1_rig, s1_top, s1_bot, s1_h, s1_w, s1_midx, s1_midy;
	int16_t		s2_lef, s2_rig, s2_top, s2_bot, s2_h, s2_w, s2_midx, s2_midy;
	int32_t		distance, min_distance;
	uint16_t	closest_symbol_index;

	uint16_t	non_overlap_x, non_overlap_y;
	int16_t		dist_x, dist_y1, dist_y2;
	uint16_t	dist_mx, dist_my;

//	float		right1, height1, top1, mid1;
//	float		left2,  height2, top2, mid2;
//	int32_t		closestSymb;
	uint16_t	i, j;
	float		line_spacing;
//	float		minDist, currDist;
	image_t**	new_img;
	uint16_t	new_img_height;
	uint16_t	new_img_offset_y;
	uint16_t	new_img_cu_offset_y;
	uint16_t	new_img_cl_offset_y;
	uint16_t	new_img_width;
	uint16_t	new_img_offset_x;
	uint16_t	new_img_cu_offset_x;
	uint16_t	new_img_cl_offset_x;

	line_spacing	= staff->line_spacing;

	i = 0;
	while (i < symbols->length && symbols->length > 1) {

		symbol1	= (symbol_t*) linked_list_getIndexData(symbols, i);
		s1_h	= symbol1->image->height;
		s1_w	= symbol1->image->width;
		s1_lef	= symbol1->offset_x;
		s1_rig	= symbol1->offset_x + symbol1->image->width;
		s1_top	= symbol1->offset_y;
		s1_bot	= s1_top + s1_h;
		s1_midy	= s1_top + (s1_h/2);
		s1_midx	= s1_lef + (s1_w/2);

		min_distance			= 10000000;		// some big number
		closest_symbol_index	= 0;

#ifdef DEBUG_COMBINE_SYMBOLS
binary_image_display(symbol1->image);
#endif

		// loop through all other symbols looking for the closest one
		for (j=0; j<symbols->length; j++) {
			if (j != i) {
				symbol2	= (symbol_t*) linked_list_getIndexData(symbols, j);
				s2_lef	= symbol2->offset_x;
				s2_h	= symbol2->image->height;
				s2_w	= symbol2->image->width;
				s2_top	= symbol2->offset_y;
				s2_midy	= s2_top + (s2_h/2);
				s2_midx	= s2_lef + (s2_w/2);

				if (s2_lef - s1_lef < 0) {
					// only look at symbols to the right
					continue;
				}

				distance	= ((int32_t) (s1_midy-s2_midy) * (int32_t) (s1_midy-s2_midy)) + ((int32_t) (s1_midx-s2_midx) * (int32_t) (s1_midx-s2_midx));
				if (distance < min_distance) {   // symbol2 is located just to the right
					min_distance			= distance;
					closest_symbol_index	= j;
				}
			}
		}

		// get that closest symbol
		symbol2	= (symbol_t*) linked_list_getIndexData(symbols, closest_symbol_index);
		s2_h	= symbol2->image->height;
		s2_w	= symbol2->image->width;
		s2_lef	= symbol2->offset_x;
		s2_rig	= s2_lef + s2_w;
		s2_top	= symbol2->offset_y;
		s2_bot	= s2_top + s2_h;
		s2_midy	= s2_top + (s2_h/2);
		s2_midx	= s2_lef + (s2_w/2);

		// figure out how far it is from the first symbol in 3 different directions
		dist_x	= s2_lef - s1_rig;
		dist_mx	= abs_16(s2_midx - s1_midx);
		dist_y1	= s1_top - s2_bot;
		dist_y2	= s2_top - s1_bot;
		dist_my	= abs_16(s2_midy - s1_midy);

		// calculate the amount they don't overlap
		non_overlap_y	= subtract_u16(s2_bot, max_u16(s2_top, s1_bot)) + subtract_u16(min_u16(s1_top, s2_bot), s2_top);
		non_overlap_x	= subtract_u16(s2_rig, max_u16(s2_lef, s1_rig)) + subtract_u16(min_u16(s1_lef, s2_rig), s2_lef);

		// use all these metrics to figure out if the symbols are close enough to be combined
		if (	min_distance < round_32(3.0F*line_spacing*line_spacing)
				||
				(dist_x >= 0 && dist_x <= round_16(line_spacing) &&
				 dist_my <= round_u16(line_spacing))
				||
				(dist_y1 >= 0 && dist_y1 <= round_16(line_spacing) &&
				 dist_mx <= round_u16(line_spacing))
				||
				(dist_y2 >= 0 && dist_y2 <= round_16(line_spacing) &&
				 dist_mx <= round_u16(line_spacing))
	//			||
	//			(abs_16(s1_h - s2_h) < round_u16(0.66F*line_spacing) &&
	//			 abs_16(s1_top - s2_top) < round_u16(2.0F*line_spacing))
				||
				(non_overlap_y < s2_h/4 &&									// images are basically overlapping, just not connected
				 non_overlap_x < s2_w/4)
			) {
			// we found a symbol that was reasonably close to this one
			// do a little more checking to make sure its good

			


			// check if the image is close enough to be combined
	//		if (	(abs_32(s1_h - s2_h) < round_u32(0.66F*line_spacing) &&
	//				abs_32(s1_top - s2_top) < round_u32(2.0F*line_spacing))
	//				||
	//				(non_overlap_y < s2_h/4 &&									// images are basically overlapping, just not connected
	//				non_overlap_x < s2_w/4)
	//			) {
				// these symbols are close enough
				// combine them

				// get the proper size for the new image based on how the two symbols are situated in the 
				// entire staff image
				if (symbol1->offset_y > symbol2->offset_y) {
					new_img_height		= max_u16((symbol1->offset_y + symbol1->image->height) - symbol2->offset_y, symbol2->image->height);
					new_img_offset_y	= symbol2->offset_y;
					new_img_cu_offset_y	= symbol1->offset_y - symbol2->offset_y;
					new_img_cl_offset_y	= 0;
				} else {
					new_img_height		= max_u16((symbol2->offset_y + symbol2->image->height) - symbol1->offset_y, symbol1->image->height);
					new_img_offset_y	= symbol1->offset_y;
					new_img_cu_offset_y	= 0;
					new_img_cl_offset_y	= symbol2->offset_y - symbol1->offset_y;
				}

				if (symbol1->offset_x > symbol2->offset_x) {
					new_img_width		= max_u16((symbol1->offset_x + symbol1->image->width) - symbol2->offset_x, symbol2->image->width);
					new_img_offset_x	= symbol2->offset_x;
					new_img_cu_offset_x	= symbol1->offset_x - symbol2->offset_x;
					new_img_cl_offset_x	= 0;
				} else {
					new_img_width		= max_u16((symbol2->offset_x + symbol2->image->width) - symbol1->offset_x, symbol1->image->width);
					new_img_offset_x	= symbol1->offset_x;
					new_img_cu_offset_x	= 0;
					new_img_cl_offset_x	= symbol2->offset_x - symbol1->offset_x;
				}

				// create the new image
				new_img		= (image_t**) malloc(sizeof(image_t*));
				*new_img	= binary_image_create(new_img_height, new_img_width);
				binary_image_whiteout(*new_img);

				// copy each image to the new image
				binary_image_copy(symbol1->image, *new_img, new_img_cu_offset_x, new_img_cu_offset_y);
				binary_image_copy(symbol2->image, *new_img, new_img_cl_offset_x, new_img_cl_offset_y);

#ifdef DEBUG_COMBINE_SYMBOLS
binary_image_display(*new_img);
#endif

				// put the data in the proper spot in the linked list
				if (closest_symbol_index > i) {
					symbol2->image		= *new_img;
					symbol2->offset_x	= new_img_offset_x;
					symbol2->offset_y	= new_img_offset_y;
					symbol2->num_black	= count_black(*new_img);

					linked_list_deleteIndexData(symbols, i);

				} else {
					symbol1->image		= *new_img;
					symbol1->offset_x	= new_img_offset_x;
					symbol1->offset_y	= new_img_offset_y;
					symbol1->num_black	= count_black(*new_img);

					linked_list_deleteIndexData(symbols, closest_symbol_index);
				}
				free(new_img);
				i = i-1;
		//	}
		}
		i = i+1;
	}
}



void contextualizer_notes_rests (linked_list *notes, linked_list *symbols) {
	// make modification to notes based on classification of whole notes and rests

	symbol_t*		symbol;
	note_t*			note;
	int16_t			note_num;
	int16_t			n;
	int16_t			i;
	uint16_t		s_lef, s_rig, s_top, s_bot;

	// loop through all of the symbols looking for notes and rests
	for (i=0; i<symbols->length; i++) {
		symbol = (symbol_t*) linked_list_getIndexData(symbols, i);

		s_lef	= symbol->offset_x;
		s_rig	= s_lef + symbol->image->width;
		s_top	= symbol->offset_y;
		s_bot	= s_top + symbol->image->height;

		switch (symbol->type) {

			case NOTE_SYM:
			case REST_SYM:
				note					= (note_t*) malloc(sizeof(note_t));
				note->begin				= s_lef;
				note->end				= s_rig;
				note->top				= s_top;
				note->bottom			= s_bot;
				note->center_of_mass	= (s_top + s_bot + 1)/2;
				note->duration			= symbol->duration;
				note->notehead_position	= NOT_APPLICABLE;
				note->connected_type	= SINGLE;
				note->midi				= 0;
				note->accidental		= NONE_AC;
				note->articulation		= NONE_AR;

				if (symbol->type == REST_SYM) {
					// mark it as a rest
					note->midi	= 0xF000;
				}

				// find closest note to the left
				for (n=0; n<notes->length; n++) {
					if ((((note_t*) linked_list_getIndexData(notes, n))->end - s_rig) > 0) {
						break; // note is to the right
					}
				}
				note_num = n - 1;

				// insert whole note into notes struct array at correct location
				if (note_num == -1)	linked_list_push_top(notes, (void**) &note);
				else				linked_list_insert_before_index(notes, note_num+1, (void**) &note);
				linked_list_deleteIndexData(symbols, i);
				i--;

				break;

			default:
				break;
		}
	}
}

void contextualizer_other (linked_list* notes, linked_list* measures, linked_list* symbols) {
    // make modification to notes based on classification of accidentals and dots

	int16_t				n;
	symbol_t*			symbol;
	note_t*				note	= NULL;
	measure_t*			measure	= NULL;
//	int16_t				note_num;
	int16_t				s_lef, s_rig, s_midx;
	int16_t				nh_midx;
	int16_t				m_lef, m_rig;
	uint8_t				on_right, on_left;

	while (!linked_list_is_empty(symbols)) {
		symbol	= (symbol_t*) linked_list_pop_top(symbols);

		s_lef	= symbol->offset_x;
		s_rig	= symbol->offset_x + symbol->image->width;
		s_midx	= (s_lef + s_rig) / 2;

		switch (symbol->type) {
			case DOT: // dot
			case DOUBLE_DOT:
				// find the note it belongs to
				for (n=1; n<notes->length; n++) {
					if (((note_t*) linked_list_getIndexData(notes, n))->end - s_rig > 0) {
						break;
					}
				}
				note	= (note_t*) linked_list_getIndexData(notes, n - 1);

				//increase duration of note
				if (symbol->type == DOT) {
					// single dot
					switch (note->duration) {
						case SIXTEENTH:		note->duration = SIXTEENTH_DOT;		break;
						case EIGHTH:		note->duration = EIGHTH_DOT;		break;
						case QUARTER:		note->duration = QUARTER_DOT;		break;
						case HALF:			note->duration = HALF_DOT;			break;
						case WHOLE:			note->duration = WHOLE_DOT;			break;
			//			case SIXTEENTH_DOT:	note->duration = SIXTEENTH_DDOT;	break;
			//			case EIGHTH_DOT:	note->duration = EIGHTH_DDOT;		break;
			//			case QUARTER_DOT:	note->duration = QUARTER_DDOT;		break;
			//			case HALF_DOT:		note->duration = HALF_DDOT;			break;
			//			case WHOLE_DOT:		note->duration = WHOLE_DDOT;		break;
						default:			break;
					}
				} else {
					// add double dot
					switch (note->duration) {
						case SIXTEENTH:		note->duration = SIXTEENTH_DDOT;	break;
						case EIGHTH:		note->duration = EIGHTH_DDOT;		break;
						case QUARTER:		note->duration = QUARTER_DDOT;		break;
						case HALF:			note->duration = HALF_DDOT;			break;
						case WHOLE:			note->duration = WHOLE_DDOT;		break;
						default:			break;
					}
				}

				break;


			case ACCIDENTAL:
				// find closest note on right
				for (n=0; n<notes->length; n++) {
					note	= (note_t*) linked_list_getIndexData(notes, n);
					if (note->end > s_rig) {
						break;
					}
				}
		//		note_num = notes->length-1;
		//		for (n=notes->length-2; n>=0; n--) {
		//			if ((left - ((note_t*) linked_list_getIndexData(notes, n))->begin) > 0) {
		//				break;
		//			}
		//		}
		//		note_num = n + 1;

				// mark accidental on note
		//		note				= (note_t*) linked_list_getIndexData(notes, note_num);
				note->accidental	= symbol->accidental;

				break;

			case REPEAT_DOT:
				// find closest thick measure line and figure out what's going on
				on_left		= 0;
				on_right	= 0;
				for (n=0; n<measures->length; n++) {
					measure	= (measure_t*) linked_list_getIndexData(measures, n);
					if (measure->type != THICK && measure->type != REPEAT_START && measure->type != REPEAT_END)	continue;

					m_lef	= (int16_t) measure->begin;
					m_rig	= (int16_t) measure->end;

					if (m_lef - s_rig > 0 && m_lef - s_rig < 50) {
						on_left		= 1;
						break;
					} else if (s_lef - m_rig > 0 && s_lef - m_rig < 50) {
						on_right	= 1;
						break;
					}
				}

				if (measure->type == THICK) {
					if (on_left) {
						measure->type	= REPEAT_END;
					} else if (on_right) {
						measure->type	= REPEAT_START;
					}
				} else if ((measure->type == REPEAT_START && on_left) || (measure->type == REPEAT_END && on_right)) {
					measure->type	= REPEAT_BOTH;
				}

				break;


			case STACCATO_DOT:
				// find the note it belongs to
				for (n=0; n<notes->length; n++) {
					note	= (note_t*) linked_list_getIndexData(notes, n);
					if (note->notehead_position == LEFT) {
						nh_midx	= note->begin - 10;
					} else {
						nh_midx	= note->end + 10;
					}
					if (abs_16(nh_midx - s_midx) < 16) {
						note->articulation	= STACCATO;
						break;
					}
				}
				
				break;

			default:
				break;
		}

		binary_image_delete(&symbol->image);
		free(symbol);

	}
}


// adds notes and measures to one music array
void concat_notes_measures (linked_list* notes, linked_list* measures, linked_list* music) {

	measure_t*			measure;
	note_t*				note;
	music_element_t*	music_el;

#ifdef DEBUG_CONCAT_NOTES_MEASURES
int	i;
#endif

#ifdef DEBUG_CONCAT_NOTES_MEASURES
for (i=0; i<measures->length; i++) {
	measure	= (measure_t*) linked_list_getIndexData(measures, i);
	disco_log("measure #%d, begin: %d", i, measure->begin);
}
#endif

	// skip first measure if dummy, otherwise add it
	measure	= (measure_t*) linked_list_pop_top(measures);
	if (measure->type != NORMAL) {
		music_el				= (music_element_t*) malloc(sizeof(music_element_t));
		music_el->type			= MEASURE;
		music_el->measure_type	= measure->type;
		music_el->duration_num	= 0;
		music_el->duration_den	= 0;
		music_el->beam_type		= SINGLE;
		music_el->slur_type		= SINGLE;
		music_el->midi			= 0;
		music_el->accidental	= NONE_AC;
		music_el->articulation	= NONE_AR;
		linked_list_push_bottom(music, (void**) &music_el);
	}
	free(measure);
	
	while (!linked_list_is_empty(measures)) {
		measure	= (measure_t*) linked_list_pop_top(measures);

		// loop through notes while they are before that measure line
		
		while (!linked_list_is_empty(notes)) {
			note	= (note_t*) linked_list_getIndexData(notes, 0);

			if (note->end <= measure->begin) {
				// note is in this measure
				music_el	= (music_element_t*) malloc(sizeof(music_element_t));
				if (note->midi == 0xF000)	music_el->type	= REST;
				else						music_el->type	= NOTE;
				music_el->measure_type	= NOT_MEASURE;
				music_el->duration		= note->duration;
				music_el->duration_den	= 1;
				switch (note->duration) {
					case SIXTEENTH:
						music_el->duration_num	= 1;
						music_el->duration_den	= 2;
						break;
					case EIGHTH:
						music_el->duration_num	= 1;
						break;
					case QUARTER:
						music_el->duration_num	= 2;
						break;
					case HALF:
						music_el->duration_num	= 4;
						break;
					case WHOLE:
						music_el->duration_num	= 8;
						break;
					case SIXTEENTH_DOT:
						music_el->duration_num	= 3;
						music_el->duration_den	= 4;
						break;
					case EIGHTH_DOT:
						music_el->duration_num	= 3;
						music_el->duration_den	= 2;
						break;
					case QUARTER_DOT:
						music_el->duration_num	= 3;
						break;
					case HALF_DOT:
						music_el->duration_num	= 6;
						break;
					case WHOLE_DOT:
						music_el->duration_num	= 12;
						break;
					case SIXTEENTH_DDOT:
						music_el->duration_num	= 7;
						music_el->duration_den	= 8;
						break;
					case EIGHTH_DDOT:
						music_el->duration_num	= 7;
						music_el->duration_den	= 4;
						break;
					case QUARTER_DDOT:
						music_el->duration_num	= 7;
						music_el->duration_den	= 2;
						break;
					case HALF_DDOT:
						music_el->duration_num	= 7;
						break;
					case WHOLE_DDOT:
						music_el->duration_num	= 14;
						break;
					default:
						music_el->duration_num	= 1;
						break;
				}
				music_el->beam_type		= note->connected_type;
				music_el->slur_type		= SINGLE;
				music_el->midi			= note->midi;
				music_el->accidental	= note->accidental;
				music_el->articulation	= note->articulation;

				linked_list_push_bottom(music, (void**) &music_el);
				linked_list_pop_top(notes);
				free(note);
			} else {
				// not in measure, need to add measure line and repeat this note
				break;
			}
		}

		// add the measure line to the music array
		music_el				= (music_element_t*) malloc(sizeof(music_element_t));
		music_el->type			= MEASURE;
		if (linked_list_is_empty(measures)) {
			switch (measure->type) {
				case NORMAL:		music_el->measure_type	= STAFF_END;		break;
				case REPEAT_END:	music_el->measure_type	= REPEAT_STAFF_END;	break;
				case THICK:			music_el->measure_type	= SHEET_END;		break;
				default:			music_el->measure_type	= STAFF_END;		break;
			}
		} else {
			music_el->measure_type	= measure->type;
		}
		music_el->duration_num	= 0;
		music_el->duration_den	= 0;
		music_el->beam_type		= SINGLE;
		music_el->slur_type		= SINGLE;
		music_el->midi			= 0;
		music_el->accidental	= NONE_AC;
		free(measure);
		linked_list_push_bottom(music, (void**) &music_el);
	}

}

void guess_time_signature (const linked_list* music, sheet_t* sheet) {

	float				counts_in_m;
//	float				counts_total;
	flex_array_t*		counts_m;
	float				note_dur;
	uint16_t			measures;
	int16_t				average_per_measure;
	int16_t				note_sum_max_index;
	uint16_t			one_beat;
	uint16_t			beats_measure;
	uint16_t			i;
	music_element_t*	music_el;
	flex_array_t*		note_sums;

	// indicies are their enum values
	note_sums	= flex_array_create(16);
	counts_m	= flex_array_create(music->length);

	counts_in_m		= 0.0F;
//	counts_total	= 0.0F;
	measures		= 0;
	for (i=0; i<music->length; i++) {
		music_el	= (music_element_t*) linked_list_getIndexData(music, i);

		if (music_el->type == NOTE || music_el->type == REST) {

			note_dur	= (float) music_el->duration_num / (float) music_el->duration_den;
			counts_in_m	+= note_dur;

			// record the type of note
			note_sums->data[music_el->duration]++;

		} else {
			// this is a measure line
			counts_m->data[measures++]	= round_16(counts_in_m);
	//		counts_total	+= counts_in_m;
			counts_in_m					= 0.0F;
	//		measures++;

		}

	}

	flex_array_change_size(&counts_m, measures);
	for (i=0; i<measures; i++) {
		disco_log("notes: %d", counts_m->data[i]);
	}

	// find the average count of each measure
//	average_per_measure	= counts_total / (float) measures;
	average_per_measure	= flex_array_median(counts_m);

	// try to determine the beat value
	note_sum_max_index	= flex_array_max_index(note_sums);

	if (note_sum_max_index == QUARTER) {
		// probably 4 or 2
		if (note_sums->data[HALF] * 2 > note_sums->data[QUARTER]) {
			// there are a lot of half notes
			one_beat	= 2;
		} else {
			one_beat	= 4;
		}
	
	} else if (note_sum_max_index == EIGHTH) {
		// could be 8 or 4
//		if (about_float(average_per_measure, 3.0F)) {
		if (average_per_measure == 3) {
			// 3 eighths per measure
			one_beat	= 8;
//		} else if (about_float(average_per_measure, 8.0F)) {
		} else if (average_per_measure == 8) {
			// 8 eighths per measure
			one_beat	= 4;
		} else {
			// ????
			one_beat	= 8;
		}
	} else {
		// guess 4 for now
		one_beat	= 4;
	}

	// figure out that top number
	switch (one_beat) {
		case 2:	beats_measure	= average_per_measure / 4;	break;
		case 4:	beats_measure	= average_per_measure / 2;	break;
		case 8:	beats_measure	= average_per_measure;		break;
		default: beats_measure	= 0;						break;
	}

	sheet->ts_num	= beats_measure;
	sheet->ts_den	= one_beat;

}

// Scans the list of all found elements for problems and tries to fix them

// Things to check:
//	- there isn't a half/whole rest inside of a connected run of notes
void clean_up_music_elements () {


}
