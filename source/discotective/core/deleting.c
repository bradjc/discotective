// functions that delete symbols and whatnot from the staff

#include "global.h"
#include "deleting.h"
#include "linked_list.h"
#include "image_functions.h"
#include "general_functions.h"
#include "platform_specific.h"
#include "allocate.h"
#include "classification.h"
#include <stdlib.h>

// Use blob kill to remove the cleff
void remove_cleff (image_t* img, staff_t* staff) {

	uint16_t		i;
	uint16_t		start_y;

	// set start y by the middle staff line
	if (staff == NULL) {
		start_y	= img->height/2;
	} else {
		start_y	= round_u16(staff->stafflines[2]);
	}

	// delete the cleff
	for (i=0; i<img->width; i++) {
		if (getPixel(img, i, start_y)) {
			blob_kill(img, i, start_y, -1, -1, -1, -1);
			break;
		}
	}
	
	// save the starting x location
	staff->cleff_start_x	= i;
}

void remove_notes_measures (image_t* img, const linked_list* notes, const linked_list* measures, const staff_t* staff) {
	float			line_thickness, line_spacing, line_w;
	uint16_t		line_w_u16;
	uint16_t		note_width;
	uint8_t			connected_sixteenth;
	uint16_t		i, j;
	uint16_t		h, w;
	int16_t			leftCut, rightCut, topCut, bottomCut;
	uint16_t		minVal, maxVal, leftVal, rightVal;
	uint16_t		cH, cW;
	uint16_t		notehead_x, notehead_y;
	uint16_t		bar_mid_x, bar_mid_y;
	note_t*			currNote;
	measure_t*		currMeasure;

#ifdef DEBUG_REMOVE_NOTES
image_t*		boxed_image;
#endif
#ifdef DEBUG_DETERMINE_PITCH
flex_array_t*	note_lines;
#endif


	h	= img->height;
	w	= img->width;

	line_thickness	= staff->line_thickness;
	line_spacing	= staff->line_spacing;
	line_w			= staff->line_thickness + staff->line_spacing;
	line_w_u16		= round_16(line_w);

#ifdef DEBUG_REMOVE_NOTES
// we need to make a copy to put make the boxed picture for debugging
boxed_image	= binary_image_create(h, w);
binary_image_whiteout(boxed_image);
binary_image_copy(img, boxed_image, 0, 0);
#endif

#ifdef DEBUG_REMOVE_NOTES
#ifdef DEBUG_DETERMINE_PITCH
note_lines	= create_midi_lines(staff);
// draw lines back on for debugging pitch
for (i=0; i<33; i++) {
	if (note_lines->data[i] < 0 || note_lines->data[i] >= (int32_t) h) continue;
	for (j=0; j<boxed_image->width; j++) {
		setPixel(boxed_image, j, (uint16_t) note_lines->data[i], BLACK);
	}
}
// draw stafflines back on
for (i=0; i<5; i++) {
	for (j=0; j<boxed_image->width; j++) {
		setPixel(boxed_image, j, round_u16(staff->stafflines[i]), (pixel_color_e) (j&0x1));
	}
}
flex_array_delete(&note_lines);
#endif
#endif


	// REMOVE STEMMED NOTES
	note_width	= round_u16(1.4F*line_w);
	minVal		= 0;
	maxVal		= 0;
	leftVal		= 0;
	rightVal	= 0;

	for (i=0; i<notes->length; i++) {
		currNote = (note_t*) linked_list_getIndexData(notes, i);

		// delete the note based on its orientation
		if (currNote->notehead_position == LEFT) {
			// note head on left
			leftCut		= currNote->begin - note_width;
			rightCut	= currNote->end + round_16(line_thickness + 1.0F);
			if (round_u16(line_thickness) > currNote->top)	topCut = 0;
			else											topCut = currNote->top - round_16(line_thickness);
			bottomCut	= currNote->bottom + round_16(1.5F*line_spacing);

			if ((currNote->duration == EIGHTH || currNote->duration == SIXTEENTH) && currNote->connected_type == SINGLE) {
				// this note is a single eighth or sixteenth note and we need to extend
				// the right cut to cut out the tail
				rightCut	+= (note_width - round_16(line_thickness));
			}
			// find a good spot to start the blob kill
			notehead_x	= currNote->begin - note_width/2;
		} else {
			if (round_u16(line_thickness) > currNote->begin)	leftCut = 0;
			else												leftCut = currNote->begin - round_16(line_thickness);
			rightCut	= currNote->end + note_width;
			topCut		= currNote->top - round_16(1.5F*line_spacing);
			bottomCut	= currNote->bottom + round_16(line_thickness);
			// find a good spot to start the blob kill
			notehead_x	= currNote->begin + note_width/2;
		}

		if (leftCut < 0)		leftCut		= 0;
		if (rightCut > w-1)		rightCut	= w-1;
		if (topCut < 0)			topCut		= 0;
		if (bottomCut > h-1)	bottomCut	= h-1;

		// find a good spot to start the blob kill
		notehead_y	= currNote->center_of_mass;

		// if half note, need to connect the ring for blob kill to work
		if (currNote->duration == HALF) {
			reconnect_half_note(img, currNote, leftCut, rightCut);
		}


#ifdef DEBUG_REMOVE_NOTES
// box the note
for (cH=(uint16_t)topCut; cH<=(uint16_t)bottomCut; cH++) {
	for (cW=(uint16_t)leftCut; cW<=(uint16_t)rightCut; cW++) {
		if (cW == leftCut || cW==rightCut || cH==topCut || cH==bottomCut) {
			setPixel(boxed_image, cW, cH, BLACK);
		}
	}
}
// mark the center of mass
for (cW=(uint16_t)leftCut; cW<=(uint16_t)rightCut; cW++) {
	setPixel(boxed_image, cW, currNote->center_of_mass, WHITE);
}
#endif

		// delete the note
		blob_kill(img, notehead_x, notehead_y, leftCut, rightCut, topCut, bottomCut);


		// handle deleting a possible bar
		// check to see if its a connected note
		if (currNote->connected_type == START) {

			// save some information about this note so we know where to delete the connector
			leftVal = currNote->begin - round_u16(0.1667F*line_w);
			if (currNote->notehead_position == LEFT) {
				minVal	= currNote->top;
				maxVal	= currNote->top;
			} else {
				minVal	= currNote->bottom;
				maxVal	= currNote->bottom;
			}

			// if the start is a sixteenth we need to record that to make sure the box will be big enough
			connected_sixteenth	= (currNote->duration == SIXTEENTH);

		} else if (currNote->connected_type == END) {

			connected_sixteenth	= (currNote->duration == SIXTEENTH);

			// set top and bottom
			if (currNote->notehead_position == LEFT) {
				// bar is on top

				if (currNote->top > maxVal) {
					// bar is sloping downward
					maxVal	= currNote->top;
				}
				if (connected_sixteenth) {
					maxVal	+= line_w_u16;
				}

				minVal	= min_u16(minVal, currNote->top);
			} else {
				// bar is on bottom
				if (currNote->bottom < minVal) {
					// bar is sloping upwards
					minVal	= currNote->bottom;
				}
				if (connected_sixteenth) {
					minVal	-= line_w_u16;
				}

				maxVal	= max_u16(maxVal, currNote->bottom);
			}

			// box in the bar
			leftCut		= leftVal;
			rightCut	= currNote->end + round_16(0.1667F*line_w);
			topCut		= minVal - line_w_u16;
			bottomCut	= maxVal + line_w_u16;

			if (leftCut < 0)  		leftCut		= 0;
			if (rightCut > w-1) 	rightCut	= w-1;
			if (topCut < 0) 		topCut		= 0;
			if (bottomCut > h-1)	bottomCut	= h-1;

			// find a spot to start the blob kill
	//		bar_mid_x	= (rightCut + leftCut) / 2;
	//		bar_mid_y	= (bottomCut + topCut) / 2;
	//		// now scan up and down until we hit black
	//		for (j=bar_mid_y; j<=bottomCut; j++) {
	//			if (getPixel(img, bar_mid_x, j)) {
	//				bar_mid_y	= j;
	//				break;
	//			}
	//			if (getPixel(img, bar_mid_x, j-(j-bar_mid_y))) {
	//				bar_mid_y	= j-(j-bar_mid_y);
	//				break;
	//			}
	//		}

#ifdef DEBUG_REMOVE_NOTES
	for (cH=topCut; cH<=bottomCut; cH++) {
		for (cW=leftCut; cW<=rightCut; cW++) {
			if (cW==leftCut || cW==rightCut || cH==topCut || cH==bottomCut) {
				if ((cH == topCut || cH == bottomCut) && (cW & 0x1)) continue;
				setPixel(boxed_image, cW, cH, BLACK);
			} 
		}
	}
#endif

			// delete the bar
	//		blob_kill(img, bar_mid_x, bar_mid_y, leftCut, rightCut, topCut, bottomCut);
			for (cH=topCut; cH<=bottomCut; cH++) {
				for (cW=leftCut; cW<=rightCut; cW++) {
					setPixel(img, cW, cH, WHITE);
				}
			}

			// reset the 16th marker
			connected_sixteenth	= 0;

		} else if (currNote->duration == SIXTEENTH) {
			// mark this so we know in case we care later
			connected_sixteenth	= 1;
		}

	}

	// delete measure lines

	for (i=0; i<measures->length; i++) {
		currMeasure = (measure_t*) linked_list_getIndexData(measures, i);

		if (round_16(line_thickness) > currMeasure->begin)	leftCut = 0;
		else											leftCut = currMeasure->begin - round_16(line_thickness);
		rightCut	= currMeasure->end + round_16(line_thickness);
		if (staff->stafflines[0] - 2.0*line_thickness < 0)	topCut = 0;
		else												topCut = round_16(staff->stafflines[0] - 2.0F*line_thickness);
		bottomCut	= round_16(staff->stafflines[4] + 2.0F*line_thickness);

		if (leftCut < 0)  		leftCut		= 0;
		if (rightCut > w-1) 	rightCut	= w-1;
		if (topCut < 0) 		topCut		= 0;
		if (bottomCut > h-1)	bottomCut	= h-1;

		// find a good spot to start blob kill
		bar_mid_x	= (rightCut + leftCut) / 2;
		bar_mid_y	= (bottomCut + topCut) / 2;

		if (currMeasure->type != NORMAL) {
			// this is some sort of repeat measure, which means it is huge
			// draw a line left to right to connect the two bars
			for (j=leftCut+3; j<rightCut-3; j++) {
				setPixel(img, j, bar_mid_y, BLACK);
			}
		}

#ifdef DEBUG_REMOVE_NOTES
	for (cH=topCut; cH<=bottomCut; cH++) {
		for (cW=leftCut; cW<=rightCut; cW++) {
			if (cW == leftCut || cW==rightCut || cH==topCut || cH==bottomCut || cW == leftCut+1 || cW==rightCut-1 || cH==topCut+1 || cH==bottomCut-1) {
				setPixel(boxed_image, cW, cH, BLACK);
			}
		}
	}
	if (currMeasure->type != NORMAL) {
		for (cW=leftCut+3; cW<rightCut-3; cW++) {
			setPixel(boxed_image, cW, bar_mid_y, BLACK);
		}
	}
#endif

		// remove the measure line
		blob_kill(img, bar_mid_x, bar_mid_y, leftCut, rightCut, topCut, bottomCut);

	}

#ifdef DEBUG_REMOVE_NOTES
binary_image_display(boxed_image);
binary_image_delete(&boxed_image);
#endif

}

