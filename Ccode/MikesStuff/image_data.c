#include <stdio.h>
#include <stdlib.h>
#include "image_data.h"


//A y projection-do not use directly
projection_t* project_y(const image_t *img);

//An x projection-do not use directly
projection_t* project_x(const image_t *img);

//Helper functions: Finds the indices of elements in the flex array with respect to some operator and some threshold
flex_array_t* find_greater(const flex_array_t *array, float threshold);
flex_array_t* find_less(const flex_array_t *array, float threshold);
flex_array_t* find_equal(const flex_array_t *array, float threshold);
flex_array_t* find_greater_equal(const flex_array_t *array, float threshold);
flex_array_t* find_less_equal(const flex_array_t *array, float threshold);
flex_array_t* find_not_equal(const flex_array_t *array, float threshold);


image_t*  make_image(uint16_t arraySizeX, uint16_t arraySizeY) {
          int i,j;
          image_t* img;
          if((arraySizeX==0) || (arraySizeY==0)) return 0;// can't have size 0.
          //allocate memory for image_t
           img=malloc(sizeof(image_t));
           img->pixels=(image_data)multialloc(sizeof(uint8_t),2,arraySizeX,arraySizeY);
           img->height=arraySizeX;
           img->width=arraySizeY;
            
           
           //initialize to zero
           for (i=0;i<arraySizeX;i++){
               for (j=0;j<(arraySizeY>>3)+1;j++){//arraySizeY is in pixels so need the index of the types
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

void delete_staff_info(staff_info *staff)
{
     if(staff){
               if ( staff->staff_lines){
                  multifree(staff->staff_lines,2);
                  staff->staff_lines=NULL;
               }
               if ( staff->staff_bounds){
                  multifree(staff->staff_bounds,2);
                  staff->staff_bounds=NULL;
               }
               free(staff);
               staff=NULL;
     }
}
                  
void delete_params(params* p){
     if(p){
           free(p);
           p=NULL;
     }
}           

void delete_flex_array(flex_array_t* proj){
     if(proj){
              free(proj);
              proj=NULL;
     }
}

uint8_t getPixel(const image_t *img,uint16_t h,uint16_t  w)
{
        uint8_t pixel_string;
        uint8_t shiftnum;
        //save image using uint8_t so as to be efficient. This function allows us
        //to access an individual pixel. as written from left to right this allows
        //the indexing of pixel to be converted to the actual index and then masks and shifts
        if (h>=(img->height) ||w>=(img->width)){
           return 0xFF;
        }                           
        pixel_string=img->pixels[h][w>>3];
        shiftnum=(7+(w&0xF8)-w);
        return (uint8_t)((pixel_string&(1<<shiftnum))>>shiftnum);
}
void setPixel(image_t *img, uint16_t h, uint16_t  w, uint8_t value)
{
     //sets the value of the pixel noted by h and w to value
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
            proj=malloc(sizeof(projection_t)+(length*sizeof(int16_t)));
            proj->length=length;
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
            proj=malloc(sizeof(projection_t)+(length*sizeof(int16_t)));
            proj->length=length;
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

int16_t max_array(const flex_array_t *proj){
        int16_t maximum;
         uint16_t i;
         if(proj->length<1)return 0xFFFF;
         maximum=proj->data[0];
         for (i=0;i<(proj->length);i++){
             if((proj->data[i])>maximum) maximum=(proj->data[i]);
         }
         return maximum;
}
                                      
flex_array_t* find_greater(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])>threshold) length++;
              }
              found_array=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              found_array->length=length;
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])>threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}

flex_array_t* find_less(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])<threshold) length++;
              }
              found_array=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              found_array->length=length;
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])<threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}

flex_array_t* find_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])==threshold) length++;
              }
              found_array=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              found_array->length=length;
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])==threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find_greater_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])>=threshold) length++;
              }
              found_array=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              found_array->length=length;
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])>=threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find_less_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])<=threshold) length++;
              }
              found_array=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              found_array->length=length;
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])<=threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find_not_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])!=threshold) length++;
              }
              found_array=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              found_array->length=length;
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])!=threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find(const flex_array_t *array, float threshold, find_flags flag)
{
                  if(flag==greater) return find_greater(array,threshold);
                  else if(flag==less) return find_less(array,threshold);
                  else if(flag==greater_equal) return find_greater_equal(array,threshold);
                  else if(flag==less_equal) return find_less_equal(array,threshold);
                  else if(flag==equal) return find_equal(array,threshold);
                  else return find_not_equal(array,threshold);
}

