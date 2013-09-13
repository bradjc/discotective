#include "scanning.h"
#include "segmentation.h"
#include "global.h"
#include <stdint.h>
#include "linked_list.h"
#include "flex_array.h"
#include "io.h"
#include "image_functions.h"
#include "general_functions.h"
#include <stdlib.h>
#include "vga.h"
#include "led.h"
#include "ssd.h"

void parse_notes_with_lines (image16_t* img, image16_t* img_temp1, image16_t* img_temp2, const staff_info* staff, uint16_t staffNumber, uint32_t* staff_lines, linked_list* stems_list, linked_list* measures_list){
	/*  finds all stemmed notes and measure markers
	%
	% input 'out' not necessary for C-code (just for matlab graphing)
	%
	% Returned structs:
	% stems.begin           - beginning of stem (left)
	% stems.end             - end of stem (right)
	% stems.position        - either 'left' or 'right' depending which side notehead_img is on
	% stems.center_of_mass  - y position of center of notehead_img
	% stems.top             - top of stem
	% stems.bottom          - bottom of stem
	% stems.eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
	% stems.midi            - midi number (field modified later)
	% stems.letter          - letter (ie 'G3') (not necessary for C)
	% stems.mod             - modifier (+1 for sharp, -1 for flat, 0 for
	%                         natural) (field modified later)
	%
	% measures.begin        - left side of measure marker
	% measures.end          - right side of measure marker
	*/

	uint16_t		line_thickness;
	uint16_t		line_spacing;
	uint16_t		h, w;
	uint16_t		extend;
	linked_list*	goodLines;
	linked_list*	vert_lines;			// linked list of all vertical lines on the staff

	uint16_t		i, j;
	int16_t*		temp;
	uint16_t		startLine;
	uint16_t		endLine;
	uint16_t		xbegin, xend;
	uint16_t		xbegin_next_stem;
	uint16_t		top, bottom, top_temp, bottom_temp;
	uint16_t		line_height;
	uint16_t		xbeginN, xendN;
	uint8_t			duration;
	uint8_t			mmFound;
	uint8_t			rest_found;
	note_cuts*		notes;
	uint16_t		mini_height;
	uint16_t		midPoint;
	projection_t*	yproj;
	projection_t*	xproj;
	uint16_t		proj_mean, difference;
	measure_t*		measure;
	stems_t*		stems;
	uint16_t		topWeight, bottomWeight;
	uint8_t 		connector_on_bottom;
	uint8_t			connector_on_top;
	int16_t 		notehead_bottom_index;
	int16_t			notehead_left_index;
	int16_t			notehead_right_index;
	int16_t			notehead_top_index;
	uint16_t		prev_stem_pos;
	uint16_t		prev_stem_was_conn_eighth;
	uint16_t		prev_stem_was_single_eighth_right;	// single eighth with the head on the right (tail loops up)
	uint16_t		prev_stem_was_single_eighth_left;	// single eighth with head on left (tail flairs out and down)

	uint16_t		accum;
	uint16_t		notehead_thrsh;
	flex_array_t	*notehead_indices;


	line_thickness	= staff->thickness;
	line_spacing	= staff->spacing;

	h = img->height;
	w = img->width;

	prev_stem_was_single_eighth_right	= 0;
	prev_stem_was_single_eighth_left	= 0;
	prev_stem_was_conn_eighth			= 0;


	vert_lines = linked_list_create();

	get_sub_img(img, img_temp1, -1, -1, -1, w-(2*line_spacing/16)-1); // brad executive change

	// find vertical lines
	goodLines	= find_all_vertical_lines(img_temp1, (75*(staff->staff_h)+99)/100, 0, vert_lines);

	// initialize with a measure at the beginning
	measure			= malloc(sizeof(measure_t));
	measure->begin	= 1;
	measure->end	= 1;
	linked_list_push_top(measures_list, measure);

	// for use with connected eighth notes
	prev_stem_was_conn_eighth	= 0;
	prev_stem_pos				= 0;

	// the maximum amount to look left and right from the stem for a note
	extend = (7*((staff->spacing + staff->thickness)/16)+2)/5;

	// loop through all found vertical lines
	while (!linked_list_is_empty(vert_lines)) {
		// grab start and end indices into goodLines for the outsides of the block of
		// lines that makes up one stem
		temp		= linked_list_pop_top(vert_lines);
		startLine	= temp[0];
		endLine		= temp[1];
		free(temp); // bug seems to be in getIndexData startLine line specifically

		// set the xbegin and xend based on the outsides of the grouping
		xbegin		= ((good_lines_t*) linked_list_getIndexData(goodLines, startLine))->left;
		xend		= ((good_lines_t*) linked_list_getIndexData(goodLines, endLine))->right;

		// Right away do a check for spurious lines.
		// So far we have an example where the tail of a right facing single
		// eighth note is being detected as a line.
		// Do a check to make sure this line is not too close to a single eighth note.

		#ifdef DEBUG_ON
			if (prev_stem_was_single_eighth_right) {
				ssd_write_value(0x06781234);
				WAIT_FOR_INTERRUPT;
			}
			if (prev_stem_was_single_eighth_left) {
				ssd_write_value(0x06784567);
				WAIT_FOR_INTERRUPT;
			}
		#endif

		if (prev_stem_was_single_eighth_right && (xbegin - prev_stem_was_single_eighth_right) < 25) {
			// This next line is the tail of the previous single eighth note. Skip.
			prev_stem_was_single_eighth_right = 0;
			continue;
		}

		// get top and bottom of found line (y axis)
		// basically search for minimum and maximum
		top		= h-1;
		bottom	= 0;
		// loop through all the lines in the block to get the best top and bottom for the stem
		for (j=startLine; j<=endLine; j++) {
			top_temp	= ((good_lines_t*) linked_list_getIndexData(goodLines, j))->top;
			bottom_temp	= ((good_lines_t*) linked_list_getIndexData(goodLines, j))->bottom;
			if (top_temp < top) {
				top = top_temp;
			}
			if (bottom_temp > bottom) {
				bottom = bottom_temp;
			}
		}
		duration	= UNKNOWN;
		line_height	= bottom - top + 1;

		//  cut small image just around the note
		notes = (note_cuts*) malloc(sizeof(note_cuts));

		// get small image around note
		mini_img_cut(img, img_temp1, top, bottom, xbegin, xend, staff, notes);

		// offsets into the entire staff image
		xbeginN	= xbegin - notes->left_cut;  //  xbegin/xend for use with mini_img
		xendN	= xend - notes->left_cut;

		// y projection
		yproj		= project_on_Y(img_temp1);
		mini_height	= yproj->length;
		midPoint	= (mini_height + 1)/2;

		// check for measure marker by seeing if the variance of the y projection
		// is small (so the "note" is basically a rectangle) or if the width is small (aka
		// there is no notehead
		proj_mean	= flex_array_rounded_mean(yproj);
		difference	= 0;

		for (i=0; i<yproj->length; i++) {
			difference += abs_int16(yproj->data[i] - (int16_t) proj_mean);
		}
		mmFound = 0;

		if ((img_temp1->width < (7*extend+9)/10) || difference < yproj->length) {
			mmFound = 1;
		}

		// handle mini_img here
		if (mmFound) {
			// MEASURE MARKER FOUND
			measure			= (measure_t*) malloc(sizeof(measure_t));
			if (measure == NULL) {
				ssd_write_value(0xFA1E0F00);
				WAIT_FOR_INTERRUPT;
			}
			measure->begin	= xbegin;
			measure->end	= xend;
			linked_list_push_bottom(measures_list, measure);	//   add to measure struct array

		} else {
			// note found instead
			// make sure its not quarter rest (check that line is skinny in middle)
			rest_found = check_line_is_not_rest(img_temp1, staff_lines, notes->top_cut, (xendN+xbeginN)/2, staff);
			if (rest_found == 1 && (line_height < staff->staff_h)) {
				// skip if rest
#ifdef DEBUG_ON
ssd_write_value(0xF000AE57);
vga_draw_binary_img(img_temp1);
WAIT_FOR_INTERRUPT;
#endif
				free(notes);
				continue;
			}

			stems				= (stems_t*) malloc(sizeof(stems_t));
			stems->eighthEnd	= 0;
			stems->eighthSingle	= 0;

			// check for eighth note connecting tails on top and bottom
			connector_on_top	= check_for_eighth_connector_on_top(img_temp1, img_temp2, xendN, staff);
			connector_on_bottom	= check_for_eighth_connector_on_bottom(img_temp1, img_temp2, xendN, staff);

			// do some error checking
			// if both top_connector and bottom_connector are both true, the notehead was too
			// big and touched the edge. However, both will only be true if the connector is on the
			// bottom.
			if (connector_on_top && connector_on_bottom) {
				connector_on_top	= 0;
				connector_on_bottom	= 1;
			}

			// do a second check to make sure the eighth note is balanced top to bottom
			// if its not then the eighth note is really not a connected eighth note

			// calculate mass on the top and bottom
			topWeight		= 0;
			bottomWeight	= 0;
			for (i=0; i<midPoint; i++) {
				topWeight += yproj->data[i];
			}
			for (i=midPoint; i<mini_height; i++) {
				bottomWeight += yproj->data[i];
			}

			// do a third check to make sure that there is enough black between the top and
			// bottom sections of the note to actually be a eighth note

			// do a fourth check if top_connector == true
			// if that is the case then there better be a note head to the left
			if (connector_on_top) {
				if (xbeginN < 10) {
					connector_on_top = 0;
				}
			}

			// do a fifth check to make sure there is black in the vertical direction
			// from the current stem to the next stem
			if (connector_on_top || connector_on_bottom) {
				if (!linked_list_is_empty(vert_lines)) {

					// get the next stem location
					temp				= linked_list_getIndexData(vert_lines, 0);
					xbegin_next_stem	= ((good_lines_t*) linked_list_getIndexData(goodLines, temp[0]))->left;
					// do a check for single eighth notes that are being found to be connected eighth notes
					if (xbegin_next_stem - xend < 25) {
						connector_on_top	= 0;
						connector_on_bottom	= 0;
					} else {
						get_sub_img(img, img_temp2, -1, -1, xend, xbegin_next_stem);
						xproj				= project_on_X(img_temp2);
						for (i=0; i<xproj->length; i++) {

							if (xproj->data[i] < 2) {
								connector_on_top	= 0;
								connector_on_bottom	= 0;
								break;
							}
						}

						flex_array_delete(xproj);
					}
				} else {
					// there are no more vertical lines
					// therefore this cannot be connected to a note on the right
					connector_on_top	= 0;
					connector_on_bottom	= 0;
				}
			}

			// this and next note are eighth notes
			if (prev_stem_was_conn_eighth || connector_on_top || connector_on_bottom) {
				duration = EIGHTH;

				// set where the note head is relative to the line
				if (connector_on_top) {
					stems->position_left		= 1;
					prev_stem_was_conn_eighth	= 1;
				} else if (connector_on_bottom) {
					stems->position_left		= 0;
					prev_stem_was_conn_eighth	= 1;
				} else {
					// the previous note was a connected eighth note but this one doesn't
					// have a connector going to the right
					stems->position_left		= prev_stem_pos;
					prev_stem_was_conn_eighth	= 0;
					stems->eighthEnd			= 1;
				}

				// set this so if the next eighth note ends the connected series of eighth notes
				// we know which side the head is on that note
				prev_stem_pos = stems->position_left;

				prev_stem_was_single_eighth_right	= 0;
				prev_stem_was_single_eighth_left	= 0;
			} else {
				// this is some note other than a connected eighth note
				// note is not part of eighth notes, find out what it is
				if (check_eighth_note(img_temp1, img_temp2, xbeginN)) {
					// note is single eighth note
					duration			= EIGHTH;
					stems->eighthEnd	= 1;
					stems->eighthSingle	= 1;
					prev_stem_was_single_eighth_right	= xend;
					prev_stem_was_single_eighth_left	= xend;
				} else {
					prev_stem_was_single_eighth_right	= 0;
					prev_stem_was_single_eighth_left	= 0;
				}

				// determine if note is pointing up or pointing down based on the
				// relative amount of black on the top and bottom
				if (bottomWeight > topWeight) {
					// stem is above the note
					stems->position_left = 1;
					prev_stem_was_single_eighth_right	= 0;
				} else {
					// stem is below the note
					stems->position_left = 0;
					prev_stem_was_single_eighth_left	= 0;
				}
			}

			flex_array_delete(yproj);

			// At this point we know which side of the stem the notehead is on.
			// Now we can further crop down the miniimg of the note since we don't
			// need any of the black pixels on the side of the stem that the notehead
			// isn't on. This then allows us to crop whitespace off the top and bottom
			// to better find the notehead and therefore calculate the center of mass.
			if (stems->position_left == 1) {
				// crop everything to the right of the stem
				get_sub_img(img_temp1, img_temp1, -1, -1, -1, xendN + 1);
			} else {
				// crop everything to the left of the stem
				get_sub_img(img_temp1, img_temp1, -1, -1, xbeginN - 1, -1);
				// reset xbeginN to handle the new size of the image
				xendN	= (xendN - xbeginN) + 1;
				xbeginN	= 1;

			}

			// FOR MIKE'S COM ALGORITHM
			// now we know where the head is relative to the stem
			// get the notehead using that information
			if (stems->position_left == 1) {    //  notehead_img is on bottom half
				// note head is on the left of the stem and therefore the bottom
				// get the note head
				notehead_top_index		= mini_height / 2;
				notehead_bottom_index	= -1;
				notehead_left_index		= 0;
				notehead_right_index	= (xbeginN+xendN+1)/2;

			} else {
				// notehead is on the right and top of the stem
				// get the notehead
				notehead_top_index		= 0;
				notehead_bottom_index	= mini_height/2;
				notehead_left_index		= (xbeginN+xendN+1)/2;
				notehead_right_index	= -1;
			}


			// get the notehead image
			get_sub_img(img_temp1, img_temp2, notehead_top_index, notehead_bottom_index, notehead_left_index, notehead_right_index);

			// not eighth note
			if (duration != EIGHTH) {
				// determine if notehead is filled or open
				if (is_note_open(img_temp2)) {
					// found a half note
					duration = HALF;
				} else {
					// found a quarter note
					// we dont handle other notes with stems
					duration = QUARTER;
				}
			}

			// CENTER OF MASS CALCULATION 2 (mike)
			// get a y project that isn't a sum but instead looks the for the last black
			// pixel in each row
			notehead_thrsh		= 10;
			yproj				= project_on_Y(img_temp2);
			notehead_indices	= flex_array_find(yproj, notehead_thrsh, greater);
			if (notehead_indices == NULL) {
				flex_array_delete(yproj);
				free(stems);
				free(notes);
				continue;
			} else {
				accum			= notehead_indices->data[notehead_indices->length/2];
			}
			flex_array_delete(notehead_indices);

			// HACK
			// This is a global offset because based on our observations the COMs
			// are a little low for every note. Some notes are spot on, but none are above
			// the staffline. Therefore we make this little adjustment.
			accum -= 2;

			stems->center_of_mass = accum + notes->top_cut + notehead_top_index;

			flex_array_delete(yproj);

			// set properties
			stems->begin	= xbegin;
			stems->end		= xend;
			stems->top		= top;
			stems->bottom	= bottom;
			stems->duration	= duration;
			stems->midi		= 0;
			stems->mod		= 0;

			linked_list_push_bottom(stems_list, stems);

#ifdef DEBUG_ON
for (tempi=xbegin; tempi<=xend; tempi++) {
	setPixel(img, tempi, img->height/2, 0);
	setPixel(img, tempi, img->height/2+1, 0);
	setPixel(img, tempi, img->height/2+2, 0);
	setPixel(img, tempi, img->height/2+3, 0);
	setPixel(img, tempi, img->height/2+4, 0);
}
vga_draw_binary_img(img);
#endif

		} //  end else not measure marker

		free(notes);

	}  //  end while

	linked_list_delete_list(vert_lines);
	linked_list_delete_list(goodLines);

	// add measure positioned at very end of staff
	measure			= (measure_t*) malloc(sizeof(measure_t));
	measure->begin	= w-1;
	measure->end	= w-1;
	linked_list_push_bottom(measures_list, measure);
}

