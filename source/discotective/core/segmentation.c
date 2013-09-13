#include "global.h"
#include "allocate.h"
#include "flex_array.h"
#include "general_functions.h"
#include "linked_list.h"
#include "image_functions.h"
#include "segmentation.h"
#include "platform_specific.h"
#include <stdio.h>

sheet_t* staff_segment_simple (const image_t *img) {
	float			thresh;
	uint16_t		i;
	uint16_t		num_lines;
	uint16_t		num_staffs;
	uint16_t		spacing_est;
	uint16_t		top_bound;
	uint16_t		bottom_bound;
	uint16_t		top_line;
	uint16_t		bottom_line;
	uint16_t*		staff_begin_end;
	uint16_t*		last_line, *next_line;
//	int16_t			max_test;
	flex_array_t*	yproj;
	flex_array_t*	all_peaks;
	flex_array_t*	staff_lines;
	flex_array_t*	staff_lines_diff;
	linked_list*	groupings;
	sheet_t*		sheet;
#ifdef DEBUG_STAFF_SEGMENT
image_t*		test_img;
int				j;
#endif
	

#ifdef DEBUG_STAFF_SEGMENT
test_img	= binary_image_create(img->height, img->width);
binary_image_whiteout(test_img);
binary_image_copy(img, test_img, 0, 0);
#endif
	
	yproj		= project_on_Y(img);

#ifdef DEBUG_STAFF_SEGMENT
flex_array_display(yproj, 1);
#endif

	thresh		= 0.41F * (float) flex_array_max(yproj);
	
	// find all indices in yprojection greater than threshold
	all_peaks = flex_array_find(yproj, round_16(thresh), greater);
	if (all_peaks == NULL) {
		segment_staff_no_lines_found();
	}
	
	// don't need the full projection anymore
	flex_array_delete(&yproj);
	
	// group together all peaks within 2 pixels of each other
	// (segment each line as a whole identity)
	groupings	= linked_list_group (all_peaks, 2);
	
	if (groupings->length == 0) {
		// something is wrong, no chance of getting staffs
		trigger_error();
	}

	staff_lines	= flex_array_create_noinit(groupings->length);
	
	flex_array_delete(&all_peaks);
	
	i = 0;
	// put the mid point of every line in a flex array
	while (!linked_list_is_empty(groupings)) {
		staff_begin_end	= (uint16_t*) linked_list_pop_top(groupings);

#ifdef DEBUG_STAFF_SEGMENT
// draw on grouping lines
for (j=0; j<test_img->width; j++) {
	setPixel(test_img, j, staff_begin_end[0], BLACK);
	setPixel(test_img, j, staff_begin_end[1], BLACK);
	setPixel(test_img, j, (staff_begin_end[0] + staff_begin_end[1]+1) / 2, (pixel_color_e) (j & 0x2));
}
#endif
		
		// take average of beginning and end of staff line
		staff_lines->data[i] = (staff_begin_end[0] + staff_begin_end[1]+1) / 2;
		i++;
		free(staff_begin_end);
	}

	linked_list_delete(groupings);
	
	// find spacing between each line and get estimated line spacing (median)
	staff_lines_diff	= flex_array_diff(staff_lines);
	spacing_est			= flex_array_median(staff_lines_diff);
		
	flex_array_delete(&staff_lines_diff);
	
	// now group lines together so that an entire staff will be considered
	// one identity
	groupings = linked_list_group_indices(staff_lines, (5*spacing_est+1)/2);
	
	// get room for the staff structs
	sheet			= (sheet_t*) malloc(sizeof(sheet_t));
	sheet->staffs	= (staff_t*) malloc(sizeof(staff_t) * groupings->length);
	
	num_staffs	= 0;
	for (i=0; i<groupings->length; i++) {
		
		staff_begin_end	= (uint16_t*) linked_list_getIndexData(groupings,i);
		num_lines		= staff_begin_end[1] - staff_begin_end[0] + 1;	// number of lines found to be part of one staff
		
		if (num_lines > 2) {
			// we found at least 3 lines, so we consider it a good staff
			top_line 	= staff_lines->data[staff_begin_end[0]];
			bottom_line = staff_lines->data[staff_begin_end[1]];
			// get top bound
			if (num_staffs == 0) {
				top_bound	= subtract_u16(top_line, (7*spacing_est)/2);
		//		if ((int16_t) top_line - (int16_t) (7*spacing_est)/2 < 0) {
		//			top_bound = 0;
		//		} else {
		//			top_bound = top_line - (7*spacing_est)/2;
		//		}
			} else {
				last_line = (uint16_t*) linked_list_getIndexData(groupings, i-1);
				// average between top line of current staff and bottom line of last staff
				top_bound = (top_line + staff_lines->data[last_line[1]]) / 2;
			}
			
			// get bottom bound
			if (i == groupings->length - 1) {
				bottom_bound	= min_u16(bottom_line + (7*spacing_est)/2, img->height-1);
			} else {
				next_line		= (uint16_t*) linked_list_getIndexData(groupings, i+1);
				// average between bottom line of current staff and top line of next staff
				bottom_bound	= (bottom_line + staff_lines->data[next_line[0]]) / 2;
			}
			
		//	if (bottom_bound > img->height - 1)  bottom_bound = img->height - 1;
			
			sheet->staffs[num_staffs].top_bound			= top_bound;
			sheet->staffs[num_staffs].bottom_bound		= bottom_bound;
			
			// initialize, should be corrected later
			sheet->staffs[num_staffs].height			= 0;
			sheet->staffs[num_staffs].line_thickness	= 0.0F;
			sheet->staffs[num_staffs].line_spacing		= 0.0F;
			sheet->staffs[num_staffs].stafflines[0]		= 0.0F;
			sheet->staffs[num_staffs].stafflines[1]		= 0.0F;
			sheet->staffs[num_staffs].stafflines[2]		= 0.0F;
			sheet->staffs[num_staffs].stafflines[3]		= 0.0F;
			sheet->staffs[num_staffs].stafflines[4]		= 0.0F;
			
			num_staffs++;

#ifdef DEBUG_STAFF_SEGMENT
// draw on staff bounds
for (j=0; j<test_img->width; j++) {
	setPixel(test_img, j, top_bound, (pixel_color_e) (j & 0x10));
	setPixel(test_img, j, bottom_bound, (pixel_color_e) (j & 0x10));
}
#endif
		}
	}
	
	linked_list_delete(groupings);
	flex_array_delete(&staff_lines);
	
	// set thickness to 0 for now. there is another function that figures it out later
	sheet->num_staffs	= num_staffs;
	sheet->ts_den		= 0;
	sheet->ts_num		= 0;
	sheet->ks			= 0;
	sheet->ks_end_x		= 0;

#ifdef DEBUG_STAFF_SEGMENT
binary_image_display(test_img);
binary_image_delete(&test_img);
#endif
	
	return sheet;
}

