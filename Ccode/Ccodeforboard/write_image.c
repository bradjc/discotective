#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "sdram.h"
#include "image_data.h"
#include "preprocessing.h"
#include "allocate.h"


#define img_start 0x00800000
#define img_end   0x00CCE300
#define SD_end    0x00FFFFFF
#define width_big     2592  
#define height_big    1944


void vga_draw_image(const image_t* img){
     uint16_t vert_down, hor_down,down_sample;
     uint16_t i,j;
     uint8_t color;
     if(!vga_init())return;
     vert_down=1;
     hor_down=1;
     if(img->height >480) vert_down=((img->height)+479)/480;
     if(img->width >640) hor_down=((img->width)+639)/640;
     down_sample=vert_down > hor_down ?vert_down :hor_down;
     for (i=0;i<(img->height);i+=down_sample){
         for (j=0;j<(img->width);j+=down_sample){
             color=(img->data[i][j])==0 ? 0xFF : 0;
             alt_up_pixel_buffer_dma_draw(VGA_port, color, j/down_sample, i/down_sample);
         }
     }
}
     


int main(int argc, char *argv[])
{
    uint8_t** image;
    uint32_t i,j,k;
    image_t* binIMG;
    k=0;
    image=(uint8_t**)get_img(width_big,height_big,sizeof(uint8_t));
    for ( i=0;i<height_big;i++){
        for (j=0;j<width_big;j++){
            image[i][j]=*(SDRAM_ptr+(k++));
        }
    }
    binIMG = make_image(height_big,width_big); /*(uint8_t **)multialloc (sizeof (uint8_t), 2, height, width);*/
	binarizeIMG(image, height_big, width_big, binIMG, -20);
	multifree(image,2);
    vga_draw_image(binIMG);
    delete_image(binIMG);
       
  
  
  
  	
  return 0;
}
