#include "classification.h"
#include "scanning.h"
#include "global.h"
#include "image_functions.h"
#include "general_functions.h"
#include "linked_list.h"
#include <stdint.h>
#include "allocate.h"
#include "platform_specific.h"


uint8_t check_if_rest (const image_t* img, const staff_t* staff, uint16_t topCut, uint16_t xbegin) {
	// checks around middle of line to make sure it is 'flat'
	// takes in mini_img

	uint16_t	height;
	uint16_t	width;
	uint16_t	extend;

	height	= img->height;
	width	= img->width;

	// a rest should be below top staffline
	if (topCut < round_u16(staff->stafflines[0]-2.0F)) {
		return 0;
	}

	// a rest should be above last staffline
	if ((topCut + height) > round_u16(staff->stafflines[4]+1.0F)) {
		return 0;
	}

	extend	= round_u16(1.6F * staff->line_spacing);

	// should be skinny width
	if (width > 4 + extend) {
		return 0;
	}

	// line for a rest will be in middle of the image if it is a rest,
	// for a note it should be on one side
	if (xbegin > width/4 && xbegin < (3*width + 3)/4) {
		// it is a rest
		return 1;
	}
	return 0;
}

uint8_t check_for_beam_on_top (const image_t* img, const staff_t *staff, uint16_t xend) {
	return check_for_beam(img, staff, xend, 1);
}

uint8_t check_for_beam_on_bottom (const image_t* img, const staff_t *staff, uint16_t xend) {
	return check_for_beam(img, staff, xend, 0);
}

// just checks if there is a long enough run of black on the right hand side of the image
// and check about 5 pixels to the left of that too
uint8_t check_for_beam (const image_t* img, const staff_t *staff, uint16_t xend, uint8_t check_top) {
	linked_list*	runs1;
	linked_list*	runs2;
	uint16_t		min_thickness;
	uint16_t		look_over;

	
	// do some simple checking
	// if there is no room between xend and the edge of the image then there can't be a beam
	if (img->width - xend < 4) {
		return 0;
	}

	// set threshold
	min_thickness	= round_u16(BEAM_CHECK_LINE_THICKNESS_MULTIPLIER * staff->line_thickness);

	// set the amount to look left from the bar to halfway between the edge and the end of the stem
	look_over	= img->width - (img->width - xend) / 2;

	runs1	= find_runs(img, img->width-1, (check_top)?TOP_TO_BOTTOM:BOTTOM_TO_TOP, 0, img->height/2);
	runs2	= find_runs(img, look_over, (check_top)?TOP_TO_BOTTOM:BOTTOM_TO_TOP, 0, img->height/2);

	if (runs1 == NULL || runs2 == NULL) {
		// something is wrong
		trigger_error();
	}

	return parse_runs(runs1, 0, 1, BLACK, 0, img->width, min_thickness, 5*min_thickness) && parse_runs(runs2, 0, 1, BLACK, 0, img->width, min_thickness, 5*min_thickness);
}

uint8_t check_for_double_beam_right (const image_t* img, const staff_t *staff, uint16_t xbegin, uint16_t xend, uint8_t check_top) {
	return check_for_double_beam(img, staff, xbegin, xend, check_top, 0, 1);
}

uint8_t check_for_double_beam_left (const image_t* img, const staff_t *staff, uint16_t xbegin, uint16_t xend, uint8_t check_top) {
	return check_for_double_beam(img, staff, xbegin, xend, check_top, 1, 0);
}

uint8_t check_for_double_beam_both (const image_t* img, const staff_t *staff, uint16_t xbegin, uint16_t xend, uint8_t check_top) {
	return check_for_double_beam(img, staff, xbegin, xend, check_top, 1, 1);
}

