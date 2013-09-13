#include "algorithms.h"
#include "image_data.h"
#include "linked_list.h"

image_t*  trim_staff(image_t *img){

     // simple function to trim excess
     // space from left and right edges of staff
     // adds two pixels of padding to each side
     
     //Var Declaration
     uint16_t height,width;
     projection_t* proj_onto_x;
     projection_t* proj_onto_y;
     uint16_t last_l,last_r,last_t,last_b;
     uint16_t trsh;
     uint16_t i,j;
     image_t* new_img;
     //End Var Declaration
     height=img->height;
     width=img->width;
    
    proj_onto_x = project(img, 1);
    
    last_l = 0;
    last_r = width-1;
    trsh = height/50;//was float
    for (i=1;i<(width+1)/3;i++){//maybe (width+1)/3-1
        if (proj_onto_x->data[i] < trsh)
            last_l = i;    
        if (proj_onto_x->data[width-i] < trsh)
            last_r = width-i;
    }
    delete_flex_array(proj_onto_x);
    proj_onto_y = project(img, 2);
    
    last_t = 0;
    last_b = height-1;
    trsh = width /200;//was float
    for (i=1;i<(height+1)/3;i++){
        if (proj_onto_y->data[i] < trsh)
            last_t = i;    
        if (proj_onto_y->data[height-i] < trsh)
            last_b = height-i;
    }
    // crop:
    new_img=make_image(last_b+5-last_t,last_r+5-last_l);
    for (i=0;i<last_b+5-last_t;i++){
        for (j=0;j<last_r+5-last_l;j++){
            if (i<2 ||j<2 ||(i>last_b+1-last_t) ||(j>last_r+1-last_l)){
                setPixel(new_img,i,j,0);
            }
            else {
                 setPixel(new_img,i,j,getPixel(img,last_t+i-2,last_l+j-2));
            }
        }
    }
    delete_image(img);
    
    return(new_img);
}

