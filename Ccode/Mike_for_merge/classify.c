#include "classify.h"

uint8_t is_note_open(const image_t* img)
{
        //Var declarations
        uint16_t height,width, open_flags,run,row,col;
        uint8_t blackFirst,thenWhite,anotherBlack,inBlack;
        //End var declarations
        
        height=img->height;
        width=img->width;
        open_flags=0;
        
        for (row=0;row<height;row++){
            //States
            blackFirst=0;
            thenWhite=0;
            anotherBlack=0;
            inBlack=getPixel(img,row,1);
            run=1;
            for (col=1; col<width;col++){
                //update runs
                if (!getPixel(img,row,col) && !inBlack) run++;//white continues
                else if(getPixel(img,row,col) && !inBlack){ //white ends
                     run=1;
                     inBlack=1;
                }
                else if(!getPixel(img,row,col) && inBlack){ //black ends
                     run=1;
                     inBlack=0;
                }
                else run++;
                
                //update state
                if(!blackFirst && run>=2 && inBlack) blackFirst=1;
                else if (!thenWhite && blackFirst && run >=3 && !inBlack) thenWhite=1;
                else if (!anotherBlack && thenWhite && run >=1 && inBlack){
                      open_flags++;
                      break;
                }
            }
        }
        if(open_flags > 2) return 1;
        else return 0;
        
}

