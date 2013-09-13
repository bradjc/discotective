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

#endif