// looks for a double beam on either the left or the right of the stem
// returns 1 if it finds a double beam on either side
uint8_t check_for_double_beam (const image_t* img, const staff_t* staff, uint16_t xbegin, uint16_t xend, uint8_t check_top, uint8_t check_left, uint8_t check_right) {
	linked_list*	left_runs1;
	linked_list*	left_runs2;
	linked_list*	right_runs1;
	linked_list*	right_runs2;
	uint8_t			left_val;
	uint8_t			right_val;
	uint16_t		min_bar_thickness;


	min_bar_thickness	= round_u16(BEAM_CHECK_LINE_THICKNESS_MULTIPLIER * staff->line_thickness);
	right_val			= 0;
	left_val			= 0;

	// set the vertical scan points
	if (check_left) {
		left_runs1	= find_runs(img, subtract_u16(xbegin, 3), (check_top)?TOP_TO_BOTTOM:BOTTOM_TO_TOP, 0, img->height/2);
		left_runs2	= find_runs(img, subtract_u16(xbegin, 8), (check_top)?TOP_TO_BOTTOM:BOTTOM_TO_TOP, 0, img->height/2);

		left_val	= parse_runs(left_runs1, 1, 2, BLACK, 2, 10, min_bar_thickness, 3*min_bar_thickness) && parse_runs(left_runs2, 1, 2, BLACK, 2, 10, min_bar_thickness, 3*min_bar_thickness);

		linked_list_delete(left_runs1);
		linked_list_delete(left_runs2);
	}

	if (check_right) {
		right_runs1	= find_runs(img, min_u16(xend + 3, img->width-1), (check_top)?TOP_TO_BOTTOM:BOTTOM_TO_TOP, 0, img->height/2);
		right_runs2	= find_runs(img, min_u16(xend + 8, img->width-1), (check_top)?TOP_TO_BOTTOM:BOTTOM_TO_TOP, 0, img->height/2);

		right_val	= parse_runs(right_runs1, 1, 2, BLACK, 2, 10, min_bar_thickness, 3*min_bar_thickness) && parse_runs(right_runs2, 1, 2, BLACK, 2, 10, min_bar_thickness, 3*min_bar_thickness);

		linked_list_delete(right_runs1);
		linked_list_delete(right_runs2);
	}

	return left_val || right_val;
}

uint8_t check_if_single_eighth_note (const image_t* img, uint16_t xbegin, notehead_pos_e notehead_pos) {
	// checks whether note is an eighth note

	uint16_t		height, width;
	uint16_t		x, y;
	uint16_t		start_x;
	uint16_t		start_y;
	linked_list*	runs;
	uint16_t		farthest_right;
	uint16_t		matched_rows;

	flex_array_t*	proj_x;
	uint8_t			not_connected;
	flex_array_t*	match_array;


	height	= img->height;
	width	= img->width;

	// get some padding
	start_x	= subtract_u16(xbegin, 2);

	// set the starting and ending points based on which way the note faces
	// this is to skip looking at the note head (particularly useful for half notes)
	start_y	= 0;
	if (notehead_pos == RIGHT) {
		start_y	= 10;
	}

	// below algorithm looks for white space in between stem and flag
	farthest_right	= 0;
	matched_rows	= 0;
	for (y=start_y; y<height; y++) {

		runs	= find_runs(img, y, LEFT_TO_RIGHT, start_x, width-1);
		if (parse_runs_main(runs, 1, 2, BLACK, SINGLE_EIGHTH_CHECK_WHITE_MIN, width, SINGLE_EIGHTH_CHECK_BLACK_MIN, SINGLE_EIGHTH_CHECK_BLACK_MAX, &match_array)) {
			matched_rows++;
			if (((run_t*) linked_list_getIndexData(runs, match_array->data[2]))->end > farthest_right) {
				farthest_right	= ((run_t*) linked_list_getIndexData(runs, match_array->data[2]))->end;
			}
			flex_array_delete(&match_array);
		}
		linked_list_delete(runs);

	}

	// check that there is no white between the note and the tail
	proj_x			= project_on_X(img);
	not_connected	= 0;
	for (x=xbegin; x<=min_u16(farthest_right, width-1); x++) {
		if (proj_x->data[x] == 0) {
			not_connected	= 1;
			break;
		}
	}
	flex_array_delete(&proj_x);

	if (matched_rows > height/4 && not_connected == 0) {
		return 1;
	}

	return 0;
}

