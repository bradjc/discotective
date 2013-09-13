#ifndef DISCO_TYPES_H
#define DISCO_TYPES_H

typedef uint8_t** image_data;
enum flag1{
     greater,
     less,
     equal,
     greater_equal,
     less_equal,
     not_equal
};
typedef enum flag1 find_flags;

enum note_dur{
     EIGHTH,
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
/*A binary image type, height and width are in terms of pixels, not elements
As such pixels should only be used with the get and set functions below*/
typedef struct{
        uint16_t height;
        uint16_t width;
        image_data pixels;
} image_t;
/*Parameters*/
typedef struct{
        uint8_t staff_h;
        uint8_t thickness;
        uint8_t spacing;
        uint8_t ks;
        uint8_t ks_x;
} params;
/*merge and take out staff_lines*/
typedef struct{
        uint16_t number_staffs;
        uint16_t **staff_bounds;
        uint16_t **staff_lines;
        
} staff_info;


/*A projection type which works alongside the image type*/
typedef struct{
        uint16_t length;
        int16_t *data;
} flex_array_t;

/*For more intuitiveness*/
typedef flex_array_t projection_t;

typedef struct{
        uint16_t top;
        uint16_t bottom;
        uint16_t left;
        uint16_t right;
        uint16_t index;
} good_lines_t;

typedef struct{
        uint16_t length;
        void **data;
} flex_pointer_array_t;

typedef struct{
        uint16_t top_cut;
        uint16_t bottom_cut;
        uint16_t left_cut;
        uint16_t right_cut;
} note_cuts;
/* finds all stemmed notes and measure markers
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
    % measures.end          - right side of measure marker*/
typedef struct{
        uint16_t begin;
        uint16_t end;
        uint16_t center_of_mass;
        uint16_t top;
        note_duration duration;
        uint16_t bottom;
        uint8_t position_left;
        uint8_t eighthEnd;
        uint16_t midi;
        int8_t mod;
} stems_t;

typedef struct{
        uint16_t begin;
        uint16_t end;
} measures_t;
        

typedef struct{
        uint16_t top;
        uint16_t bottom;
        uint16_t left;
        uint16_t right;
	uint16_t height;
	uint16_t width;
        uint16_t HtW;
        uint16_t NumBlack;
	int16_t class_label;
} symbol_t;


#endif
