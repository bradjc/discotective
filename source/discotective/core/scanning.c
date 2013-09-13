#include "scanning.h"
#include "segmentation.h"
#include "global.h"
#include <stdint.h>
#include "linked_list.h"
#include "flex_array.h"
#include "image_functions.h"
#include "general_functions.h"
#include <stdlib.h>
#include "platform_specific.h"


//  finds all stemmed notes and measure markers
void parse_notes_with_lines (image_t* img, const staff_t* staff, linked_list* notes, linked_list* measures) {
	float			line_thickness;
	float			line_spacing;
	uint16_t		h, w;
	uint16_t		extend;
	linked_list*	good_lines			= NULL;
	flex_array_t*	staff_proj_x		= NULL;

	image_t*		note_img			= NULL;
	uint16_t		i;
	line_t*			line				= NULL;
	note_t*			prev_note			= NULL;
	uint16_t		xbegin;
	uint16_t		xend;
	uint16_t		xbegin_next_stem;
	uint16_t		top, bottom;
	uint16_t		line_height;
	uint16_t		xbeginN;
	uint16_t		xendN;
	note_cuts_t		note_cuts;
	flex_array_t*	note_proj_x			= NULL;
	flex_array_t*	note_proj_y			= NULL;
	flex_array_t*	notehead_proj_y		= NULL;

	measure_t*		measure;

	note_t*			note				= NULL;
	uint16_t		top_weight;
	uint16_t		bottom_weight;

	image_t*		tooclose_check_img	= NULL;
	accidental_e	accidental_check;

	uint8_t 		beam_on_bottom;
	uint8_t			beam_on_top;
	uint8_t			double_beam;
	int16_t 		notehead_bottom_index;
	int16_t			notehead_left_index;
	int16_t			notehead_right_index;
	int16_t			notehead_top_index;

	image_t*		notehead_img		= NULL;
	uint16_t		notehead_com;
	uint16_t		notehead_thrsh;
	uint16_t		notehead_max;
	flex_array_t	*notehead_indices	= NULL;



	line_thickness	= staff->line_thickness;
	line_spacing	= staff->line_spacing;

	h = img->height;
	w = img->width;

	// get a full x projection
	staff_proj_x	= project_on_X(img);

	// find vertical lines
	good_lines	= find_all_vertical_lines(img, (68*staff->height)/100);

	// the maximum amount to look left and right from the stem for a note
	extend = round_u16(1.4F * (line_thickness + line_spacing));


	// loop through all found vertical lines
	while (!linked_list_is_empty(good_lines)) {

		line	= (line_t*) linked_list_pop_top(good_lines);

		// set up a lot of useful variables
		xbegin		= line->left;
		xend		= line->right;
		top			= line->top;
		bottom		= line->bottom;
		line_height	= bottom - top + 1;

		// get the note image
		note_img	= note_cutout(img, top, bottom, xbegin, xend, staff, &note_cuts);
#ifdef DEBUG_FIND_STEMMED_NOTES
binary_image_display(note_img);
#endif

		// setup more variables
		// offsets into the mini image of just the note
		xbeginN	= xbegin - note_cuts.left_cut;
		xendN	= xend - note_cuts.left_cut;

		// next line information
		xbegin_next_stem	= UINT16_MAX;
		if (!linked_list_is_empty(good_lines)) {
			xbegin_next_stem	= ((line_t*) linked_list_getIndexData(good_lines, 0))->left;
			// check to see if the next stem is actually a part of the next note
	//		if (xbegin_next_stem - xend < MIN_SPACE_BETWEEN_STEMS) {
				// good chance the next thing is part of the single eighth note
	//			if (good_lines->length >= 2) {
	//				xbegin_next_stem	= ((line_t*) linked_list_getIndexData(good_lines, 1))->left;
	//			}
	//		}
		}

		// Previous note information
		if (!linked_list_is_empty(notes)) {
			prev_note	= (note_t*) linked_list_getIndexData(notes, notes->length-1);
		} else {
			// this is the first note, so just create a dummy one
			prev_note	= (note_t*) malloc(sizeof(note_t));
			prev_note->begin				= 0;
			prev_note->end					= 0;
			prev_note->top					= 0;
			prev_note->bottom				= 0;
			prev_note->duration				= UNKNOWN_DUR;
			prev_note->notehead_position	= UNKNOWN_POS;
			prev_note->connected_type		= UNKNOWN_CONN;
		}

		// get projections
		note_proj_x	= project_on_X(note_img);
		note_proj_y	= project_on_Y(note_img);

		// start the checking!

		// Check to see if the note is just too tall. Probably not the best thing
		//	to do, but I need it to fix when pre processing fails.
		if (line_height > (7*staff->height)/4) {
			goto parse_notes_with_lines_LINE_CLEANUP;
		}

		// Check to see if this line is too close to a single eighth note.
		// The tail of a right facing single eighth note can be picked up as a verical line.
		if (	prev_note->duration == EIGHTH &&
				prev_note->connected_type == SINGLE &&
				prev_note->notehead_position == RIGHT &&
				xbegin - prev_note->end < MIN_SPACE_BETWEEN_STEMS
			) {
			// yep we just found part of the previous eighth note
			goto parse_notes_with_lines_LINE_CLEANUP;
		}

		// Check for measure marker
		measure = check_if_measure_line(note_img, staff, measures, xbegin, xend, note_cuts.left_cut);
		if (measure == NULL) {
			// not a measure marker, probably a note or something
		} else if (measure == (measure_t*) 0x1) {
			// is a measure marker, but is too close to a previous measure marker
			goto parse_notes_with_lines_LINE_CLEANUP;
		} else {
			// we found a measure marker!
			linked_list_push_bottom(measures, (void**) &measure);
			goto parse_notes_with_lines_LINE_CLEANUP;
		}

		// Check to see if it is a quarter rest
		if (check_if_rest(note_img, staff, note_cuts.top_cut, (xendN+xbeginN)/2)) {
			// skip if rest
			goto parse_notes_with_lines_LINE_CLEANUP;
		}

		// Check to see if it is too close to the next line
		// If so, I know of two things it could be:
		//	- an accidental
		//	- a measure line
		if (xbegin_next_stem - xend < (MIN_SPACE_BETWEEN_STEMS + 15)) {

			// get an image of just current symbol
			tooclose_check_img	= binary_image_create(note_img->height, note_img->width);
			binary_image_whiteout(tooclose_check_img);

			for (i=top-note_cuts.top_cut; i<bottom-note_cuts.top_cut; i+=5) {
				if (getPixel(note_img, xbeginN, i)) {
					blob_copy(note_img, tooclose_check_img, xbeginN, i, 0, 0);
				}
			}

			pure_white_crop(&tooclose_check_img);

#ifdef DEBUG_FIND_STEMMED_NOTES
binary_image_display(tooclose_check_img);
#endif

			// determine what it is
			
			// check to see if it is an accidental
			accidental_check = classify_accidental(tooclose_check_img);
			if (accidental_check == SHARP || accidental_check == NATURAL) {
				// skip this accidental
				goto parse_notes_with_lines_LINE_CLEANUP;
			}

			// check to see if it is a measure marker
			measure = check_if_measure_line(tooclose_check_img, staff, measures, xbegin, xend, note_cuts.left_cut);
			if (measure != NULL && measure != (measure_t*) 0x1) {
				// we found a measure marker!
				linked_list_push_bottom(measures, (void**) &measure);
				goto parse_notes_with_lines_LINE_CLEANUP;
			}
		}

		// check to see if it is thick enough to even possibly be a note
		if (note_img->width < MIN_NOTE_WIDTH) {
			goto parse_notes_with_lines_LINE_CLEANUP;
		}


		// At this point it seems to be a note

		note					= (note_t*) malloc(sizeof(note_t));
		note->connected_type	= UNKNOWN_CONN;
		note->duration			= UNKNOWN_DUR;
		note->notehead_position	= UNKNOWN_POS;
		note->begin				= xbegin;
		note->end				= xend;
		note->top				= top;
		note->bottom			= bottom;
		note->midi				= 0;
		note->accidental		= NONE_AC;
		note->articulation		= NONE_AR;

		// Check for connected notes

		// Check for beams on the top and bottom
		beam_on_top		= check_for_beam_on_top(note_img, staff, xendN);
		beam_on_bottom	= check_for_beam_on_bottom(note_img, staff, xendN);

		// If beam_on_bottom is true, beam_on_top cannot be true because of the
		//	way noteheads are oriented relative to the beam.
		// If there is no room for a notehead to the left, beam_on_top cannot be true
		if (beam_on_bottom || xbeginN < MIN_NOTEHEAD_WIDTH) {
			beam_on_top = 0;
		}

		// Do the main check to make sure there is black in the vertical direction
		//	from the current stem to the next stem.
		if (beam_on_top || beam_on_bottom) {
			if (!linked_list_is_empty(good_lines)) {

				// Scan right making sure there is a beam all the way to the next note
				for (i=xend; i<=xbegin_next_stem; i++) {
					if (staff_proj_x->data[i] < MIN_EIGHTH_CONN_THICKNESS) {
						beam_on_top		= 0;
						beam_on_bottom	= 0;
						break;
					}
				}

			} else {
				// There are no more vertical lines
				// Therefore this cannot be connected to a note on the right
				beam_on_top		= 0;
				beam_on_bottom	= 0;
			}
		}

		if (beam_on_top || beam_on_bottom || prev_note->connected_type == START || prev_note->connected_type == MIDDLE) {
			// This is a connected note

			// check the duration of the note (either 8th or 16th note)
			// check the orientation
			if (prev_note->connected_type != START && prev_note->connected_type != MIDDLE) {
				// this is the first note in the run
				// therefore if there is a double beam it can only be on the right
				double_beam				= check_for_double_beam_right(note_img, staff, xbeginN, xendN, beam_on_top);
				note->connected_type	= START;

			} else if (beam_on_top || beam_on_bottom) {
				// this is a middle note in the connected run
				// double beam could be on either side
				double_beam				= check_for_double_beam_both(note_img, staff, xbeginN, xendN, beam_on_top);
				note->connected_type	= MIDDLE;

			} else {
				// this is the last note in a connected run
				// double beam can only be on left
				double_beam				= check_for_double_beam_left(note_img, staff, xbeginN, xendN, (prev_note->notehead_position==LEFT));
				note->connected_type	= END;
			}

			// set note duration
			if (double_beam) {
				note->duration	= SIXTEENTH;
			} else {
				note->duration	= EIGHTH;
			}

			// set where the note head is relative to the line
			if (beam_on_top) {
				note->notehead_position	= LEFT;
			} else if (beam_on_bottom) {
				note->notehead_position	= RIGHT;
			} else {
				// the previous note was a connected eighth note but this one doesn't
				// have a connector going to the right
				note->notehead_position	= prev_note->notehead_position;
			}

		} else {
			// this note is not connected
			note->connected_type	= SINGLE;
		}

		// Check to see if this is a single note
		if (note->connected_type == SINGLE) {
			// Need to determine which way it faces

			// Determine if note is pointing up or pointing down based on the
			//	relative amount of black on the top and bottom.
			top_weight		= 0;
			bottom_weight	= 0;
			for (i=0; i<note_img->height/2; i++) {
				top_weight		+= note_proj_y->data[i];
				bottom_weight	+= note_proj_y->data[note_img->height-1-i];
			}
			if (bottom_weight > top_weight) {
				// stem is above the note
				note->notehead_position	= LEFT;
			} else {
				// stem is below the note
				note->notehead_position	= RIGHT;
			}

		}

		// Isolate the notehead to find the center of mass of the notehead and
		//	duration if not already known.

		// Set up the bounds
		if (note->notehead_position	== LEFT) {
		//	notehead_top_index		= (3*note_img->height) / 5;
		//	notehead_bottom_index	= -1;
			notehead_bottom_index	= -1;
			notehead_top_index		= (bottom - note_cuts.top_cut) - (2*note_img->height) / 5;
			notehead_left_index		= 0;
			notehead_right_index	= xendN;
		} else {
		//	notehead_top_index		= 0;
		//	notehead_bottom_index	= (2*note_img->height) / 5;
			notehead_top_index		= 0;
			notehead_bottom_index	= (2*note_img->height) / 5 + (top - note_cuts.top_cut);
			notehead_left_index		= xbeginN;
			notehead_right_index	= -1;
		}

		// Get the notehead image
		notehead_img	= get_sub_img(note_img, notehead_top_index, notehead_bottom_index, notehead_left_index, notehead_right_index);
		notehead_proj_y	= project_on_Y(notehead_img);
		notehead_max	= flex_array_max(notehead_proj_y);

		// Check to see if we know the duration of the note
		if (note->duration == UNKNOWN_DUR) {
			// Determine the duration of the note

			// check if it is a single eighth note
			if (check_if_single_eighth_note(note_img, xbeginN, note->notehead_position)) {
				// note is single eighth note
				note->duration	= EIGHTH;
			
			} else if (check_if_note_is_open(notehead_img)) {
				// half note
				note->duration	= HALF;

			} else {
				// quarter note
				note->duration	= QUARTER;
			}
		}

		// Find the middle of the notehead in the vertical direction.
		// Find all of the rows that have more than ten black pixels in them and
		//	then use the median of that.
		if (note->duration == HALF) {
			// Set a special threshold for half notes.
			// This is necessary because they are open and sometimes get
			//	cropped a lot and don't meet the threshold for all other notes.
			notehead_thrsh	= min_u16(6, max_u16(4, (34*notehead_max)/100));	// 4
		} else if ((note->duration == EIGHTH || note->duration == SIXTEENTH) && note->connected_type == SINGLE && note->notehead_position == RIGHT) {
			notehead_thrsh	= (40*notehead_max)/100;	// 13
		} else {
			notehead_thrsh	= (33*notehead_max)/100;	// 9
		}
		notehead_indices	= flex_array_find(notehead_proj_y, notehead_thrsh, greater);
	//	flex_array_delete(&yproj);
		if (notehead_indices == NULL) {
			// couldn't find a notehead, this must not be an actual note somehow
			goto parse_notes_with_lines_LINE_CLEANUP;
		} else {
			// pick the median ish
			notehead_com	= notehead_indices->data[notehead_indices->length/2];
		}

		// HACK
		// This is a global offset because based on our observations the COMs
		// are a little low for every note. Some notes are spot on, but none are above
		// the staffline. Therefore we make this little adjustment.
		notehead_com -= 1;

		// ANOTHER HACK
		// I've (brad) noticed that single eighth/sixteenth notes with the notehead on
		//	the right get a little screwed up with this algorithm. The tail interferes
		//	and makes the COM lower than it should be.
		if ((note->duration == EIGHTH || note->duration == SIXTEENTH) && note->connected_type == SINGLE && note->notehead_position == RIGHT) {
			notehead_com	-= 1;
		}

		// ANOTHER HACK
		// high notes have ledger lines
		if (top < round_u16(staff->stafflines[0] - staff->line_thickness - staff->line_spacing)) {
			notehead_com	-= 1;
		}

#ifdef DEBUG_FIND_STEMMED_NOTES
#ifdef DEBUG_FIND_NOTEHEAD_COM
binary_image_display(notehead_img);
for (i=0; i<notehead_img->width; i++) {
	setPixel(notehead_img, i, notehead_com, WHITE);
}
binary_image_display(notehead_img);
#endif
#endif
		// set note center of mass
		note->center_of_mass = notehead_com + note_cuts.top_cut + notehead_top_index;


		// add note to notes array
		linked_list_push_bottom(notes, (void**) &note);
		
		// final cleanup
parse_notes_with_lines_LINE_CLEANUP:

		// delete images
		if (note_img != NULL)			binary_image_delete(&note_img);
		if (tooclose_check_img != NULL)	binary_image_delete(&tooclose_check_img);
		if (notehead_img != NULL)		binary_image_delete(&notehead_img);

		// free memory
		free(line);
		if (prev_note->duration == UNKNOWN_DUR)	{
			free(prev_note);
			prev_note	= NULL;
		}

		// delete flex arrays
		if (note_proj_x != NULL)		flex_array_delete(&note_proj_x);
		if (note_proj_y != NULL)		flex_array_delete(&note_proj_y);
		if (notehead_proj_y != NULL)	flex_array_delete(&notehead_proj_y);
		if (notehead_indices != NULL)	flex_array_delete(&notehead_indices);

	}

	if (measures->length == 0 || notes->length == 0) {
		// hmm this is a bad sign
		disco_log("didn't find any measures and/or notes.");
		exit(1);
	}

	// Check to make sure that there are measure lines at each end
//	if (((measure_t*) linked_list_getIndexData(measures, 0))->begin > ((note_t*) linked_list_getIndexData(notes, 0))->begin) {
	if (1) {
		// there isn't an starting measure line
		// add one
		measure			= (measure_t*) malloc(sizeof(measure_t));
		measure->begin	= 1;
		measure->end	= 1;
		measure->type	= NORMAL;
		linked_list_push_top(measures, (void**) &measure);	//   add to measure struct array
	}
	if (((measure_t*) linked_list_getIndexData(measures, measures->length-1))->end < ((note_t*) linked_list_getIndexData(notes, notes->length-1))->end) {
		// there isn't an ending measure line
		// add one
		measure			= (measure_t*) malloc(sizeof(measure_t));
		measure->begin	= w-1;
		measure->end	= w-1;
		measure->type	= NORMAL;
		linked_list_push_bottom(measures, (void**) &measure);	//   add to measure struct array
	}

	flex_array_delete(&staff_proj_x);
	linked_list_delete(good_lines);

}

