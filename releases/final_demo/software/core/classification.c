#include "classification.h"
#include "global.h"
#include "image_functions.h"
#include "general_functions.h"
#include "linked_list.h"
#include <stdint.h>
#include "allocate.h"
#include "general_functions.h"
#include "vga.h"
#include "ssd.h"


uint8_t check_line_is_not_rest (const image16_t* img, const uint32_t *staff_lines, uint16_t topCut, uint16_t xbegin, const staff_info* staff) {
	// checks around middle of line to make sure it is 'flat'
	// takes in mini_img

	uint16_t height, width;
	uint16_t line_spacing, extend;

	height	= img->height;
	width	= img->width;

	// a rest should be below top staffline
	if (topCut < (staff_lines[0] - 2)) {
		return 0;
	}

	// a rest should be above last staffline
	if ((topCut + height) > staff_lines[4] + 1) {
		return 0;
	}

	line_spacing	= staff->spacing;
	extend			= (8*line_spacing + 2)/80;

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

uint8_t check_for_eighth_connector_on_top (image16_t* img, image16_t* temp_img, uint16_t xend, const staff_info *staff) {
	uint16_t		i;
	uint16_t		in_black;
	uint16_t		black_count;
	uint16_t		far_right_y_bound;
	uint16_t		left_y_bound;
	flex_array_t	*proj_x;


	// scan the right edge of the image looking for a run of black
	// if found this would be the end of eighth connector

	// run down the right side to half way looking for a black run
	// if none found, not an eighth note
	in_black	= 0;
	black_count	= 0;
	for (i=0; i<img->height/2; i++) {
		if (getPixel(img, img->width-1, i)) {
			in_black = 1;
			black_count++;
		} else {
			if (in_black) {
				// we hit white again, stop
				break;
			}
		}
	}
	far_right_y_bound = i - 1;

	// if there was no black on the far right side column, not
	// an eighth note. if the run was not >= 2*line thickness, not an eighth note
	if (!in_black || black_count < ((2*staff->thickness)>>4) || black_count<6) {
		return 0;
	}

	// now check closer to the note stem the same process as before
	// to determine which way the eighth connector is slanting
	in_black	= 0;
	for (i=0; i<img->height/2; i++) {
		if (getPixel(img, xend+2, i)) {
			in_black = 1;
		} else {
			if (in_black) {
				// we hit white again, stop
				break;
			}
		}
	}
	left_y_bound = i - 1;

	// get smaller image that should capture the eighth note connector
	get_sub_img(img, temp_img, -1, max_uint16(far_right_y_bound, left_y_bound), xend, img->width-1);

	proj_x = project_on_X(temp_img);

	// loop through y_proj and make sure that there is no gap in the possible eighth connector
	for (i=0; i<proj_x->length; i++) {
		if (proj_x->data[i] == 0) {
			// there is a gap, so there doesn't seem to be solid eighth connector
			return 0;
		}
	}

	// if we got here, we think its an eighth
	return 1;

}

uint8_t check_for_eighth_connector_on_bottom (image16_t* img, image16_t* temp_img, uint16_t xend, const staff_info *staff) {
	uint16_t		i;
	uint16_t		in_black;
	uint16_t		black_count;
	uint16_t		far_right_y_bound;
	uint16_t		left_y_bound;
	flex_array_t	*proj_x;


	// scan the right edge of the image looking for a run of black
	// if found this would be the end of eighth connector

	// run down the right side to half way looking for a black run
	// if none found, not an eighth note
	in_black	= 0;
	black_count	= 0;
	for (i=img->height-1; i>img->height/2; i--) {
		if (getPixel(img, img->width-1, i)) {
			in_black = 1;
			black_count++;
		} else {
			if (in_black) {
				// we hit white again, stop
				break;
			}
		}
	}
	far_right_y_bound = i + 1;

	// if there was no black on the far right side column, not
	// an eighth note. if the run was not >= 2*line thickness, not an eighth note
	if (!in_black || black_count < ((2*staff->thickness)>>4)) {
		return 0;
	}

	// now check closer to the note stem the same process as before
	// to determine which way the eighth connector is slanting
	in_black	= 0;
	for (i=img->height-1; i>img->height/2; i--) {
		if (getPixel(img, xend+2, i)) {
			in_black = 1;
		} else {
			if (in_black) {
				// we hit white again, stop
				break;
			}
		}
	}
	left_y_bound = i + 1;

	// get smaller image that should capture the eighth note connector
	get_sub_img(img, temp_img, min_uint16(far_right_y_bound, left_y_bound), -1, xend, img->width-1);

	proj_x = project_on_X(temp_img);

	// loop through y_proj and make sure that there is no gap in the possible eighth connector
	for (i=0; i<proj_x->length; i++) {
		if (proj_x->data[i] == 0) {
			// there is a gap, so there doesn't seem to be solid eighth connector
			return 0;
		}
	}

	// if we got here, we think its an eighth
	return 1;

}

uint8_t check_eighth_note (const image16_t* img, image16_t* temp_img, uint16_t xbegin) {
	// checks whether note is an eighth note

	uint16_t	height, width;
	uint16_t	start, flags;
	uint16_t	i, j;
	uint16_t	hitBlack, hitWhite;
	//image_t* test_img;


	height	= img->height;
	width	= img->width;

	// get some padding
	start = 0;
	if (xbegin-2 >= 0) {
		start = xbegin - 2;
	} else {
		if (xbegin-1 >= 0) {
			start = xbegin - 1;
		}
	}

	// below algorithm looks for white space in between stem and flag
	flags	= 0;
	for (i=0; i< height; i++){
		// states
		hitBlack = 0;
		hitWhite = 0;

		for (j=start; j<width-1; j++) {
			if (!hitBlack && getPixel(img, j, i)) {
				hitBlack = 1;
			} else if (hitBlack && !hitWhite && !(getPixel(img, j, i) || getPixel(img, j+1, i))) {
				hitWhite = 1;
			} else if (hitWhite && getPixel(img, j, i)) {
				flags++;
				break;
			}
		}
	}

	if (flags > height/3) {
		return 1;
	}

	return 0;
}

uint8_t is_note_open (const image16_t* img) {
	uint16_t	height, width;
	uint16_t	open_flags;
	uint16_t	run, row, col;
	uint8_t		blackFirst;
	uint8_t		thenWhite;
	uint8_t		anotherBlack;
	uint8_t		inBlack;

	height		= img->height;
	width		= img->width;
	open_flags	= 0;

	for (row=1; row<height-1; row++) {
		// States
		thenWhite		= 0;
		anotherBlack	= 0;
		inBlack			= getPixel(img, 0, row);
		blackFirst		= inBlack;
		run				= 1;
		for (col=1; col<width; col++) {
			// update runs
			if (!getPixel(img, col, row) && !inBlack) {
				//white continues
				run++;
			} else if (getPixel(img, col, row) && !inBlack){
				// white ends
				run		= 1;
				inBlack	= 1;
			} else if (!getPixel(img, col, row) && inBlack){
				// black ends
				run		= 1;
				inBlack	= 0;
			} else run++;

			// update state
			if (!blackFirst && run > 1 && inBlack) {
				blackFirst	= 1;
			} else if (!thenWhite && blackFirst && run > 0 && !inBlack) {
				thenWhite	= 1;
			} else if (!anotherBlack && thenWhite && run > 2 && inBlack) {
				open_flags++;
				break;
			}
		}
	}

	if (open_flags > 2) {
		return 1;
	}

	return 0;
}

// takes in the image after the notes have been found and vertical lines have been removed
void identify_note_pitches (const image16_t* img, staff_info* staff, uint32_t* stafflines, linked_list* notes) {
	/*% fills in .midi and .letter fields for note struct
	%
	% output is struct NOTE
	% notes.begin           - beginning of stem (left)
	% notes.end             - end of stem (right)
	% notes.position        - either 'left' or 'right' depending which side notehead is on
	% notes.center_of_mass  - y position of center of notehead
	% notes.top             - top of stem
	% notes.bottom          - bottom of stem
	% notes.eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
	% notes.midi            - midi number
	% notes.letter          - letter (ie 'G3') (not necessary for C)
	% notes.mod             - modifier (+1 for sharp, -1 for flat, 0 for
	%                         natural)
	*/

	uint32_t		line_thickness, line_spacing;
	uint32_t		*lines_spaces, *line_top, *line_bot;
	uint32_t		i, j;
	uint32_t		h, w;
	uint32_t		length_line_spaces;
	uint32_t		minDummy;
	uint32_t		closest;
	uint32_t		aboveLength, aboveLines_length, belowLines_length;
	uint32_t		*allMIDI;
	uint32_t		start;
	uint32_t		*temp;
	int32_t			line;
	stems_t			*tmp;
	uint16_t		MIDI, COM;
	uint16_t		*dif;
	linked_list		*aboveLines, *belowLines;
	uint16_t		trebleMIDI[16]	= {77,  76,  74,  72,  71,  69,  67,  65,  64,  62,  60,  59,  57,  55,  53,  52};
	uint16_t		aboveMIDI[11]	= {96,  95,  93,  91,  89,  88,  86,  84,  83,  81,  79};

	h	= img->height;
	w	= img->width;

	line_thickness	= (uint32_t) staff->thickness;
	line_spacing	= (uint32_t) staff->spacing;

	line		= (uint32_t) stafflines[0];
	line 		= line << 4;
	aboveLines	= linked_list_create();

	// SETUP OF LINE-HEIGHT INDICIES AND MIDI VALUES

	// set up indices for ledger lines above staff:
	for (i=0; i<5; i++) {
	    line = (int32_t) (line - line_spacing - line_thickness);
		if (line < 0) {
			// may go above image height:
			break;
	    }
		line_top	= malloc(sizeof(uint32_t));
		*line_top	= (line / 16);
		// add to linked list for ledge lines above staff:
		linked_list_push_top(aboveLines, line_top);
	}

	aboveLines_length	= aboveLines->length;
	aboveLength			= 2 * aboveLines->length;

	// set up indices for ledger lines below staff:
	belowLines	= linked_list_create();
	for (i=1; i<4; i++) {
		line		= stafflines[4] + (i*(line_spacing + line_thickness) + 8)/16;
		line_bot	= malloc(sizeof(uint32_t));
		*line_bot	= line;
		linked_list_push_bottom(belowLines, line_bot);
	}
	belowLines_length = belowLines->length;


	length_line_spaces	= 2*(aboveLines_length + 5 + belowLines_length);
	lines_spaces		= malloc(sizeof(uint32_t) * length_line_spaces);

	// fill in indices for whitespace between ledger lines above staff:
	for (i=0; i<aboveLines_length; i++) {
		temp				= linked_list_pop_top(aboveLines);
		lines_spaces[2*i]	= (uint32_t) *temp;
		lines_spaces[2*i+1]	= (uint32_t) (*temp + (line_spacing + line_thickness + 8 )/32);
		free(temp);
	}

	// fill in indices for whitespace between lines in staff
	for (i=0; i<5; i++) {
		if(i<4){
			lines_spaces[2*(i+aboveLines_length)]	= (uint32_t) stafflines[i];
			lines_spaces[2*(i+aboveLines_length)+1]	= (uint32_t) ((stafflines[i] + stafflines[i+1]+1)/2);
		}
		else{
			lines_spaces[2*(i+aboveLines_length)]	= (uint32_t) stafflines[i];
			lines_spaces[2*(i+aboveLines_length)+1]	= (uint32_t) (stafflines[i] + (line_spacing + line_thickness + 8)/32);
		}
	}

	// fill in indices for whitespace between ledger lines above staff:
	for (i=0; i<belowLines_length; i++) {
		temp										= linked_list_pop_top(belowLines);
		lines_spaces[2*(i+aboveLines_length+5)]		= (uint32_t) *temp;
		lines_spaces[2*(i+aboveLines_length+5)+1]	= (uint32_t) (*temp + (line_spacing + line_thickness + 8 )/32);
		free(temp);
	}


#ifdef DEBUG_ON

	// draw lines back on
	for (i=0; i<length_line_spaces; i++) {
		for (j=0; j<img->width; j++) {
			if (i & 0x1) {
				/*if (j & 0x1)  {
					setPixel(img, j, lines_spaces[i], 1);
				} else {
					setPixel(img, j, lines_spaces[i], 0);
				}*/
			} else {
				setPixel(img, j, lines_spaces[i], 1);
			}
		}
	}

	// draw stafflines back on
	for (i=0; i<5; i++) {
		for (j=0; j<img->width; j++) {
			if (j & 0x1)  {
				setPixel(img, j, stafflines[i], 1);
			} else {
				setPixel(img, j, stafflines[i], 0);
			}
		}
	}

	vga_draw_binary_img(img);
	WAIT_FOR_INTERRUPT;
	pan_image(img);
#endif


	// resetting midi values... it's a stupid algorithm
	if (aboveLength==0){
		allMIDI = malloc(sizeof(uint32_t) * 16);
	 	for (i=0; i<16; i++) {
			allMIDI[i] = trebleMIDI[i];
		}
	} else {
		start	= 11 - aboveLength;
		allMIDI	= malloc(sizeof(uint32_t) * (16 + 11 - start));

		for (i=start; i<11; i++) {
			allMIDI[i-start]	= aboveMIDI[i];
		}
		for (i=0; i<16; i++) {
			allMIDI[i+11-start]	= trebleMIDI[i];
		}
	}


	// SET MIDI VALUES OF NOTES BASED ON ABOVE SETUP

	dif = malloc(sizeof(uint32_t) * length_line_spaces);
	for (i=0; i<notes->length; i++) {
		tmp		= (stems_t*) linked_list_getIndexData(notes, i);
		COM		= tmp->center_of_mass;
		MIDI	= tmp->midi;

#ifdef DEBUG_ON
for (j=tmp->begin; j<tmp->end; j++) {
	setPixel(img, j, tmp->center_of_mass, 0);
}
#endif

		// look for closest index of line:
	    if (MIDI==0 && COM !=0) {
			for (j=0; j<length_line_spaces; j++) {
		    	dif[j] = abs_int32(lines_spaces[j] - COM); // value closest to zero will be where its located
			}

			minDummy	= dif[0];
			closest		= 0;
			for (j=1; j<length_line_spaces; j++) {
				if (dif[j] < minDummy) {
					minDummy	= dif[j];
					closest		= j;
				}
			}
		    // modify notes struct
		    tmp->midi =allMIDI[closest];

		}
	}

	free(dif);
	free(allMIDI);
	free(lines_spaces);
	linked_list_delete_list(aboveLines);
	linked_list_delete_list(belowLines);
}

void remove_notes_measures (image16_t* img, linked_list* stems, linked_list* measures_list, staff_info* staff, uint32_t* stafflines) {
	uint32_t		line_thickness, line_spacing, line_w;
	uint32_t		note_width;
	uint32_t		inEighth;
	uint32_t		i, j;
	uint32_t		h, w;
	int32_t			leftCut, rightCut, topCut, bottomCut;
	uint32_t		minVal, maxVal, leftVal, rightVal;
	uint32_t		cH, cW;
	stems_t			*currStem;
	measure_t		*currMeasure;


	h	= img->height;
	w	= img->width;

	line_thickness	= (uint32_t) staff->thickness;
	line_spacing	= (uint32_t) staff->spacing;
	line_w			= (uint32_t) (staff->thickness + staff->spacing)>>4;


	// remove last measure marker at the end of staff
	for (i=0; i<h; i++) {
		for (j=((w<<4)-3*line_spacing-16)>>4; j<w; j++) {
			setPixel(img, j, i, 0);
		}
	}

	// REMOVE STEMMED NOTES
	note_width	= (uint32_t) ((7*line_w+3)/5);
	minVal		= 0;
	maxVal		= 0;
	leftVal		= 0;
	rightVal	= 0;
	inEighth	= 0;

	for (i=0; i<stems->length; i++) {
		currStem = (stems_t*) linked_list_getIndexData(stems, i);

		// delete the note based on its orientation
		if (currStem->position_left == 1) {
			// note head on left
			leftCut		= currStem->begin - note_width;
			rightCut	= ((currStem->end<<4) + line_thickness)>>4;
			if (((int32_t) (currStem->top<<4) - (int32_t) line_thickness) < 0) {
				topCut	= 0;
			} else {
				topCut	= ((currStem->top<<4) - line_thickness)>>4;
			}
			bottomCut	= currStem->bottom + (uint32_t) ((3*line_spacing+16)/32);

			if (currStem->duration == EIGHTH && currStem->eighthSingle) {
				// this note is a single eighth note and we need to extend
				// the right cut to cut out the tail
				rightCut	+= ((note_width<<4) - line_thickness)>>4;
			}
		} else {
			if (((int32_t) (currStem->begin<<4) - (int32_t) line_thickness) < 0) {
				leftCut = 0;
			} else {
				leftCut		= ((currStem->begin<<4) - line_thickness)>>4;
			}
			rightCut	= currStem->end + note_width;
			topCut		= currStem->top - (uint32_t) ((3*line_spacing+16)/32);
			bottomCut	= ((currStem->bottom<<4) + line_thickness)>>4;
		}

		if (leftCut < 0)		leftCut		= 0;
		if (rightCut > w-1)		rightCut	= w-1;
		if (topCut < 0)			topCut		= 0;
		if (bottomCut > h-1)	bottomCut	= h-1;

		// white out the note
		for (cH=topCut; cH<=bottomCut; cH++) {
			for(cW=leftCut; cW<=rightCut; cW++) {
#ifdef DEBUG_ON
				if (cW == leftCut || cW==rightCut || cH==topCut || cH==bottomCut) {
					setPixel(img, cW, cH, 1);
				}
#endif
#ifndef DEBUG_ON
				setPixel(img, cW, cH, 0);
#endif
			}
		}

#ifdef ERASE_NOTES_REAL_TIME
vga_draw_binary_img(img);
#endif

#ifdef DEBUG_ON
		// draw center of mass
		for (cW=leftCut; cW<=rightCut; cW++) {
			setPixel(img, cW, currStem->center_of_mass, 0);
		}
#endif

		// check to see if its an eighth note, and really it it is a connected eighth note
		if (currStem->duration == EIGHTH) {

			if (!inEighth && currStem->eighthEnd) {
				// this is a single eighth note and we don't need to do
				// any of this

			} else if (!inEighth) {
				// we are at the start of eighth notes
				inEighth	= 1;

				// get the first set of values
				if (currStem->position_left == 1) {
					minVal	= currStem->top;
					maxVal	= currStem->top;
				} else {
					minVal	= currStem->bottom;
					maxVal	= currStem->bottom;
				}

				// save the left value at the beginning
				leftVal = currStem->begin - (uint32_t) ((line_w + 3)/6);

			} else if (currStem->eighthEnd) {
				// we are at the end of the connected eighth notes
				// if its the end of a series, delete the connector

				// get the corners of the connecting bar
				if (currStem->position_left == 1) {
					if (currStem->top < minVal) {
						minVal = currStem->top;
					}
					if (currStem->top > maxVal) {
						maxVal = currStem->top;
					}
				} else {
					if (currStem->bottom < minVal) {
						minVal = currStem->bottom;
					}
					if (currStem->bottom > maxVal) {
						maxVal = currStem->bottom;
					}
				}

				// cut out the bar
				rightVal	= currStem->end + (uint32_t) ((line_w + 3)/6);
				topCut		= minVal - line_w;
				bottomCut	= maxVal + line_w;

				if (leftVal < 0)  		leftVal		= 0;
				if (rightVal > w-1) 	rightVal	= w-1;
				if (topCut < 0) 		topCut		= 0;
				if (bottomCut > h-1)	bottomCut	= h-1;

				for (cH=topCut; cH<=bottomCut; cH++) {
					for(cW=leftVal; cW<=rightVal; cW++) {
#ifdef DEBUG_ON
						if (cW == leftVal || cW==rightVal || cH==topCut || cH==bottomCut) {
							setPixel(img, cW, cH, 1);
						}

#endif
#ifndef DEBUG_ON
						setPixel(img, cW, cH, 0);
#endif
					}
				}
				inEighth	= 0;
			}
		}
	}

	// REMOVE MEASURE LINES

	for (i=0; i<measures_list->length; i++) {
		currMeasure = (measure_t*) linked_list_getIndexData(measures_list, i);

		if ((uint32_t) (currMeasure->begin<<4) - (uint32_t) line_thickness < 0) {
			leftCut		= 0;
		} else {
			leftCut		= ((currMeasure->begin<<4) - line_thickness)>>4;
		}
		rightCut	= ((currMeasure->end<<4) + line_thickness)>>4;
		if ((uint32_t) stafflines[0] - (uint32_t) ((2*line_thickness)>>4) < 0) {
			topCut	= 0;
		} else {
			topCut	= (uint32_t) (stafflines[0] - ((2*line_thickness)>>4));
		}
		bottomCut	= (uint32_t) (stafflines[4] + ((2*line_thickness)>>4));

		if (leftCut < 0)  		leftCut		= 0;
		if (rightCut > w-1) 	rightCut	= w-1;
		if (topCut < 0) 		topCut		= 0;
		if (bottomCut > h-1)	bottomCut	= h-1;

		for (cH=topCut; cH<=bottomCut; cH++) {
			for (cW=leftCut; cW<=rightCut; cW++) {
#ifdef DEBUG_ON
				if (cW == leftVal || cW==rightVal || cH==topCut || cH==bottomCut ||
						cW == leftVal+1 || cW==rightVal-1 || cH==topCut+1 || cH==bottomCut-1
				) {
					setPixel(img, cW, cH, 1);
				}
#endif
#ifndef DEBUG_ON
				setPixel(img, cW, cH, 0);
#endif
			}
		}
	}

}

void update_notes_with_key_signature (linked_list* notes, staff_info *staff) {

	// TYPES are not correct
	int16_t i;
	int16_t accum, ind;
	int16_t	key_sig;

	int16_t note_lookup[12]={0};
	// A A# B C C# D D# E F F# G  G#
	// 0 1  2 3 4  5 6  7 8 9  10 11

	key_sig = staff->ks;

	// set up: set corresponding array values
	// to 1 for sharp and -1 for flat
	accum = 8;
	for (i = 0; i < key_sig; i++) {
		note_lookup[accum] = 1;
		accum = (accum + 7) % 12;
	}
	accum = 2;
	for (i = 0; i > key_sig; i--) {
		note_lookup[accum] = -1;
		accum = (accum + 5) % 12;
	}

	// set note mods to corresponding values:
	// ADJUST implementation for linked list...
	for (i = 0; i < notes->length; i++) {
        if (((stems_t*) linked_list_getIndexData(notes, i))->midi != 0){
           ind = ((((stems_t*) linked_list_getIndexData(notes, i))->midi) - 57) % 12;
           ((stems_t*) linked_list_getIndexData(notes, i))->mod = note_lookup[ind];
        }
	}

}


void classify_symbols (linked_list *symbols, linked_list *notes, linked_list *measures, staff_info* staff, image16_t *img, image16_t* temp_img, uint32_t* staff_lines) {
	/*classify all remaining symbols

	 symbols struct:
	   .top
	   .bot
	   .lef
	   .rig
	   .img
	   .class (-1 coming in)

	 CLASSES
	  0 - trash
	  1 - 1/4 rest (squiggly)
	  2 - wide things (ties)
	  3 - dot
	  4 - measure marker
	  5 - 1/2 rest (hat w/ company)
	  6 - full rest (lonely hat)
	  7 - sharp (#)
	  8 - flat (b)
	  9 - natural (box badly drawn)
	  10 - whole notes
	  11 - 1/8 rest*/

	symbol_t	*currSymbol;
	uint32_t	line_w, line_thickness, line_spacing;
	uint16_t	top, bot, lef, rig;
	uint16_t	ntop, nbot, nlef, nrig;
	uint16_t	sH, sW, i, mm;
	uint16_t	BWratio_num, BWratio_den;
	uint16_t	rightOfNote, leftOfNote;
	uint16_t	note;
	uint16_t	vertClose, horClose;
	uint16_t	leftMM, rightMM;
	uint16_t	notesInMeasure;
	uint16_t	midOfMeasure;
	uint16_t	midOfSym;
	stems_t		*currNote;
	measure_t	*currMeasure;
	measure_t	*leftMMmeasure, *rightMMmeasure;

	line_thickness	= staff->thickness;
	line_spacing	= staff->spacing;
	line_w			= ((2*staff->thickness) + staff->spacing)>>4;

	midOfMeasure	= 0;
	midOfSym		= 0;

	for (i=0; i<symbols->length; i++){
		currSymbol = (symbol_t*) linked_list_getIndexData(symbols, i);

		top = currSymbol->top;
		bot = currSymbol->bottom;
		lef = currSymbol->left;
		rig = currSymbol->right;

		sH = currSymbol->height;
		sW = currSymbol->width;

		BWratio_num	= currSymbol->NumBlack;
		BWratio_den	= (sH*sW - currSymbol->NumBlack + 1);

		rightOfNote	= 0;
		leftOfNote	= 0;

		// get the image of the symbol, only used sometimes
		get_sub_img(img, temp_img, currSymbol->top, currSymbol->bottom, currSymbol->left, currSymbol->right);

		for (note=0; note<notes->length; note++) {
			// check for closeness of symbol to notes
			currNote = (stems_t*) linked_list_getIndexData(notes, note);

			ntop	= currNote->top;
			nbot	= currNote->bottom;
			nlef	= currNote->begin;
			nrig	= currNote->end;

			// check to right of note
			vertClose	= 0;
			horClose	= 0;
			if (currNote->position_left) {
				if (abs_int16((top+bot+1)/2-nbot) < (4*(nbot-ntop) + 5)/10 && (nbot-top + line_w/2) > 0)	vertClose	= 1;
				if ((lef-nrig) > 0 && (lef-nrig) < line_w)	horClose	= 1;
			} else {
				if (abs_int16((top+bot+1)/2 - ntop) < (4*(nbot - ntop) + 5)/10 && (bot - ntop + (line_w+1)/2) > 0) vertClose	= 1;
				if ((lef-nrig) > 0 && (lef-nrig) < (5*line_w + 1)/2) horClose	= 1;
			}
			if (vertClose && horClose) {
				rightOfNote = 1;
			}

			// check to left of a note
			vertClose	= 0;
			horClose	= 0;
			if (currNote->position_left) {
				if (abs_int16((top+bot+1)/2 - nbot) < (3*(nbot - ntop + 1 + 5))/10 && (nbot - top -1) > 0) vertClose	= 1;
				if ((rig-nlef) <= 0 && (nlef - rig) < (5*line_w + 1)/2) horClose	= 1;
			} else {
				if (abs_int16((top+bot+1)/2 - ntop) < (3*(nbot - ntop + 1) + 5)/10 && (bot - ntop -1) > 0) vertClose	= 1;
				if ((rig-nlef) <=0 && (nlef - rig) < line_w) horClose	= 1;
			}
			if (vertClose && horClose) {
				leftOfNote = 1;
			}
		}

		// get the image of the symbol, only used sometimes
	//	get_sub_img(img, temp_img, currSymbol->top, currSymbol->bottom, currSymbol->left, currSymbol->right);

		// if symbol is directly to right of a note
		if (rightOfNote && 2*sH > sW && sH <= (line_w + 5) && sW < ((3*line_spacing+1)/2)>>4) {
			// dot
			currSymbol->type = DOT;

		// if symbol is directly to the left of a note
		} else if (leftOfNote && 2*sH > sW && sH > line_w && sW > (line_w + 2)/3) {
			// accidental found
			currSymbol->type = classify_accidental(temp_img);

		} else {
			// symbol is not near a note
			// some sort of other symbol  (whole notes, 1/4 rest, 1/2 rest, full rest, eighth rest(?))

			// check if it is tall and skinny and in the right portion of the staff for a quarter note
			// make sure it is above and below the proper staff lines
			if (	sH > 2*line_w &&
					2*sH > 3*sW &&
					top <= (((staff_lines[1]<<4)-line_thickness)>>4) &&
					top >= (((staff_lines[0]<<4)-(line_thickness*2))>>4) &&
					bot >= (((staff_lines[3]<<4)-line_thickness)>>4)
				) 
			{
				// squiggly
				// quarter rest
				currSymbol->type = QUARTER_REST;

			} else if (	sH > (5*line_w + 3)/4		&&
						2*sH > 3*sW					&&
						top >= staff_lines[1] - 3	&&
						bot <= staff_lines[3] + 8
					  )
			{
				// eighth rest
				currSymbol->type = EIGHTH_REST;

			} else {
				// 1/2 or full rest or whole note

				// find left & right measure markers
				leftMM	= 0;
				rightMM	= 0;
				for (mm = 0; mm<measures->length; mm++) {
					currMeasure = (measure_t*) linked_list_getIndexData(measures, mm);

					if (currMeasure->begin < lef){
						leftMM = mm;
					}
					if (rightMM==0 && currMeasure->end > rig){
						rightMM = mm;
					}
				}

				// count how many notes found within current measure
				notesInMeasure	= 0;
				leftMMmeasure	= (measure_t*) linked_list_getIndexData(measures, leftMM);
				rightMMmeasure	= (measure_t*) linked_list_getIndexData(measures, rightMM);

				for (note=0; note<notes->length; note++) {
					currNote = (stems_t*) linked_list_getIndexData(notes, note);

					if (currNote->end > leftMMmeasure->begin && currNote->begin < rightMMmeasure->end) {
						notesInMeasure = notesInMeasure + 1;
					}
				}

				if (notesInMeasure == 0) {

					// either a whole note or whole rest

					if (is_note_open(temp_img) == 1 && sH > (8*line_w + 5)/10 && sH < (13*line_w + 5)/10 && sW < 3*line_w) {
						// whole note found
						currSymbol->type = WHOLE_NOTE;

					} else {
						if (top > staff_lines[0] && bot < staff_lines[3]) {
							// within staff lines
							midOfMeasure	= (leftMMmeasure->begin + rightMMmeasure->begin + 1)/2;
							midOfSym		= (lef + rig + 1)/2;
						}
						if (abs_int16(midOfMeasure - midOfSym) < 2*line_w && sW > line_w) {
							// in middle of measures
							// whole rest found
							currSymbol->type	= FULL_REST;
						}
					}
				} else {
					// half or eighth(?) rest
					if (top > staff_lines[0] && bot < staff_lines[3] &&
						abs_int16((top+bot+1)/2-staff_lines[2]) < line_w && sW > (8*line_w + 5)/10){
						// within middle of staff
						if (BWratio_num > BWratio_den){
							// half rest found
							currSymbol->type = HALF_REST;
						} else {
							// eighth rest found
							currSymbol->type = EIGHTH_REST;
						}
					}
				}

			} // end else 1/2 or full rest or whole note

		} // end else other symbol

	}
}

symbol_type classify_accidental (image16_t* img) {
	// classifies accidentals

	uint16_t		height;
	uint16_t		width;
	uint16_t 		thresh;
	uint16_t 		thickness;
	projection_t*	proj_x;
	uint16_t		firstPeakLoc, secondPeakLoc;
	uint16_t		firstPeakY, secondPeakY;
	uint16_t		i;
	uint8_t			firstStop, secondStop;
	flex_array_t*   all_peaks;
	uint16_t* 		peak_begin_end;
	linked_list* 	groupings;


	height	= img->height;
	width	= img->width;

	firstPeakY	= 0;
	secondPeakY	= 0;

	proj_x	= project_on_X(img);
	thresh = (80 * flex_array_max(proj_x)) / 100;

	all_peaks = flex_array_find(proj_x, thresh, greater);
	flex_array_delete(proj_x);

	groupings	= linked_list_group (all_peaks, 3);
	flex_array_delete(all_peaks);

	if(groupings->length == 1) {
		// must be a FLAT
		peak_begin_end = linked_list_pop_top(groupings);
		thickness = peak_begin_end[1] - peak_begin_end[0];
		free(peak_begin_end);

		linked_list_delete_list(groupings);

		if (thickness < width/2)
			return FLAT;
		else
			return SHARP;

	} else if (groupings->length == 2) {
		// must be sharp or natural

		peak_begin_end = linked_list_pop_top(groupings);
		firstPeakLoc = (peak_begin_end[0] + peak_begin_end[1] + 1) / 2;

		free(peak_begin_end);

		peak_begin_end = linked_list_pop_top(groupings);
		secondPeakLoc = (peak_begin_end[0] + peak_begin_end[1] + 1) / 2;

		free(peak_begin_end);

		linked_list_delete_list(groupings);

		// now find where two peaks begin vertically
		firstStop	= 0;
		secondStop	= 0;
		for (i=0; i<height; i++) {
			if (firstStop == 0 && getPixel(img, firstPeakLoc, i) == 1) {
				firstPeakY	= i;
				firstStop	= 1;
			}
			if (secondStop == 0 && getPixel(img, secondPeakLoc, i) == 1) {
				secondPeakY	= i;
				secondStop	= 1;
			}
			if (firstStop == 1 && secondStop == 1) break;
		}

		// sharp's second peak should start about the same or slightly higher than
		// the first. A natural's should start lower.
		if (firstPeakLoc < secondPeakLoc) {
			if (secondPeakY <= firstPeakY+2) {
				return SHARP;
			} else {
				return NATURAL;
			}
		}
		if (firstPeakY <= secondPeakY+2) {
			return SHARP;
		}

		return NATURAL;
	} else {
		// we found more than two peaks, let's throw this out
		linked_list_delete_list(groupings);

		return TRASH;
	}

}

void contextualizer_other(linked_list* notes, linked_list* measures, linked_list* symbols) {
    /* make modification to notes based on classification of accidentals and
    % dots
    %
    % input structs:
    %%% symbols struct:
    %   .top
    %   .bot
    %   .lef
    %   .rig
    %   .img
    %   .class (-1 coming in)
    %
    % CLASSES
    %  0 - trash
    %  1 - 1/4 rest (squiggly)
    %  2 - wide things (ties)
    %  3 - dot
    %  4 - measure marker
    %  5 - 1/2 rest (hat w/ company)
    %  6 - full rest (lonely hat)
    %  7 - sharp (#)
    %  8 - flat (b)
    %  9 - natural (box badly drawn)
    %  10 - whole notes
    %  11 - 1/8 rest
    %
    %%% notes struct:
    %  .begin           - beginning of stem (left)
    %  .end             - end of stem (right)
    %  .position        - either 'left' or 'right' depending which side notehead_img is on
    %  .center_of_mass  - y position of center of notehead_img
    %  .top             - top of stem
    %  .bottom          - bottom of stem
    %  .dur             - duration of note in beats (0.5,1,2,4 etc)
    %  .eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
    %  .midi            - midi number (field modified later)
    %  .letter          - letter (ie 'G3') (not necessary for C)
    %  .mod             - modifier (+1 for sharp, -1 for flat, 0 for natural)*/

    int16_t		i, n;
    int16_t		mod;
    symbol_t*	current_symbol;
    int16_t		note_num;
    int16_t		rightMM;
    int16_t		midi_to_mod;

	while (!linked_list_is_empty(symbols)) {
		current_symbol = linked_list_pop_top(symbols);

		switch (current_symbol->type) {
			case DOT: // dot
				// find the note it belongs to
				for (n=1; n<notes->length; n++) {
					if ((((stems_t*) linked_list_getIndexData(notes, n))->end - current_symbol->right) > 0) {
						break;
					}
				}
				note_num = n - 1;

				//increase duration of dot
		// We're not going to handle dotted eighth notes. This takes care of some errors with
		// floating black dots getting assigned to eighth notes
		//		if (((stems_t*) linked_list_getIndexData(notes, note_num))->duration == EIGHTH) {
		//			((stems_t*) linked_list_getIndexData(notes, note_num))->duration = EIGHTH_DOT;
		//		} else
				if (((stems_t*) linked_list_getIndexData(notes, note_num))->duration == QUARTER) {
					((stems_t*) linked_list_getIndexData(notes, note_num))->duration = QUARTER_DOT;
				} else if (((stems_t*) linked_list_getIndexData(notes, note_num))->duration == HALF) {
					((stems_t*) linked_list_getIndexData(notes,note_num))->duration = HALF_DOT;
				}
				break;


			case SHARP: // accidentals
			case FLAT:
			case NATURAL:
				if (current_symbol->type == SHARP)		mod = 1;
				else if (current_symbol->type == FLAT)	mod = -1;
				else									mod = 0;

				// find closest note on right
				note_num = notes->length-1;
				for (n=notes->length-3; n>=0; n--) {
					if ((current_symbol->left - ((stems_t*) linked_list_getIndexData(notes, n))->begin) > 0) {
						break;
					}
				}
				note_num = n + 1;

				// find first measure marker to right of accidental
				for (n=measures->length-2; n>=0; n--) {
					if (current_symbol->right > (((measure_t*) linked_list_getIndexData(measures, n))->end)) {
						break;
					}
				}
				rightMM = n + 1;

				// loop thru notes again, modify all notes within measure with
				// same pitch as accidental's partner note
				midi_to_mod = ((stems_t*) linked_list_getIndexData(notes, note_num))->midi;

				if (midi_to_mod != 0) {
					for (n=0; n<notes->length; n++) {
						if (	((stems_t*) linked_list_getIndexData(notes, n))->end > current_symbol->left &&
								((stems_t*) linked_list_getIndexData(notes,n))->begin < ((measure_t*) linked_list_getIndexData(measures, rightMM))->end
							) {

							if (((stems_t*) linked_list_getIndexData(notes, n))->midi == midi_to_mod) {
								(((stems_t*) linked_list_getIndexData(notes,n))->mod) = mod;

							}
						}
					}
				}
				break;
			default:
				break;
		}

		free(current_symbol);

	}
}


uint16_t contextualizer_notes_rests(linked_list *notes, linked_list *symbols) {
    /* make modification to notes based on classification of whole notes and
    % rests
    %
    % input structs:
    %%% symbols struct:
    %   .top
    %   .bot
    %   .lef
    %   .rig
    %   .img
    %   .class (-1 coming in)
    %
    % CLASSES
    %  0 - trash
    %  1 - 1/4 rest (squiggly)
    %  2 - wide things (ties)
    %  3 - dot
    %  4 - measure marker
    %  5 - 1/2 rest (hat w/ company)
    %  6 - full rest (lonely hat)
    %  7 - sharp (#)
    %  8 - flat (b)
    %  9 - natural (box badly drawn)
    %  10 - whole notes
    %  11 - 1/8 rest
    %
    %%% notes struct:
    %  .begin           - beginning of stem (left)
    %  .end             - end of stem (right)
    %  .position        - either 'left' or 'right' depending which side notehead_img is on
    %  .center_of_mass  - y position of center of notehead_img
    %  .top             - top of stem
    %  .bottom          - bottom of stem
    %  .dur             - duration of note in beats (0.5,1,2,4 etc)
    %  .eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
    %  .midi            - midi number (field modified later)
    %  .letter          - letter (ie 'G3') (not necessary for C)
    %  .mod             - modifier (+1 for sharp, -1 for flat, 0 for natural)
    */

	symbol_t*		current_symbol;
	stems_t*		whole_note_struct;
	stems_t*		rest_struct;
	int16_t			note_num;
	int16_t			n;
	note_duration	duration;
	int16_t			i;

	uint16_t wholeFound = 0;
	for (i=0; i<symbols->length; i++) {
		// loop through all of the symbols looking for notes and rests

		current_symbol = (symbol_t*) linked_list_getIndexData(symbols, i);

		switch (current_symbol->type) {

			case WHOLE_NOTE: // whole note
				wholeFound = 1;
				whole_note_struct					= malloc(sizeof(stems_t));
				whole_note_struct->begin			= current_symbol->left;
				whole_note_struct->end				= current_symbol->right;
				whole_note_struct->center_of_mass	= (current_symbol->top +current_symbol->bottom + 1)/2;
				whole_note_struct->top				= current_symbol->top;
				whole_note_struct->bottom			= current_symbol->bottom;
				whole_note_struct->duration			= WHOLE;
				whole_note_struct->eighthEnd		= 0;
				whole_note_struct->midi				= 0;
				whole_note_struct->mod				= 0;
				whole_note_struct->position_left	= 0;

				// find closest note to the left
				for (n=0; n<notes->length; n++) { // find closest note to the left of the dot
					if ((((stems_t*) linked_list_getIndexData(notes, n))->end - current_symbol->right) > 0) {
						break; // note is to the right
					}
				}
				note_num = n - 1;

				// insert whole note into notes struct array at correct location
				if (note_num == -1)	linked_list_push_top(notes, whole_note_struct);
				else				linked_list_insert_before_index(notes, note_num+1, whole_note_struct);
				linked_list_deleteIndexData(symbols, i);
				i--;

				break;
			case QUARTER_REST:
			case HALF_REST:
			case FULL_REST:
			case EIGHTH_REST:
				// rest found
				if (current_symbol->type == EIGHTH_REST)		duration = EIGHTH;
				else if (current_symbol->type == QUARTER_REST)	duration = QUARTER;
				else if (current_symbol->type == HALF_REST)		duration = HALF;
				else											duration = WHOLE;

				rest_struct					= malloc(sizeof(stems_t));
				rest_struct->begin			= current_symbol->left;
				rest_struct->end			= current_symbol->right;
				rest_struct->center_of_mass	= 0;
				rest_struct->top			= current_symbol->top;
				rest_struct->bottom			= current_symbol->bottom;
				rest_struct->duration		= duration;
				rest_struct->eighthEnd		= 0;
				rest_struct->eighthSingle	= 0;
				rest_struct->midi			= 0xF000;
				rest_struct->mod			= 0;
				rest_struct->position_left	= 0;

				// find closest note to the left
				for (n=0; n<notes->length; n++){ // find closest note to the left of the dot
					if ((((stems_t*) linked_list_getIndexData(notes, n))->end - current_symbol->right) > 0) {
						break; // note is to the right
					}
				}
				note_num = n - 1;

				// insert rest into notes struct array at correct location
				if (note_num == -1)	linked_list_push_top(notes,rest_struct);
				else				linked_list_insert_before_index(notes, note_num+1, rest_struct);

				linked_list_deleteIndexData(symbols, i);
				i--;
				break;
		}
	}
	return wholeFound;
}
