#include "segmentation.h"
#include "global.h"
#include "allocate.h"
#include "flex_array.h"
#include "led.h"
#include "ssd.h"
#include "general_functions.h"
#include "linked_list.h"
#include "image_functions.h"
#include "vga.h"

//#define EXPECTED_NUM_LINES 10

staff_info* staff_segment_simple (const image16_t *img) {
	uint16_t		thresh;
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
	flex_array_t*	yproj;
	flex_array_t*	all_peaks;
	flex_array_t*	staff_lines;
	flex_array_t*	staff_lines_diff;
	linked_list*	groupings;
	staff_info*		staff;


	yproj	= project_on_Y(img);

	thresh	= (50 * flex_array_max(yproj)) / 100;

	// find all indices in yprojection greater than threshold
	all_peaks = flex_array_find(yproj, thresh, greater);
	if (all_peaks == NULL) {
		segment_staff_no_lines_found();
	}

	// don't need the full projection anymore
	flex_array_delete(yproj);

	// group together all peaks within 2 pixels of each other
	// (segment each line as a whole identity)
	groupings		= linked_list_group (all_peaks, 2);
	staff_lines		= flex_array_create_noinit(groupings->length);

	flex_array_delete(all_peaks);
	i=0;

	while(!linked_list_is_empty(groupings)) {
		staff_begin_end = linked_list_pop_top(groupings);

		// take average of beginning and end of staff line
		staff_lines->data[i] = (staff_begin_end[0] + staff_begin_end[1]+1) / 2;
		i++;
		free(staff_begin_end);
	}

	linked_list_delete_list(groupings);

	// find spacing between each line
	staff_lines_diff = flex_array_diff(staff_lines);
	// get estimated line spacing
	spacing_est = flex_array_min(staff_lines_diff);

	free(staff_lines_diff);

	// now group lines together so that an entire staff will be considered
	// one identity
	groupings = linked_list_group_indices(staff_lines, (5*spacing_est+1)/2);

	// get room for the staff structs
	staff				= (staff_info*) malloc(sizeof(staff_info));
	staff->staff_bounds	= (staff_bound*) get_spc(groupings->length, sizeof(staff_bound));

	i			= 0;
	num_staffs	= 0;
	for (i=0; i<groupings->length; i++) {

		staff_begin_end	= linked_list_getIndexData(groupings,i);
		num_lines		= staff_begin_end[1]-staff_begin_end[0]+1; // number of lines found to be part of one staff

		if (num_lines > 2) {
			// we found at least 3 lines, so we consider it a good staff
			top_line 	= staff_lines->data[staff_begin_end[0]];
			bottom_line = staff_lines->data[staff_begin_end[1]];
			// get top bound
			if (num_staffs == 0) {
				if ((int16_t) top_line - (int16_t) (7*spacing_est)/2 < 0) {
					top_bound = 0;
				} else {
					top_bound = top_line - (7*spacing_est)/2;
				}
			} else {
				last_line = linked_list_getIndexData(groupings,i-1);
				// average between top line of current staff and bottom line of last staff
				top_bound = (top_line + staff_lines->data[last_line[1]]) / 2;
			}

			// get bottom bound
			if (i == groupings->length -1) {
				bottom_bound = bottom_line + (7*spacing_est)/2;
			} else {
				next_line		= linked_list_getIndexData(groupings,i+1);
				// average between bottom line of current staff and top line of next staff
				bottom_bound	= (bottom_line + staff_lines->data[next_line[0]]) / 2;
			}

			if (bottom_bound > img->height - 1)  bottom_bound = img->height - 1;

			staff->staff_bounds[num_staffs].top_bound		= top_bound;
			staff->staff_bounds[num_staffs].bottom_bound	= bottom_bound;

			num_staffs++;
		}
	}

	linked_list_delete_list(groupings);
	flex_array_delete(staff_lines);

	// set thickness to 0 for now. there is another function that figures it out later
	staff->thickness = 0;
	staff->num_staffs = num_staffs;
	// compute average staff height:
	staff->staff_h = 4 * spacing_est;
	// initialize these
	staff->ks	= 0;
	staff->ks_x	= 0;

	return staff;
}