// finds all vertical lines (stems, measure markers)
linked_list* find_all_vertical_lines (const image_t* img, uint16_t height_min) {

	int16_t			height, width;
	int16_t			col, row;
	uint16_t		i;
	linked_list*	vertical_runs;
	linked_list*	grouped_runs;
	linked_list*	real_lines;
	uint8_t			inLine;
	uint8_t			shift;
	uint8_t			step;
	uint8_t			used_white;
	int16_t			cursor_v, cursor_h;
	flex_array_t*	columns_in_line;				// used to keep track where the vertical line is
	flex_array_t*	vertical_lines_found_left;
	line_t*			vert_run;
	line_t*			real_line;
	uint16_t		left, right, top, bottom;
	uint16_t		top_temp, bottom_temp;
	int16_t*		temp;

	height	= img->height;
	width	= img->width;

	vertical_runs	= linked_list_create();
	grouped_runs	= linked_list_create();
	real_lines		= linked_list_create();
	columns_in_line	= flex_array_create(img->width);


	// go through the staff image looking for vertical runs of black
	for (col=0; col<width; col++) {

		// Go through a column and find any pixels that are black with
		//	two white pixels above it
		// This is a starting point for looking for a black vertical line
		for (row=2; row<height; row++) {
			
			if (!getPixel(img, col, row-2) && !getPixel(img, col, row-1) && getPixel(img, col, row)) {
				// the previous 2 pixels were white and now we're at a black pixel
				inLine		= 1;
				cursor_v	= row;
				cursor_h	= col;
				shift		= 0;
				used_white	= 0;
				flex_array_zero(columns_in_line);

				// look for runs of black
				while (inLine) {
					step = 0;
					if (cursor_v+1 < height && getPixel(img, cursor_h, cursor_v+1)) {
						// pixel right below is black
						cursor_v++;
						step = 1;
					}

					// allow 1 white pixel in run
					if (!step && !used_white) {
						// the pixel below isn't black
						// see if the pixel below is white and the pixel below that one is black
						if (cursor_v < height - 2) {
							if (getPixel(img, cursor_h, cursor_v+2)) {
								// we have a spot there there is a 1 pixel white gap
								cursor_v	+= 2;
								step		= 1;
								used_white	= 1;
							}
						}
					}

					if (cursor_h+1 < width && cursor_v+1 < height && !step) {
						if (getPixel(img, cursor_h+1, cursor_v+1)) {
							// pixel to the bottom right is black
							cursor_v++;
							cursor_h++;
							step = 1;
							shift++;
						}
					}

					if (cursor_h-1 >= 0 && cursor_v+1 < height && !step) {
						if (getPixel(img, cursor_h-1, cursor_v+1) ) {
							// pixel to the bottom left is black
							cursor_v++;
							cursor_h--;
							step = 1;
							shift++;
						}
					}

					// if we haven't used up our white pixel yet and we didn't find any more black,
					//	move to the right or the left and then on the next loop we can see if we will
					//	be able to use up the 1 white pixel skip
					if (!step && !used_white && (cursor_v - row < height_min)) {
						if (cursor_h-1 >= 0) {
							if (getPixel(img, cursor_h-1, cursor_v)) {
								cursor_h--;
								step	= 1;
								shift++;
							}
						}
						if (!step && cursor_h < width-1) {
							if (getPixel(img, cursor_h+1, cursor_v)) {
								cursor_h++;
								step	= 1;
								shift++;
							}
						}
					}

					// mark which column we found a black pixel in
					columns_in_line->data[cursor_h]++;

					if (!step || shift > 3 || cursor_v>=height) {
						//can't continue black run
						//possible memory issue here. cursor_v magically becomes 2631...
						if (cursor_v - row >= height_min) {
							vert_run			= (line_t*) malloc(sizeof(line_t));
							vert_run->bottom	= cursor_v;
							vert_run->left		= flex_array_max_index(columns_in_line);
							vert_run->top		= row;
				//			vert_run->right		= col>cursor_h ? col : cursor_h;
							vert_run->right		= flex_array_max_index(columns_in_line);
							linked_list_push_bottom(vertical_runs, (void**) &vert_run);
					   }
					   inLine = 0;
					}
				}
			}
		}
	}

	// now that we've found all the vertical black runs, process and group them into usable lines

	// shove all of the lines into a flex array so that they can be grouped
	vertical_lines_found_left	= flex_array_create(vertical_runs->length);
	for (i=0; i<vertical_runs->length; i++) {
		vertical_lines_found_left->data[i]	= ((line_t*) linked_list_getIndexData(vertical_runs, i))->left;
#ifdef DEBUG_FIND_VERTICAL_LINES
disco_log("vert line %d: %d", i, vertical_lines_found_left->data[i]);
#endif
	}
	// group lines together so that runs are part of the same black line
	//	register as one line
	linked_list_fill_group_indices(grouped_runs, vertical_lines_found_left, 4); // 2nd arg chosen to group close lines together

#ifdef DEBUG_FIND_VERTICAL_LINES
for (i=0; i<grouped_runs->length; i++) {
	disco_log("good line %d, %d", ((int16_t*) linked_list_getIndexData(grouped_runs, i))[0], ((int16_t*) linked_list_getIndexData(grouped_runs, i))[1]);
}
#endif

	// go through and create a linked list with the final lines

	// iterate through each grouping of vertical runs
	while (!linked_list_is_empty(grouped_runs)) {
		temp	= (int16_t*) linked_list_pop_top(grouped_runs);

		// set the left and right as the outsides of the outer lines in the grouping
		left	= ((line_t*) linked_list_getIndexData(vertical_runs, temp[0]))->left;
		right	= ((line_t*) linked_list_getIndexData(vertical_runs, temp[1]))->right;

		// determine the top and bottom by finding the extremes of all of the lines in
		//	that grouping
		top		= height - 1;
		bottom	= 0;
		for (i=temp[0]; i<=temp[1]; i++) {
			top_temp	= ((line_t*) linked_list_getIndexData(vertical_runs, i))->top;
			bottom_temp	= ((line_t*) linked_list_getIndexData(vertical_runs, i))->bottom;
			if (top_temp < top)			top		= top_temp;
			if (bottom_temp > bottom)	bottom	= bottom_temp;
		}

		// create a new line struct and add the line to it
		real_line	= (line_t*) malloc(sizeof(line_t));
		real_line->top		= top;
		real_line->bottom	= bottom;
		real_line->left		= left;
		real_line->right	= right;

		free(temp);
		linked_list_push_bottom(real_lines, (void**) &real_line);
	}

	// cleanup
	linked_list_delete(vertical_runs);
	linked_list_delete(grouped_runs);
	flex_array_delete(&vertical_lines_found_left);
	flex_array_delete(&columns_in_line);

	return real_lines;
}