// look for rows where there is black, then white, then black again
uint8_t check_if_note_is_open (const image_t* img) {
	uint16_t		height, width;
	uint16_t		y;
	uint16_t		black_max;
	linked_list*	runs		= NULL;
	flex_array_t*	match_array	= NULL;
	uint16_t		white_total;		// total number of white pixels found in middle of note
	uint16_t		open_flags;


	height		= img->height;
	width		= img->width;
	open_flags	= 0;
	white_total	= 0;
	black_max	= (55*width)/100;

	for (y=0; y<height; y++) {

		runs = find_runs(img, y, LEFT_TO_RIGHT, 0, width-1);
		if (parse_runs_main(runs, 1, 2, BLACK, NOTEHEAD_CHECK_WHITE_MIN, width, NOTEHEAD_CHECK_BLACK_MIN, black_max, &match_array)) {
			open_flags++;
			white_total	+= ((run_t*) linked_list_getIndexData(runs, match_array->data[1]))->length;
			flex_array_delete(&match_array);
		}
		linked_list_delete(runs);

		if (open_flags >= NOTEHEAD_CHECK_OPEN_FLAGS_MIN && white_total >= NOTEHEAD_CHECK_MIN_TOTAL_WHITE) {
			return 1;
		}

	}

	return 0;
}

// Creates the y coordinates of all of the lines that notes can be on using the
//	staff lines that were found
flex_array_t* create_midi_lines (const staff_t* staff) {

	float			line_w;
	flex_array_t*	note_lines;
	float			line;
	int				i;

	line_w			= staff->line_thickness + staff->line_spacing;
	note_lines		= flex_array_create_noinit(33);

	// 6 lines above the staff
	line	= staff->stafflines[0];
	for (i=10; i>=0; i-=2) {
		line					-= line_w;
		note_lines->data[i]		= round_16(line);
		note_lines->data[i+1]	= round_16(line + 0.5F*line_w);
	}

	// staff lines
	for (i=0; i<5; i++) {
		note_lines->data[i*2+12]	= round_16(staff->stafflines[i]);
		if (i < 4) {
			note_lines->data[i*2+13]	= round_16(0.5F * (staff->stafflines[i] + staff->stafflines[i+1]));
		}
	}

	// 6 lines below staff
	line	= staff->stafflines[4];
	for (i=22; i<=32; i++) {
		line					+= line_w;
		note_lines->data[i]		= round_16(line);
		note_lines->data[i-1]	= round_16(line - 0.5F*line_w);
	}

	return note_lines;
}

// takes in the image after the notes have been found and vertical lines have been removed
void identify_note_pitches (linked_list* notes, const staff_t* staff) {

	flex_array_t*	note_lines;		// six major lines above and below, plus the 5 staff lines, and all of the spaces
	int				i, j;
	note_t*			note;
	uint16_t		MIDI;
	uint16_t		COM;
	int16_t			dif;
	int16_t			previous_dif;
	uint16_t		closest;
	uint16_t		midi[33]	= {98, 96, 95, 93, 91, 89, 88, 86, 84, 83, 81, 79, 77, 76, 74, 72, 71, 69, 67, 65, 64, 62, 60, 59, 57, 55, 53, 52, 50, 48, 47, 45, 43};

	note_lines	= create_midi_lines(staff);

	// find the midi line that is closest (ties go to the lower line) to each note
	for (i=0; i<notes->length; i++) {
		note	= (note_t*) linked_list_getIndexData(notes, i);
		COM		= note->center_of_mass;
		MIDI	= note->midi;

		// look for closest index of line:
	    if (MIDI == 0 && COM != 0) {
			previous_dif	= INT16_MAX;	// set the previous difference to the highest it could be
			closest			= 32;			// set default at highest, in case the last line is the correct one
			for (j=0; j<33; j++) {
				// skip lines that are off the image
				if (note_lines->data[j] < 0) continue;

				dif	= abs_16(note_lines->data[j] - COM);

				// check so that it guesses the lower (higher y value) line if there is a tie
				if (dif <= previous_dif) {
					// set the closest difference so far
					previous_dif	= dif;
				} else {
					// the difference is now getting bigger, we found a winner last time
					closest			= j-1;
					break;
				}
			}

		    // modify notes struct
		    note->midi = midi[closest];

		}
	}

	flex_array_delete(&note_lines);

}