/*
staff_info* staff_segment (const image16_t *img) {
	uint16_t		thrsh;
	uint16_t		height;
	uint16_t		width;
	uint16_t		i;
	uint16_t		staff_counter;
	uint16_t		s_begin, s_end;
	uint16_t		all_staffs_height;		// sum of the height of all of the individual staffs
	uint16_t		staff_height_plus_padding;	// the height of the staff plus a buffer
	uint16_t		spacing_guess;
	int16_t			temp;
	flex_array_t*	proj_onto_y;
	flex_array_t*	crude_lines;
	flex_array_t*	diff_array;
	flex_array_t*	minus_array;
	flex_array_t*	compare_array;
	flex_array_t*	kill_array;
	flex_array_t*	less_crude_lines;
	flex_array_t*	diff_lines;
	flex_array_t*	test_lines;
	staff_info*		staff;

	// this code uses a projection to determine cuts for
	// segmenting a music page into individual lines of music

	height	= img->height;
	width	= img->width;

	// projection on to vertical axis
	proj_onto_y = project_on_Y(img);

	// calculate threshold
	thrsh		= (50 * flex_array_max(proj_onto_y)) / 100;

	// get the first guess by finding the rows with a lot of black pixels
	crude_lines = flex_array_find(proj_onto_y, thrsh, greater);

	if (crude_lines == NULL) {
		segment_staff_no_lines_found();
	}

	// don't need the full projection anymore
	flex_array_delete(proj_onto_y);

	// create array holding y values of all stafflines
	i = 0;

	// try to determine the number of staff lines in the image
	// iterate through the array of crude lines

	// create an array for the better estimation of staff lines
	less_crude_lines = flex_array_create(crude_lines->length);

	// keep track of the line widths

	i = 0;
	staff_counter = 0;
	// iterate through the crude lines
	while (i < crude_lines->length) {
		s_begin = crude_lines->data[i];

		// next staffline must be at least two pixels away
		while 	(	((i+1) < crude_lines->length) &&
						((crude_lines->data[i] + 1) == crude_lines->data[i+1] ||
						((crude_lines->data[i] + 2) == crude_lines->data[i+1]))
				) {
			i++;
		}
		s_end = crude_lines->data[i];

		// add staffline to array
		less_crude_lines->data[staff_counter]	= (s_begin + s_end + 1)/2;

		i++;
		staff_counter++;
	}

	// set the lengths since we skipped some work by just allocating a larger array
	less_crude_lines->length = staff_counter;

	// don't need crude_lines anymore
	flex_array_delete(crude_lines);

	// search for any incorrect lines
	// (check against others)

	diff_lines		= flex_array_diff(less_crude_lines);
	spacing_guess	= flex_array_median(diff_lines);
	flex_array_delete(diff_lines);

	// create an array of lines to get rid of
	kill_array = flex_array_create(less_crude_lines->length);

	i = 0;
	while (i <= (less_crude_lines->length-5)) {
		//can probably be efficient-ized, but will try laters

		// get the first five theoretical lines and their spacing
		test_lines		= flex_array_get_sub_array(less_crude_lines, i, i+4);
		diff_array		= flex_array_abs_diff(test_lines);
		flex_array_delete(test_lines);

		// subtract away the likely spacing value
		minus_array		= flex_array_minus(diff_array, spacing_guess);
		flex_array_delete(diff_array);
		compare_array	= flex_array_find(minus_array, spacing_guess/5, greater);
		flex_array_delete(minus_array);
		if (compare_array != NULL) {
			kill_array->data[i] = 1;
			i++;
			flex_array_delete(compare_array);
		}

		i+=5;
	}

	// get rid of any remaining lines
	while (i < less_crude_lines->length) {
		kill_array->data[i] = 1;
		i++;
	}

	// kill bad stafflines
	less_crude_lines = flex_array_kill_array_indices(less_crude_lines, kill_array);
	flex_array_delete(kill_array);

	// hopefully we found staff lines that correspond to staffs
	if (less_crude_lines->length % 5) {
		staff_segment_not_mult_of_five();
	}

	staff = (staff_info*) malloc(sizeof(staff_info));

	// set thickness to 0 for now. there is another function that figures it out
	// later
	staff->thickness	= 0;
	staff->num_staffs	= less_crude_lines->length/5;
	// get room for the staff structs
	staff->staff_bounds = (staff_bound*) get_spc(sizeof(staff_bound), less_crude_lines->length/5);

	// accumulate heights of staff for calculating global average:
	all_staffs_height = 0;
	for (i=0; i<less_crude_lines->length; i+=5) {
		all_staffs_height += less_crude_lines->data[i+4] - less_crude_lines->data[i];
	}

	// compute average staff height:
	staff->staff_h = (all_staffs_height + (staff->num_staffs/2)) / staff->num_staffs;

	// calculate a nice amount of staff padding (5/4 of staff height)
	staff_height_plus_padding = ((staff->staff_h*5) + 2)/4;

	// find staff bounds with padding and add to struct
	for (i=0; i<less_crude_lines->length; i+=5) {
		// Set the bounds of the staff to 10/4 of the height of the actual staff
		// centered around the middle of the staff
		temp = less_crude_lines->data[i+2] - staff_height_plus_padding;
		if (temp < 0) temp = 0;
		staff->staff_bounds[i/5].top_bound = temp;

		temp = less_crude_lines->data[i+2] + staff_height_plus_padding;
		if (temp >= height) temp = height - 1;
		staff->staff_bounds[i/5].bottom_bound = temp;
	}

	flex_array_delete(less_crude_lines);

	// initialize these
	staff->ks	= 0;
	staff->ks_x	= 0;

	return staff;
}
*/

