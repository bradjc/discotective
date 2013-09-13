#ifndef __GLOBAL_H_
#define __GLOBAL_H_


#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>

//#include "system.h"
#include <stdint.h>

// Program Options

// debugging
#define	DEBUG_BINARIZE_ADAPTIVE_OTSU
#define	DEBUG_PREPROCESS_CROP
//#define	DEBUG_EDGE_BLOB_KILL
#define	DEBUG_STAFF_SEGMENT
#define	DEBUG_TRIM_STAFF
#define	DEBUG_FIND_MEASURE_LINE
//#define	DEBUG_FIND_MEASURE_LINE_STEPS
#define	DEBUG_DESKEW
//#define	DEBUG_FIND_LINE_WIDTH_SPACING
#define	DEBUG_REMOVE_STAFF_LINES
#define	DEBUG_GET_KEY_SIG
//#define	DEBUG_FIND_VERTICAL_LINES
#define	DEBUG_FIND_STEMMED_NOTES
//#define	DEBUG_NOTE_CUTOUT
#define	DEBUG_FIND_NOTEHEAD_COM
#define	DEBUG_DETERMINE_PITCH
#define	DEBUG_REMOVE_NOTES
#define	DEBUG_CLASSIFY_SYMBOLS
#define	DEBUG_COMBINE_SYMBOLS


// general
#define LINE_WIDTH_THRESHOLD		6

// Other
#define BIN_COLOR_WHITE		1
#define BIN_COLOR_BLACK		0
#define BIN_WHITE_BYTE		0xFF
#define BIN_BLACK_BYTE		0x00
#define BIN_WHITE_WORD		0xFFFFFFFF
#define BIN_BLACK_WORD		0x00000000

#define SINE_TABLE_SIZE 	4096

//#define DEBUG_ON


extern int16_t sine_samples[SINE_TABLE_SIZE];

// ENUMS
typedef enum {
	FIXED			= 0,
	OTSU,
	ENTROPY
} binarize_threshold_e;

typedef enum {
	WHITE			= 0,
	BLACK
} pixel_color_e;

typedef enum {
	LEFT_TO_RIGHT	= 0,
	RIGHT_TO_LEFT,
	TOP_TO_BOTTOM,
	BOTTOM_TO_TOP
} direction_e;

typedef enum {
	UNKNOWN_DUR		= 0,
	SIXTEENTH,
	EIGHTH,
	QUARTER,
	HALF,
	WHOLE,
	SIXTEENTH_DOT,
	EIGHTH_DOT,
	QUARTER_DOT,
	HALF_DOT,
	WHOLE_DOT,
	SIXTEENTH_DDOT,
	EIGHTH_DDOT,
	QUARTER_DDOT,
	HALF_DDOT,
	WHOLE_DDOT,
} duration_e;

typedef enum {
	LEFT			= 0,
	RIGHT,
	NOT_APPLICABLE,
	UNKNOWN_POS
} notehead_pos_e;

typedef enum {
	SINGLE			= 0,
	START,
	MIDDLE,
	END,
	UNKNOWN_CONN
} note_conn_e;

typedef enum {
	NONE_AC			= 0,
	SHARP,
	FLAT,
	NATURAL
} accidental_e;

typedef enum {
	NONE_AR			= 0,
	STACCATO,
	STACCATISSIMO,
	MARCATO,
	TENUTO,
	MARTELLATO,
	LEFT_PIZZICATO,
	SNAP_PIZZICATO,
	NAT_HARMONIC,
	FERMATA,
	UP_BOW,
	DOWN_BOW
} articulation_e;	

typedef enum {
	UNCLASSIFIED	= 0,
	TRASH,
	NOTE_SYM,
	REST_SYM,
	SLUR,
	DOT,
	DOUBLE_DOT,
	MEASURE_MARKER,
	ACCIDENTAL,
	REPEAT_DOT,
	STACCATO_DOT
} symbol_e;

typedef enum {
	NOTE			= 0,
	REST,
	MEASURE
} element_e;

typedef enum {
	NOT_MEASURE		= 0,
	NORMAL,							// just an average, middle of the staff measure marker
	THICK,							// we know its a thick measure line, but not sure of repeat direction
	REPEAT_START,
	REPEAT_END,
	REPEAT_BOTH,
	STAFF_END,						// this measure marks the end of a staff
	REPEAT_STAFF_END,				// this measure marks the end of a staff and is a left facing repeat symbol
	SHEET_END
} measure_e;

