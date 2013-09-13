#include "segmentation.h"

image_t*  trim_staff(image_t *img){

     /* simple function to trim excess
     space from left and right edges of staff
     adds two pixels of padding to each side
     
     Var Declaration*/
     uint16_t height,width;
     projection_t* proj_onto_x;
     projection_t* proj_onto_y;
     uint16_t last_l,last_r,last_t,last_b;
     uint16_t trsh;
     uint16_t i,j;
     image_t* new_img;
     /*End Var Declaration*/
     height=img->height;
     width=img->width;
    
    proj_onto_x = project(img, 1);
    
    last_l = 0;
    last_r = width-1;
    trsh = height/50;/*was float*/
    for (i=1;i<(width+1)/3;i++){/*maybe (width+1)/3-1*/
        if (proj_onto_x->data[i] < trsh)
            last_l = i;    
        if (proj_onto_x->data[width-i] < trsh)
            last_r = width-i;
    }
    delete_flex_array(proj_onto_x);
    proj_onto_y = project(img, 2);
    
    last_t = 0;
    last_b = height-1;
    trsh = width /200;/*was float*/
    for (i=1;i<(height+1)/3;i++){
        if (proj_onto_y->data[i] < trsh)
            last_t = i;    
        if (proj_onto_y->data[height-i] < trsh)
            last_b = height-i;
    }
    /*crop:*/
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
       /*this code uses a projection to determine cuts for 
       segmenting a music page into individual lines of music*/

       height=img->height;
       width=img->width;
       /*projection on to vertical axis:*/
       proj_onto_y = project(img , 2);
       /*calculate threshold:*/
       thrsh = 0.42 * max_array(proj_onto_y);
       crude_lines = find(proj_onto_y,thrsh,greater);
       delete_flex_array(proj_onto_y);
       /*create array holding y values of all stafflines:*/
       l = crude_lines->length;
       i = 0;
       length_staff_lines=0;
       
       /*find length of staff line array*/
       while (i < l){
    
             /*next staffline must be at least two pixels away:*/
             while ( ((i+1)<l) && ((crude_lines->data[i]+1)==crude_lines->data[i+1]||((crude_lines->data[i]+2)==crude_lines->data[i+1]))){
                   i = i + 1;
             }
             length_staff_lines++;
             i = i + 1;
       }
       
       less_crude_lines=make_flex_array(length_staff_lines);
       
       line_w=make_flex_array(length_staff_lines);
       i=0;
       staffCounter=0;
       while (i < l){
             s_begin = crude_lines->data[i];
    
             /*next staffline must be at least two pixels away:*/
             while ( ((i+1)<l) && ((crude_lines->data[i]+1)==crude_lines->data[i+1]||((crude_lines->data[i]+2)==crude_lines->data[i+1]))){
                   i = i + 1;
             }
             s_end = crude_lines->data[i];
             /*add staffline to array:*/
             
             less_crude_lines->data[staffCounter]=(s_begin+s_end+1)/2;/*round((s_begin + s_end)/2) works the same*/
             line_w->data[staffCounter]=(s_end - s_begin+1);/*think this is necessary the +1 is new*/
             i = i + 1;
             staffCounter++;
       }
       delete_flex_array(crude_lines);
       /*search for any incorrect lines*/
       /*(check against others):*/
       diff_lines=diff(less_crude_lines);
       fudge=median(diff_lines);
       delete_flex_array(diff_lines);
       l = less_crude_lines->length;
       kill_array=make_flex_array(l);
       for (i=0;i<l;i++){
           kill_array->data[i]=0;
       }
       i = 0;
       while (i<=(l-5)){
            test_lines = sub_array(less_crude_lines,i,i+4);/*staff_lines(i:i+4);*/
            diff_array=abs_diff(test_lines);
            delete_flex_array(test_lines);
            minus_array_var=minus(diff_array,fudge);
            delete_flex_array(diff_array);
            compare_array=find(minus_array_var,fudge/5,greater);
            delete_flex_array(minus_array_var);
            if (compare_array){
               kill_array->data[i]=1;
               i = i + 1;
            }
            delete_flex_array(compare_array);
            i = i + 5;
       }
       while (i<l){
             kill_array->data[i]=1;
             i++;
       }
       /*for (i=0;i<l;i++){
           if(kill_array->data[i]==0) printf("%d\n",less_crude_lines->data[i]);
       }
       system("PAUSE");*/
       /*kill bad stafflines:*/
       less_crude_lines=kill_array_indices(less_crude_lines,kill_array);
       delete_flex_array(kill_array);
       l=less_crude_lines->length;
       if(l%5)return NULL;/*error checking should change later;*/
       
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

       /*calculate a good place to cut stafflines*/
       top=get_line_at_index(staff,0);
       middle=get_line_at_index(staff,2);
       bottom=get_line_at_index(staff,4);
       diff_array=minus_array(bottom,top);
       delete_flex_array(top);
       delete_flex_array(bottom);
       new_param=malloc(sizeof(params));
       new_param->staff_h=rounded_mean(diff_array);
       delete_flex_array(diff_array);
       range_f=((new_param->staff_h)*range_f+2)/4;/*should be same as round(range_f/2*mean(staff_lines(5, :) - staff_lines(1, :))); where range_f was 2.5*/
       for (i=0;i<l/5;i++){
            addNum=middle->data[i]-range_f;
            if(addNum<0) addNum=0;
            staff->staff_bounds[i][0]=addNum;
            addNum=middle->data[i]+range_f;
            if(addNum>=height) addNum=height-1;
            staff->staff_bounds[i][1]=addNum;
       }
       delete_flex_array(middle);
       /*music parameters */
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
       new_param->spacing=addNum/(4*(staff->number_staffs))-new_param->thickness;/*may introduce rounding errors*/
       new_param->ks=0;
       new_param->ks_x=0;
       return new_param;
}