// Takes in a cropped, delined staff with a treble cleff.
// Finds the key signature and crops out the cleff and key signature.
// Current version: 5-13-2011
// - finds the treble cleff and uses blob kill to remove it
// - then scans from the left looking for black. when it finds black it
//   uses a blob kill like stack to copy the blob to a new image where the symbol is processed.
// - if the symbol is sharp or flat it is talied and removed.
// - if not it determines if it is a key signature or a note and proceeds from there.
void get_key_signature (image_t** in_img, sheet_t* sheet) {

	uint16_t		h, w;
	uint16_t		i, j;
	uint16_t		staff_height;
	uint16_t		center_of_staff;
	flex_array_t*	proj_x;
	uint16_t		max_width_to_check;
	image_t*		small_img;
	uint16_t		sharps, flats;
	accidental_e	accidental;
	uint16_t		symbol_x;
	uint8_t			found_sym_up;
	uint8_t			found_sym_down;
	uint16_t		symbol_y_up		= 0;
	uint16_t		symbol_y_down	= 0;
	uint16_t		extend;
	uint16_t		left_bound;
	uint16_t		right_bound;
	uint16_t		top_bound;
	uint16_t		bottom_bound;
	uint16_t		time_signature_right;
	uint16_t		ks_right;
	image_t*		img;
	image_t*		out_img;


	// setup
	staff_height		= sheet->staffs[0].height;
	max_width_to_check	= 5 * staff_height;
	img					= *in_img;
	h					= img->height;
	w					= img->width;
	sharps				= 0;
	flats				= 0;
	center_of_staff		= round_u16((sheet->staffs[0].stafflines[4] + sheet->staffs[0].stafflines[0]) / 2.0F);

	// project onto x-axis
	proj_x = project_on_X(img);

	// cleff is already gone
	i = 0;
	while (proj_x->data[i] < LINE_WIDTH_THRESHOLD) {
		i++;
	}

#ifdef DEBUG_GET_KEY_SIG
binary_image_display(img);
#endif

	// jump a few pixels in to skip over the cleff some
	i = subtract_u16(i, round_u16(sheet->staffs[0].line_spacing));

	// set default
	ks_right				= i;
	time_signature_right	= 0;

	// create the small image to copy blobs on
	small_img	= binary_image_create(1, 1);

	// loop through all symbols until we find ones that aren't part of
	// the key signature
	while (i < max_width_to_check) {

		// prepare a small image to put the copied blob on
		binary_image_delete(&small_img);
		small_img	= binary_image_create(h, max_width_to_check);
		binary_image_whiteout(small_img);

		// get a new x projection because the old one has the cleff or a key sig symbol still in it
		flex_array_delete(&proj_x);
		proj_x = project_on_X(img);

		// skip the rest of the white until the first black thing
		// this could be a part of the key signature, a time signature, or the first note
		while (i < max_width_to_check && proj_x->data[i] < LINE_WIDTH_THRESHOLD) {
			i++;
		}
		
		// look for the next symbol on the staff
		// this may not find anything where the previous scan left off (the x projection
		// could have been triggered by noise around the edges). therefore we need to look
		// until we find something
		found_sym_up	= 0;
		found_sym_down	= 0;
		while (i < max_width_to_check && !found_sym_up && !found_sym_down) {

			// the best data is in the middle
			// first look up, then look down.
			// this is because there can be a gap in the time signature, but I
			// want to get the whole thing in the small image
			symbol_x = i;
			for (j=0; j<staff_height/2; j++) {
				if (getPixel(img, i, center_of_staff-j)) {
					symbol_y_up		= center_of_staff-j;
					found_sym_up	= 1;
					break;
				}
			}
			for (j=2; j<staff_height/2; j++) {
				if (getPixel(img, i, center_of_staff+j)) {
					symbol_y_down	= center_of_staff+j;
					found_sym_down	= 1;
					break;
				}
			}

			i++;
		}

		// still a chance we didn't find anything
		if (!found_sym_up && !found_sym_down) {
			// stop now
			break;
		}

		// copy the symbol and hopefully the rest of it (if its disconnected) to the new image
		// not the most efficient thing in the world, but hey
		if (found_sym_up && found_sym_down) {
			extend	= 20;
		} else {
			// this is probably not the time signature, but rather a sharp or flat
			extend	= 10;
		}
		for (j=symbol_x; j<min_u16(symbol_x+extend, max_width_to_check); j++) {
			if (found_sym_up && getPixel(img, j, symbol_y_up))		blob_copy_and_kill(img, small_img, j, symbol_y_up, 0, 0);
			if (found_sym_down && getPixel(img, j, symbol_y_down))	blob_copy_and_kill(img, small_img, j, symbol_y_down, 0, 0);
		}

		// work on the image a bit more
		// flats can get disconnected from the right side, try to guess if we have a flat and get the rest of it
		find_bounds(small_img, &left_bound, &right_bound, &top_bound, &bottom_bound);

		if (right_bound - left_bound <= 10) {
			// looks like we only got the stem of the flat, lets try to get the rest
			for (j=left_bound; j<min_u16(left_bound+12, max_width_to_check); j++) {
				if (getPixel(img, j, subtract_u16(bottom_bound, 3)))	blob_copy_and_kill(img, small_img, j, subtract_u16(bottom_bound, 3), 0, 0);
				if (getPixel(img, j, (bottom_bound+top_bound)/2 + 3))	blob_copy_and_kill(img, small_img, j, (bottom_bound+top_bound)/2 + 3, 0, 0);
			}
		}


#ifdef DEBUG_GET_KEY_SIG
binary_image_display(small_img);
#endif

		// crop out the extra white space to get just the symbol
		pure_white_crop(&small_img);

		// do a check to make sure we're looking at something reasonable
		if (count_black(small_img) < 50) {
			i = symbol_x + (small_img->width/2);
			continue;
		}

		// check to see if the symbol is a flat or sharp
		accidental	= classify_accidental(small_img);

		if (accidental == SHARP) {
			sharps++;
		} else if (accidental == FLAT) {
			flats++;
		} else {
			// we found some other symbol
			// check to see if it is the key signature

			// lets just say its the key sig for now
			time_signature_right = symbol_x + small_img->width;
			break;
		}

		// set the right hand side of the key sig as it currently site
		ks_right	= symbol_x + small_img->width;
		i			= symbol_x + (small_img->width/2);

#ifdef DEBUG_GET_KEY_SIG
binary_image_display(img);
#endif
		
	}

	// delete the small image
	binary_image_delete(&small_img);
	// delete the last x projection
	flex_array_delete(&proj_x);
		
	// finish up
	if (sharps >= flats) {
		sheet->ks = sharps + flats;
	} else {
		sheet->ks = -1 * (sharps + flats);
	}

	// set the location of the key signature for future cropping
	sheet->ks_end_x = ks_right - sheet->staffs[0].cleff_start_x; 

	// crop image at this point for the rest of the processing
	out_img = get_sub_img(img, -1, -1, max_u16(time_signature_right, ks_right), -1);
	binary_image_delete(&img);
	*in_img	= out_img;
}