linked_list* find_all_vertical_lines (const image16_t* img, uint16_t height_min, uint16_t leftCutoff, linked_list* vert_lines) {
    /* finds all vertical lines (stems, measure markers)
     Returns:
    groupings - indices within goodLines array of start and end of each vertical line
       ex: [40 42
            55 58
            100 110]

     goodLines - array of structs for each vertical found
       .top
       .bottom
       .left
       .right*/

	uint16_t		height, width, col, row;
	uint16_t		num_starts_black_in_col;
	uint16_t		i, real_length;
	linked_list*	goodlines_first;				//since unsure of size, trim down later
	flex_array_t*	starts_of_black_in_col;
	uint8_t			inLine, shift, step;
	uint16_t		cursor_v, cursor_h;
	good_lines_t*	lines;

	height	= img->height;
	width	= img->width;

	goodlines_first = linked_list_create();

	real_length = 0;

	// go through the staff image
	for (col=0; col<width; col++) {
		num_starts_black_in_col	= 0;
		i						= 0;

		// guess a length (aka the height of the image)
		starts_of_black_in_col = flex_array_create(height);

		// go through a column and find any pixels that are black with
		// a white pixel above it
		for (row=1; row<height; row++) {
			if (!getPixel(img, col, row-1) && getPixel(img, col, row)) {
				// the previous pixel was white and now we're at a black pixel
				num_starts_black_in_col++;
				starts_of_black_in_col->data[i++] = row;
			}
		}
		starts_of_black_in_col->length = num_starts_black_in_col;

		// loop through all possible starts
		for (i=0; i<num_starts_black_in_col; i++) {
			inLine		= 1;
			cursor_v	= starts_of_black_in_col->data[i];
			cursor_h	= col;
			shift		= 0;

			// look for runs of black
			while (inLine) {
				step = 0;
				if (getPixel(img, cursor_h, cursor_v+1)) {
					// pixel right below is black
					cursor_v++;
					step = 1;
				}

				if (cursor_h+1 < width && !step) {
					if (getPixel(img, cursor_h+1, cursor_v+1)) {
						// pixel to the bottom right is black
						cursor_v++;
						cursor_h++;
						step = 1;
						shift++;
					}
				}

				if (cursor_h-1 >= 0 && !step) {
					if (getPixel(img, cursor_h-1, cursor_v+1) ){
						// pixel to the bottom left is black
						cursor_v++;
						cursor_h--;
						step = 1;
						shift ++;
					}
				}

				if (!step || shift > 3){
					//can't continue black run
					if (cursor_v - starts_of_black_in_col->data[i] >= height_min) {
						real_length++;
						lines			= (good_lines_t *) malloc(sizeof(good_lines_t));
						lines->bottom	= cursor_v;
						lines->index	= col;
						lines->left		= col<cursor_h ? col : cursor_h;
						lines->top		= starts_of_black_in_col->data[i];
						lines->right	= col>cursor_h ? col : cursor_h;
						lines->left		+= leftCutoff-1;
						lines->right	+= leftCutoff-1;
						linked_list_push_bottom(goodlines_first, lines);
				   }
				   inLine = 0;
				}

			} // end while in line

		} // end for thru each starting location
		flex_array_delete(starts_of_black_in_col);

	} // end for thru each column

	starts_of_black_in_col = flex_array_create(real_length);
	for (i=0; i<real_length; i++) {
		starts_of_black_in_col->data[i] = ((good_lines_t*) linked_list_getIndexData(goodlines_first, i))->left;
	}
	// GROUP LINES TOGETHER
	linked_list_fill_group_indices(vert_lines, starts_of_black_in_col, 5); // 2nd arg chosen to group close lines together

	flex_array_delete(starts_of_black_in_col);
	return goodlines_first;
}