image_t* get_staff(const image_t* img, const staff_info* staff,uint16_t count)
{
         /*Var Declarations*/
         uint16_t top,bottom;
         image_t* new_img;
         /*End Var Declarations*/
         
         /*isolate staff*/
         top=staff->staff_bounds[count][0];
         bottom=staff->staff_bounds[count][1];
         new_img=get_sub_img(img,top,bottom,-1,-1);
         
         /*trim staff*/
         blob_kill(new_img,0,1);
         return trim_staff(new_img);
}

/* Matlab conversion in progress*/

image_t* remove_lines(image_t* img, params* staff_params, uint16_t numCuts, uint16_t **STAFFLINES)
{
         /*returns staff without lines, and STAFFLINES as a 5x2 array*/
         uint16_t line_thickness,height,width,line_spacing;
         uint16_t beginCut,endCut;
         projection_t* yprojection;
         projection_t* yprojection2;
         flex_array_t* ones_array;
         flex_array_t* ones_array2;
         flex_array_t* staffLines;
         uint16_t** last_stafflines;
         int16_t* array_staff;
         linked_list* stack;
         int16_t max_project;
         uint16_t i,j,lines_found;
         int16_t shift_variable;
         uint16_t vertSplice;
         image_t* fixThatImage;
         image_t* new_img;
         
         
         /*End Var Declarations*/
         line_thickness=staff_params->thickness; 
         line_spacing=staff_params->spacing;
         height=img->height;
         width=img->width;
         beginCut = 0;
         endCut = (width+numCuts/2)/numCuts;
         
         /*/ get inital staff line estimates*/
         yprojection2 = project(img,2);
         
         ones_array=array_ones(line_thickness);
         ones_array2=array_ones(1);
         yprojection = filter(ones_array,ones_array2,yprojection2); /* reduce impact of 'double peaks' (curvy lines)*/
         delete_flex_array(ones_array);
         delete_flex_array(ones_array2);
         delete_flex_array(yprojection2);
         max_project = index_of_max(yprojection);
         for (i=max_project-(line_spacing+1)/2;i<max_project+(line_spacing+1)/2;i++){
             yprojection->data[i]=0;
         }
             

         staffLines=find(yprojection,.8*max_project,greater); /*delete staff line, twiddle with the 85% later*/
         stack = group(staffLines,3);

         last_stafflines=multialloc(sizeof(uint16_t),2,5,2);
         i=0;
         while (is_list_empty( stack)==0){
               array_staff=pop_bottom(stack);
               last_stafflines[i][0]=(uint16_t)array_staff[0];
               last_stafflines[i][1]=(uint16_t)array_staff[1];
               free(array_staff);
               i++;
         }
    /* LOOP THRU VERTICAL CUTS*/
    shift_variable=0;
    for (vertSplice = 0;vertSplice<numCuts; vertSplice++){
        fixThatImage = get_sub_img(img,-1,-1,beginCut,endCut);
    
        /*pretty up staff lines*/
        /*implement this once created...
        //[img(:,beginCut:endCut),shift_variable,stafflines] = ...
          //  fix_lines_and_remove_smart(fixThatImage,params,last_stafflines,shift_variable,vertSplice);
            
        //modify last_stafflines in place */ 
        delete_image(fixThatImage);
        if (vertSplice==1 && STAFFLINES){
           for (i=0;i<5;i++){
               for (j=0;j<2;j++){
                   STAFFLINES[i][j]=last_stafflines[i][j]+2;/*create STAFFLINES*/
               }
           }
        }
        
    
        beginCut = endCut + 1;
        endCut += (width+numCuts/2)/numCuts;
        if (endCut >= width) endCut = width-1;
    }
    
    new_img=make_image(img->height +4,img->width +4);
    for (i=0;i<(img->height +4);i++){
        for (j=0;j<(img->width +4);j++){
            if (i<2 ||j<2 ||(i>(img->height +1)) ||(j>(img->width +1))){
                setPixel(new_img,i,j,0);
            }
            else {
                 setPixel(new_img,i,j,getPixel(img,i-2,j-2));
            }
        }
    }
    return new_img;
}
/*Matlab code conversion*/