flex_array_t* diff(const flex_array_t *array)
{
              
              uint16_t length,i;
              flex_array_t* difference;
              if(array->length<2)return NULL;
              length=(array->length)-1;
              
              difference=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              difference->length=length;
              for (i=0;i<length;i++){
                  difference->data[i]=(array->data[i+1])-(array->data[i]);
              }
              return difference;
}

flex_array_t* abs_diff(const flex_array_t *array)
{
              int16_t new_diff;
              
              uint16_t length,i;
              flex_array_t* difference;
              if(array->length<2)return NULL;
              length=(array->length)-1;
              
              difference=malloc(sizeof(flex_array_t)+(length*sizeof(int16_t)));
              difference->length=length;
              for (i=0;i<length;i++){
                  new_diff=(array->data[i+1])-(array->data[i]);
                  if (new_diff<0) new_diff*=(-1);
                  difference->data[i]=new_diff;
              }
              return difference;
}

int16_t sum(const flex_array_t *array)
{
        int16_t sum_var;
        uint16_t i;
        sum_var=0;
        for (i=0; i<(array->length);i++){
            sum_var+=(array->data[i]);
        }
        return sum_var;
}

int16_t rounded_mean(const flex_array_t *array)
{
        uint16_t length;
        int16_t  sum_var;
        length=array->length;
        sum_var=sum(array);
        sum_var+=length>>1;
        return sum_var/length;
}     
//This function allows the computation of the median without sorting.
//It has worst case complexity O(n^2) which is the same as quicksort, but since 
//in most cases the mean and median will be nearby  it has average complexity O(n),
// with a somewhat obnoxious constant factor, but still pretty good
int16_t median(const flex_array_t *array)
{
        
        uint16_t i;
        int16_t var,var2;
        int16_t next,prev;
        int16_t test_median;
        if(array->length<1)return 0xFFFF;
        test_median=rounded_mean(array);
        
        while(1){
            var=0;
            var2=0;
            next=32767;
            prev=-32768;
            for (i=0;i<(array->length);i++){
                if (array->data[i]>test_median){
                   var++;
                   var2++;
                   if((array->data[i]-test_median)<(next-test_median)) next=array->data[i];
                }
                else if (array->data[i]<test_median){
                     if ((test_median-array->data[i])<(test_median-prev))prev=array->data[i];
                }
                else var2++;
            }
            if ((array->length)%2){//if odd 
               if(var*2==(array->length)-1 ) return test_median;
               else if(var*2<(array->length)) test_median=prev;
               else test_median=next;
            }
            else{
                 if (var*2==(array->length)){
                    if(var==var2)return (prev+next+1)/2;
                    else return (next+test_median+1)/2;
                 }
                 else if(var2*2 ==(array->length))return (test_median+prev+1)/2;
                 else if(var*2<(array->length) && var2*2 > (array->length))return test_median;
                 else if(var*2<(array->length)) test_median=prev;
                 else test_median=next;
            }   
        }  
        
         
}

flex_array_t* sub_array(const flex_array_t *array, uint16_t begin, uint16_t end)
{
              flex_array_t *new_array;
              uint16_t i;
              if(end<begin || array==NULL) return NULL;
              if(end>= (array->length)  )end= (array->length) -1;
              new_array=  malloc(sizeof(flex_array_t)+((end+1-begin)*sizeof(int16_t)));
              new_array->length=end+1-begin;
              for (i=begin;i<=end;i++){
                  new_array->data[i-begin]=array->data[i];
              }
              return new_array;
}

flex_array_t* minus(const flex_array_t *array, int16_t number)
{
              flex_array_t *new_array;
              uint16_t i;
              new_array=malloc(sizeof(flex_array_t)+((array->length)*sizeof(int16_t)));
              new_array->length=array->length;
              for (i=0;i<array->length;i++){
                  new_array->data[i]=array->data[i]-number;
              }
              return new_array;
}
 
flex_array_t* minus_array(const flex_array_t *array, const flex_array_t *array2)
{
              
              flex_array_t *new_array;
              uint16_t i;
              if(array->length!=array2->length)return NULL;
              new_array=malloc(sizeof(flex_array_t)+((array->length)*sizeof(int16_t)));
              new_array->length=array->length;
              for (i=0;i<array->length;i++){
                  new_array->data[i]=array->data[i]-array2->data[i];
              }
              return new_array;
} 