// determines if a given blob is worthy of being a symbol
// requires that the image given to it is cropped tightly around the black
// returns 1 if the blob is good to go as a symbol
uint8_t check_if_blob_is_symbol (const image_t* img) {

	uint32_t black_count;

	if (img->height < BLOB_CHECK_MIN_HEIGHT && img->width < BLOB_CHECK_MIN_WIDTH) {
		// both dimensions are small, ditch it
		return 0;
	
	} else if (img->height > BLOB_CHECK_MIN_HEIGHT && img->width > BLOB_CHECK_MIN_WIDTH) {
		// both dimensions are decent
		return 1;
	
	} else {
		black_count	= count_black(img);
		if (black_count >= BLOB_CHECK_MIN_TOTAL_BLACK) {
			return 1;
		}
	}

	return 0;
}

// Determines if an image is a measure line.
// if it is, it returns the measure_t struct all filled in
// if it isn't, it returns NULL
measure_t* check_if_measure_line (const image_t* img, const staff_t* staff, const linked_list* measures, uint16_t xbegin, uint16_t xend, uint16_t left_offset) {
//	image_t*		line_img;
	uint16_t		h, w;
	flex_array_t*	proj_x;
	flex_array_t*	proj_y;
	measure_t*		measure = NULL;
	uint32_t		difference;
	flex_array_t*	tall_lines;
	uint16_t		tall_lines_length;
	measure_t*		measure_prev;


	h		= img->height;
	w		= img->width;
	proj_y	= project_on_Y(img);
	proj_x	= project_on_X(img);
	
	// check for measure marker by seeing if the variance of the y projection
	// is small (so the "note" is basically a rectangle) or if the width is small (aka
	// there is no notehead)
	difference	= flex_array_absolute_difference_from_mean(proj_y);

	// also check if there are a lot of tall black lines in the x projection
	// this would imply that it is a repeat marker
	tall_lines			= flex_array_find(proj_x, h-4, greater_equal);
	tall_lines_length	= 0;
	if (tall_lines != NULL) {
		tall_lines_length	= tall_lines->length;
	}
	
	if (((uint16_t) difference < (6*h)/5 || tall_lines_length >= 8) && h >= (9*staff->height)/10 && 2*flex_array_mean_rounded(proj_y) > flex_array_max(proj_y)) {
		// there isn't much difference in each row of this note image
		// that would imply it's a measure marker (or maybe some other crap,
		//	so do some more checking)
		// OR there are a lot of vertical tall lines
		// AND the line is about as tall as the staff

		// check for the previous measure marker and make sure this one is far enough away
		if (measures->length > 0) {
			measure_prev	= (measure_t*) linked_list_getIndexData(measures, measures->length-1);
			if (abs_diff_u16(xbegin, measure_prev->end) < MIN_SPACE_BETWEEN_MEASURES) {
				// This one is too close, but is still a measure marker.
				// Probably got a repeat or other large measure line twice.
				measure	= (measure_t*) 0x1;
				goto check_if_measure_line_END;
			}
		}

		measure			= (measure_t*) malloc(sizeof(measure_t));
		measure->begin	= xbegin;
		measure->end	= xend;

		// now try to determine the type of the measure marker
		// look at the number of tall lines
		if (tall_lines_length < 8) {
			// this is a skinny (aka normal) measure marker
			measure->type	= NORMAL;
		
		} else {
			// this is a thicker measure marker
			measure->type	= THICK;

			// we need to set the xbegin and xend values to include the whole
			//	thing (the thick bar and the thinner bar)
			measure->begin	= left_offset + tall_lines->data[0];
			measure->end	= left_offset + tall_lines->data[tall_lines->length-1];
		}
	}

	// cleanup and return
check_if_measure_line_END:

	flex_array_delete(&proj_y);
	flex_array_delete(&proj_x);
	if (tall_lines != NULL)	flex_array_delete(&tall_lines);

	return measure;
}