flex_pointer_array_t* find_top_bottom(const image_t* img,uint16_t height_min,uint16_t leftCutoff,linked_list* groupings){
    // finds all vertical lines (stems, measure markers)
    // Returns:
    // groupings - indices within goodLines array of start and end of each vertical line
    //   ex: [40 42
    //        55 58
    //        100 110]
    //
    // goodLines - array of structs for each vertical found
    //   .top
    //   .bottom
    //   .left
    //   .right
    
    //Var Declarations
    uint16_t height,width,col,row,test_length,i,real_length;
    flex_pointer_array_t *goodlines;
    linked_list *goodlines_first;//since unsure of size, trim down later
    flex_array_t *starts;
    uint8_t inLine,shift,step;
    uint16_t cursor1,cursor2;
    good_lines_t *lines;
    //End Var Declarations
    
    height=img->height;
    width=img->width;

    goodlines_first=create_linked_list();                                   
   
    real_length=0;
    for (col=0;col<width;col++){
        test_length=0;
        i=0;
        for (row=1;row<height;row++){
            if(!getPixel(img,row-1,col) && getPixel(img,row,col)) test_length++;
        }
        starts=make_flex_array(test_length);
        for (row=1;row<height;row++){
            if(!getPixel(img,row-1,col) && getPixel(img,row,col)) starts->data[i++]=row;;
        }
        
        for (i=0;i<test_length;i++) {//start = starts;
            inLine = 1;
            cursor1=starts->data[i];
            cursor2=col;
            shift = 0;
            
            while(inLine){
                step = 0;
                if ( getPixel(img,cursor1+1,cursor2) ){ // right below
                    cursor1++;
                    step = 1;
                }
    
                if ( cursor2+1 < width && !step ){ // to the bottom right
                    if (getPixel(img,cursor1+1,cursor2+1) ){
                        cursor1++;
                        cursor2++;
                        step = 1;
                        shift++;
                    }
                }
                    
                if ( cursor2-1 >= 0 && !step){ // to the bottom left
                    if (getPixel(img,cursor1+1,cursor2-1) ){
                        cursor1++;
                        cursor2--;
                        step = 1;
                        shift ++;
                    }
                }
                    
                if (!step || shift > 3){ // can't continue black run
                   if (cursor1-(starts->data[i])>=height_min){
                        real_length++;
                        lines=(good_lines_t *)malloc(sizeof(good_lines_t));
                        lines->bottom=cursor1;
                        lines->index=col;
                        lines->left= col<cursor2 ? col : cursor2;
                        lines->top=starts->data[i];
                        lines->right=col>cursor2 ? col: cursor2;
                        lines->left +=leftCutoff-1;
                        lines->right+= leftCutoff-1;
                        push_top(goodlines_first,lines);
                   }
                   inLine = 0;
                }
                
            } // end while in line
        
        } // end for thru each starting location 
        delete_flex_array(starts);   
        
    } // end for thru each column
    goodlines=make_flex_pointer_array(real_length,sizeof(good_lines_t*));
    starts=make_flex_array(real_length);
    for (i=0;i<real_length;i++){
        goodlines->data[i]=pop_bottom(goodlines_first);
        starts->data[i]=((good_lines_t*)(goodlines->data[i]))->left;
    }
    delete_list(goodlines_first);
    //GROUP LINES TOGETHER
    groupings=fill_group(groupings,starts,5); //2nd arg chosen to group close lines together
    
    delete_flex_array(starts);
    return goodlines;

}

