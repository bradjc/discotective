#include "allocate.h"
#include "preprocessing.h"
#include "global.h"
#include "image_functions.h"
#include "segmentation.h"
#include "scanning.h"
#include "classification.h"
#include "deleting.h"
#include "platform_specific.h"
#include "audio.h"
#include "music_functions.h"
#include <stdint.h>

// Main loop of the program
// takes in an array of 8 bit rgba values
// returns a linked list of notes
linked_list* run (uint8_t* rgba_img, uint16_t height, uint16_t width) {
	grayimage_t*	gray_img			= NULL;
	image_t*		binary_img			= NULL;
	image_t*		binary_img_fixed	= NULL;
	image_t*		binary_img_otsu		= NULL;
	image_t*		binary_img_entropy	= NULL;
	image_t*		staff_img = NULL;
	sheet_t*		sheet;
	linked_list*	notes;
	linked_list*	measures;
	linked_list*	symbols;
	linked_list*	music;
	int				i;
		
	notes		= linked_list_create();
	measures	= linked_list_create();
	symbols		= linked_list_create();
	music		= linked_list_create();

	
	// convert to grayscale
	convert_rgb_to_grayscale(rgba_img, height, width, &gray_img);
	grayscale_image_display(gray_img);
	
	// delete the old array
	free(rgba_img);

	// convert to binary
	disco_log_nol("binarization...");
//	binarizeIMG(gray_img, &binary_img2);

	binarize_threshold(gray_img, &binary_img_otsu, OTSU);
	binarize_threshold(gray_img, &binary_img_fixed, FIXED);
	binarize_threshold(gray_img, &binary_img_entropy, ENTROPY);
	binary_img	= binarize_threshold_adaptive_otsu(gray_img, 75);

	grayscale_image_delete(&gray_img);
	disco_log("DONE");

	binary_image_display(binary_img);
	binary_image_display(binary_img_fixed);
	binary_image_display(binary_img_otsu);
	binary_image_display(binary_img_entropy);

	binary_image_delete(&binary_img_fixed);
	binary_image_delete(&binary_img_otsu);
	binary_image_delete(&binary_img_entropy);

	
	// crop the image
	// This should be the same (or close to it, maybe some threshold differences)
	// as doing both tbCrop and lrCrop.
	disco_log_nol("crop...");
	initial_crop_image(&binary_img);
	inside_outside_crop(&binary_img);
	disco_log("DONE");
	binary_image_display(binary_img);
	
	// remove any black from the edges
	disco_log_nol("blob kill...");
	edge_blob_kill(binary_img);
	disco_log("DONE");
	binary_image_display(binary_img);
	
	// correct for skew
	disco_log_nol("horizontal deskew...");
	horizontal_deskew(&binary_img);
	binary_image_display(binary_img);
//	flex_array_display(project_on_Y(binary_img), 1);
	disco_log("DONE");
	binary_image_display(binary_img);
	
	// crop off more whitespace after deskewing
	disco_log_nol("final crop...");
	white_crop_preprocess(&binary_img);
	disco_log("DONE");
	binary_image_display(binary_img);
	

	//Segmentation..........................
	
	// Find the various staffs in the image
	sheet	= staff_segment_simple(binary_img);
	disco_log("number staffs: %d", sheet->num_staffs);
	
	// Loop through the detected staffs
	for (i=0; i<sheet->num_staffs; i++) {
		disco_log("working on staff #%d", i);

		// Get the specific staff
		get_staff_img(binary_img, &staff_img, sheet->staffs+i);
		binary_image_display(staff_img);

		// Remove the staff lines
		disco_log_nol("removing lines...");
		remove_staff_lines(staff_img, sheet->staffs+i);
		disco_log("DONE");
		binary_image_display(staff_img);

		disco_log_nol("removing cleff...");
		remove_cleff(staff_img, sheet->staffs+i);
		disco_log("DONE");
		binary_image_display(staff_img);

		disco_log_nol("vertical deskew on staff...");
		vertical_deskew_staff(&staff_img, sheet->staffs+i);
		binary_image_display(staff_img);
//		flex_array_display(project_on_X(staff_img), 0);
		disco_log("DONE");
		
		// Check which staff this is
		if (i == 0) {
			// first remove the treble cleff to make deskew work better
			
			// get the key signature on the first staff
			// this function also crops it
			disco_log_nol("getting key signature...");
			get_key_signature(&staff_img, sheet);
			disco_log("DONE");
			disco_log("key sig: %d", sheet->ks);
		} else {
			// just get rid of the treble cleff and time signature
			crop_off_cleff_key_signature(&staff_img, sheet, i);
		}
		binary_image_display(staff_img);
		
		disco_log_nol("finding stemmed notes...");
		parse_notes_with_lines(staff_img, sheet->staffs+i, notes, measures);
		disco_log("DONE");
		
		binary_image_display(staff_img);
		disco_log_nol("removing stemmed notes and measures...");
		remove_notes_measures(staff_img, notes, measures, sheet->staffs+i);
		binary_image_display(staff_img);
		disco_log("DONE");
		
		disco_log_nol("finding symbols...");
		find_symbols(staff_img, symbols);
		binary_image_delete(&staff_img);
		disco_log("DONE");
		
		// Figure out if any of the symbols got split, and if so, re-join them
		disco_log_nol("combining symbols...");
		combine_symbols(symbols, sheet->staffs+i);
		disco_log("DONE");
		
		// Determine what symbol each of the black blobs is
		disco_log_nol("classifying symbols...");
		classify_symbols(symbols, notes, measures, sheet->staffs+i);
		disco_log("DONE");
		
		// Use already found notes to classify some of the symbols we have found
		disco_log_nol("contextualizing notes...");
		contextualizer_notes_rests(notes, symbols);
		disco_log("DONE");
		
		// Determine the pitch of all found notes
		disco_log_nol("finding pitches of notes...");
		identify_note_pitches(notes, sheet->staffs+i);
		disco_log("DONE");
		
		// Handle other symbols
		disco_log_nol("contextualizing other...");
		contextualizer_other(notes, measures, symbols);
		disco_log("DONE");
		
		disco_log("measures: %d", measures->length);

		disco_log_nol("combining notes measures...");
		concat_notes_measures(notes, measures, music);
		linked_list_clear_list(measures);
		linked_list_clear_list(notes);
		linked_list_clear_list(symbols);
		disco_log("DONE");

	}

	guess_time_signature(music, sheet);

	display_notes(sheet, music);
	print_abc_format(sheet, music);

	delete_sheet(&sheet);

	linked_list_delete(symbols);
	linked_list_delete(notes);
	linked_list_delete(measures);
	linked_list_delete(music);
	binary_image_delete(&binary_img);

	return music;
}