// classify all remaining symbols
void classify_symbols (linked_list *symbols, const linked_list *notes, const linked_list *measures, const staff_t* staff) {

	symbol_t*		symbol;
	measure_t*		measure;
	note_t*			note;
	flex_array_t*	proj_x;
	flex_array_t*	proj_y;
	float			line_w, line_thickness, line_spacing;
	uint16_t		line_w_u16;
	int16_t			line_w_16;
	uint16_t		sm_note_width;
	uint16_t		s_h, s_w;
	int16_t			s_top, s_bot, s_lef, s_rig, s_midx, s_midy;
	int16_t			n_top, n_bot, n_lef, n_rig, nh_midy, nh_midx;
	int16_t			sym_r_to_note_l;	// symbol right to note left
	int16_t			note_r_to_sym_l;	// note right to symbol left
	int16_t			sym_b_to_note_t;	// symbol bottom to note top
	int16_t			note_b_to_sym_t;	// note bottom to symbol top
	int16_t			sym_my_to_nh_my;	// symbol middle y axis to notehead middle y axis
	int16_t			sym_mx_to_nh_mx;	// symbol midpoint to notehead midpoint on x axis
	uint16_t		i, j;
	float			black_percent;
	uint8_t			left_of_note, right_of_note, above_note, below_note;
	uint8_t			close_to_measure;
	int16_t			m_lef, m_rig;
	uint16_t		notes_in_measure;


	line_thickness	= staff->line_thickness;
	line_spacing	= staff->line_spacing;
	line_w			= (2 * line_thickness) + line_spacing;
	line_w_u16		= round_u16(line_w);
	line_w_16		= round_16(line_w);
	sm_note_width	= round_u16(line_thickness + line_spacing);

	for (i=0; i<symbols->length; i++) {
		symbol	= (symbol_t*) linked_list_getIndexData(symbols, i);

#ifdef DEBUG_CLASSIFY_SYMBOLS
binary_image_display(symbol->image);
#endif

		s_h		= symbol->image->height;
		s_w		= symbol->image->width;

		s_top	= symbol->offset_y;
		s_bot	= s_top + s_h;
		s_lef	= symbol->offset_x;
		s_rig	= s_lef + s_w;
		s_midx	= (s_rig + s_lef) / 2;
		s_midy	= (s_top + s_bot) / 2;

		black_percent	= (float) symbol->num_black / (float) (s_h * s_w);
		proj_x			= project_on_X(symbol->image);
		proj_y			= project_on_Y(symbol->image);

		right_of_note		= 0;
		left_of_note		= 0;
		above_note			= 0;
		below_note			= 0;
		close_to_measure	= 0;

		// look to see if this symbol is to the left or right or above or below of a note (any note)
		for (j=0; j<notes->length; j++) {
			// check for closeness of symbol to notes
			note = (note_t*) linked_list_getIndexData(notes, j);

			// setup variables
			n_top	= note->top;
			n_bot	= note->bottom;
			if (note->notehead_position == LEFT) {
				n_lef	= subtract_u16(note->begin, sm_note_width);
				n_rig	= note->end;
				nh_midy	= n_bot - round_16(0.5F * line_w);
			} else {
				n_lef	= note->begin;
				n_rig	= note->end + sm_note_width;
				nh_midy	= n_top + round_16(0.5F * line_w);
			}
			nh_midx	= (n_lef + n_rig) / 2;

			// calculate some distances
			sym_r_to_note_l		= n_lef - s_rig;
			note_r_to_sym_l		= s_lef - n_rig;
			sym_b_to_note_t		= n_top - s_bot;
			note_b_to_sym_t		= s_top - n_bot;
			sym_my_to_nh_my		= abs_16(nh_midy - s_midy);
			sym_mx_to_nh_mx		= abs_16(nh_midx - s_midx);

			// check left and right
			if (sym_my_to_nh_my < line_w_u16) {
				// check right
				if (note_r_to_sym_l > 0 && note_r_to_sym_l < line_w_16) {
					right_of_note	= 1;
				}

				// check left
				if (sym_r_to_note_l > 0 && sym_r_to_note_l < line_w_16) {
					left_of_note	= 1;
				}
			}

			// check if it above or below a notehead
			if (sym_mx_to_nh_mx < line_w_u16) {
				if (note->notehead_position == LEFT) {
					if (note_b_to_sym_t > 0 && note_b_to_sym_t < (3*line_w_16)/2) {
						below_note	= 1;
					}
				} else {
					if (sym_b_to_note_t > 0 && sym_b_to_note_t < (3*line_w_16)/2) {
						above_note	= 1;
					}
				}
			}

		}

		// look to see if the note is close to a thick measure marker
		for (j=0; j<measures->length; j++) {
			measure	= (measure_t*) linked_list_getIndexData(measures, j);

			// if its not a larger measure marker then it doesn't matter
			if (measure->type != THICK)	continue;

			m_lef	= (int16_t) measure->begin;
			m_rig	= (int16_t) measure->end;

			if ((m_lef - s_rig > 0 && m_lef - s_rig < line_w_16) || (s_lef - m_rig > 0 && s_lef - m_rig < line_w_16)) {
				close_to_measure = 1;
				break;
			}
		}

		// Actually check the note
		if (		right_of_note &&						// located to the right of a note
					s_h <= round_u16(line_w + 2.0F) &&		// not taller than line width
					s_w < round_u16(1.25F * line_spacing) &&	// not too wide
	//				abs_diff_u16(sH, sW) < 5 &&				// about as tall as it is wide (supposed to be a circle)
					black_percent > 0.5F					// img is mostly black
			) {		
			// dot
			symbol->type	= DOT;

		} else if (	right_of_note &&						// located to the right of a note
					s_h <= round_u16(line_w + 2.0F) &&		// not taller than line width
					2 * s_w >= s_h &&							// wider than tall
					proj_x->data[s_w/2] == 0					// white gap in the middle
			) {
			// double dot
			symbol->type	= DOUBLE_DOT;

		} else if (	left_of_note &&							// located to the left of a note
					2 * s_h > s_w &&							// taller than it is wide
					s_h > round_u16(line_w) &&				// taller than line_w
					s_w > round_u16(0.3333F*line_w)			// decently wide
			){
			// accidental
			symbol->type		= ACCIDENTAL;
			symbol->accidental	= classify_accidental(symbol->image);

		} else if (	close_to_measure &&							// located near a measure
					s_h <= round_u16(line_w + 2.0F) &&			// not taller than line width
					s_w < round_u16(1.25F * line_spacing) &&	// not too wide
					black_percent > 0.5F						// img is mostly black
			) {		
			// repeat marker dot
			symbol->type	= REPEAT_DOT;

		} else if (	close_to_measure &&							// located near a measure
					s_h <= round_u16(2.0F*line_w + 2.0F) &&		// not taller than line width
					s_w < round_u16(1.25F * line_spacing) &&	// not too wide
					proj_y->data[s_h/2] == 0					// white gap in the middle
			) {		
			// repeat marker dot
			symbol->type	= REPEAT_DOT;

		} else if (	(below_note || above_note) &&			// located above or below a notehead
					s_h <= round_u16(line_w + 2.0F) &&		// not taller than line width
					s_w < round_u16(1.25F * line_spacing) &&	// not too wide
					black_percent > 0.5F					// img is mostly black
			) {		
			// staccato dot
			symbol->type	= STACCATO_DOT;

		} else if (	s_h > round_u16(2.0F * line_w) &&									// tall enough
					2 * s_h > 3 * s_w &&													// skinny
					s_w >= round_u16(0.3F * line_w) &&									// not too skinny
					s_top <= round_u16(staff->stafflines[1] - line_thickness) &&			// above 2nd staffline
					s_top >= round_u16(staff->stafflines[0] - 2.0F*line_thickness) &&		// below 1st staffline
					s_bot >= round_u16(staff->stafflines[3] - line_thickness) &&			// below 4th staffline
					s_bot <= round_u16(staff->stafflines[4] - line_thickness)				// above 5th staffline
			) {
			// quarter rest
			symbol->type		= REST_SYM;
			symbol->duration	= QUARTER;

		} else if (	s_h > round_u16(1.25F*line_w) &&										// tall enough
					2*s_h > 3*s_w &&														// skinny
					s_w >= round_u16(0.6F*line_w) &&										// not too skinny
					s_top >= round_u16(staff->stafflines[1] - 3.0F) &&					// below 2nd staffline
					s_bot <= round_u16(staff->stafflines[3] + 8.0F)						// above 4th staffline
			) {
			// eighth rest
			symbol->type		= REST_SYM;
			symbol->duration	= EIGHTH;

		} else {
			// 1/2 or full rest or whole note

			// figure out how many notes are in the measure that the symbol is
			notes_in_measure	= count_note_in_measure(notes, measures, s_midx);

			if (notes_in_measure == 0) {
				// either a whole note or whole rest

				if (		check_if_note_is_open(symbol->image) &&		// open like a hole note
							s_h > round_u16(0.8F*line_w) &&					// about a line_w tall
							s_h < round_u16(1.3F*line_w) &&
							s_w < round_u16(3.0F*line_w)						// not overly wide
					) {
					// whole note
					symbol->type		= NOTE_SYM;
					symbol->duration	= WHOLE;

				} else if (	s_top > round_u16(staff->stafflines[0]) &&																// between the correct staff lines
							s_bot < round_u16(staff->stafflines[3]) &&
							abs_16((int16_t) get_center_x_of_measure(measures, s_midx) - (int16_t) s_midx) < round_u16(2.0F*line_w) &&	// about in the middle of the staff
							s_w > line_w_u16																							// wide enough

					) {
					// whole rest
					symbol->type		= REST_SYM;
					symbol->duration	= WHOLE;
				}
			} else {
				// half rest possibly
				if (	s_top > round_u16(staff->stafflines[0]) &&										// below top staffline
						s_bot < round_u16(staff->stafflines[3]) &&										// above 4th staffline
						abs_16((s_top+s_bot+1)/2-round_u16(staff->stafflines[2])) < round_u16(line_w) &&	// center is near the 3rd staffline
			//			s_h > round_u16(1.25F*line_w) &&													// sufficiently tall
						s_w > round_u16(0.8F*line_w) &&													// width is sufficiently wide
						black_percent > 0.8F															// quite black
					) {
					// half rest
					symbol->type		= REST_SYM;
					symbol->duration	= HALF;
				}
			}
		}

		flex_array_delete(&proj_x);
		
	}
}