// simple function to trim excess
// space from left and right edges of staff
// adds two pixels of padding to each side
void trim_staff (image_t** in_img) {
	image_t*		img;
	uint16_t		i;
	flex_array_t*	proj_x;
//	int16_t			threshold;
	uint16_t		left_crop		= 0;
	uint16_t		right_crop		= 0;
//	uint16_t		top_crop		= 0;
//	uint16_t		bottom_crop		= 0;

	img		= *in_img;
	proj_x	= project_on_X(img);

#ifdef DEBUG_TRIM_STAFF
flex_array_display(proj_x, 0);
#endif

	// start in the middle and go out
	// the lines are still on it, so there won't be a x projection that is white until the edges
	for (i=0; i<img->width/2; i++) {
		if (left_crop == 0 && proj_x->data[img->width/2 - i] == 0) {
			left_crop = img->width/2 - i;
		}

		if (right_crop == 0 && proj_x->data[img->width/2 + i] == 0) {
			right_crop = img->width/2 - i;
		}
	}

		
	// figure out how much to crop off the left and right
//	threshold = (*img)->height / 50.0F;
/*	threshold = round_16(0.25F * (*img)->height);
	
	for (i=0; i<((*img)->width+1)/3; i++) {
		if (left_crop == 0 && proj_x->data[i] >= threshold) {
			left_crop = i;
		}
		
		if (right_crop == 0 && proj_x->data[(*img)->width - i - 1] >= threshold) {
			right_crop = i;
		}
	}

	// backoff until we hit white
	for (i=left_crop; i>0; i--) {
		if (proj_x->data[i] < 4) {
			left_crop	= i;
			break;
		}
	}

	for (i=right_crop; i>0; i--) {
		if (proj_x->data[(*img)->width - 1 - i] < 4) {
			right_crop	= i;
			break;
		}
	}*/
	
	//leave 2 padding in each dimension
	left_crop	= subtract_u16(left_crop, 2);
	right_crop	= subtract_u16(right_crop, 2);
	
	// do the actual crop
	crop(in_img, left_crop, right_crop, 0, 0);

	flex_array_delete(&proj_x);
}