params* staff_segment(const image_t *img, staff_info *staff){
       int8_t range_f;
       float thrsh;
       uint16_t height;
       uint16_t width;
       uint16_t l;
       uint16_t i;
       uint16_t staffCounter,staffX,staffY;
       uint16_t length_staff_lines;
       uint16_t s_begin,s_end,fudge;
       int16_t addNum;
       projection_t* proj_onto_y;
       flex_array_t* crude_lines;
       flex_array_t* line_w;
       flex_array_t* diff_array;
       flex_array_t* minus_array_var;
       flex_array_t* compare_array;
       flex_array_t* kill_array;
       flex_array_t* less_crude_lines;
       flex_array_t* diff_lines;
       flex_array_t* test_lines;
       flex_array_t* top;
       flex_array_t* middle;
       flex_array_t* bottom;
       params* new_param;
       range_f=5;
       // this code uses a projection to determine cuts for 
       // segmenting a music page into individual lines of music

       height=img->height;
       width=img->width;

       // projection on to vertical axis:
       proj_onto_y = project(img , 2);

       // calculate threshold:
       thrsh = 0.42 * max_array(proj_onto_y);
       crude_lines = find(proj_onto_y,thrsh,greater);
       delete_flex_array(proj_onto_y);
       
       // create array holding y values of all stafflines:
       l = crude_lines->length;
       i = 0;
       length_staff_lines=0;
       
       //find length of staff line array
       while (i < l){
    
             // next staffline must be at least two pixels away:
             while ( ((i+1)<l) && ((crude_lines->data[i]+1)==crude_lines->data[i+1]||((crude_lines->data[i]+2)==crude_lines->data[i+1]))){
                   i = i + 1;
             }
             length_staff_lines++;
             i = i + 1;
       }
       
       less_crude_lines=malloc(sizeof(flex_array_t)+(length_staff_lines*sizeof(int16_t)));
       less_crude_lines->length=length_staff_lines;
       
       line_w=malloc(sizeof(flex_array_t)+(length_staff_lines*sizeof(int16_t)));
       line_w->length=length_staff_lines;
       i=0;
       staffCounter=0;
       while (i < l){
             s_begin = crude_lines->data[i];
    
             // next staffline must be at least two pixels away:
             while ( ((i+1)<l) && ((crude_lines->data[i]+1)==crude_lines->data[i+1]||((crude_lines->data[i]+2)==crude_lines->data[i+1]))){
                   i = i + 1;
             }
             s_end = crude_lines->data[i];
             // add staffline to array:
             
             less_crude_lines->data[staffCounter]=(s_begin+s_end+1)/2;//round((s_begin + s_end)/2) works the same
             line_w->data[staffCounter]=(s_end - s_begin+1);//think this is necessary the +1 is new
             i = i + 1;
             staffCounter++;
       }
       delete_flex_array(crude_lines);
       // search for any incorrect lines
       // (check against others):
       diff_lines=diff(less_crude_lines);
       fudge=median(diff_lines);
       delete_flex_array(diff_lines);
       l = less_crude_lines->length;
       kill_array=malloc(sizeof(flex_array_t)+(l*sizeof(int16_t)));
       kill_array->length=l;
       for (i=0;i<l;i++){
           kill_array->data[i]=0;
       }
       i = 0;
       while (i<(l-5)){
            test_lines = sub_array(less_crude_lines,i,i+4);//staff_lines(i:i+4);
            diff_array=abs_diff(test_lines);
            delete_flex_array(test_lines);
            minus_array_var=minus(diff_array,fudge);
            delete_flex_array(diff_array);
            compare_array=find(minus_array_var,fudge/5,greater);
            delete_flex_array(minus_array_var);
            if (compare_array->length){
               kill_array->data[i]=1;
               i = i + 1;
            }
            delete_flex_array(compare_array);
            i = i + 5;
       }
       
       // kill bad stafflines:
       less_crude_lines=kill_array_indices(less_crude_lines,kill_array);
       delete_flex_array(kill_array);
       l=less_crude_lines->length;
       if(l%5)return NULL;//error checking should change later;
       
       staff->staff_lines=(uint16_t**)multialloc(sizeof(uint16_t),2,5,l/5);
       staff->staff_bounds=(uint16_t**)multialloc(sizeof(uint16_t),2,l/5,2);
       staff->number_staffs=l/5;
       staffX=0;
       staffY=0;
       for (i=0;i<l;i++){
           staff->staff_lines[staffX][staffY]=less_crude_lines->data[i];
           staffX++;
           if (staffX==5){
              staffX=0;
              staffY++;
           }
       }
       
       delete_flex_array(less_crude_lines);

       // calculate a good place to cut stafflines
       top=get_line_at_index(staff,0);
       middle=get_line_at_index(staff,2);
       bottom=get_line_at_index(staff,4);
       diff_array=minus_array(bottom,top);
       delete_flex_array(top);
       delete_flex_array(bottom);
       new_param=malloc(sizeof(params));
       new_param->staff_h=rounded_mean(diff_array);
       delete_flex_array(diff_array);
       range_f=((new_param->staff_h)*range_f+2)/4;//should be same as round(range_f/2*mean(staff_lines(5, :) - staff_lines(1, :))); where range_f was 2.5
       for (i=0;i<l/5;i++){
            addNum=middle->data[i]-range_f;
            if(addNum<0) addNum=0;
            staff->staff_bounds[i][0]=addNum;
            addNum=middle->data[i]+range_f;
            if(addNum>=height) addNum=height-1;
            staff->staff_bounds[i][1]=addNum;
       }
       delete_flex_array(middle);
       //music parameters 
       new_param->thickness=rounded_mean(line_w);
       delete_flex_array(line_w);
       addNum=0;
       for (i=1;i<5;i++){
           top=get_line_at_index(staff,i);
           bottom=get_line_at_index(staff,i-1);
           diff_array=minus_array(top,bottom);
           delete_flex_array(top);
           delete_flex_array(bottom);
           addNum+=sum(diff_array);
           delete_flex_array(diff_array);
       }
       addNum+=2*(staff->number_staffs);
       new_param->spacing=addNum/(4*(staff->number_staffs))-new_param->thickness;//may introduce rounding errors
       new_param->ks=0;
       return new_param;
}

