#include "vga.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "alt_types.h"
#include "io.h"
#include "global.h"
#include "ssd.h"
#include "flex_array.h"
#include "flash.h"


void write_image_to_flash (image16_t* image, uint32_t location) {
     
     uint32_t k=0;
     //uint16_t i,j;
     
     //write byte width to the first word, width to second, and height to third
     IOWR_16DIRECT(location,0,image->byte_width);
     IOWR_16DIRECT(location,2,image->width);
     IOWR_16DIRECT(location,4,image->height);
     
     for( k=0; k< (image->byte_width)*(image->height); k++){
          IOWR_8DIRECT(location, k+6, IORD_8DIRECT(image->pixels, k));
     }
}

void read_image_from_flash(image16_t* image,uint32_t location_in_flash){
     
     uint32_t k=0;
     
     //read byte width from the first word, width from second, and height from third
     image->byte_width	= 324;
     image->width		= 2592;
     image->height		= 1944;
     
     
     for( k=0; k< (image->byte_width)*(image->height); k++){
          IOWR_8DIRECT(image->pixels,k,IORD_8DIRECT(location_in_flash, k));
     }
}