// takes in a pure white cropped image and tries to determine if it is
//	an accidental, and if so, which one
accidental_e classify_accidental (const image_t* img) {

	uint16_t		height;
	uint16_t		width;
	uint16_t 		thresh;
	uint16_t 		thickness;
	flex_array_t*	proj_x;
	flex_array_t*	proj_y_left;
	flex_array_t*	proj_y_right;
	uint16_t		peak1_x;
	uint16_t		peak2_x;
	uint16_t		peak1_y;
	uint16_t		peak2_y;
	int16_t			peak1_y_top, peak1_y_bot;
	int16_t			peak2_y_top, peak2_y_bot;
	uint16_t		dist_to_mid1;
	uint16_t		dist_to_mid2;
	uint16_t		peak1_x_begin;
	uint16_t		peak1_x_end;
	uint16_t		peak2_x_begin;
	uint16_t		peak2_x_end;
	uint16_t		left_peak_end;
	uint16_t		right_peak_begin;
	uint16_t		i;
	uint8_t			firstStop, secondStop;
	flex_array_t*   all_peaks;
	uint16_t* 		peak_begin_end;
	linked_list* 	groupings;
	uint8_t			sharp_flags;
	uint8_t			natural_flags;
	accidental_e	return_val;


	height		= img->height;
	width		= img->width;
	return_val	= NONE_AC;
	firstStop	= 0;
	secondStop	= 0;
	peak1_y		= 0;
	peak2_y		= 0;

	proj_x		= project_on_X(img);
	thresh		= (80 * max_u16((uint16_t) flex_array_max(proj_x), height/2)) / 100;
	all_peaks	= flex_array_find(proj_x, thresh, greater);
		
	if (all_peaks == NULL) {
		disco_log("Error in accidental land, couldn't find any peaks...\n");
		flex_array_delete(&proj_x);
		return NONE_AC;
	}

	groupings	= linked_list_group(all_peaks, 2);
	flex_array_delete(&all_peaks);

	if (groupings->length == 1) {
		// might be a FLAT

		peak_begin_end	= (uint16_t*) linked_list_pop_top(groupings);
		thickness		= peak_begin_end[1] - peak_begin_end[0];

		// check to make sure the peak isn't too wide and that it is situated in the left half of the image
		// make sure there is no gap in the image (it must be connected)
		if (thickness < width/2 && peak_begin_end[0] < width/3 && img->height > img->width) {
			if (flex_array_min(proj_x) > 0) {
				// definitely a flat
				return_val	= FLAT;
			} else {
				// could still be a flat
				// find the tops of the left and right halves of the image
				proj_y_left		= project_on_Y_partial(img, 0, img->width/2);
				proj_y_right	= project_on_Y_partial(img, img->width/2, img->width-1);
				for (i=0; i<img->height; i++) {
					if (!firstStop && proj_y_left->data[i] > 1) {
						peak1_y		= i;
						firstStop	= 1;
					}
					if (!secondStop && proj_y_right->data[i] > 1) {
						peak2_y		= i;
						secondStop	= 1;
					}
					if (firstStop && secondStop) break;
				}
				if (abs_16((int16_t) ((img->height-peak1_y) / 2) - (int16_t) (img->height - peak2_y)) < 4) {
					// the second peak is about half of the first
					return_val	= FLAT;
				}
				flex_array_delete(&proj_y_left);
				flex_array_delete(&proj_y_right);
			}
		}

		free(peak_begin_end);

	} else if (groupings->length == 2) {
		// must be SHARP or NATURAL

		// should be completely connected
		if (flex_array_min(proj_x) > 0) {

			// get information about peaks
			peak_begin_end	= (uint16_t*) linked_list_pop_top(groupings);
			peak1_x			= (peak_begin_end[0] + peak_begin_end[1] + 1) / 2;
			peak1_x_begin	= peak_begin_end[0];
			peak1_x_end		= peak_begin_end[1];
			free(peak_begin_end);

			peak_begin_end	= (uint16_t*) linked_list_pop_top(groupings);
			peak2_x			= (peak_begin_end[0] + peak_begin_end[1] + 1) / 2;
			peak2_x_begin	= peak_begin_end[0];
			peak2_x_end		= peak_begin_end[1];
			free(peak_begin_end);

			// sort peaks
			if (peak1_x < peak2_x) {
				// peak1 on left
				left_peak_end		= peak1_x_end;
				right_peak_begin	= peak2_x_begin;
			} else {
				left_peak_end		= peak2_x_end;
				right_peak_begin	= peak1_x_begin;
			}

			// first do another test for strictness
			// The peaks of a sharp or natural should be more or less centered around the middle
			dist_to_mid1	= abs_16((int16_t) width/2 - (int16_t) peak1_x);
			dist_to_mid2	= abs_16((int16_t) width/2 - (int16_t) peak2_x);

			if (abs_16((int16_t) dist_to_mid1 - (int16_t) dist_to_mid2) < 6) {

				// now find where two peaks begin vertically
				proj_y_left		= project_on_Y_partial(img, 0, left_peak_end);
				proj_y_right	= project_on_Y_partial(img, right_peak_begin, img->width-1);
				peak1_y_top		= -1;
				peak2_y_top		= -1;
				peak1_y_bot		= 0;
				peak2_y_bot		= 0;
				sharp_flags		= 0;
				natural_flags	= 0;	

				// get the top and bottom of the peaks
				for (i=0; i<img->height; i++) {
					if (proj_y_left->data[i] > 0) {
						if (peak1_y_top == -1)	peak1_y_top	= i;
						peak1_y_bot	= i;
					}
					if (proj_y_right->data[i] > 0) {
						if (peak2_y_top == -1)	peak2_y_top	= i;
						peak2_y_bot	= i;
					}
				}

				// A sharp's second peak should start about the same or slightly higher than
				//	the first. A natural's should start lower. Check the bottom too.

				// Check the tops. Look to see if there is a significant difference.
				if (peak2_y_top < peak1_y_top) {
					sharp_flags++;
				} else if (peak1_y_top + 2 < peak2_y_top) {
					natural_flags++;
				}

				// Check the bottoms.
				if (peak1_y_bot > peak2_y_bot) {
					sharp_flags++;
				} else if (peak2_y_bot - 2 > peak1_y_bot) {
					natural_flags++;
				}

				// Look at which is more likely
				if (sharp_flags > natural_flags) {
					return_val	= SHARP;
				} else if (natural_flags > sharp_flags) {
					return_val	= NATURAL;
				} else {
					// guess it's a sharp for now
					return_val	= SHARP;
				}

				flex_array_delete(&proj_y_left);
				flex_array_delete(&proj_y_right);
			}
		}
	}

	flex_array_delete(&proj_x);
	linked_list_delete(groupings);

	return return_val;
}