// Takes in a cropped, delined staff with a treble cleff.
// Finds the key signature and crops out the cleff and key signature.
void get_key_signature (image16_t* img, image16_t* temp_img1, staff_info* staff, uint32_t* staff_lines) {

	uint16_t		h, w;
	uint16_t		i, j;
	uint16_t		time_signature_left;
	uint16_t		time_signature_right;
	projection_t*	proj_x;
	projection_t*	proj_y;
	uint16_t		ks_x_begin, ks_x_end;
	uint16_t		max_width_to_check;
	uint16_t		cleff_right;
	uint16_t		black_run;
	uint8_t			time_signature_found;

	uint16_t		sharps, flats;
	uint16_t		accidental_right;
	uint16_t		accidental_left;
	uint16_t		accidental_top;
	uint16_t		accidental_bottom;
	symbol_type		accidental;


	max_width_to_check			= 3 * (staff_lines[4]-staff_lines[0]);

	// default
	time_signature_left			= 3 * (staff_lines[4]-staff_lines[0]);
	time_signature_right		= 3 * (staff_lines[4]-staff_lines[0]);

	// get size
	h	= img->height;
	w	= img->width;

	// project onto x-axis
	proj_x = project_on_X(img);

	// lets try something new
	// first find the cleff
	i = 0;
	while (proj_x->data[i] < LINE_WIDTH_THRESHOLD) {
		i++;
	}
	// find cleff
	while (i < (proj_x->length - 1) && (proj_x->data[i] >= LINE_WIDTH_THRESHOLD)) {
		i++;
	}

	cleff_right = i;

	// scan from the right starting at max_width_to_check
	// look for the massive amount of black pixels that should be the key signature
	black_run	= 0;
	time_signature_found = 0;
	for (i=max_width_to_check; i>cleff_right; i--) {
		if (time_signature_found) {
			// we now just need to find the left side of the time signature
			if (proj_x->data[i] < LINE_WIDTH_THRESHOLD) {
				// we hit the white at the left side of the time signature
				time_signature_left = i;
				break;
			}
		} else {
			// still looking for the right side of the time signature
			if (black_run > 0) {
				// we saw what we thought was the start of the time signature
				// from the right
				if (proj_x->data[i] > ((9*staff->staff_h)/10)) {
					black_run++;
				} else {
					// oops we didn't actually see the start
					// reset, try again
					black_run = 0;
				}
			} else {
				// still looking for the start
				if (proj_x->data[i] > ((9*staff->staff_h)/10)) {
					// found the start
					black_run				= 1;
				}
			}
			if (black_run > TIME_SIGNATURE_BLACK_WIDTH) {
				time_signature_found = 1;
			}
		}
	}

	// now get time signature right
	for (i=time_signature_left+10; i<max_width_to_check; i++) {
		if (proj_x->data[i] < LINE_WIDTH_THRESHOLD) {
			time_signature_right = i + 3;
			break;
		}
	}


	// now set the key signature location parameters
	ks_x_begin	= cleff_right;
	ks_x_end	= time_signature_left - 5;

	staff->ks_x	= time_signature_left;

	flex_array_delete(proj_x);

#ifdef DEBUG_ON
	for (i=0; i<img->height; i++) {
		setPixel(img, ks_x_begin, i, 1);
		setPixel(img, ks_x_end, i, 1);
	}

	pan_image(img);
#endif

	// CLASSIFY KEY SIGNATURE
	sharps	= 0;
	flats	= 0;

	// isolate key signature section
	get_sub_img(img, temp_img1, -1, -1, ks_x_begin, ks_x_end);

	proj_x = project_on_X(temp_img1);

	i = 0;
	while (i < proj_x->length) {

		// skip whitespace
		while (i < proj_x->length && proj_x->data[i] == 0) {
			i++;
		}

		accidental_left = i;
		// find bounds of the first sharp or flat
		while (i < proj_x->length && proj_x->data[i] > 3) {
			i++;
		}
		accidental_right = i;

		if (accidental_right - accidental_left < MIN_ACCIDENTAL_WIDTH) {
			// just skip the remaining whitespace at the right
			continue;
		}

		// get a small image of the accidental
		get_sub_img(img, temp_img1, -1, -1, ks_x_begin + accidental_left, ks_x_begin + accidental_right);

		proj_y = project_on_Y(temp_img1);

		// crop the image top to bottom before passing it to classify_accidental
		accidental_top		= 0;
		accidental_bottom	= img->height - 1;
		for (j=0; j<img->height; j++) {
			if (accidental_top == 0) {
				if (proj_y->data[j] < 3) continue;
				else accidental_top = j;
			} else {
				if (proj_y->data[j] >= 3) {
					continue;
				} else {
					accidental_bottom = j;
					break;
				}
			}
		}

		flex_array_delete(proj_y);

		get_sub_img(img, temp_img1, accidental_top, accidental_bottom, ks_x_begin + accidental_left, ks_x_begin + accidental_right);

		accidental = classify_accidental(temp_img1);

		if (accidental == SHARP || accidental == NATURAL) {
			sharps++;
		} else if (accidental == FLAT) {
			flats++;
		} else {
			// who knows
		}

		i++;
	}

	// finish up
	if (sharps >= flats) {
		staff->ks = sharps + flats;
	} else {
		staff->ks = -1 * (sharps + flats);
	}

	flex_array_delete(proj_x);

	if (staff->ks_x <= 0){
		staff->ks_x =  ks_x_end - 5;
	}

	// crop image at this point for the rest of the processing
	get_sub_img(img, img, -1, -1, time_signature_right, -1);

}

