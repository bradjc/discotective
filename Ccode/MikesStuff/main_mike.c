#include <stdio.h>
#include <stdlib.h>
#include "image_data.h"
#include "allocate.h" 
#include "linked_list.h"  
#include "algorithms.h"
#include "main_katie.h"

#define function_test 0

int main_test(int argc, char *argv[])
{   
   uint16_t i;    
   uint16_t j;
   params* my_params;
   staff_info* staff;
   projection_t* mike_proj;
   flex_array_t* mike_hist;
   flex_array_t* A;
   flex_array_t* B;
   flex_array_t* X;
   flex_array_t* Y;
   
   image_t* katie;
   
                     
  image_t* img;
  image_t* new_img;
  img=make_image(24,16);
  /*Manually create a staff*/
  img->pixels[0][0]=0x00;
  img->pixels[0][1]=0x00; 
  img->pixels[1][0]=0x3F;
  img->pixels[1][1]=0xFC;  
  img->pixels[2][0]=0x3F;
  img->pixels[2][1]=0xFC; 
  img->pixels[3][0]=0x80;
  img->pixels[3][1]=0x80; 
  img->pixels[4][0]=0x80;
  img->pixels[4][1]=0x80; 
  img->pixels[5][0]=0x00;
  img->pixels[5][1]=0x00;  
  img->pixels[6][0]=0x3F;
  img->pixels[6][1]=0xFC; 
  img->pixels[7][0]=0x3F;
  img->pixels[7][1]=0xFC; 
  img->pixels[8][0]=0x80;
  img->pixels[8][1]=0x80; 
  img->pixels[9][0]=0x00;
  img->pixels[9][1]=0x20;  
  img->pixels[10][0]=0x44;
  img->pixels[10][1]=0x00; 
  img->pixels[11][0]=0x3F;
  img->pixels[11][1]=0xFC; 
  img->pixels[12][0]=0x3F;
  img->pixels[12][1]=0xFC; //end line 3
  img->pixels[13][0]=0x01;
  img->pixels[13][1]=0x00;  
  img->pixels[14][0]=0x10;
  img->pixels[14][1]=0x00; 
  img->pixels[15][0]=0x20;
  img->pixels[15][1]=0x80; 
  img->pixels[16][0]=0x3F;
  img->pixels[16][1]=0xFC; 
  img->pixels[17][0]=0x3F;
  img->pixels[17][1]=0xFC;  
  img->pixels[18][0]=0x00;
  img->pixels[18][1]=0x00; 
  img->pixels[19][0]=0x80;
  img->pixels[19][1]=0x80; 
  img->pixels[20][0]=0x80;
  img->pixels[20][1]=0x80;  
  img->pixels[21][0]=0x3F;
  img->pixels[21][1]=0xFC; 
  img->pixels[22][0]=0x3F;
  img->pixels[22][1]=0xFC;  
  img->pixels[23][0]=0x00;
  img->pixels[23][1]=0x00;
  
  i=0;    
  j=0;
  for (i=0;i<(img->height);i++){
      for (j=0;j<(img->width);j++){
          printf("%d",getPixel(img,i,j));
      }
      printf("\n");
  }                              
  staff=malloc(sizeof(staff_info));
  my_params=staff_segment(img,staff);
  for (i=0;i<(staff->number_staffs);i++){
           printf("Staffs lines: %d,%d,%d,%d,%d\n",staff->staff_lines[0][i],staff->staff_lines[1][i],staff->staff_lines[2][i],staff->staff_lines[3][i],staff->staff_lines[4][i]);
           new_img=get_staff(img,staff,i);
           for (i=0;i<(new_img->height);i++){
               for (j=0;j<(new_img->width);j++){
                   printf("%d",getPixel(new_img,i,j));
               }
               printf("\n");
           }
           printf("\n");
           delete_image(new_img);
  }
  
  X=malloc(sizeof(flex_array_t)+5*sizeof(int16_t));
  A=malloc(sizeof(flex_array_t)+2*sizeof(int16_t));
  B=malloc(sizeof(flex_array_t)+4*sizeof(int16_t));
  B->length=4;
  A->length=2;
  X->length=5;
  A->data[0]=1;
  A->data[1]=1;
  B->data[0]=1;
  B->data[1]=10;
  B->data[2]=-1;
  B->data[3]=0;
  X->data[0]=1;
  X->data[1]=2;
  X->data[2]=0;
  X->data[3]=2;
  X->data[4]=1;
  Y=filter(B,A,X);
  for (i=0;i<(Y->length);i++){
      printf(" %d \n",Y->data[i]);
  }
  delete_flex_array(A);
  delete_flex_array(B);
  delete_flex_array(X);
  delete_flex_array(Y);
  
  
  /*
  for (i=0;i<(staff->number_staffs);i++){
           printf("Staffs bounds: %d,%d\n",staff->staff_bounds[i][0],staff->staff_bounds[i][1]);
  }*/
  
  delete_staff_info(staff);
  delete_params(my_params);
   delete_image(img);
   printf("Press A key + Enter to end");
   scanf("%*d",&i); 
  return 0;
}


int main(int argc, char *argv[])
{
    if(function_test) return main_test(argc,argv);
    else return main_katie(argc,argv);
}
