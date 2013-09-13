#include "global.h"
#include "preprocessing.h"
#include "vga.h"
#include "led.h"
#include "ssd.h"
#include "char_display.h"
#include "alt_types.h"
#include "segmentation.h"
#include "dds.h"
#include "scanning.h"
#include "classification.h"
#include "linked_list.h"
#include <stdlib.h>
#include "flash.h"


int main () {

	uint16_t	i;

	image16_t		image;
	image16_t		image2;
	image16_t		image3;
	image16_t		image4;

	linked_list*	stems_list;
	linked_list*	all_notes;
	linked_list*	measures_list;
	linked_list*	symbols;

	staff_info*		staff;
	uint32_t 		staff_lines[5];


	// Wait until we have a image to go with
	WAIT_FOR_INTERRUPT;

#ifdef DEMO_MODE
	WAIT_FOR_INTERRUPT;
#endif

	// Set locations for full size binary images
	image.pixels	= 0x00800000;
	image2.pixels	= 0x00900000;
	image3.pixels	= 0x00a00000;
	image4.pixels	= 0x00b00000;

	stems_list		= linked_list_create();
	all_notes		= linked_list_create();
	measures_list	= linked_list_create();
	symbols			= linked_list_create();

	// do the main initialization of drivers and such
	init();

	// display title
	char_display_title();

	led_turn_on(0);

	//WAIT_FOR_INTERRUPT;*/

	// Convert the gray scale image to binary
	binarize_threshold(SDRAM_BASE, &image);
	vga_draw_binary_img(&image);

#ifdef DEMO_MODE
	WAIT_FOR_INTERRUPT;
#endif


#ifdef READ_FROM_FLASH
	//Flash image 1: Victors
	//			  2: Birthday
	//            3: Hedwig
	read_image_from_flash(&image,FLASH_IMAGE2); // UNCOMMENT to load image
	vga_draw_binary_img(&image);				// from flash
	WAIT_FOR_INTERRUPT;
#endif

	// Fix the fisheye distortion
	correct_fish_eye(&image, &image2);
	vga_draw_binary_img(&image2);
	led_turn_on(1);

#ifdef DEMO_MODE
	WAIT_FOR_INTERRUPT;
#endif

	// Crop the image
//	initial_crop_image(&image2);
//	vga_draw_binary_img(&image2);
	led_turn_on(2);

	// Find the various staffs in the image
	staff = staff_segment_simple(&image2);

	led_turn_on(3);

	// Loop through the detected staffs
	for (i=0; i<staff->num_staffs; i++) {

		led_turn_off(4);
		led_turn_off(5);
		led_turn_off(6);
		led_turn_off(7);
		led_turn_off(8);
		led_turn_off(9);
		led_turn_off(10);
		led_turn_off(11);
		led_turn_off(12);
		led_turn_off(13);

		// Get the specific staff
		get_staff_img(&image2, &image, staff, i);
		vga_draw_binary_img(&image);

#ifdef DEMO_MODE
	ssd_write_value(image.byte_width);
	WAIT_FOR_INTERRUPT;
	ssd_write_value(image.height);
	WAIT_FOR_INTERRUPT;
#endif

		// Remove the staff lines
		remove_lines(&image, &image3, 30, staff_lines, staff);
		led_turn_on(4);
		vga_draw_binary_img(&image);

#ifdef DEMO_MODE
	WAIT_FOR_INTERRUPT;
#endif

		// Check which staff this is
		if (i == 0) {
			// get the key signature on the first staff
			// this function also crops it
			get_key_signature(&image, &image3, staff, staff_lines);

		} else {
			// just get rid of the treble cleff and time signature
			crop_off_cleff_key_signature(&image, staff);
		}
		led_turn_on(5);
		vga_draw_binary_img(&image);

#ifdef DEMO_MODE
	ssd_write_value(image.byte_width);
	WAIT_FOR_INTERRUPT;
	ssd_write_value(image.height);
	WAIT_FOR_INTERRUPT;
#endif

		// Find and classify all notes with stems
		parse_notes_with_lines(&image, &image3, &image4, staff, 0, staff_lines, stems_list, measures_list);
		led_turn_on(6);
		vga_draw_binary_img(&image);

		// Delete all the notes with stems found above and all measure lines
		remove_notes_measures(&image, stems_list, measures_list, staff, staff_lines);
		led_turn_on(7);
		vga_draw_binary_img(&image);

#ifdef DEMO_MODE
	WAIT_FOR_INTERRUPT;
#endif

		// Find all remaining black on that staff that is of reasonable size
		find_symbols_simple(&image, &image4, symbols);
		led_turn_on(8);

		// Figure out if any of the symbols got split, and if so, re-join them
		combine_symbols (symbols, staff);
		led_turn_on(9);

		// Determine what symbol each of the black blobs is
		classify_symbols (symbols, stems_list, measures_list, staff, &image, &image4, staff_lines);
		led_turn_on(10);

		// Use already found notes to classify some of the symbols we have found
		contextualizer_notes_rests(stems_list, symbols);
		led_turn_on(11);

		// Determine the pitch of all found notes
		identify_note_pitches(&image, staff, staff_lines, stems_list);
		led_turn_on(12);

		// Add in the key signature
		update_notes_with_key_signature(stems_list, staff);
		led_turn_on(13);

		// Handle other symbols
		contextualizer_other(stems_list, measures_list, symbols);
		led_turn_on(14);

		// Copy all of the notes into the master note list
		linked_list_move(stems_list, all_notes);
	}

	// Redraw the de-fisheyed image while the music plays
	vga_draw_binary_img(&image2);

	while (1) {
		play_song(all_notes);
		WAIT_FOR_INTERRUPT;
	}

    return 0;
}