void trim_staff (image16_t *img) {

	// simple function to trim excess
	// space from left and right edges of staff
	// adds two pixels of padding to each side

	alt_u16 i;
	alt_u16 pixel_count;
	alt_u16 threshold;
	alt_u16 left_crop	= 0;
	alt_u16 right_crop	= 0;
	alt_u16 top_crop	= 0;
	alt_u16 bottom_crop	= 0;


	// figure out how much to crop off the left and right
	threshold = img->height/50;

	for (i=0; i<(img->width+1)/3; i++) {
		pixel_count = project_on_X_single(img, i);
		if (pixel_count < threshold) {
			left_crop = i+1;
		}
		pixel_count = project_on_X_single(img, img->width - i - 1);

		if (pixel_count < threshold) {
			right_crop = i+1;
		}
	}

	top_crop = 0;
	bottom_crop = 0;

	//leave 2 padding in each dimension
	if (left_crop <= 1) 	left_crop = 0;
	else					left_crop -= 2;
	if (right_crop <= 1)	right_crop = 0;
	else					right_crop -= 2;
	if (top_crop <= 1)		top_crop = 0;
	else					top_crop -= 2;
	if (bottom_crop <= 1)	bottom_crop = 0;
	else					bottom_crop -= 2;

	// do the actual crop
	crop(img, img, left_crop, right_crop, top_crop, bottom_crop);
}

// puts the specified staff in out_img
void get_staff_img (const image16_t* img, image16_t* out_img, staff_info* staff, uint16_t staff_index) {
	uint16_t	top, bottom;
	uint16_t	top_with_padding;
	uint16_t	bottom_with_padding;
	uint16_t	i, j;

	if (staff_index >= staff->num_staffs) {
		bad_exit();
	}

	top		= staff->staff_bounds[staff_index].top_bound;
	bottom	= staff->staff_bounds[staff_index].bottom_bound;

	get_sub_img(img, out_img, top, bottom, -1, -1);

	trim_staff(out_img);

	// set the thickness and spacing properties
	set_line_width_and_spacing(out_img, staff);
}

void set_line_width_and_spacing (const image16_t *img, staff_info* staff) {

	/// OVERVIEW ///
	// this code finds an average thickness for stafflines.
	// it does so by sweeping down 16 separate columns.
	// in the end, it essentially finds an expected value
	// of the width of the black segments crosses.
	// CAREFUL:  line_width is in Q_4

	alt_u16			i;
	alt_u16			row, col;
	alt_u16			accum, sum;
	alt_u16			white_length, black_length;
	alt_u16			max, start, end;
	alt_u16			sample_locations[NUM_X_SAMPLES];	// x position for the columns we are going to look at
	alt_u16			white_histo_max_index;
	alt_u16			black_histo_max_index;
	flex_array_t	*white_histo;
	flex_array_t	*black_histo;

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
			while (row < img->height && getPixel(img, col, row++) == 0) {
				white_length++;
			}

			// black run
			black_length = 0;
			while (row < img->height && getPixel(img, col, row++) == 1) {
				black_length++;
			}

			// store the lengths we just found
			white_histo->data[white_length]++;
			black_histo->data[black_length]++;

		}
	}

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
		if (black_histo->data[i] > max) {
			black_histo_max_index	= i;
			max						= black_histo->data[i];
		}
	}

	// find the average value surrounding the most populated bin
	// white first
	start = white_histo_max_index - 2;
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

	staff->spacing	= (16 * accum) / sum;

	// black second
	start = black_histo_max_index - 2;
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

	staff->thickness		= (16 * accum) / sum;

	flex_array_delete(white_histo);
	flex_array_delete(black_histo);
}