image_t* mini_img_cut(const image_t* img,uint16_t top,uint16_t bottom,uint16_t xbegin,uint16_t xend,const params* parameters, note_cuts* cuts)
{
    // cuts out small image around stem/measure marker
    
    //Var Declarations
    uint16_t height, width,line_spacing,extend,count;
    int16_t left,right;
    int16_t topCut,bottomCut,leftCut,rightCut;
    int16_t extUp,extDown,extLeft,extRight;
    image_t* sub_img;
    projection_t* proj;
    //End Var Declarations
    
    height=img->height;
    width=img->width;
    
    line_spacing = parameters->spacing;
    
    extend = (8*line_spacing+2)/5;
    
    
    // top and bottom cuts
    
    left = xbegin - line_spacing;
    right = xend + line_spacing;
    
    extUp = 1;
    count = 0;
    while (extUp < line_spacing && top-extUp >= 0){
          sub_img=get_sub_img(img,top-extUp,top-extUp,left,right);
          proj=project(sub_img,2);
          delete_image(sub_img);
          if(proj->data[0] == 0) count ++;
          delete_flex_array(proj);
          if(count > 2) break;
          extUp++;
    }
    topCut = top - extUp + count;

    extDown = 1;
    count = 0;
    while (extDown < line_spacing && bottom+extDown <height){
          sub_img=get_sub_img(img,bottom+extDown,bottom+extDown,left,right);
          proj=project(sub_img,2);
          delete_image(sub_img);
          if(proj->data[0] == 0) count ++;
          delete_flex_array(proj);
          if(count > 2) break;
          extDown++;
    }
    bottomCut = bottom + extDown - count;
    
    // left and right cuts
    
    extLeft = 1;
    count = 0;
    while (extLeft < extend && xbegin-extLeft>=0){
          sub_img=get_sub_img(img,topCut,bottomCut,xbegin-extLeft,xbegin-extLeft);
          proj=project(sub_img,1);
          delete_image(sub_img);
          if(proj->data[0] == 0) count ++;
          delete_flex_array(proj);
          if(count > 0) break;
          extLeft++;
    }
    leftCut = xbegin - extLeft + count;
    
    extRight = 1;
    count = 0;
    while (extRight < extend && xend+extRight<width){
          sub_img=get_sub_img(img,topCut,bottomCut, xend+extRight, xend+extRight);
          proj=project(sub_img,1);
          delete_image(sub_img);
          if(proj->data[0] == 0) count ++;
          delete_flex_array(proj);
          if(count > 0) break;
          extRight++;
    }
    rightCut = xend + extRight - count;
    
    // precautions to prevent segfaults:
    if (topCut < 0) topCut = 0;
    if (bottomCut >= height)  bottomCut = height-1;
    if (leftCut < 0) leftCut = 0;
    if (rightCut >= width) rightCut = width-1;
    
    cuts->bottom_cut=bottomCut;
    cuts->left_cut=leftCut;
    cuts->right_cut=rightCut;
    cuts->top_cut=topCut;
    
    
    
    // output - cut box
    return get_sub_img(img,topCut,bottomCut,leftCut,rightCut);
}