void find_first_measure_line (const image_t* img, const staff_t* staff, uint16_t* x1_ret, uint16_t* y1_ret, uint16_t* x2_ret, uint16_t* y2_ret) {
	find_measure_line(img, staff, 1, x1_ret, y1_ret, x2_ret, y2_ret);
}

void find_last_measure_line (const image_t* img, const staff_t* staff, uint16_t* x1_ret, uint16_t* y1_ret, uint16_t* x2_ret, uint16_t* y2_ret) {
	find_measure_line(img, staff, 0, x1_ret, y1_ret, x2_ret, y2_ret);
}

// This function scans left to right to find the first staff line.
// It tries to do this by sending out 5 horizontal lines that look for black in the
// image. When they find black, they try to see if they all found the same amount
// of black. If so, they found a consistently thick line that should be a measure marker.
// This has to be complicated like this because it is intended to help vertical_deskew,
// and the line could be crooked so just doing a projection won't work.
// returns: x index of measure line (middle hopefully)
void find_measure_line (const image_t* img, const staff_t* staff, uint8_t find_first, uint16_t* x1_ret, uint16_t* y1_ret, uint16_t* x2_ret, uint16_t* y2_ret) {
	uint16_t		w, wm1;
	uint16_t		i1, i2, i3, i4, i5;		// current x index of each of the lines
	uint16_t		y1, y2, y3, y4, y5;		// the set y coordinate of each line, 1 is on top
	uint16_t		start1, start2, start3, start4, start5;
	uint16_t		thickness_range;
	uint16_t		skew_range;
	uint16_t		min_end;
	flex_array_t*	five_line_arr;
	flex_array_t*	line_end_diff1;
	flex_array_t*	line_end_diff2;
	uint16_t		measure_line_x;

#ifdef DEBUG_FIND_MEASURE_LINE
image_t*		test_img;
#endif

#ifdef DEBUG_FIND_MEASURE_LINE
test_img	= binary_image_create(img->height, img->width);
binary_image_whiteout(test_img);
binary_image_copy(img, test_img, 0, 0);
#endif

	measure_line_x	= 0;
	
	w	= img->width;
	wm1	= img->width - 1;
	i1	= 0;
	i2	= 0;
	i3	= 0;
	i4	= 0;
	i5	= 0;

	// only need to create this once
	five_line_arr	= flex_array_create(5);

	// set the y coordinates of the lines
	y1	= round_u16(staff->stafflines[0] + 2.0F*staff->line_thickness);	// top
	y5	= round_u16(staff->stafflines[4] - 2.0F*staff->line_thickness);	// bottom
	y3	= (y1 + y5)/2;													// middle
	y2	= (y1 + y3)/2;													// top middle
	y4	= (y3 + y5)/2;													// bottom middle

	// set return y values
	*y1_ret	= y1;
	*y2_ret	= y5;

	// loop through looking for a line of constant width
	while (i1<w && i2<w && i3<w && i4<w && i5<w) {
		// skip whitespace
		while (i1<w && !getPixel(img, ((find_first)?i1:wm1-i1), y1))	{
#ifdef DEBUG_FIND_MEASURE_LINE
setPixel(test_img, ((find_first)?i1:wm1-i1), y1, BLACK);
#endif
			i1++;
		}
		while (i2<w && !getPixel(img, ((find_first)?i2:wm1-i2), y2))	{
#ifdef DEBUG_FIND_MEASURE_LINE
setPixel(test_img, ((find_first)?i2:wm1-i2), y2, BLACK);
#endif
			i2++;
		}
		while (i3<w && !getPixel(img, ((find_first)?i3:wm1-i3), y3))	{
#ifdef DEBUG_FIND_MEASURE_LINE
setPixel(test_img, ((find_first)?i3:wm1-i3), y3, BLACK);
#endif
			i3++;
		}
		while (i4<w && !getPixel(img, ((find_first)?i4:wm1-i4), y4))	{
#ifdef DEBUG_FIND_MEASURE_LINE
setPixel(test_img, ((find_first)?i4:wm1-i4), y4, BLACK);
#endif
			i4++;
		}
		while (i5<w && !getPixel(img, ((find_first)?i5:wm1-i5), y5))	{
#ifdef DEBUG_FIND_MEASURE_LINE
setPixel(test_img, ((find_first)?i5:wm1-i5), y5, BLACK);
#endif
			i5++;
		}
#ifdef DEBUG_FIND_MEASURE_LINE
#ifdef DEBUG_FIND_MEASURE_LINE_STEPS
binary_image_display(test_img);
#endif
#endif

		// save the current x position to compare with location after finding black
		start1	= i1;
		start2	= i2;
		start3	= i3;
		start4	= i4;
		start5	= i5;

		// find the end of the current black run
		while (i1<w && getPixel(img, ((find_first)?i1:wm1-i1), y1))	i1++;
		while (i2<w && getPixel(img, ((find_first)?i2:wm1-i2), y2))	i2++;
		while (i3<w && getPixel(img, ((find_first)?i3:wm1-i3), y3))	i3++;
		while (i4<w && getPixel(img, ((find_first)?i4:wm1-i4), y4))	i4++;
		while (i5<w && getPixel(img, ((find_first)?i5:wm1-i5), y5))	i5++;

		// put the length of the black run in an array to calculate the range
		five_line_arr->data[0]	= i1 - start1;
		five_line_arr->data[1]	= i2 - start2;
		five_line_arr->data[2]	= i3 - start3;
		five_line_arr->data[3]	= i4 - start4;
		five_line_arr->data[4]	= i5 - start5;

		// find the biggest spread in the runs of black
		thickness_range	= flex_array_range(five_line_arr);

		// put all of the end points in the array to calculate the range
		five_line_arr->data[0]	= i1;
		five_line_arr->data[1]	= i2;
		five_line_arr->data[2]	= i3;
		five_line_arr->data[3]	= i4;
		five_line_arr->data[4]	= i5;
		skew_range	= flex_array_range(five_line_arr);
		min_end		= flex_array_min(five_line_arr);

		

		// if the range is too great, then this wasn't a consistenly sized line and
		// therefore isn't the staff line
		// if the range of end values is high, then we hit not a skewed line but multiple lines

		if (thickness_range <= MEASURE_LINE_VARIATION_THRESHOLD && skew_range <= X_SKEW_MAXIMUM) {
			// we think we found a measure line
			// do some more checking to make sure

			// get the "second derivative" of the endpoints
			// they should be rather constantly spaced
			line_end_diff1	= flex_array_diff(five_line_arr);
			line_end_diff2	= flex_array_diff(line_end_diff1);
			if (flex_array_max(line_end_diff2) <= MEASURE_LINE_SLOPE_VARIATION && flex_array_min(line_end_diff2) >= -1*MEASURE_LINE_SLOPE_VARIATION) {
				// the endpoints look like they form a line
				// we found the measure line
				// record the measure line as the average of the top and bottom points
				if (find_first) {
					*x1_ret	= (i1 + start1)/2;
					*x2_ret	= (i5 + start5)/2;
				} else {
					*x1_ret	= ((wm1-i1) + (wm1-start1))/2;
					*x2_ret	= ((wm1-i5) + (wm1-start5))/2;
				}
				flex_array_delete(&line_end_diff1);
				flex_array_delete(&line_end_diff2);
				break;
			}
			flex_array_delete(&line_end_diff1);
			flex_array_delete(&line_end_diff2);
		}

		// rest i1-i5 so that the feelers do not get on different lines
		i1 = i2 = i3 = i4 = i5 = min_end;

	}

#ifdef DEBUG_FIND_MEASURE_LINE
binary_image_display(test_img);
binary_image_delete(&test_img);
#endif

	flex_array_delete(&five_line_arr);
	
}