void find_symbols_simple (image16_t* img, image16_t* temp_img, linked_list *symbols) {
	uint16_t		i, j;
	uint16_t		left_bound;
	uint16_t		right_bound;
	uint16_t		top_bound;
	uint16_t		bottom_bound;
	uint16_t		black_pixel_sum;
	uint16_t		max_ind;
	flex_array_t*	proj_x;
	flex_array_t*	proj_y;
	symbol_t*		symbol;



	// project on x to find where there is still black
	proj_x	= project_on_X(img);

	// loop through to find where there is black
	i = 0;
	while (i < proj_x->length) {

		// clear out any white space
		while (i < proj_x->length && proj_x->data[i] < 3) {
			i++;
		}

		// find bounds of black stuff we hit
		left_bound = i;

		while (i < proj_x->length && proj_x->data[i] >= 3) {
			i++;
		}
		right_bound = i - 1;

		// get sub image so we can find top and bottom bounds
		get_sub_img(img, temp_img, -1, -1, left_bound, right_bound);

		proj_y = project_on_Y(temp_img);

		// find the maximum of the projection, make that the starting point, and
		// work from there.
		max_ind	= flex_array_get_max_index(proj_y);

		// look for the end of the top
		for (j=max_ind; j>0; j--) {
			if (proj_y->data[j] == 0) {
				break;
			}
		}
		top_bound = j;

		// look for the end of the bottom
		for (j=max_ind; j<proj_y->length; j++) {
			if (proj_y->data[j] == 0) {
				break;
			}
		}
		bottom_bound = j;

		// get the number of black pixels
		black_pixel_sum = 0;
		for (j=top_bound; j<=bottom_bound; j++) {
			black_pixel_sum += proj_y->data[j];
		}


		// now create a symbol and push it onto the linked list
		symbol				= malloc(sizeof(symbol_t));
		symbol->top			= top_bound;
		symbol->bottom		= bottom_bound;
		symbol->left		= left_bound;
		symbol->right		= right_bound;
		symbol->height		= bottom_bound - top_bound + 1;
		symbol->width		= right_bound - left_bound + 1;
		symbol->NumBlack	= black_pixel_sum;
		symbol->type		= UNCLASSIFIED;

		if (symbol->height <= 5 || symbol->width <= 5 || black_pixel_sum < 15) {
			free(symbol);
			flex_array_delete(proj_y);
			continue;
		}

		linked_list_push_bottom(symbols, symbol);

		flex_array_delete(proj_y);
	}

	flex_array_delete(proj_x);
}