void remove_lines (image16_t* img, image16_t* temp_img, uint32_t numCuts, uint32_t* stafflines, staff_info* staff) {
// initialize stafflines to a 5 elt array
	uint32_t		line_w;
	uint32_t		beginCut, endCut;
	flex_array_t	*proj_y;
	uint32_t		linesFound;
	uint32_t		*stafflines_tmp;
	uint32_t		**STAFFLINES;
	uint32_t		i;
	uint32_t		vertSplice;
	uint32_t		max_project;
	uint32_t		loc;
	uint32_t		eraseTop, eraseBottom;
	uint32_t		min_thisLineY, max_thisLineY;
	uint32_t		shift_variable;
	uint32_t		h, w;
	uint32_t		**last_stafflines;
	uint32_t		ii, jj;
	int32_t			min_thisLineY_tmp;

	max_thisLineY = 0;

	h = img->height;
	w = img->width;

	line_w			= (uint32_t) ((staff->thickness + staff->spacing + 8)/16);

	beginCut	= 0;
	endCut		= (uint32_t)((w)/numCuts);

	proj_y = project_on_Y(img);

	linesFound = 0;

	stafflines_tmp	= malloc(10 * sizeof(uint32_t));
	while (linesFound < 5){
		max_project = proj_y->data[0];
		loc = 0;
		for (i=1; i<h; i++){
			if (proj_y->data[i] > max_project) {
				max_project = proj_y->data[i];
				loc = i;
			}
		}
		linesFound = linesFound + 1;

		// all y coordinates of a line that is part of same staff line
		eraseTop	= loc - (uint32_t)((line_w+1)/3);
		eraseBottom	= loc + (uint32_t)((line_w+1)/3);

		if (eraseBottom > h-1) {
			eraseBottom = h-1;
		}

		min_thisLineY_tmp = -1;
		for (i=eraseTop; i<=eraseBottom; i++) {
			if (proj_y->data[i]>=(9*max_project)/10) {
				if (min_thisLineY_tmp == -1){
					min_thisLineY_tmp = i;
				}
				max_thisLineY = i;
			}
			// erase to avoid line in further iterations
			proj_y->data[i] = 0;
		}
		min_thisLineY = (uint32_t) min_thisLineY_tmp;

		stafflines_tmp[2*(linesFound-1)]	= min_thisLineY;
		stafflines_tmp[2*(linesFound-1)+1]	= max_thisLineY;
	}

	flex_array_delete(proj_y);
	quickSort(stafflines_tmp, 0, 9);

	last_stafflines	= (uint32_t **) multialloc (sizeof(uint32_t), 2, 5, 2);
	STAFFLINES		= (uint32_t **) multialloc (sizeof(uint32_t), 2, 5, 2);

	for (i=0; i<5; i++){
		last_stafflines[i][0] = stafflines_tmp[2*i];
		last_stafflines[i][1] = stafflines_tmp[2*i + 1];
	}
	free(stafflines_tmp);

	// LOOP THRU VERTICAL CUTS
	shift_variable=0;
	for(vertSplice =0; vertSplice<numCuts; vertSplice++){

		get_sub_img(img, temp_img, -1, -1, beginCut, endCut);

    	// pretty up staff lines
		fix_lines_and_remove(temp_img, staff, last_stafflines, &shift_variable, vertSplice);

		for (ii=0; ii<h; ii++){
			for (jj=beginCut; jj<=endCut; jj++){
				setPixel(img, jj, ii, getPixel(temp_img, jj-beginCut, ii));
			}
		}

    	if (vertSplice==0){
			for(i=0; i<5; i++){
				STAFFLINES[i][0] = last_stafflines[i][0];
				STAFFLINES[i][1] = last_stafflines[i][1];
			}
    	}

		beginCut = endCut + 1;
		endCut = endCut + 1 + (uint32_t)((w)/numCuts);

		if (endCut > w-1) {
			endCut = w-1;
		}
	}

	for(i=0; i<5; i++){
		stafflines[i] = (uint32_t)(((STAFFLINES[i][0] + STAFFLINES[i][1]+1)/2) - ((staff->thickness+8)>>5));
	}

	multifree(STAFFLINES, 2);
	multifree(last_stafflines, 2);
}