// This find symbols uses a connected component like approach to find all meaningful
// black spots in the image.
// First it divides the image up into slices based on where there is black. That way
// it doesn't waste time searching a bunch of white space.
// Each slice is then searched for black. When a black spot is found, blob_copy transfers
// it to a new image. If this image has enough black on it, it is added to the symbols
// list.
// Each separate black blob gets its own image.
void find_symbols (image_t* img, linked_list *symbols) {
	int				i, j, k;
	uint16_t*		sections;		// an array of x-indicies that tell where to segment the image for conn comp. analysis. has both start and end indicies
	uint16_t		num_sections;	// a count of how many slices there are
	flex_array_t*	proj_x;
	uint16_t		left_bound;
	uint16_t		right_bound;
	uint16_t		left_cropped;
	uint16_t		right_cropped;
	uint16_t		top_cropped;
	uint16_t		bottom_cropped;
	symbol_t*		symbol;
	image_t**		new_img;		// this has to be a double pointer to allow me to create multiple new images (images for each symbol)

	// project on x to find where there is still black
	proj_x			= project_on_X(img);

	// set up the sections array
	// worst case we would have black every other pixel
	sections		= (uint16_t*) malloc(sizeof(uint16_t) * img->width);
	num_sections	= 0;
	i				= 0;

	// loop through projection looking for sections of black
	// first skip any whitespace to make it easier to prevent running off the end of the projection
	while (i < proj_x->length && proj_x->data[i] == 0) i++;

	while (i < proj_x->length) {
		// mark the left side in the sections array
		sections[num_sections*2]	= i;

		// find the end of the black
		while (i < proj_x->length && proj_x->data[i] > 0) i++;
		sections[num_sections*2+1]	= i-1;
		num_sections++;

		// skip any whitespace
		while (i < proj_x->length && proj_x->data[i] == 0) i++;
	}

	// no longer needed
	flex_array_delete(&proj_x);

	// loop through all of the sections
	for (k=0; k<num_sections; k++) {
		left_bound	= sections[k*2];
		right_bound	= sections[k*2+1];

		// loop through the section looking for black
		for (j=0; j<img->height; j++) {
			for (i=left_bound; i<=right_bound; i++) {
				
				// if weve found a black pixel, create a new image and copy the blob into it
				if (getPixel(img, i, j)) {
					// create an image the proper size
					new_img		= (image_t**) malloc(sizeof(image_t*));
					*new_img	= binary_image_create(img->height, right_bound-left_bound+1);
					binary_image_whiteout(*new_img);
					
					// copy the blob
					blob_copy_and_kill(img, *new_img, i, j, left_bound, 0);

					// crop the whitespace away
					pure_white_crop_returns(new_img, &left_cropped, &right_cropped, &top_cropped, &bottom_cropped);

					// determine if the black blob is worth keeping
					if (check_if_blob_is_symbol(*new_img)) {
						// add this to the symbols list
						symbol				= (symbol_t*) malloc(sizeof(symbol_t));
						symbol->image		= *new_img;
						symbol->offset_x	= left_bound + left_cropped;
						symbol->offset_y	= top_cropped;
						symbol->num_black	= count_black(*new_img);
						symbol->type		= UNCLASSIFIED;

						linked_list_push_bottom(symbols, (void**) &symbol);

					} else {
						// delete unused image
						binary_image_delete(new_img);
					}

					free(new_img);

				}
			}
		}
	}

	free(sections);
}

