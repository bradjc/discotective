#include <stdio.h>
#include <stdlib.h>
#include "image_data.h"
#include "utility_functions.h"

/*A y projection-do not use directly*/
projection_t* project_y(const image_t *img);

/*An x projection-do not use directly*/
projection_t* project_x(const image_t *img);

image_t*  make_image(uint16_t arraySizeX, uint16_t arraySizeY) {
          int i,j;
          image_t* img;
          if((arraySizeX==0) || (arraySizeY==0)) return 0;/* can't have size 0.*/
          /*allocate memory for image_t*/
           img=malloc(sizeof(image_t));
           img->pixels=(image_data)multialloc(sizeof(uint8_t),2,arraySizeX,arraySizeY);
           img->height=arraySizeX;
           img->width=arraySizeY;
            
           
           /*initialize to zero*/
           for (i=0;i<arraySizeX;i++){
               for (j=0;j<(arraySizeY>>3)+1;j++){/*arraySizeY is in pixels so need the index of the types*/
                   img->pixels[i][j]=0x00;
               }
           }
           return img;
} 
              

void delete_image(image_t* img){
     if(img){
             multifree(img->pixels,2);
             free(img);
             img=NULL;
     }
}



uint8_t getPixel(const image_t *img,uint16_t h,uint16_t  w)
{
        uint8_t pixel_string;
        uint8_t shiftnum;
        /*save image using uint8_t so as to be efficient. This function allows us
        to access an individual pixel. as written from left to right this allows
        the indexing of pixel to be converted to the actual index and then masks and shifts*/
        if (h>=(img->height) ||w>=(img->width)){
           return 0xFF;
        }                           
        pixel_string=img->pixels[h][w>>3];
        shiftnum=(7+(w&0xF8)-w);
        return (uint8_t)((pixel_string&(1<<shiftnum))>>shiftnum);
}
void setPixel(image_t *img, uint16_t h, uint16_t  w, uint8_t value)
{
     /*sets the value of the pixel noted by h and w to value*/
     if (h>=(img->height) ||w>=(img->width)){
           return;
     }
     if(value){
               img->pixels[h][w>>3]=img->pixels[h][w>>3]|(1<<(7+(w&0xF8)-w));
     }
     else{
          img->pixels[h][w>>3]=img->pixels[h][w>>3]&( 0xFF^   (1<<   (7+(w&0xF8)-w)   )     );
    }
}   

projection_t* project_y(const image_t *img)
{           
            uint16_t i,j;
            int16_t sum;
            uint16_t length;
            projection_t* proj;
            length=img->height;
            proj=make_flex_array(length);
            for (i=0;i<(length);i++){
                sum=0;
                for (j=0;j<(img->width);j++){
                    sum+=getPixel(img,i,j);
                }
                proj->data[i]=sum;
            }
            return proj;
}
projection_t* project_x(const image_t *img)
{
            uint16_t i,j;
            int16_t sum;
            uint16_t length;
             projection_t* proj;
             length=img->width;
            proj=make_flex_array(length);
            for (i=0;i<length;i++){
                sum=0;
                for (j=0;j<img->height;j++){
                    sum+=getPixel(img,j,i);
                }
                proj->data[i]=sum;
            }
            return proj;
}
projection_t* project(const image_t *img,int xOrY){
             if(xOrY==1) return project_x(img);
             else return project_y(img);
}

image_t* get_sub_img(const image_t* img, int16_t h_start, int16_t h_end,int16_t w_start,int16_t w_end)
{
         /*Var Declarations*/
         image_t* new_img;
         uint16_t  i,j;
         /*End Var Declarations*/
         
         
         /*Input cleaning and error checking*/
         if(h_start==-1) h_start=0;
         if(h_end==-1) h_end=img->height -1;
         if(w_start==-1) w_start=0;
         if(w_end==-1) w_end=img->width -1;
         
         if(h_start<0 ||h_end<0||w_start<0||w_end<0){
                      printf("get_sub_img: Index below 0\n");
                      printf("h: [%d %d], w: [%d %d]\n",h_start,h_end,w_start,w_end);
                      return NULL;
         
         }
         if(h_start>h_end ||w_start>w_end){
                      printf("get_sub_img: Overlapping indices\n");
                      printf("h: [%d %d], w: [%d %d]\n",h_start,h_end,w_start,w_end);
                      return NULL;
         
         }
         if(h_end>=(img->height)||w_end>=(img->width)){
                      printf("get_sub_img:Index greater than or equal to width or height, pass -1 to indicate end of matrix\n");
                      printf("h:%d, height:%d, w: %d, width: %d\n",h_end,img->height,w_end,img->width);
                      return NULL;
         
         }
         /*End cleaning and error checking*/
         
         new_img=make_image(h_end-h_start+1,w_end-w_start+1);
         for (i=0;i<(new_img->height);i++){
             for (j=0;j<(new_img->width);j++){
                 setPixel(new_img,i,j,getPixel(img,i+h_start,j+w_start));
             }
         }
         return new_img;
}


void print_image(const image_t* img){
     uint16_t i,j;
     for (i=0;i< (img->height);i++){
         for (j=0; j< (img->width);j++){
             if (getPixel(img,i,j)) printf("#");
             else printf(" ");
         }
         printf("\n");
     }
     printf("\n\n");
}

uint8_t all_black(const image_t* img){
        uint16_t i,j;
        
        for (i=0;i< (img->height) ;i++){
            for (j=0; j< (img->width); j++){
                if (!getPixel(img,i,j)) return 0;
            }
        }
        return 1;
}

uint8_t any_black(const image_t* img){
        uint16_t i,j;
        
        for (i=0;i< (img->height) ;i++){
            for (j=0; j< (img->width); j++){
                if (getPixel(img,i,j)) return 1;
            }
        }
        return 0;
}
                      
         