void combine_symbols (linked_list *symbols, staff_info* staff) {
	symbol_t	*currSymbol;
	symbol_t	*cmpSymbol;
	symbol_t	*closestSymbol;
	int32_t		right1, height1, top1, left2, height2, top2;
	int32_t		closestSymb;
	uint16_t	i, j;
	uint16_t	line_spacing;
	uint16_t	minDist, currDist;

	line_spacing = staff->spacing;

	i = 0;
	while(i < symbols->length) {

		currSymbol	= (symbol_t*) linked_list_getIndexData(symbols, i);
		right1		= (int32_t) currSymbol->right;
		height1		= (int32_t) currSymbol->height;
		top1		= (int32_t) currSymbol->top;

		minDist		= 0xFFFF;
		closestSymb	= -1;

		for(j=0; j<symbols->length; j++) {
			if (j != i) {
				cmpSymbol	= (symbol_t*) linked_list_getIndexData(symbols, j);
				left2		= (int32_t) cmpSymbol->left;
				height2		= (int32_t) cmpSymbol->height;
				top2		= (int32_t) cmpSymbol->top;

				currDist	= (uint16_t)	(((top1+(height1+1)/2)-(top2+(height2+1)/2))*((top1+(height1+1)/2)-(top2+(height2+1)/2))) +
											((right1-left2)*(right1-left2));
				if (left2-right1 > 0 && currDist < minDist) {   // symbol2 is located just to the right
					minDist		= currDist;
					closestSymb	= j;
				}
			}
		}

		if(closestSymb != -1) {

			closestSymbol	= (symbol_t*) linked_list_getIndexData(symbols, closestSymb);
			height2			= closestSymbol->height;
			top2			= closestSymbol->top;

			// WORK WITH THESE THRESHOLDS
			if (	(minDist < (3*line_spacing*line_spacing)>>8) &&
					(abs_int32(height1-height2) < (((2*line_spacing)/3)>>4)) &&
					(abs_int32(top1-top2) < ((2*line_spacing)>>4))
				) {

				if (closestSymb > i){
					closestSymbol->left	= currSymbol->left;
					if (currSymbol->top < closestSymbol->top) {
						closestSymbol->top	= currSymbol->top;
					}
					if (currSymbol->bottom > closestSymbol->bottom) {
						closestSymbol->bottom	= currSymbol->bottom;
					}
					closestSymbol->height	= closestSymbol->bottom - closestSymbol->top + 1;
					closestSymbol->width	= closestSymbol->right - closestSymbol->left + 1;

					linked_list_deleteIndexData(symbols, i);

				} else {
					currSymbol->right	= closestSymbol->right;
					if (closestSymbol->top < currSymbol->top) {
						currSymbol->top	= closestSymbol->top;
					}
					if (closestSymbol->bottom > currSymbol->bottom) {
						currSymbol->bottom	= closestSymbol->bottom;
					}
					currSymbol->height	= currSymbol->bottom - currSymbol->top + 1;
					currSymbol->width	= currSymbol->right - currSymbol->left + 1;

					linked_list_deleteIndexData(symbols, closestSymb);
				}
				i = i-1;
			}
		}
		i = i+1;
	}
}
