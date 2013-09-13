#ifndef __GLOBAL_H_
#define __GLOBAL_H_

#include "alt_types.h"
#include "system.h"
#include <stdint.h>

// Program Options

//#define	READ_FROM_FLASH 0
#define	ERASE_NOTES_REAL_TIME
//#define	DEMO_MODE
//#define	DEBUG_ON


// Addresses
#define SDRAM_BASE		0x00800000
#define VGA_BASE		0x00F6A000
#define VGA_BASE_BACK	0x00FB5000
#define SRAM_BASE		0x01000000
#define SWITCHES_BASE	0x01090000

// Other
#define BIN_COLOR_WHITE		1
#define BIN_COLOR_BLACK		0
#define BIN_WHITE_BYTE		0xFF
#define BIN_BLACK_BYTE		0x00

//#define SINE_TABLE_SIZE 	512
#define SINE_TABLE_SIZE 	4096

//#define DEBUG_ON


extern alt_16 sine_samples[SINE_TABLE_SIZE];


// Custom Instruction

// wait_for_interrupt blocks in hardware until
// the interrupt from the bridge is triggered.
#define WAIT_FOR_INTERRUPT __builtin_custom_in(ALT_CI_WAIT_FOR_INTERRUPT_CUSTOM_INSTRUCTION_0_91_INST_N)


// Types

typedef struct {
	uint16_t	height;		// the height of the image in pixels
	uint16_t	width;		// the width of the image in pixels
	uint16_t	byte_width;	// the number of bytes in the width of the image
	uint32_t	pixels;		// the location in memory of the start of the image
} image16_t;

typedef struct {
	alt_u16		bottom_bound;	// the y pixel index of the bottom of a staff
	alt_u16		top_bound;
} staff_bound;

typedef struct{
	uint16_t	num_staffs;		// number of staffs in the original image
	uint16_t	staff_h;		// the calculated height of individual staffs (all the same)
	uint16_t	thickness;		// line thickness
	uint16_t	spacing;		// spacing between the 5 staff lines (from line center to line center)
	uint16_t	ks;				// key signature
	uint16_t	ks_x;			// key signature location
	staff_bound	*staff_bounds;	// array of structs, 1 for each staff
} staff_info;


//A projection type which works alongside the image type
typedef struct{
	uint16_t	length;
	int16_t		*data;
} flex_array_t;

//For more intuitiveness
typedef flex_array_t projection_t;

typedef struct{
	uint16_t	top_cut;
	uint16_t	bottom_cut;
	uint16_t	left_cut;
	uint16_t	right_cut;
} note_cuts;

typedef struct{
	uint16_t	top;
	uint16_t	bottom;
	uint16_t	left;
	uint16_t	right;
	uint16_t	index;
} good_lines_t;

enum note_dur {
	EIGHTH		= 0,
	QUARTER,
	HALF,
	WHOLE,
	EIGHTH_DOT,
	QUARTER_DOT,
	HALF_DOT,
	WHOLE_DOT,
	UNKNOWN
};
typedef enum note_dur note_duration;

typedef struct{
	uint16_t		begin;
	uint16_t		end;
	uint16_t		center_of_mass;
	uint16_t		top;
	note_duration	duration;
	uint16_t		bottom;
	uint8_t			position_left;
	uint8_t			eighthEnd;
	uint8_t			eighthSingle;
	uint16_t		midi;
	int8_t			mod;
} stems_t;

typedef struct{
	uint16_t	begin;
	uint16_t	end;
} measure_t;

enum flag1{
     greater,
     less,
     equal,
     greater_equal,
     less_equal,
     not_equal
};
typedef enum flag1 find_flags;

enum symbol1 {
	UNCLASSIFIED	= 0,
	TRASH,
	QUARTER_REST,
	TIES,
	DOT,
	MEASURE_MARKER,
	HALF_REST,
	FULL_REST,
	SHARP,
	FLAT,
	NATURAL,
	WHOLE_NOTE,
	EIGHTH_REST		// 12
};
typedef enum symbol1 symbol_type;

typedef struct{
	uint16_t	top;
	uint16_t	bottom;
	uint16_t	left;
	uint16_t	right;
	uint16_t	height;
	uint16_t	width;
	uint16_t	NumBlack;
	symbol_type	type;
} symbol_t;

// Functions

// Initialize all the peripheral drivers
void init ();

void bad_exit ();

void array_create_fail (uint16_t length);

void array_length_fail ();

void linked_list_create_fail();

void get_spc_fail();

void get_mspc_fail();

void flex_array_diff_length_fail();
void flex_array_abs_diff_length_fail();
void flex_array_median_length_fail();
void flex_array_get_sub_array_length_fail();
void flex_array_get_sub_array_double_length_fail();
void flex_array_minus_length_fail();
void flex_array_minus_array_length_fail();
void flex_array_kill_array_indices_length_fail();
void flex_array_histogram_length_fail();
void flex_array_get_max_index_length_fail();
void flex_array_create_init_ones_length_fail();
void flex_array_filter_length_fail();
void flex_array_merge_length_fail();

void check_memory();

void segment_staff_no_lines_found();
void staff_segment_not_mult_of_five();

#endif