// Replaces remove_staff_lines and fix_remove_lines
// Doesn't cut the staff up and look at segments at a time.
// It scans through and adjusts the staff to make it horizontal on a pixel-column
//	by pixel-column basis.
void remove_staff_lines (image_t* img, staff_t* staff) {
	// initialize stafflines to a 5 elt array
	uint16_t		h, w;
	uint16_t		line_w;
	flex_array_t*	proj_y;

//	uint16_t		lines_found;
//	uint16_t		max_val, max_loc;
//	uint16_t		stafflines_first_guess_tmp[10];
//	staffline_t		stafflines_first_guess[5];

	uint16_t		i, j;//, ii;

	uint8_t			found_starting_stafflines;
	uint16_t		start_slice_width;
	int16_t			max_val;
	int16_t*		temp_ptr_16;
	flex_array_t*	stafflines_guess_fa;
	linked_list*	stafflines_guess_ll;
	staffline_t		stafflines[5];

	float			stafflines_mid_start[5];	// the indicies of stafflines we guessed. used to line everything up
	float			stafflines_mid[5];			// the indicies of the stafflines in the current column. used to find the stafflines in the next column
	float			total_staffline_diff;
	uint8_t			total_staffline_removed;

	uint16_t		sl_index;
	uint16_t		y_start;
	uint16_t		extend;
	uint8_t			hit_black_top, hit_black_bot;
	uint16_t		top_bound, bot_bound;
	flex_array_t**	thickness_array;
	float			thickness_threshold_start;
	float			thickness_threshold;
//	uint8_t			row_of_white;
//	uint16_t		thickness_threshold_l;
//	uint16_t		thickness_threshold_t;
	uint16_t		thickness;
	uint8_t			last_delete[5];
	int16_t			vertical_adjustment;
	int16_t			previous_move;
	flex_array_t*	vertical_adjustments;
#ifdef DEBUG_REMOVE_STAFF_LINES
image_t*		test_img;
image_t*		copy_img;
#endif


//	image_t*		temp_img = NULL;

		
	h			= img->height;
	w			= img->width;
	line_w		= round_u16(staff->line_thickness + staff->line_spacing);

	thickness_threshold_start	= staff->line_thickness * 1.65F;
//	thickness_threshold_l	= round_u16(staff->line_thickness*1.65F + 1.0F);	// loose
//	thickness_threshold_t	= round_u16(staff->line_thickness*1.65F);			// tight
	
#ifdef DEBUG_REMOVE_STAFF_LINES
test_img	= binary_image_create(h, w);
binary_image_whiteout(test_img);
binary_image_copy(img, test_img, 0, 0);
copy_img	= binary_image_create(h, w);
binary_image_whiteout(copy_img);
binary_image_copy(img, copy_img, 0, 0);
#endif

//	proj_y		= project_on_Y(img);

	
	// try to find a first guess on staff lines by using a projection
	// of half of the image
/*	proj_y		= project_on_Y_partial(img, 0, (uint16_t) (w/2));
#ifdef DEBUG_REMOVE_STAFF_LINES
flex_array_display(proj_y, 1);
#endif
	for (lines_found=0; lines_found<5; lines_found++) {
		// start each by looking at the current maximum
		max_val	= (uint16_t) flex_array_max(proj_y);
		max_loc	= flex_array_max_index(proj_y);
			
		// all y coordinates of a line that is part of same staff line
		// clear out projection values around the maximum so they don't get hit again
		line_y_top_guess	= subtract_u16(max_loc, (line_w+1) / 3);
		line_y_bottom_guess	= min_u16(max_loc + ((line_w+1) / 3), h-1);
		
		// loop through looking at the projection where we think a line is
		// set the line where it is .9 of the maximum
		line_y_top = 0;
		for (i=line_y_top_guess; i<=line_y_bottom_guess; i++) {
			if (proj_y->data[i] >= (9*max_val) / 10) {
				if (line_y_top == 0) {
					line_y_top = i;
				}
				line_y_bottom = i;
			}
			// erase to avoid line in further iterations
			proj_y->data[i] = 0;
		}
	
		// set the stafflines to the bounds we found
		stafflines_first_guess_tmp[2*linesFound]	= line_y_top;
		stafflines_first_guess_tmp[2*linesFound+1]	= line_y_bottom;
	}
	flex_array_delete(&proj_y);
	// sort because the loop up there guarantees no order
	quickSort(stafflines_first_guess, 0, 9);
	// copy the raw data into a nicer array
	for (i=0; i<5; i++) {
		stafflines_first_guess[i].top_bound = stafflines_tmp[2*i];
		stafflines_first_guess[i].bot_bound = stafflines_tmp[2*i + 1];
	}*/



	// Try to find the starting y indicies of the staff lines
	// Do this by taking a projection of larger and larger slices until
	//	we get a grouping that looks like staff lines
	found_starting_stafflines	= 0;
	for (start_slice_width=75; start_slice_width<w; start_slice_width+=50) {
		proj_y				= project_on_Y_partial(img, 0, start_slice_width);
#ifdef DEBUG_REMOVE_STAFF_LINES
flex_array_display(proj_y, 1);
#endif
		max_val				= flex_array_max(proj_y);
		stafflines_guess_fa	= flex_array_find(proj_y, (66*max_val)/100, greater_equal);
		stafflines_guess_ll	= linked_list_group(stafflines_guess_fa, 3);

		flex_array_delete(&proj_y);
		flex_array_delete(&stafflines_guess_fa);

		if (stafflines_guess_ll->length == 5) {
			// we found a promising start for our staff lines
			found_starting_stafflines	= 1;
			// copy the staff lines to a better array
			for (i=0; i<5; i++) {
				temp_ptr_16	= (int16_t*) linked_list_pop_top(stafflines_guess_ll);
				stafflines[i].top_bound	= temp_ptr_16[0];
				stafflines[i].bot_bound	= temp_ptr_16[1];
				free(temp_ptr_16);
			}
			linked_list_delete(stafflines_guess_ll);
			break;
		}
		linked_list_delete(stafflines_guess_ll);
	}

	if (!found_starting_stafflines) {
		disco_log("couldn't find a start to the staff lines, this is bad");
		exit(-1);
	}

	// create an array of middles of each staff line
	for (i=0; i<5; i++) {
		stafflines_mid_start[i]	= ((float) stafflines[i].top_bound + (float) stafflines[i].bot_bound) / 2.0F;
		stafflines_mid[i]		= stafflines_mid_start[i];
		staff->stafflines[i]	= stafflines_mid_start[i];
		last_delete[i]			= 0;
	}

	// set staff height
	staff->height	= round_u16(staff->stafflines[4] - staff->stafflines[0]);

	extend					= round_u16(0.6F*line_w + 1.0F);
	// keeps track of the vertical adjustment so when there are few stafflines in a given
	//	column (notes covering a lot of them) we can just use this as the adjustment value
	previous_move			= 0;
	vertical_adjustments	= flex_array_create(w);

	// Keep track of the found thickness of each line at each column. This lets us calculate
	//	a moving average of the recent line thicknesses, so we can adjust the line thickness
	//	threshold as the line changes thicknesses.
	// Do this with an array of flex arrays.
	thickness_array			= (flex_array_t**) malloc(sizeof(flex_array_t*) * 5);
	for (i=0; i<5; i++) {
		thickness_array[i]	= flex_array_create(w);
	}


	// loop through and erase pixels
	for (i=0; i<w; i++) {

		total_staffline_diff	= 0.0F;
		total_staffline_removed	= 0;

		// loop through each staff line
		for (sl_index=0; sl_index<5; sl_index++) {
			y_start			= round_u16(stafflines_mid[sl_index]);
			top_bound		= 0;
			bot_bound		= h - 1;
			hit_black_top	= 0;		// we need to find the staffline first. jitteryness sometimes means that our guess for the staff line is wrong
			hit_black_bot	= 0;

#ifdef DEBUG_REMOVE_STAFF_LINES
setPixel(test_img, i, y_start, WHITE);
#endif

			// look up determining where the top of the staff line is
			for (j=min_u16(y_start+2, h-1); j>subtract_u16(y_start, extend);  j--) {

				if (getPixel(img, i, min_u16(h-1, j+1)) && !getPixel(img, i, j)) {
					// there must be a black pixel below this one
					// we must be on a white pixel

								// pixels left right and above
					if (	(!getPixel(img, subtract_u16(i, 1), j) &&	// pixel to the left
							!getPixel(img, min_u16(w-1, i+1), j) &&												// pixel to the right
							!getPixel(img, i, subtract_u16(j, 1)))												// pixel above
							||	// two above
							(!getPixel(img, i, subtract_u16(j, 1)) &&
							!getPixel(img, i, subtract_u16(j, 2)))
							||	// two to the right
							(!getPixel(img, min_u16(w-1, i+1), j) &&
							!getPixel(img, min_u16(w-1, i+2), j))
							||	// two to the left
							(!getPixel(img, subtract_u16(i, 1), j) &&
							!getPixel(img, subtract_u16(i, 2), j))
						) {

						top_bound	= j + 1;
						break;
					}
				}
			}

			// look down determining where the bottom of the staff line is
			for (j=subtract_u16(y_start, 2); j<min_u16(y_start + extend, h-2);  j++) {

				if (getPixel(img, i, subtract_u16(j, 1)) && !getPixel(img, i, j)) {

					if (	(!getPixel(img, subtract_u16(i, 1), j) &&	// pixel to the left
							!getPixel(img, min_u16(w-1, i+1), j) &&												// pixel to the right
							!getPixel(img, i, min_u16(h-1, j+1)))												// pixel above
							||	// two below
							(!getPixel(img, i, min_u16(h-1, j+1)) &&
							!getPixel(img, i, min_u16(h-1, j+2)))
							||	// two to the right
							(!getPixel(img, min_u16(w-1, i+1), j) &&
							!getPixel(img, min_u16(w-1, i+2), j))
							||	// two to the left
							(!getPixel(img, subtract_u16(i, 1), j) &&
							!getPixel(img, subtract_u16(i, 2), j))
						) {

						bot_bound	= j - 1;
						break;
					}
				}
			}
			

			// check to see if the line thickness we found is in the proper range to be a staffline
			thickness	= bot_bound - top_bound + 1;

			// calculate thresholds
			if (i > 100) {
				// do this when we have enough samples to use
				thickness_threshold	= flex_array_mean_float_pastx_skipzeros(thickness_array[sl_index], i-1, 75) + 0.5F;
			} else {
				thickness_threshold	= thickness_threshold_start;
			}
			// if we deleted last time for this staffline, use the larger threshold, otherwise use the tighter threshold
	//		if (last_delete[sl_index]) {
			thickness_threshold	+= 1.0F;
	//		}

			if (thickness <= round_u16(thickness_threshold)) {
				// erase the staffline
				for (j=top_bound; j<=bot_bound; j++) {
					setPixel(img, i, j, WHITE);
				}
				last_delete[sl_index]	= 1;

				// add on how much different the center of the line we found was from the line
				//	we found before. this is to line everything up later
				total_staffline_diff	+= ((((float) bot_bound + (float) top_bound) / 2.0F) - stafflines_mid_start[sl_index]);
				total_staffline_removed++;	

				// record the thickness for adjusting the threshold later
				thickness_array[sl_index]->data[i]	= thickness;
			} else {
				last_delete[sl_index]	= 0;
			}

		}

		// Now that we've removed all of the staff lines for this column
		//	look at the average difference between where the staff lines were this time
		//	and where they were before
		if (total_staffline_removed < 4) {
			vertical_adjustment	= previous_move;
		} else {
			vertical_adjustment	= floor_16(total_staffline_diff / (float) total_staffline_removed);
			previous_move		= vertical_adjustment;
		}

		// adjust the midpoint so we can find the lines in the next column
		for (sl_index=0; sl_index<5; sl_index++) {
			stafflines_mid[sl_index]	= stafflines_mid_start[sl_index] + (float) vertical_adjustment;
		}

		// save the vertical adjustment for adjusting later
		vertical_adjustments->data[i]	= vertical_adjustment;

		
	//	binary_image_display(img);
	}

#ifdef DEBUG_REMOVE_STAFF_LINES
binary_image_display(test_img);
// try to see the difference between the filtered adjustments and the not filtered
//flex_array_display(vertical_adjustments, 0);
//flex_array_print(vertical_adjustments);
for (i=0; i<w; i++) {
	for (j=0; j<(h - abs_16(vertical_adjustments->data[i])); j++) {
		if (vertical_adjustments->data[i] < 0) {
			// move down
			setPixel(test_img, i, h-1-j, getPixel(copy_img, i, h-1-j+vertical_adjustments->data[i]));
		} else {
			// move up
			setPixel(test_img, i, j, getPixel(copy_img, i, j+vertical_adjustments->data[i]));
		}
	}
}
binary_image_display(test_img);
#endif

	// filter the array to get rid of jagged ness
	flex_array_smoother(vertical_adjustments);

	// adjust the actual image
	for (i=0; i<w; i++) {
		for (j=0; j<(h - abs_16(vertical_adjustments->data[i])); j++) {
			if (vertical_adjustments->data[i] < 0) {
				// move down
				setPixel(img, i, h-1-j, getPixel(img, i, h-1-j+vertical_adjustments->data[i]));
#ifdef DEBUG_REMOVE_STAFF_LINES
setPixel(test_img, i, h-1-j, getPixel(copy_img, i, h-1-j+vertical_adjustments->data[i]));
#endif
			} else {
				// move up
				setPixel(img, i, j, getPixel(img, i, j+vertical_adjustments->data[i]));
#ifdef DEBUG_REMOVE_STAFF_LINES
setPixel(test_img, i, j, getPixel(copy_img, i, j+vertical_adjustments->data[i]));
#endif
			}
		}
	}

	flex_array_delete(&vertical_adjustments);

#ifdef DEBUG_REMOVE_STAFF_LINES
binary_image_display(test_img);
binary_image_delete(&test_img);
binary_image_delete(&copy_img);
#endif
	binary_image_display(img);

}