void fix_lines_and_remove (image16_t* img, staff_info* staff, uint32_t** last_STAFFLINES, uint32_t *previous_start, uint32_t cutNum) {
// remove lines from small portion of staff. also straightens staff.
	flex_array_t	*stafflines_tmp;
	uint32_t		*yprojection;
	uint32_t		line_thickness, line_spacing, line_w;
	uint32_t		*last_STAFFLINES_avg;
	uint32_t		max_project;
	uint32_t		sum;
	uint32_t		h, w;
	uint32_t		i, j, ii;
	uint32_t		count;
	uint32_t		**STAFFLINES;
	uint32_t		dummy;
	uint32_t		loc;
	uint32_t		shift;
	uint32_t		findLine;
	uint32_t		match;
	uint32_t		lineBegin, lineEnd;
	uint32_t		found_thickness;
	uint32_t		middle;
	uint32_t		tooThick, tooHigh, tooLow;
	uint32_t		any_stafflines_zero;
	uint32_t		now_avg, last_avg;
	uint32_t		goodLine;
	uint32_t		curr, extend;
	uint32_t		lastDelete;
	uint32_t		cW, cH;
	uint32_t		topStop, botStop;
	uint32_t		thickness, thickness_th;
	uint32_t		paramThickness;
	uint32_t		topLine;
	uint32_t		shift_loop;
	uint8_t			line_thickness_q4;
	int16_t			*tempData;
	int16_t			*temp_array;
	int32_t			lineY;
	uint8_t			pixelData;
	linked_list		*staffLines;
	linked_list		*allLINES;

	STAFFLINES = multialloc(sizeof(uint32_t), 2, 5, 2);

	h = img->height;
	w = img->width;

	line_thickness		= (uint32_t)(staff->thickness+8)/16;
	line_thickness_q4	= staff->thickness;
	line_spacing		= (uint32_t)(staff->spacing)/16;
	line_w				= (uint32_t)(staff->thickness+8 + staff->spacing)/16;


	last_STAFFLINES_avg = (uint32_t *)malloc(sizeof(uint32_t)*5);
	for (i=0; i<5; i++) {
		last_STAFFLINES_avg[i] = (uint32_t)((last_STAFFLINES[i][0] + last_STAFFLINES[i][1] + 1)/2);
	}

	yprojection= (uint32_t *)mget_spc((uint32_t)h, sizeof(uint32_t));

	max_project = 0;
	for (i=0; i<h; i++) {
		sum = 0;
		for (j=0; j<w; j++) {
			sum += getPixel(img, j, i);
		}
		yprojection[i] = sum;
		if (yprojection[i] > max_project) {
			max_project = yprojection[i];
		}
	}
	count = 0;
	for(i=0; i<h; i++){
		if (yprojection[i] >= (9*max_project)/10) {    // delete staff line, twiddle with the 80% later (90%)
			count++;
		}
	}
	stafflines_tmp = flex_array_create(count);
	count = 0;
	for (i=0; i<h; i++){
		if (yprojection[i] >= (9*max_project)/10){    // delete staff line, twiddle with the 80% later (90%)
			stafflines_tmp->data[count] = i;
			count++;
		}
	}
	free(yprojection);

	staffLines = linked_list_group(stafflines_tmp, 3);

	if (cutNum == 0 && staffLines->length == 5) {
		i = 0;
	    while(linked_list_is_empty(staffLines)==0){
			tempData=(int16_t*)linked_list_pop_top(staffLines);
			STAFFLINES[i][0] = tempData[0];
			STAFFLINES[i][1] = tempData[1];
			i++;
			free(tempData);
		}
	} else if ((staffLines->length) == 0){
		for(i=0; i<5; i++){
			STAFFLINES[i][0] = last_STAFFLINES[i][0];
			STAFFLINES[i][1] = last_STAFFLINES[i][1];
		}
	} else if (cutNum == 0 && (staffLines->length) < 5){
	    //choose one line, then find closest line in last_STAFFLINES
		tempData = (int16_t*)(linked_list_getIndexData(staffLines, 0));
	    goodLine = (uint32_t)((tempData[0] + tempData[1] + 1)/2);

		dummy = abs(last_STAFFLINES_avg[0] - goodLine);
		loc = 0;
		for(i=1; i<5; i++){
			curr = abs(last_STAFFLINES_avg[i] - goodLine);
			if (curr < dummy){
				dummy	= curr;
				loc		= i;
			}
		}
		shift = goodLine - last_STAFFLINES_avg[loc];

		for(i=0;i<5;i++){
			STAFFLINES[i][0] = last_STAFFLINES[i][0]+shift;
			STAFFLINES[i][1] = last_STAFFLINES[i][1]+shift;
		}

	} else {
		count = 0;
		for (findLine=0; findLine<5; findLine++) {

			match = 0;
			for (i=0; i<(staffLines->length); i++) {
				tempData	= (int16_t*)(linked_list_getIndexData(staffLines, i));
				lineBegin	= (uint32_t)tempData[0];
				lineEnd		= (uint32_t)tempData[1];
				// lineBegin is top of line, lineEnd is bottom

			    found_thickness = lineEnd-lineBegin+1;
			    middle = (uint32_t)((lineBegin + lineEnd+1)/2);

			    // determine if the line is of expected location/size
				tooThick	= 0;
				tooHigh		= 0;
				tooLow		= 0;
			    if (found_thickness > (line_thickness+2)) tooThick=1;
				if (middle < (last_STAFFLINES_avg[findLine] - 3)) tooHigh=1;
				if (middle > (last_STAFFLINES_avg[findLine] + 3)) tooLow=1;

				if (cutNum == 0) {
					tooHigh = 0;
					tooLow = 0;
					if (middle < (last_STAFFLINES_avg[0] - 2*line_spacing)){tooHigh=1;}
					if (middle > (last_STAFFLINES_avg[4] + 2*line_spacing)){tooLow=1;}
				}

				if (tooThick || tooHigh || tooLow) {
					continue;
				} else {
					// we found good match for staffline
					match = 1;
					// SAVE STAFF LINE LOCATIONS
					STAFFLINES[count][0] = lineBegin;
					STAFFLINES[count][1] = lineEnd;
					count++;
					linked_list_deleteIndexData(staffLines, i);
					break;
				}

			} // end looping thru found lines

			if (!match) {
		    	// flag that no match was found
		    	STAFFLINES[count][0] = 0;
				STAFFLINES[count][1] = 0;
				count++;
			}

	    } // end looping through matching staff lines

	    // check for lines that did not get match
		any_stafflines_zero = 0;
		for (i=0; i<5; i++) {
			if (STAFFLINES[i][0] == 0) {
				any_stafflines_zero = 1;
				break;
			}
		}

		if (any_stafflines_zero) {
			// find shift value first
			shift = 100; // big value
			for (findLine = 0; findLine<5; findLine++) {
				// loop to find nonzero entry in STAFFLINES, then calculate shift
				if (STAFFLINES[findLine][0]){ // if nonzero
					now_avg		= (uint32_t)((STAFFLINES[findLine][0]+STAFFLINES[findLine][1]+1)/2);
					last_avg	= last_STAFFLINES_avg[findLine];
					shift		= now_avg - last_avg;
					break;
				}
			}

			if (shift == 100) {
				shift = 0;
			}
			// replace any flagged (with 0) entries in STAFFLINES
			for (findLine=0;findLine<5;findLine++) {
				if (STAFFLINES[findLine][0] == 0) {
					STAFFLINES[findLine][0] = last_STAFFLINES[findLine][0]+shift;
					STAFFLINES[findLine][1] = last_STAFFLINES[findLine][1]+shift;
				}
			}
		}
	}

	led_turn_on(16);
	extend = (uint32_t)((line_w+2)/4)+1;
	// create stafflines above
	allLINES	= linked_list_create();
	lineY		= (int32_t)(((STAFFLINES[0][0] + STAFFLINES[0][1]+1)/2) - line_w);
	while (1) {
		if (lineY < (int32_t)(extend + 2)){
			break;
		} else {
			temp_array		= malloc(sizeof(int16_t)*2);
			temp_array[0]	= (int16_t)lineY;
			temp_array[1]	= (int16_t)lineY;
			linked_list_push_top(allLINES, temp_array);
       		lineY = (int32_t)(lineY - (int32_t)line_w );
   		}
	}
	for (i=0; i<5; i++) {
		temp_array		= malloc(sizeof(uint32_t)*2);
		temp_array[0]	= (int16_t)STAFFLINES[i][0];
		temp_array[1]	= (int16_t)STAFFLINES[i][1];
		linked_list_push_bottom(allLINES, temp_array);
	}
	// create stafflines below
	lineY = (uint32_t)(((STAFFLINES[4][0] + STAFFLINES[4][1]+1)/2) + line_w); // first above line
	while (1) {
   		if (lineY > (h - extend - 3)) {
   			break;
		} else {
			temp_array		= malloc
					(sizeof(int16_t)*2);
			temp_array[0]	= (int16_t)lineY;
			temp_array[1]	= (int16_t)lineY;
			linked_list_push_bottom(allLINES, temp_array);
       		lineY = (uint32_t)(lineY + (int32_t)line_w);
   		}
	}
	led_turn_off(16);

	// REMOVE STAFF LINES

	while (linked_list_is_empty(allLINES) == 0) {
		tempData = (int16_t*)linked_list_pop_top(allLINES);
		lineBegin	= tempData[0];
		lineEnd		= tempData[1];
		middle		= (lineBegin + lineEnd + 1)/2;
		lastDelete	= 0;
		free(tempData);

		for (j=0; j<w; j++) {
			// top of staff line
			topStop = 0;
			// incorporated katies changes--mike
			for (ii = (lineBegin-1); ii>=(lineBegin-extend); ii--) {
				if (ii < 2) {//CHANGE
					break;
				}
				if (getPixel(img, j, ii)==0 &&getPixel(img, j, ii-1)==0 && getPixel(img, j, ii-2)==0) {//CHANGE
					// then erase
					topStop = ii+1;
					break;
				}
			}
			// bottom of staff line
			botStop = h-1;
			for(ii = lineEnd+1; ii<=(lineEnd+extend); ii++){
				if (ii > h-3) {//CHANGE
					break;
				}
				if (getPixel(img, j, ii)==0 && getPixel(img, j, ii+1)==0 && getPixel(img, j, ii+2)==0) {//CHANGE
					botStop = ii-1;
					break;
				}
			}

			// check thickness of line, delete if skinny
			thickness = botStop - topStop + 1;
			if ((staff->thickness+8)/16 < 3){
				paramThickness = (staff->thickness+8)/16 + 1;
			} else {
				paramThickness = (staff->thickness+8)/16;
			}
			if (lastDelete){
				// there was a line deletion last iteration
				thickness_th = paramThickness*2; // higher threshold
			} else {
				thickness_th = paramThickness*2-2;
			}
			thickness_th = thickness_th + 2; //GHETTO FIX

			if (thickness <= thickness_th) {
				for (ii=topStop; ii<=botStop; ii++){
					setPixel(img, j, ii, 0);
				}
				lastDelete = 1;
			} else {
				lastDelete = 0;
			}
		}

	} // end staff line

	topLine = STAFFLINES[0][0];
	if (*previous_start) {
    	if (*previous_start<topLine) {
        	shift=topLine-(*previous_start);
			for (shift_loop=0; shift_loop<(h-shift); shift_loop++) {
				for (cW=0; cW<w; cW++) {
					pixelData = getPixel(img, cW, shift_loop+shift);
		    		setPixel(img, cW, shift_loop, pixelData);
				}
			}
			for(cH=h-shift-1; cH<h; cH++){
				for(cW=0; cW<w; cW++){
					setPixel(img, cW, cH, 0);
				}
			}
		} else if (*previous_start>topLine) {
        	shift = *previous_start-topLine;

			for (shift_loop=h-1; shift_loop>=shift; shift_loop--) {
				for (cW=0; cW<w; cW++) {
					pixelData = getPixel(img, cW, shift_loop-shift);
		    		setPixel(img, cW, shift_loop, pixelData);
				}
			}
			for(cH=0; cH<shift; cH++){
				for(cW=0; cW<w; cW++){
		    		setPixel(img, cW, cH, 0);
				}
			}
		}

	} else {
	   	*previous_start = topLine;
	}

	for(i=0; i<5; i++) {
		last_STAFFLINES[i][0] = STAFFLINES[i][0];
		last_STAFFLINES[i][1] = STAFFLINES[i][1];
	}
	linked_list_delete_list(staffLines);
	linked_list_delete_list(allLINES);
	multifree(STAFFLINES, 2);
}