void blob_kill(image_t* img, uint8_t lr, uint8_t tb){

    //%%% OVERVIEW %%%
    
    // this algorithm removes any black images from
    // around the image border using a depth first search
    
    // be sure that the blobs are not large
    // or the runtime will increase dramatically
    
    // set lr to 1 to remove blobs from the left and right
    // set tb to 1 to remove blobs from the top and bottom
    
    //%%% SET-UP %%%
    //Var Declarations
    uint16_t height,width,col,row,n;
    uint8_t nbors[4][2];
    linked_list* stack;
    uint16_t* array;
    uint16_t* array2;
    int16_t watch;
    //End Var Declaraions
    height=img->height;
    width=img->width;
    nbors[0][0]=-1;
    nbors[0][1]=-1;
    nbors[1][0]=-1;
    nbors[1][1]= 1;
    nbors[2][0]= 1;
    nbors[2][1]=-1;
    nbors[3][0]= 1;
    nbors[3][1]= 1;
    stack=create_linked_list();
    watch=0;
    
    
    //%%% ALGORITHM %%%
    
    if (lr == 1){
        // loop through left and right border pixels
        for (col = 0;col<width;col+=width-1){
            for (row = 0;row<height;row++){
                
                // look for blob:
                if (getPixel(img,row,col) == 1){
                    
                    // initialize blob stuff:
                    setPixel(img,row,col,0);
                    array=malloc(2*sizeof(uint16_t));
                    array[0]=row;
                    array[1]=col;
                    push_top(stack,array);
                    watch++;
                    
                    // depth first search:
                    while (is_list_empty(stack)==0){
                          array=pop_top(stack);
                        
                        // check neighbors:
                        for (n=0;n<4;n++){
                            array2=malloc(2*sizeof(uint16_t));
                            array2[0]=array[0]+nbors[n][0];
                            array2[1]=array[1]+nbors[n][1];
                            if (array2[0]>0 && array2[1]>0 && array2[0]<=height && array2[1]<=width && getPixel( img,array2[0], array2[1] ) ){
                                push_top(stack,array2);
                                watch++;
                                setPixel(img,array2[0], array2[1],0);
                            }
                            else free(array2);
                        }
                        free(array);
                    }
                }
            }
        }
    }
    
    if (tb == 1){
        // loop through top and bottom border pixels:
        for (col = 0;col<width;col++){
            for (row = 0;row<height;row+=height-1){
                
                // look for blob:
                if (getPixel(img,row,col) == 1){
                    
                    // initialize blob stuff:
                    setPixel(img,row,col,0);
                    array=malloc(2*sizeof(uint16_t));
                    array[0]=row;
                    array[1]=col;
                    push_top(stack,array);
                    
                    // depth first search:
                    while (is_list_empty(stack)==0){
                          array=pop_top(stack);
                        
                        // check neighbors:
                        for (n=0;n<4;n++){
                            array2=malloc(2*sizeof(uint16_t));
                            array2[0]=array[0]+nbors[n][0];
                            array2[1]=array[1]+nbors[n][1];
                            if (array2[0]>0 && array2[1]>0 && array2[0]<=height && array2[1]<=width && getPixel( img,array2[0], array2[1] ) ){
                                push_top(stack,array2);
                                setPixel(img,array2[0], array2[1],0);
                            }
                            else free(array2);
                        }
                        free(array);
                    }
                }
            }
        }
    }
    delete_list(stack);

}

image_t* get_staff(const image_t* img, const staff_info* staff,uint16_t count)
{
         //Var Declarations
         uint16_t top,bottom;
         image_t* new_img;
         //End Var Declarations
         
         //isolate staff
         top=staff->staff_bounds[count][0];
         bottom=staff->staff_bounds[count][1];
         new_img=get_sub_img(img,top,bottom,-1,-1);
         
         //trim staff
         blob_kill(new_img,0,1);
         return trim_staff(new_img);
}
         
         