void crop_off_cleff_key_signature (image_t** img, const sheet_t *sheet, uint16_t staff_num) {
	if (sheet->ks == 0) {
		// no key signature, don't need to remove it
		*img	= get_sub_img(*img, -1, -1, sheet->staffs[staff_num].cleff_start_x + 5, -1);
	} else {
		*img	= get_sub_img(*img, -1, -1, sheet->ks_end_x + sheet->staffs[staff_num].cleff_start_x + 5, -1);
	}
}

// This function draws a line in the notehead of a half note
// so that the entire half note is connected by black pixels.
// That way it is easier to delete the half note.
// left_bound and right_bound are the bounds of the deletion box for the note
void reconnect_half_note (image_t* img, const note_t* note, uint16_t left_bound, uint16_t right_bound) {
	uint16_t		i;
	uint16_t		notehead_mid;

	notehead_mid	= note->center_of_mass;
	i				= left_bound;

	// scan right until we hit black
	// this gets us to the notehead
	while (i<=right_bound) {
		if (getPixel(img, i, notehead_mid)) {
			break;
		}
		i++;
	}

	// scan right until we hit white
	// this gets us to the start of the center of the note
	while (i<=right_bound) {
		if (!getPixel(img, i, notehead_mid)) {
			break;
		}
		i++;
	}

	// now go right drawing a line, stop if we hit black again
	while (i<=right_bound) {
		if (getPixel(img, i, notehead_mid)) {
			break;
		}
		setPixel(img, i, notehead_mid, BLACK);
		i++;
	}
#ifdef DEBUG_REMOVE_NOTES
binary_image_display(img);
#endif
}

void delete_sheet (sheet_t** sheet) {
	free((*sheet)->staffs);
	free(*sheet);
	*sheet	= NULL;
}