flex_array_t* kill_array_indices(flex_array_t *array, const flex_array_t *indices)
{
              uint16_t i,end,length,j;
              flex_array_t *new_array;
              length=0;
              j=0;
              end=((array->length) < (indices->length))?(array->length):(indices->length);
              for (i=0;i<end;i++){
                  if(!(indices->data[i])) length++;
              }
              new_array=malloc(sizeof(flex_array_t)+((length)*sizeof(int16_t)));
              new_array->length=length;
              for (i=0;i<end;i++){
                  if (!(indices->data[i])){
                     new_array->data[j]=array->data[i];
                     j++;
                  }
              }
              delete_flex_array(array);
              return new_array;
}   

flex_array_t* get_line_at_index(const staff_info *staff,uint8_t index)
{
              uint8_t i;
              flex_array_t* new_array;
              new_array=malloc(sizeof(flex_array_t)+((staff->number_staffs)*sizeof(int16_t))); 
              new_array->length=(staff->number_staffs);
              for (i=0;i<(staff->number_staffs);i++){
                  new_array->data[i]=staff->staff_lines[index][i];
              }
              return new_array;
}                                                 



flex_array_t* hist(const flex_array_t *array)
{
              //Var Declarations
              flex_array_t* output_array;
              int16_t max_var;
              uint16_t i;
              uint16_t index;
              //End Var Declarations
              
              max_var=max_array(array)+1;
              if(max_var<1) return NULL;//for this values must be non-negative
              output_array=malloc(sizeof(flex_array_t)+max_var*sizeof(int16_t));
              output_array->length=max_var;
              
              for (i=0;i<max_var;i++){
                  output_array->data[i]=0;
              }
              for (i=0;i<array->length;i++){
                  index=array->data[i];
                  output_array->data[index]++;
              }
              return output_array;
}

uint16_t index_of_max(const flex_array_t *array)
{
         //Var Declarations
         int16_t maximum;
         uint16_t index;
         uint16_t i;
         //End Var Declarations
         if(array->length<1)return 0xFFFF;
         maximum=array->data[0];
         index=0;
         for (i=0;i<(array->length);i++){
             if ((array->data[i])>maximum){
                maximum=(array->data[i]);
                index=i;
             }
         }
         return index;
}

image_t* get_sub_img(const image_t* img, int16_t h_start, int16_t h_end,int16_t w_start,int16_t w_end)
{
         //Var Declarations
         image_t* new_img;
         uint16_t  i,j;
         //End Var Declarations
         
         
         //Input cleaning and error checking
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
         //End cleaning and error checking
         
         new_img=make_image(h_end-h_start+1,w_end-w_start+1);
         for (i=0;i<(new_img->height);i++){
             for (j=0;j<(new_img->width);j++){
                 setPixel(new_img,i,j,getPixel(img,i+h_start,j+w_start));
             }
         }
         return new_img;
}

flex_array_t* array_ones(uint16_t length)
{
              flex_array_t* new_array;
              uint16_t i;
              
              new_array=malloc(sizeof(flex_array_t)+length*sizeof(int16_t)); 
              new_array->length=length;
              for (i=0;i<length;i++){
                  new_array->data[i]=0;
              }
              return new_array;
}

flex_array_t* filter(const flex_array_t *B,const flex_array_t *A,const flex_array_t *X)
{
              flex_array_t* Y;
              uint16_t i,j;
              
              Y=malloc(sizeof(flex_array_t)+(X->length)*sizeof(int16_t));
              Y->length=X->length;
              for (i=0;i<(Y->length);i++){
                  j=0;
                  Y->data[i]=0;
                  while(j<(B->length)&&i>=j){
                      Y->data[i]=(Y->data[i])+(B->data[j])*( X->data[i-j]);
                      j++;
                  }
                  j=1;
                  while(j<(A->length)&&i>=j){                       
                      Y->data[i]=(Y->data[i])-(A->data[j])*( Y->data[i-j]);
                      j++;
                  }
                  Y->data[i]=((Y->data[i])+(A->data[0])/2)/(A->data[0]);
              }  
              return Y;
}                 
                      
         