// puts the specified staff in out_img
void get_staff_img (const image_t* img, image_t** out_img, staff_t* staff) {

	*out_img	= get_sub_img(img, staff->top_bound, staff->bottom_bound, -1, -1);
	
	// trim off whitespace off the left and right, leave 2 pixel padding
	trim_staff(out_img);
	
	// set the thickness and spacing properties
	set_line_width_and_spacing(*out_img, staff);
}

void set_line_width_and_spacing (const image_t *img, staff_t* staff) {
	
	/// OVERVIEW ///
	// this code finds an average thickness for stafflines.
	// it does so by sweeping down 16 separate columns.
	// in the end, it essentially finds an expected value
	// of the width of the black segments crosses.
	
	uint16_t		i;
	uint16_t		row, col;
	uint16_t		accum, sum;
	uint16_t		white_length, black_length;
	uint16_t		max, start, end;
	uint16_t		sample_locations[NUM_X_SAMPLES];	// x position for the columns we are going to look at
	uint16_t		white_histo_max_index;
	uint16_t		black_histo_max_index;
	flex_array_t*	white_histo;
	flex_array_t*	black_histo;
#ifdef DEBUG_FIND_LINE_WIDTH_SPACING
image_t*	test_img;
int			j;
#endif

#ifdef DEBUG_FIND_LINE_WIDTH_SPACING
test_img = binary_image_create(img->height, img->width);
binary_image_whiteout(test_img);
binary_image_copy(img, test_img, 0, 0);
#endif

	// initialize x sample locations
	for (i=0; i<NUM_X_SAMPLES; i++) {
		sample_locations[i] = (i * (img->width/NUM_X_SAMPLES)) + img->width/(NUM_X_SAMPLES*2);
	}
	
	// create arrays to hold the length of various runs
	// worst case the runs are all 1 pixel long and there are img->height/2 of them
	white_histo = flex_array_create(img->height+1);
	black_histo = flex_array_create(img->height+1);
	
	for (i=0; i<NUM_X_SAMPLES; i++) {
		
		col = sample_locations[i];
		row = 0;
		
		while (row < img->height) {
			// whitespace
			white_length = 0;
			while (row < img->height && getPixel(img, col, row) == 0) {
				white_length++;
				row++;
			}
			
			// black run
			black_length = 0;
			while (row < img->height && getPixel(img, col, row) == 1) {
				black_length++;
				row++;
			}
			
			// store the lengths we just found
			white_histo->data[white_length]++;
			black_histo->data[black_length]++;
			
		}
#ifdef DEBUG_FIND_LINE_WIDTH_SPACING
for (j=0; j<test_img->height; j++) {
	setPixel(test_img, col, j, !getPixel(img, col, j));
}
#endif
	}

#ifdef DEBUG_FIND_LINE_WIDTH_SPACING
binary_image_display(test_img);
binary_image_delete(&test_img);
#endif
	
	// do the histograms
	// set the length of the array properly
	
	// find the bin (length of a black and white run) with the maximum number of instances
	max						= 0;
	white_histo_max_index	= 0;
	for (i=1; i<white_histo->length; i++) {
		if (white_histo->data[i] > max) {
			white_histo_max_index	= i;
			max						= white_histo->data[i];
		}
	}
	
	max						= 0;
	black_histo_max_index	= 0;
	for (i=1; i<black_histo->length; i++) {
		if (black_histo->data[i] >= max) {
			black_histo_max_index	= i;
			max						= black_histo->data[i];
		}
	}
	
	// find the average value surrounding the most populated bin
	// white first
	start = subtract_u16(white_histo_max_index, 2);
	if (start < 1) {
		start = 1;
	}
	
	end = white_histo_max_index + 2;
	if (end >= white_histo->length) {
		end = white_histo->length - 1;
	}
	
	accum	= 0;
	sum		= 0;
	for (i=start; i<=end; i++) {
		accum	+= i * 	white_histo->data[i];
		sum		+= 		white_histo->data[i];
	}
	
	staff->line_spacing	= (float) accum / (float) sum;
	
	// black second
	start = subtract_u16(black_histo_max_index, 2);
	if (start < 1) {
		start = 1;
	}
	
	end = black_histo_max_index + 2;
	if (end >= black_histo->length) {
		end = black_histo->length - 1;
	}
	
	accum	= 0;
	sum		= 0;
	for (i=start; i<=end; i++) {
		accum	+= i * black_histo->data[i];
		sum		+= black_histo->data[i];
	}
	
	staff->line_thickness	= (float) accum / (float) sum;
	
	flex_array_delete(&white_histo);
	flex_array_delete(&black_histo);
}