typedef enum {
     greater,
     less,
     equal,
     greater_equal,
     less_equal,
     not_equal
} find_flag_e;

// Types

typedef struct {
	uint16_t	height;
	uint16_t	width;
	uint8_t*	image;		// this is a 1d array because the first thing binImg() did was make it that way
} grayimage_t;

typedef struct {
	uint16_t	height;		// the height of the image in pixels
	uint16_t	width;		// the width of the image in pixels
	uint16_t	word_width;	// the number of 32 bit words in the width of the image
	uint32_t*	pixels;		// pointer to the start of the image
} image_t;

typedef struct {
	uint16_t	height;			// the calculated height of individual staffs
	float		line_thickness;	// line thickness
	float		line_spacing;	// spacing between the 5 staff lines (from line center to line center)
	uint16_t	bottom_bound;	// the y pixel index of the bottom of a staff (includes padding)
	uint16_t	top_bound;
	uint16_t	cleff_start_x;	// the x pixel location of the start of the cleff. used to have a reference point for key signature location
	float		stafflines[5];	// the y pixel locations of the middle of each staffline
} staff_t;

typedef struct {
	uint16_t	num_staffs;		// number of staffs in the original image
	uint16_t	ts_num;
	uint16_t	ts_den;
	int16_t		ks;				// value that represents the key signature
	uint16_t	ks_end_x;		// x value of the end of the key signature from the start of the cleff
	staff_t		*staffs;		// array of structs, 1 for each staff
} sheet_t;

typedef struct {
	uint16_t		begin;
	uint16_t		end;
	uint16_t		top;
	uint16_t		bottom;
	uint16_t		center_of_mass;			// y location of the center of mass of the notehead
	duration_e		duration;
	notehead_pos_e	notehead_position;		// where the notehead is relative to the stem
	note_conn_e		connected_type;			// whether or not the note is connected, and if so, is it the start, end, or middle			
	uint16_t		midi;					// midi value of the note
	accidental_e	accidental;				// sharps and flats modifiers
	articulation_e	articulation;
} note_t;

typedef struct{
	uint16_t		begin;
	uint16_t		end;
	measure_e		type;
} measure_t;

// new symbol type
// keeps an image of each symbol along with it
typedef struct {
	image_t*		image;
	uint16_t		offset_x;		// how to transform the symbol image coordinates back into the staff image
	uint16_t		offset_y;
	uint32_t		num_black;
	symbol_e		type;
	duration_e		duration;
	accidental_e	accidental;
} symbol_t;

typedef struct {
	element_e		type;
	measure_e		measure_type;
	duration_e		duration;
	uint16_t		duration_num;	// top of fraction that represents the duration with respect to an eighth note
	uint16_t		duration_den;
	note_conn_e		beam_type;		// whether or not this is a beamed note, and if so, where in the beam it is
	note_conn_e		slur_type;		// whether or not this is a tied or slurred note
	uint16_t		midi;			// pitch of note
	accidental_e	accidental;		// what accidental is attached to this specific note
	articulation_e	articulation;
} music_element_t;


typedef struct {
	uint16_t	length;
	int16_t		*data;
} flex_array_t;

// struct that holds staff line data when the staff is 
typedef struct {
	uint16_t	top_bound;
	uint16_t	bot_bound;
} staffline_t;

typedef struct {
	uint16_t	top_cut;
	uint16_t	bottom_cut;
	uint16_t	left_cut;
	uint16_t	right_cut;
} note_cuts_t;

typedef struct {
	uint16_t	top;
	uint16_t	bottom;
	uint16_t	left;
	uint16_t	right;
//	uint16_t	index;
} line_t;

// for blob kill esque functions
typedef struct {
	uint16_t	x;
	uint16_t	y;
} pixel_t;

// for functions that look for runs of pixels in an image
typedef struct {
	pixel_color_e	color;
	uint16_t		length;
	uint16_t		start;
	uint16_t		end;
} run_t;


// Functions

// Initialize all the peripheral drivers
//void init ();

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

void segment_staff_no_lines_found();
void staff_segment_not_mult_of_five();

#endif