void get_key_sig(const image_t* img,const staff_info* staff, params* parameters){

    //Var Declarations
    uint16_t top0,bot0;
    int16_t top,bot;
    float middle;
    image_t* staff0, *staff1, *lineless_img, *shape_img,ks_img;
    uint16_t h,w,fudge,i,left,right;
    uint16_t **STAFFLINES;
    projection_t* proj1, *projs;
    uint16_t ks_x_begin,ks_x_end;
    uint16_t sharps,flats,l,minm,peak1,peak2,p1_x,p2_x;
    int16_t valley;
    int16_t lst_width;
    float w1,w2,s;
    //End Var Declarations
    lst_width=0;
    valley=0;
    
    //%% SET UP STAFF %%%
    
    // get first staff:
           
    top0 = staff->staff_bounds[0][0];
    bot0 = staff->staff_bounds[0][1];
    middle = (top0 + bot0)/2.0;
    
    // prepare to crop at a very specific height:
    top = (int16_t)(middle - (parameters->staff_h)/1.3+.5);
    bot = (int16_t)(middle + (parameters->staff_h)/1.3+.5);
    
    // perform crop:
    staff0 = get_sub_img( img,top,bot, -1,-1);
    
    // trim excess material:
    staff0 = trim_staff(staff0);
    
    // get size and trim:
    h=staff1->height;
    w=staff1->width;
    fudge=(parameters->staff_h+1)/3;// avoids a specific bug
    staff1=get_sub_img(staff0,-1,-1,fudge-1,(w+2)/4-1);
    
    ////// ISOLATE KEY SIGNATURE //////
    
    // remove lines and find middle line:
    STAFFLINES=multialloc(sizeof(uint16_t),2,5,2);
    image_t* remove_lines(image_t* img, params* staff_params, uint16_t numCuts, uint16_t **STAFFLINES);
    lineless_img = remove_lines(staff1, parameters, 20,STAFFLINES);
    middle = (float)STAFFLINES[1][0];
    
    // project onto x-axis:
    proj1 = project(lineless_img, 1);
    
    
    // note: the following code uses the variable i to travel from left to
    // right along the projection.  first it looks for whitespace, then
    // the clef, then sharps or flats, then a key signature.  it detects
    // the key signature by recognizing that a shape centered vertically
    // on the staff.  if no key signature is detected, however, the algorithm
    // can still recover later.
    
    // find all whitespace to the left:
    i = 0;
    while (proj1->data[i] < 2 || proj1->data[i+2] < 2){
        i ++;
    }
    
    // find cleff:
    while (i < (proj1->length - 2) && proj1->data[i] > 1 || proj1->data[i+2] > 1){
        // error check:
        if (i >= (proj1->length - 2)){
            printf("error in staffline removal (key signature classification)");
            delete_image(lineless_img);
            delete_image(staff1);
            delete_flex_array(proj1);
            return;
        }
        i++;
    }
    
    // note start of key signature segment:
    ks_x_begin = i + 5;
    
    // find sharps or flats:
    ks_x_end = 0;
    while (ks_x_end == 0){
        
        // find next symbol:
        //   remove whitespace:
        while(proj1->data[i] < 2 || proj1->data[i+2] < 2){
            i ++;
        }
        left = i;
        //   remove non-whitespace:
        while ((proj1->data[i] > 1 || (proj1->data[i+2] > 1){
            i++;
        }
        right = i;
    
        // isolate symbol:
        shape_img = get_sub_img(lineless_img,-1,-1,left,right);
        
        // take projection onto y:
        projs = project(shape_img, 2);
        
        // find top and bottom bounds:
        top = 0;
        while(projs->data[top] == 0 || projs->data[top+2] == 0){
            top ++;
        }
        bot = h-1;
        while(projs->data[bot] == 0 || projs->data[bot-2] == 0){
            bot --;
        }
        
        // test if bounds are centered about middle line;
        // if so, a key signature is detected:
        if (  ((bot+top)/2.0 - middle) < (parameters->line_spacing)/4.0 && ((bot+top)/2.0 - middle) > (parameters->line_spacing)/(-4.0)){
            ks_x_end = left - 8;
        }
        delete_image(shape_img);
        delete_flex_array(projs);
        
    }
    delete_flex_array(proj1);
    // if key signature segment is very thin,
    // they key must be c:
    if (ks_x_end - ks_x_begin < 5){
        parameters->ks_x = 1;
        parameters->ks = 0;
        return;
    }
    
    // isolate key signature section:
    ks_img = get_sub_img(lineless_img,-1,-1ks_x_begin,ks_x_end);
    
    
    ////// CLASSIFY KEY SIGNATURE //////
    
    // take projection onto x:
    proj1 = project(ks_img, 1);
    
    // travel along projection to classify
    // sharps and flats as they come:
    sharps = 0;
    flats = 0;
    l = proj1->length;
    i = 0;
    while (i < l){
        
        // eat up whitespace:
        while (i < l && proj->data[i] == 0){
            i ++;
        }
        
        
        // find first peak (must be at least min pixels):
        peak1 = 0;
        minm = 8;
        while (i < l && peak1 <= minm){
            while ( (i<(l-1) && proj1->data[i] < proj->data[i+1]) || (i<(l-2) && proj1->data[i] < proj->data[i+2]) ){
                i ++;
            }
            peak1 = project->data[i];
            p1_x = i;
            i ++;
        }
        
        // find dip:
        while ( (i<(l-1) && proj1->data[i] >= proj->data[i+1]) || (i<(l-2) && proj1->data[i] >= proj->data[i+2]) ){
            i++;
        }
        if (i < l) valley = proj1->data[i];
        
        // find second peak:
        while ( (i<(l-1) && proj1->data[i] < proj->data[i+1]) || (i<(l-2) && proj1->data[i] < proj->data[i+2]) ){
              i ++;
        }
        //Current stop of conversion
         // complicated if statement to avoid bugs:
        if (i < l && ((sharps + flats == 0) || abs(i - p1_x - lst_width) < 2)){
            peak2 = proj1->data[i]
            p2_x = i;
            i +=2;
            lst_width = p2_x - p1_x;
            
            // discriminate:
            // (idk, i just made these up... maybe make something better later)
            w1 = -0.6 * ((peak1 - peak2) - parameters->height/10.0);
            w2 = 0.4 * ((peak2 - valley) - parameters->height/7.0);
            s = w1 + w2;
            
            // classify sharp or flat:
            if (s > 0) sharps ++;
            else flats ++;
        }
        else{
            
            if (i < l){
                // error in classification of key signature;
                // reassign value for ks_x (used to trim staffs later):
                parameters->ks_x = (i + fudge + (parameters->height+1)/2 - 10 > 0) ? (i + fudge + (parameters->height+1)/2 - 10) : 0; ;
                i++;
            }
            else{
                // no error; assign ks_x:
                parameters->ks_x = (fudge + ks_x_end - 5) > 0 ? (fudge + ks_x_end - 5)  : 0;
            }
            
        }
        
        // eat up the remaining hump:
        while (i < l && project->data[i] > 0){
            i++;
        }
       
        // loops to next symbol if neccessary ^:
        
    }
    
    // finish up:
    if (sharps >= flats) parameters->ks = sharps + flats;
    else parameters->ks = -1 * (sharps + flats);

}