// cuts out small image around stem/measure marker
image_t* note_cutout (const image_t* img, uint16_t top, uint16_t bottom, uint16_t xbegin, uint16_t xend, const staff_t* staff, note_cuts_t* cuts) {
	uint16_t		extend;
	uint16_t		count;
	uint16_t		first_cut_left, first_cut_right;
	uint16_t		left_start;
	uint16_t		count_thresh;
	int16_t			i;
	int16_t			top_cut, bottom_cut, left_cut, right_cut;
	float			line_w;
	flex_array_t*	proj;
	image_t*		out_img;
	

	line_w			= staff->line_thickness + staff->line_spacing;
	
	// extend: the max amount to look left and right
	// count_thresh: the min amount of white needed to say we found the entire note
	extend			= round_u16(1.4F * line_w);
	count_thresh	= round_u16(0.4F * line_w);
	
	// check for <0 and >width
	// first_cut_left tells us the first "left cut" for the smaller image
	first_cut_left	= subtract_u16(xbegin, extend);
	left_start		= min_u16(xbegin, extend);
	first_cut_right	= min_u16(img->width-1, xbegin + extend);

	// get the projection on x of that image
	proj	= project_on_X_partial(img, subtract_u16(top, 10), min_u16(bottom+10, img->height-1));
	
	// figure out the left bound
	// loop through projection going left starting at the left side
	//	of the vertical line
	// set threshold at 0.4 * line width
	count	= 0;
	for (i=xbegin; i>=first_cut_left; i--) {
		if (proj->data[i] < 3) {
			count++;
		} else {
			count = 0;
		}
		if (count >= count_thresh) {
			// we found a long enough run of whitespace
			break;
		}
	}
	// reset leftCut back to where the run of white started
	left_cut	= subtract_u16(i + count, 1);
	
	// right cut
	count	= 0;
	for (i=xend; i<=first_cut_right; i++) {
		if (proj->data[i] < 3) {
			count++;
		} else {
			count = 0;
		}
		if (count >= count_thresh) {
			// we found a long enough run of whitespace
			break;
		}
	}
	// reset leftCut back to where the run of white started
	right_cut	= min_u16(i - count, img->width-1);
	
	flex_array_delete(&proj);
	
	// now look at the top and bottom cut positions
	// move the top up and bottom down to include more of the note
	// while looking in the left to right region found above.
	
	// get the projection on y of that image
	proj = project_on_Y_partial(img, left_cut, right_cut);
	
	// look above the image until a lot of white is found
	for (i=top; i>0; i--) {
		if (proj->data[i] == 0) break;
	}
	top_cut = i + 1;
	
	// look below the image until a lot of white is found
	for (i=bottom; i<proj->length; i++) {
		if (proj->data[i] == 0) break;
	}
	bottom_cut = i - 1;

	flex_array_delete(&proj);
	
	top_cut		= max_16(top_cut, 0);
	bottom_cut	= min_16(bottom_cut, img->height-1);
	left_cut	= max_16(left_cut, 0);
	right_cut	= min_16(right_cut, img->width-1);
	
	cuts->bottom_cut	= bottom_cut;
	cuts->left_cut		= left_cut;
	cuts->right_cut		= right_cut;
	cuts->top_cut		= top_cut;
	
	// output - cut box
	out_img	= get_sub_img(img, top_cut, bottom_cut, left_cut, right_cut);

	return out_img;
}