// returns the indicies of the linked_list of the measures that surround an x index
void find_measure_markers_around_point (const linked_list* measures, uint16_t x_index, uint16_t* mm_left_index, uint16_t* mm_right_index) {
	measure_t*	measure;
	uint16_t	i;

	*mm_left_index	= 0;
	*mm_right_index	= 0;
	for (i=0; i<measures->length; i++) {
		measure = (measure_t*) linked_list_getIndexData(measures, i);

		if (measure->begin < x_index){
			*mm_left_index	= i;
		}
		if (*mm_right_index == 0 && measure->end > x_index){
			*mm_right_index	= i;
			break;
		}
	}
}

uint16_t get_center_x_of_measure (const linked_list* measures, uint16_t x_index) {
	uint16_t	mm_left_index;
	uint16_t	mm_right_index;
	uint16_t	mm_left_x;
	uint16_t	mm_right_x;

	// get the measure marker indicies
	find_measure_markers_around_point(measures, x_index, &mm_left_index, &mm_right_index);

	mm_left_x	= ((measure_t*) linked_list_getIndexData(measures, mm_left_index))->end;
	mm_right_x	= ((measure_t*) linked_list_getIndexData(measures, mm_right_index))->begin;

	return (mm_left_x + mm_right_x) / 2;
}

// returns the number of notes found in a measure
uint16_t count_note_in_measure (const linked_list* notes, const linked_list* measures, uint16_t x_index) {
	uint16_t	i;
	note_t*		note;
	uint16_t	note_count		= 0;
	uint16_t	mm_left_index;
	uint16_t	mm_right_index;
	uint16_t	mm_left_x;
	uint16_t	mm_right_x;

	// get the measure marker indicies
	find_measure_markers_around_point(measures, x_index, &mm_left_index, &mm_right_index);

	// get the x coordinates
	mm_left_x	= ((measure_t*) linked_list_getIndexData(measures, mm_left_index))->end;
	mm_right_x	= ((measure_t*) linked_list_getIndexData(measures, mm_right_index))->begin;

	// loop through and count the notes in the measure
	for (i=0; i<notes->length; i++) {
		note	= (note_t*) linked_list_getIndexData(notes, i);
		if (note->begin > mm_left_x && note->end < mm_right_x) {
			note_count++;
		}
	}

	return note_count;
}