void mini_img_cut(const image16_t* img, image16_t* out_img, uint16_t top, uint16_t bottom, uint16_t xbegin, uint16_t xend, const staff_info* staff, note_cuts* cuts) {
	// cuts out small image around stem/measure marker

	uint16_t		line_spacing;
	uint16_t		extend,count;
	uint16_t		line_w;
	uint16_t		count_thresh;
	uint16_t		i;
	int16_t			topCut, bottomCut, leftCut, rightCut;
	projection_t*	proj;
	uint16_t		first_cut_left, first_cut_right;

	line_spacing	= staff->spacing;
	// get line_w in q4 format
	line_w			= staff->thickness + line_spacing;

	// get extend = 1.4*line_w and translate back to q0
	extend	= (7*line_w + 2)/80;

	// get the entire image cropped tob and bottom

	// check for <0 and >width
	// first_cut_left tells us the first "left cut" for the smaller image
	if (xbegin < extend){
		first_cut_left	= 0;
	} else {
		first_cut_left	= xbegin - extend;
	}
	if (xend + extend >= img->width) {
		first_cut_right	= img->width - 1;
	} else {
		first_cut_right	= xbegin + extend;
	}

	get_sub_img(img, out_img, top, bottom, first_cut_left, first_cut_right);

	// get the projection on x of that image
	proj = project_on_X(out_img);

	// figure out the left bound
	// loop through projection going left starting at the left side
	// of the vertical line
	count_thresh	= (4*line_w+5)/160;
	count			= 0;

	for (i=extend; i>0; i--) {
		if (proj->data[i] < 3) {
			count++;
		} else {
			count = 0;
		}
		if (count > count_thresh) {
			// we found a long enough run of whitespace
			break;
		}
	}
	// reset leftCut back to where the run of white started
	leftCut = first_cut_left + i + count - 1;
	if (leftCut < 0){
		leftCut = 0;
	}

	// right cut
	count = 0;
	for (i=extend + (xend - xbegin); i<out_img->width; i++) {
		if (proj->data[i] < 3) {
			count++;
		} else {
			count = 0;
		}
		if (count > count_thresh) {
			// we found a long enough run of whitespace
			break;
		}
	}
	// reset leftCut back to where the run of white started
	rightCut = i - count + first_cut_left + 1;
	if (rightCut > img->width-1){
		rightCut = img->width-1;
	}

	flex_array_delete(proj);

	// now look at the top and bottom cut positions
	// move the top up and bottom down to include more of the note
	// while looking in the left to right region found above.

	// get the whole height image
	get_sub_img(img, out_img, -1, -1, leftCut, rightCut);

	// get the projection on y of that image
	proj = project_on_Y(out_img);

	// look above the image until a lot of white is found
	for (i=top; i>0; i--) {
		if (proj->data[i] == 0) {
			// stop when we hit white
			break;
		}
	}
	topCut = i + 1;

	// look below the image until a lot of white is found
	for (i=bottom; i<img->height; i++) {
		if (proj->data[i] == 0) {
			// stop when we hit white
			break;
		}
	}
	bottomCut = i - 1;

	// hack to fix eighth note classification
	// cuts off a possible staff line at the bottom of the note
	// hopefully this doesn't affect other notes
	// bottomCut -= ((staff->thickness*2)>>4);

	if (topCut < 0)					topCut		= 0;
	if (bottomCut >= img->height) 	bottomCut	= img->height-1;
	if (leftCut < 0)				leftCut		= 0;
	if (rightCut >= img->width)		rightCut	= img->width-1;

	cuts->bottom_cut	= bottomCut;
	cuts->left_cut		= leftCut;
	cuts->right_cut		= rightCut;
	cuts->top_cut		= topCut;

	// output - cut box
	get_sub_img(img, out_img, topCut, bottomCut, leftCut, rightCut);
}

void crop_off_cleff_key_signature (image16_t* img, staff_info *staff) {
	get_sub_img(img, img, -1, -1, staff->ks_x, -1);
}
