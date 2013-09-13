#include "classify.h"
#include "segmentation.h"
#include <stdio.h>
#include "utility_functions.h"
#include "image_data.h"


uint8_t is_note_open(const image_t* img)
{
        /*Var declarations*/
        uint16_t height,width, open_flags,run,row,col;
        uint8_t blackFirst,thenWhite,anotherBlack,inBlack;
        /*End var declarations*/
        
        height=img->height;
        width=img->width;
        open_flags=0;
        
        for (row=0;row<height;row++){
            /*States*/
            thenWhite=0;
            anotherBlack=0;
            inBlack=getPixel(img,row,0);
            blackFirst=inBlack;
            run=1;
            for (col=1; col<width;col++){
                /*update runs*/
                if (!getPixel(img,row,col) && !inBlack) run++;/*white continues*/
                else if(getPixel(img,row,col) && !inBlack){ /*white ends*/
                     run=1;
                     inBlack=1;
                }
                else if(!getPixel(img,row,col) && inBlack){ /*black ends*/
                     run=1;
                     inBlack=0;
                }
                else run++;
                
                /*update state*/
                if(!blackFirst && run > 1 && inBlack) blackFirst=1;
                else if (!thenWhite && blackFirst && run > 0 && !inBlack) thenWhite=1;
                else if (!anotherBlack && thenWhite && run > 0 && inBlack){
                      open_flags++;
                      break;
                }
            }
        }
        if(open_flags > 1) return 1;
        else return 0;
        
}

void get_key_sig(const image_t* img,staff_info* staff, params* parameters){

    /*Var Declarations*/
    int16_t top,bot;
    int16_t middle;
    image_t* staff0, *staff1, *lineless_img, *shape_img,*ks_img;
    uint16_t h,w,fudge,i,left,right;
    uint32_t *STAFFLINES;
    projection_t* proj1, *projs;
    uint16_t ks_x_begin,ks_x_end;
    uint16_t sharps,flats,l,minm,peak1,peak2,p1_x,p2_x;
    int16_t valley;
    int16_t lst_width;
    int32_t w1,w2,s;
    char outputFilename[50];
    /*End Var Declarations*/
    lst_width=0;
    valley=0;
    
    /*%% SET UP STAFF %%%*/
    top=staff->staff_bounds[0][0];
    bot=staff->staff_bounds[0][1];
    /* get first staff:*/      
    middle = (top+bot+1)/2;
    
    /* prepare to crop at a very specific height:*/
    /*top = (int16_t)(middle - (10*(parameters->staff_h)+6)/13);
    //bot = (int16_t)(middle + (10*(parameters->staff_h)+6)/13);*/
    
    /* perform crop:*/
    staff0 = get_sub_img( img,top,bot, -1,-1);
    /* trim excess material:*/
    staff0 = trim_staff(staff0);
    
    /* get size and trim:*/
    h=staff0->height;
    w=staff0->width;
    fudge=(parameters->staff_h+1)/3;/* avoids a specific bug*/
    staff1=get_sub_img(staff0,-1,-1,fudge-1,(w+2)/4-1);
    /* ISOLATE KEY SIGNATURE //////*/
    /* remove lines and find middle line:*/
    STAFFLINES=malloc(5*sizeof(uint32_t));
    lineless_img = make_image(staff1->height+4, staff1->width+4);
    remove_lines_2(staff1, parameters, 20,lineless_img,STAFFLINES,staff);
    middle =STAFFLINES[2];/*think this is right was   [1][0]*/
    
    /* project onto x-axis:*/
    proj1 = project(lineless_img, 1);
    
    /* note: the following code uses the variable i to travel from left to
    // right along the projection.  first it looks for whitespace, then
    // the clef, then sharps or flats, then a key signature.  it detects
    // the key signature by recognizing that a shape centered vertically
    // on the staff.  if no key signature is detected, however, the algorithm
    // can still recover later.*/
    /* find all whitespace to the left:*/
    i = 0;
    while (proj1->data[i] < 2 || proj1->data[i+2] < 2){
        i ++;
    }
    
    /* find cleff:*/
    while ( i < (proj1->length - 2) && (proj1->data[i] > 1 || proj1->data[i+2] > 1)){
        /* error check:*/
        if (i >= (proj1->length - 2)){
            printf("error in staffline removal (key signature classification)");
            delete_image(lineless_img);
            delete_image(staff1);
            delete_flex_array(proj1);
            return;
        }
        i++;
    }
    /* note start of key signature segment:*/
    ks_x_begin = i + 5;
    /* find sharps or flats:*/
    ks_x_end = 0;
    while (ks_x_end == 0){
        
        /* find next symbol:*/
        /*  remove whitespace:*/
        while(proj1->data[i] < 2 || proj1->data[i+2] < 2){
            i ++;
        }
        left = i;
        /*   remove non-whitespace:*/
        while ((proj1->data[i] > 1) || (proj1->data[i+2] > 1)){
            i++;
        }
        right = i;
    
        /* isolate symbol:*/
        shape_img = get_sub_img(lineless_img,-1,-1,left,right);
        
        /* take projection onto y:*/
        projs = project(shape_img, 2);
        
        /* find top and bottom bounds:*/
        top = 0;
        while(projs->data[top] == 0 || projs->data[top+2] == 0){
            top ++;
        }
        bot = h-1;
        while(projs->data[bot] == 0 || projs->data[bot-2] == 0){
            bot --;
        }
        
        /* test if bounds are centered about middle line;
        // if so, a key signature is detected:*/
        if (  (bot-top > (9*parameters->staff_h)/10) ||  i> parameters->staff_h){
            ks_x_end = left - fudge+1;/*minus 8?? shouldn't this be minus fudge-1*/
        }
        delete_image(shape_img);
        delete_flex_array(projs);
        
    }
    delete_flex_array(proj1);
    /* if key signature segment is very thin,
    // they key must be c:*/
    if (ks_x_end - ks_x_begin < 5){
        parameters->ks_x = 1;
        parameters->ks = 0;
        return;
    }
    /* isolate key signature section:*/
    ks_img = get_sub_img(lineless_img,-1,-1,ks_x_begin,ks_x_end);
    
    /* CLASSIFY KEY SIGNATURE */
    
    /* take projection onto x:*/
    proj1 = project(ks_img, 1);
    
    /* travel along projection to classify
    sharps and flats as they come:*/
    sharps = 0;
    flats = 0;
    l = proj1->length;
    i = 0;
    while (i < l){
        
        /* eat up whitespace:*/
        while (i < l && proj1->data[i] == 0){
            i ++;
        }
        
        
        /* find first peak (must be at least min pixels):*/
        peak1 = 0;
        minm = 8;
        while (i < l && peak1 <= minm){
            while ( (i<(l-1) && proj1->data[i] < proj1->data[i+1]) || (i<(l-2) && proj1->data[i] < proj1->data[i+2]) ){
                i ++;
            }
            peak1 = proj1->data[i];
            p1_x = i;
            i ++;
        }
        
        /* find dip:*/
        while ( (i<(l-1) && proj1->data[i] >= proj1->data[i+1]) || (i<(l-2) && proj1->data[i] >= proj1->data[i+2]) ){
            i++;
        }
        if (i < l) valley = proj1->data[i];
        
        /* find second peak:*/
        while ( (i<(l-1) && proj1->data[i] < proj1->data[i+1]) || (i<(l-2) && proj1->data[i] < proj1->data[i+2]) ){
              i ++;
        }
        /*Current stop of conversion
         // complicated if statement to avoid bugs:*/
        if (i < l && ((sharps + flats == 0) || abs(i - p1_x - lst_width) < 2)){
            peak2 = proj1->data[i];
            p2_x = i;
            i +=2;
            lst_width = p2_x - p1_x;
            
            /* discriminate:
            // (idk, i just made these up... maybe make something better later)*/
            w1 = -3 * (70*(peak1 - peak2) - 7*parameters->staff_h);
            w2 = 2 * (70*(peak2 - valley) - 10*parameters->staff_h);
            s = w1 + w2;
            
            /* classify sharp or flat:*/
            if (s > 0) sharps ++;
            else flats ++;
        }
        else{
            
            if (i < l){
                /* error in classification of key signature;
                // reassign value for ks_x (used to trim staffs later):*/
                parameters->ks_x = (i + fudge + (parameters->staff_h+1)/2 - 10 > 0) ? (i + fudge + (parameters->staff_h+1)/2 - 10) : 0; ;
                i++;
            }
            else{
                /* no error; assign ks_x:*/
                parameters->ks_x = (fudge + ks_x_end - 5) > 0 ? (fudge + ks_x_end - 5)  : 0;
            }
            
        }
        
        /* eat up the remaining hump:*/
        while (i < l && proj1->data[i] > 0){
            i++;
        }
       
        /* loops to next symbol if neccessary ^:*/
        
    }
    
    /* finish up:*/
    if (sharps >= flats) parameters->ks = sharps + flats;
    else parameters->ks = -1 * (sharps + flats);

}

/*matlab coversion*/

uint8_t check_eighth_tail(const image_t* img, const params* parameters,uint16_t row,uint16_t col){
    /* looks for a connecting tail between eighth notes
    row, col are the guessed starting point for a tail*/
    
    /*Var Declarations*/
    uint16_t height, width,line_spacing,cursor1,cursor2,findRow;
    int16_t ymoved, extension;
    image_t* test_img;
    /*End var declarations*/
    height=img->height;
    width=img->width;
    ymoved = 0;
    cursor2=col;
    line_spacing = parameters->spacing;
    /* find black starting pixel*/
    if (getPixel(img,row,col)){
        cursor1 = row;
    }
    else if (getPixel(img,row-1,col)){
        cursor1 = row-1;
    }
    else if (getPixel(img,row+1,col)){
        cursor1 = row+1;
    }
    else if (getPixel(img,row-2,col)){
        cursor1 = row-2;
    }
    else if (getPixel(img,row+2,col)){
        cursor1 = row+2;
    }
    else if (getPixel(img,row-3,col)){
        cursor1 = row-3;
    }
    else if (getPixel(img,row+3,col)){
        cursor1 = row+3;
    }
    else if (getPixel(img,row-4,col)){
        cursor1 = row-4;
    }
    else if (getPixel(img,row+4,col)){
        cursor1 = row+4;
    }
    else if (getPixel(img,row-5,col)){
        cursor1 = row-5;
    }
    else if (getPixel(img,row+5,col)){
        cursor1 = row+5;
    }
    else return 0;
    
    extension = 0;
    while (extension < 2*line_spacing){
        if (getPixel(img, cursor1, cursor2+1 )) {
                          cursor2++;
        }
        else{
            findRow = cursor1;
            while (!getPixel(img, findRow, cursor2+1) && (findRow < height-6)){
                findRow ++;
            }
            test_img=get_sub_img(img,cursor1, findRow,cursor2, cursor2);
            if (all_black(test_img) && getPixel(img,findRow, cursor2+1)){
                delete_image(test_img);
                cursor1 = findRow;
                cursor2++;
                ymoved += int_abs(findRow - cursor1);
            }
            else{
                delete_image(test_img);
                findRow = cursor1;
                while (!getPixel(img, findRow, cursor2+1) && (findRow > 4)){
                    findRow --;
                }
                test_img=get_sub_img(img,findRow, cursor1,cursor2, cursor2);
                
                if (all_black(test_img) && getPixel(img,findRow, cursor2+1)){
                    delete_image(test_img);
                    cursor1 = findRow;
                    cursor2++;
                    ymoved += int_abs(findRow - cursor1);
                }
                else{
                     delete_image(test_img);
                     return 0;
                }
            }
        }
        extension ++;
    } /* end while*/
    if (ymoved < (6*line_spacing+4)/5) return 1;
    return 0;
}

uint8_t check_eighth_note(const image_t* img,uint16_t xbegin){
    /* checks whether note is an eighth note
    % returns:

    I think this is wrong, looks like 1 if 8th 0 otherwise*/
    
    /*Var Declarations*/
    uint16_t height,width,start,flags,i,j;
    uint16_t hitBlack, hitWhite;
    image_t* test_img;
    
    /*End Var Declarations*/
    
    height=img->height;
    width=img->width;
    
    start = 0;
    if (xbegin - 2 >= 0) start = xbegin -2;
    else if(xbegin - 1 >= 0) start = xbegin -1;
    
    /* below algorithm looks for white space inbetween stem and flag*/
    flags = 0;
    for (i=0; i< height; i++){
        /* states*/
        hitBlack = 0;
        hitWhite = 0;
        
        
        for (j=start; j < width-1 ; j++){
            if (!hitBlack && getPixel(img,i,j)) hitBlack = 1;
            else if (hitBlack && !hitWhite && !(getPixel(img,i,j) || getPixel(img,i,j+1)) ) hitWhite = 1;
            else if (hitWhite && getPixel(img,i,j)){
                flags++;
                break;
            }
        }
    }
    
    
    
    if (flags > height/3) return 1;
    else return 0;


}

/*matlab conversion*/

uint8_t  check_line_is_not_rest_new(const image_t* img,const uint32_t *staff_lines,uint16_t topCut,uint16_t xbegin,const params* parameters)
{
    /* checks around middle of line to make sure it is 'flat'
    % takes in mini_img*/
    
    /*Var Declaration*/
    uint16_t height,width,line_spacing,extend;
    
    /*End Var Declaration*/
    height=img->height;
    width=img->width;
    
    
    /* top should be below top staffline*/
    if ((uint32_t)topCut < staff_lines[0]-(uint32_t)(parameters->spacing)/3) return 0;
    
    /* bottom should be above last staffline*/
    if ((uint32_t)(topCut + height) > staff_lines[4]+1) return 0;
    
    
    line_spacing = parameters->spacing;
    extend = (8*line_spacing+2)/5;
    printf("in check rest, width %d line_spacing %d xbegin %d extend %d\n",width,line_spacing,xbegin,extend);
    /* should be skinny width*/
    if (width > 4+extend) return 0;

    
    /* line for a rest will be in middle of the image if it is a rest, for a
    % note it should be on one side*/
    if (xbegin >= width/4 && xbegin < (3*width+3)/4) return 1;
    return 0;
}

/*end conversion*/



void  find_lines(image_t* img, const params* parameters, uint16_t staffNumber, uint32_t* staff_lines, linked_list* stems_list, linked_list* measures_list){
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
    
    /*Var Declarations*/
    uint16_t line_thickness, line_spacing,h,w;
    uint16_t leftCutoff,extend;
    linked_list* goodLines;
    good_lines_t* good_lines_tmp;
    flex_array_t *peaks;
    linked_list* groupings;
    image_t* top_bot_img, *mini_img, *sub_img;
    uint16_t i,j,j_start,j_end;
    uint8_t lastStemEighth,lastStemPosition;
    int16_t* temp;
    uint16_t startLine, endLine, xbegin,xend;
    uint16_t top, bottom, line_height,xbeginN,xendN;
    uint8_t mmFound,rest_found;
    note_duration duration;
    note_cuts* notes;
    uint16_t mini_height, midPoint;
    projection_t* yproj, *top_bot_proj, *mid_proj;
    uint16_t proj_mean, difference,maxPos,offSet;
    measures_t * measure;
    stems_t* stems;
    uint8_t tail_on_top, tail_on_bottom;
    uint16_t top25,bot25,topWeight,bottomWeight;
    /*End Var Declarations*/
    
    line_thickness = parameters->thickness;
    line_spacing = parameters->spacing;
    
    h=img->height;
    w=img->width;
    
    
    /* find vertical lines based on x-projection*/
    /*this should work....should test*/
    if (staffNumber == 0) {
                    leftCutoff = (parameters->staff_h)-1;
                    for (i = 0 ; i < h ; i++){
                        for (j = 0 ; j < (leftCutoff+1)/8 ; j++ ){
                            img->pixels[i][j]=0;
                        }
                        for ( j= j*8; j<=leftCutoff; j++){
                            setPixel(img,i,j,0);
                        }
                    }
    }
    else leftCutoff = 0;

    groupings=create_linked_list();
    
    /* group close lines together
    % note: find_top_bottom can be ported to inside this function
    % note: not run all the way to right of image, just to not deal with
    % segfaulting*/
    top_bot_img=get_sub_img(img,-1,-1,leftCutoff,w-3*line_spacing-1);
    goodLines = find_top_bottom(top_bot_img,(75*(parameters->staff_h)+99)/100,leftCutoff, groupings);
    delete_image(top_bot_img);

    /*initialize with a measure at the beginning*/
    measure=malloc(sizeof(measures_t));
    measure->begin=1;
    measure->end=1;
    push_top(measures_list,measure);
    
    /* for use with connected eighth notes:*/
    lastStemEighth = 0;
    lastStemPosition = 0;
    
    
    
    extend = (7*(parameters->spacing+parameters->thickness)+2)/5;
    
    
    while (is_list_empty(groupings)==0){
        
        /* grab start and end xlocations for vertical line*/
        temp = pop_top(groupings);
        startLine = temp[0];
        endLine = temp[1]; 
        free(temp); /*bug seems to be in getIndexData startLine line specifically*/ 
	xbegin =((good_lines_t*)getIndexData(goodLines,startLine))->left;
	xend   =((good_lines_t*)getIndexData(goodLines,endLine))->right;
        /*xbegin = ((good_lines_t*)(goodLines->data[startLine]))->left;
        xend = ((good_lines_t*)(goodLines->data[endLine]))->right;*/
        /* get top and bottom of found line (y axis)*/
        top=h-1; 
        bottom=0;
        for (j=startLine; j<= endLine; j++){
            if ((((good_lines_t*)getIndexData(goodLines,j))->top) < top) top= ((good_lines_t*)getIndexData(goodLines,j))->top;
            if ((((good_lines_t*)getIndexData(goodLines,j))->bottom)>bottom) bottom = ((good_lines_t*)getIndexData(goodLines,j))->bottom;
        }
        duration = UNKNOWN;
        
        line_height = bottom - top;
        
        /* cut small image just around line*/
        notes=(note_cuts*)malloc(sizeof(note_cuts));
        mini_img= mini_img_cut(img,top,bottom,xbegin,xend,parameters, notes);
        /*if(xbegin==901 && notes->left_cut==901 && xend==904){
                       print_image(mini_img);
                       system("PAUSE");
        }*/
        xbeginN = xbegin - (notes->left_cut);  /* xbegin/xend for use with mini_img*/
        xendN = xend - (notes->left_cut);
/*check left position logic to make sure that it doesn't segfault*/
/* aka if xbeginN is 0 or thereabouts it should never be consider to have left position. not sure if it will have right...suppose could be measure or something*/
    
        
        /* y projection*/
        yproj = project(mini_img,2);
        mini_height = yproj->length;
        midPoint = (mini_height+1)/2;
        
        /* check for measure marker*/
        top_bot_proj=get_sub_array(yproj, 1, (mini_height+2)/4, (3*mini_height+2)/4, mini_height-2); /* take top and bottom*/

        mid_proj = sub_array(yproj,  (mini_height+2)/4, (3*mini_height+2)/4);   
 
        proj_mean=rounded_mean(top_bot_proj);
        difference=0;
        
 
        for (i=0; i< top_bot_proj->length; i++){
            difference+= abs(top_bot_proj->data[i]-proj_mean);
        }
        
   
        mmFound=0;
        if ((mini_img->width < (7*extend+9)/10) || (difference < top_bot_proj->length && proj_mean < rounded_mean(mid_proj)*2)) mmFound=1;
        delete_flex_array(top_bot_proj);
        delete_flex_array(mid_proj);  
        if (mmFound==1 && !(line_height > (6*parameters->staff_h)/5)){
            /* MEASURE MARKER FOUND*/
            measure=(measures_t*)malloc(sizeof(measures_t));
            measure->begin=xbegin;
            measure->end=xend;
            push_bottom(measures_list,measure);/*  add to measure struct array*/
        }    
        else{    /* note found instead*/
            /* make sure its not quarter rest (check that line is skinny in middle)*/
            
            rest_found = check_line_is_not_rest_new(mini_img,staff_lines,notes->top_cut,(xendN+xbeginN)/2,parameters);
            /*printf("check rest: %d xendN %d xbeginN %d\n", rest_found,xendN, xbeginN);
            //outputIMG(mini_img,"checkingRest.tif");
            //system("PAUSE"); */
            if (rest_found==1 && (line_height < parameters->staff_h)) continue; /* true for very tall lines (chords)*/
            
            stems=(stems_t*)malloc(sizeof(stems_t));
            stems->eighthEnd=0;
            /* remove stem*/
            for (i=0; i< h; i++){
                for (j=xbegin-1; j<=xend+1;j++){
                    setPixel(img,i,j,0);
                }
            }   
            
            
            /* check for eighth note connecting tails on top and bottom*/
            tail_on_top = check_eighth_tail(img, parameters, top+line_thickness, xend+3); /*top+x*linethickness?*/
            tail_on_bottom = check_eighth_tail(img, parameters, bottom-line_thickness, xend+3);
    		
    
            if ((tail_on_top==1 || tail_on_bottom==1 )  || lastStemEighth==1 ){  /* this and next note are eighth notes*/ /*&& xbeginN<(line_spacing+line_thickness+1)/2)*/
                duration = EIGHTH;
                /*outputIMG(sub_img,"noteCheck.tif");*/
                if (tail_on_top){
                    stems->position_left = 1;
                    lastStemEighth = 1;
                }
                else if (tail_on_bottom){
                    stems->position_left = 0;
                    lastStemEighth = 1;
                }
                else {
                    stems->position_left = lastStemPosition;
                    lastStemEighth = 0;
                }
                lastStemPosition = stems->position_left;
                if (!(tail_on_top || tail_on_bottom)) stems->eighthEnd = 1;
            }
    
        
            else{
                if(check_eighth_note(mini_img,xbeginN)==1) {
                    duration = EIGHTH;  /*note is single eighth note*/
                    stems->eighthEnd=1;
                }
                top25 = (midPoint+1)/2;
                bot25 = (midPoint+mini_height+1)/2-1;
                topWeight=0;
                bottomWeight=0;
                for (i=0; i<top25;i++){
                    topWeight+= yproj->data[i];
                }
                for (i=bot25; i<mini_height;i++){
                    bottomWeight+= yproj->data[i];
                }
                
                /* note pointing up or pointing down?*/
                if (bottomWeight > topWeight) stems->position_left = 1;
                else stems->position_left = 0;
            }
            
            
            if (stems->position_left==1){    /* notehead_img is on bottom half*/
                delete_flex_array(yproj);
                sub_img=get_sub_img(mini_img,(3*mini_height+2)/5,-1,0,xbeginN-1);
                yproj=project(sub_img,2);
                delete_image(sub_img);
                maxPos = xbeginN - 1;
                offSet = notes->top_cut + (3*mini_height+2)/5;
                
                if(duration != EIGHTH){
                    /* get small image of notehead_img*/
                    sub_img=get_sub_img(mini_img,mini_img->height-1-line_spacing-line_thickness,-1,0,(xbeginN+xendN+1)/2);
                }
                            
            }    
            else{    /* notehead is on top half*/
                delete_flex_array(yproj);
                sub_img=get_sub_img(mini_img,0,(2*mini_height+2)/5,xendN+1,-1);
                yproj=project(sub_img,2);
                delete_image(sub_img);
                maxPos = mini_img->width - xendN;
                offSet = notes->top_cut;
                
                if(duration != EIGHTH){
                    /* get small image of notehead_img*/
                    sub_img=get_sub_img(mini_img,0,line_spacing+line_thickness-1,(xbeginN+xendN+1)/2,-1);
                }
                
            }
            if(duration != EIGHTH){
                /* determine if notehead is filled or open*/
                if(is_note_open(sub_img)==0) duration = QUARTER;
                else duration = HALF;
                delete_image(sub_img);
            }
            
            /*find center of mass of notehead*/
            if (duration==EIGHTH){
                peaks=find(yproj,maxPos/3,greater);
                if(peaks) stems->center_of_mass=rounded_mean(peaks)+offSet;
		        else {	
			         /*this happens if peaks is empty, aka nothing was found greater than the threshold*/
			         printf("Error: Center of Mass undefined (8th note), skipping\n");
			         outputIMG(mini_img,"miniCheck.tif");
			         /*system("PAUSE");*/
			         free(stems);
			         continue;
                }
                delete_flex_array(peaks);
            }
            else{
                 /* find line's center of mass (applicable to notes)*/
                peaks=find(yproj,(line_spacing-1)/6,greater);
                if(peaks) stems->center_of_mass=rounded_mean(peaks)+offSet;
		        else {	
			         /*this happens if peaks is empty, aka nothing was found greater than the threshold*/
			                printf("Error: Center of Mass undefined, skipping\n");
			                printf("check: %d max %d xbegin %d xend %d",line_spacing,max_array(yproj),xbegin,xend);
			                outputIMG(mini_img,"miniCheck.tif");
			                /*outputIMG(sub_img,"noteCheck.tif");*/
			                /*system("PAUSE");*/
                            free(stems);
			                continue;
                 }
                delete_flex_array(peaks);
            }
            stems->begin=xbegin;
            stems->end=xend;
            stems->top=top;
            stems->bottom=bottom;
            stems->duration=duration;
            stems->midi=0;
            stems->mod=0;
            push_bottom(stems_list,stems);   
        } /* end else not measure marker*/
        delete_flex_array(yproj);
        delete_image(mini_img);
        free(notes);
        
    }  /* end while*/
    delete_list(groupings);
    delete_list(goodLines);
    
    /*add measure positioned at very end of staff*/
     measure=(measures_t*)malloc(sizeof(measures_t));
     measure->begin=w-1;
     measure->end=w-1;
     push_bottom(measures_list,measure);


}

void get_MIDI(const image_t* img,uint32_t h,uint32_t w, params* parameters, uint32_t* stafflines, linked_list* notes){
	/*% fills in .midi and .letter fields for note struct
	%
	% output is struct NOTE
	% notes.begin           - beginning of stem (left)
	% notes.end             - end of stem (right)
	% notes.position        - either 'left' or 'right' depending which side notehead is on
	% notes.center_of_mass  - y position of center of notehead
	% notes.top             - top of stem
	% notes.bottom          - bottom of stem
	% notes.eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
	% notes.midi            - midi number
	% notes.letter          - letter (ie 'G3') (not necessary for C)
	% notes.mod             - modifier (+1 for sharp, -1 for flat, 0 for
	%                         natural)*/
	uint32_t line_thickness, line_spacing, *lines_spaces, i, j, *line_top, *line_bot,
		length_line_spaces, minDummy, closest, aboveLength, *temp, aboveLines_length,
		belowLines_length, *allMIDI, start;
	int32_t line;
	stems_t *tmp;
	uint16_t MIDI, COM, *dif;
	linked_list *aboveLines, *belowLines;
	uint32_t trebleMIDI[16] = {77,  76,  74,  72,  71,  69,  67,  65,  64,  62,  60,  59,  57,  55,  53,  52};
	uint32_t aboveMIDI[11] =  {96,  95,  93,  91,  89,  88,  86,  84,  83,  81,  79};

/*CHANGE FOR BOARD*/
	line_thickness = (uint32_t)(parameters->thickness);
	line_spacing = (uint32_t)(parameters->spacing);

	line = (uint32_t)(stafflines[0]);
	aboveLines=create_linked_list(); 
	for(i=0;i<5;i++){
	    	line = (int32_t)(line - line_spacing - line_thickness);
		if(line < 0){
			break;
	    	}
		line_top = malloc(sizeof(uint32_t));
		*line_top = line;
		push_top(aboveLines,line_top); 
	}
	aboveLines_length = aboveLines->length;
	aboveLength = 2*aboveLines->length;

	belowLines=create_linked_list(); 
	for(i=1;i<4;i++){
		line = stafflines[4] + i*(line_spacing+line_thickness);
		line_bot = malloc(sizeof(uint32_t));
		*line_bot = line;
		push_bottom(belowLines, line_bot);
	}
	belowLines_length = belowLines->length;

	length_line_spaces = 2*(aboveLines_length+5+belowLines_length);
	lines_spaces = malloc(sizeof(uint32_t)*length_line_spaces);

	for(i=0;i<aboveLines_length;i++){
		temp = (pop_top(aboveLines));
		lines_spaces[2*i]=(uint32_t)(*temp);
		lines_spaces[2*i+1]=(uint32_t)(*temp + (line_spacing + line_thickness)/2);
		free(temp);
	}
	for(i=0;i<5;i++){
		lines_spaces[2*(i+aboveLines_length)]=(uint32_t)(stafflines[i]);
		lines_spaces[2*(i+aboveLines_length)+1]=(uint32_t)(stafflines[i]+ (line_spacing + line_thickness)/2);
	}
	for(i=0;i<belowLines_length;i++){
		temp = (pop_top(belowLines));
		lines_spaces[2*(i+aboveLines_length+5)]=(uint32_t)(*temp);
		lines_spaces[2*(i+aboveLines_length+5)+1]=(uint32_t)(*temp+ (line_spacing + line_thickness)/2);
		free(temp);
	}

	if (aboveLength==0){
		allMIDI = malloc(sizeof(uint32_t)*16);
	 	for(i=0;i<16;i++){
			allMIDI[i] = trebleMIDI[i];		
		}
	}
	else{
		start = 11-aboveLength;		
		allMIDI = malloc(sizeof(uint32_t)*(16+11-start));
		
		for(i=start;i<11;i++){
			allMIDI[i-start] = aboveMIDI[i];
		}
		for(i=0;i<16;i++){
			allMIDI[i+11-start] = trebleMIDI[i];		
		}
	}
	

	dif = malloc(sizeof(uint32_t)*length_line_spaces);
	for(i=0;i<notes->length;i++){
		tmp = ((stems_t*)(getIndexData(notes,i)));
		COM = tmp->center_of_mass; 
		MIDI = tmp->midi;

	    	if(MIDI==0 && COM !=0){ 
	    			
			for(j=0; j<length_line_spaces; j++){
		    		dif[j] = abs(lines_spaces[j] - COM); /*% value closest to zero will be where its located*/
			}

			minDummy = dif[0];
			closest =0;
			for(j=1; j<length_line_spaces; j++){
				if(dif[j]<minDummy){
					minDummy = dif[j];
					closest = j;		
				}
			}
		    	/*% modify notes struct*/
		    	tmp->midi = allMIDI[closest];
	    
		}//end if MIDI==0 and COM !=0
	} /*% end FOR each stem*/

	free(dif);
	free(allMIDI);
	free(lines_spaces);
	delete_list(aboveLines);
	delete_list(belowLines);
}


void remove_notes_measures(image_t* img,uint32_t h,uint32_t w,linked_list* stems, linked_list* measures_list, params* parameters, uint32_t* stafflines){
	uint32_t line_thickness, line_spacing, line_w, note_width, inEighth, i, j, iter,
		leftCut, rightCut, topCut, bottomCut, *tops, *bottoms, minVal, maxVal,cH,cW;
	stems_t *currStem, *temp, *currGroupStem;
	measures_t *currMeasure;
	linked_list *group;

	line_thickness = (uint32_t)(parameters->thickness);
	line_spacing = (uint32_t)(parameters->spacing);
	line_w = (uint32_t)(parameters->thickness + parameters->spacing);

	/*remove last measure marker at the end of staff*/
	for(i=0; i<h; i++){
		for(j=w-3*line_spacing-1; j<w; j++){
			setPixel(img,i,j,0);
		}
	}

	/*% REMOVE STEMMED NOTES*/
	note_width = (uint32_t)((7*line_w+1)/2);

	inEighth = 0;

	for(i=0;i<(stems->length);i++){
		currStem = ((stems_t*)(getIndexData(stems,i)));

	   	if (!inEighth && currStem->duration == EIGHTH){ /* start an eighth grouping*/
			inEighth = 1;		
			group=create_linked_list();
			
			temp = malloc(sizeof(stems_t));

			temp->begin=currStem->begin;
			temp->end=currStem->end;
			temp->center_of_mass=currStem->center_of_mass;
			temp->top=currStem->top;
			temp->duration=currStem->duration;
			temp->bottom=currStem->bottom;
			temp->position_left=currStem->position_left;
			temp->eighthEnd=currStem->eighthEnd;
			temp->midi=currStem->midi;
			temp->mod=currStem->mod;
			
			push_bottom(group,temp);      
		}
	   	else if (currStem->duration == EIGHTH){ /*% continue an eighth grouping*/
			temp = malloc(sizeof(stems_t));

			temp->begin=currStem->begin;
			temp->end=currStem->end;
			temp->center_of_mass=currStem->center_of_mass;
			temp->top=currStem->top;
			temp->duration=currStem->duration;
			temp->bottom=currStem->bottom;
			temp->position_left=currStem->position_left;
			temp->eighthEnd=currStem->eighthEnd;
			temp->midi=currStem->midi;
			temp->mod=currStem->mod;
 
			push_bottom(group,temp);  
		}
 	    else{    /*cut out single note*/
			/*choose extension based on line spacing*/
			if (currStem->position_left == 1){ /*note head on left */
			    	leftCut = currStem->begin - note_width;
			    	rightCut = currStem->end + line_thickness;
			    	topCut = currStem->top - line_thickness;
			    	bottomCut = currStem->bottom + (uint32_t)((3*line_spacing+1)/2);
			}
			else{
				leftCut = currStem->begin - line_thickness;
			    	rightCut = currStem->end + note_width;
			    	topCut = currStem->top - (uint32_t)((3*line_spacing+1)/2);
			    	bottomCut = currStem->bottom + line_thickness;
			}
		
			/*segfault precaution:*/
			if (leftCut < 0){ leftCut = 0; }
			if (rightCut > w-1){ rightCut = w-1; }
			if (topCut < 0){ topCut = 0; }
			if (bottomCut > h-1){ bottomCut = h-1; }
			
			for(cH=topCut; cH<=bottomCut; cH++){
				for(cW=leftCut; cW<=rightCut; cW++){
					setPixel(img,cH,cW,0);
				}
			}
  	  	}
	    
	    
	    	if (currStem->eighthEnd){ /*end an eighth grouping/single eighth and cut*/
		
			inEighth = 0;
		
			/*cut out individual notes*/
			for (j=0;j<(group->length);j++){
				currGroupStem = ((stems_t*)(getIndexData(group,j)));
			    	if (currGroupStem->position_left == 1){
					leftCut = currGroupStem->begin - note_width;
					rightCut = currGroupStem->end + (uint32_t)((line_w+3)/6);
				}
			    	else{
					leftCut = currGroupStem->begin - (uint32_t)((line_w+3)/6);
					rightCut = currGroupStem->end + note_width; 
				}               
			    	topCut = currGroupStem->top - line_w;
			    	bottomCut = currGroupStem->bottom + line_w;
			    
			    	/*segfault precaution:*/
			    	if (leftCut < 0){ leftCut = 0; }
			   	if (rightCut > w-1){ rightCut = w-1; }
			    	if (topCut < 0){ topCut = 0; }
			    	if (bottomCut > h-1){ bottomCut = h-1; }
			    
			    	for(cH=topCut; cH<=bottomCut; cH++){
					for(cW=leftCut; cW<=rightCut; cW++){
						setPixel(img,cH,cW,0);
					}
				}
			}

			/*cut out connector*/
			if (group->length > 1){
			
				tops = malloc(sizeof(uint32_t)*group->length);
				bottoms = malloc(sizeof(uint32_t)*group->length);

			    	for(j=0;j<(group->length);j++){
					currGroupStem = ((stems_t*)(getIndexData(group,j)));

					tops[j] = currGroupStem->top;
					bottoms[j] = currGroupStem->bottom;
			    	}
			    
			    	if (((stems_t*)(getIndexData(group,0)))->position_left == 1){ /*group is left pointing*/
					minVal = tops[0];
					maxVal = tops[0];
					for(iter=1;iter<group->length;iter++){
						if(tops[iter]<minVal){
							minVal = tops[iter];					
						}			
						if(tops[iter]>maxVal){
							maxVal = tops[iter];
						}
					}
					topCut = minVal - line_w;
					bottomCut = maxVal + line_w;
				}
			    	else{
					minVal = bottoms[0];
					maxVal = bottoms[0];
					for(iter=1;iter<group->length;iter++){
						if(bottoms[iter]<minVal){
							minVal = bottoms[iter];					
						}			
						if(bottoms[iter]>maxVal){
							maxVal = bottoms[iter];
						}
					}
					topCut = minVal - line_w;
					bottomCut = maxVal + line_w;
				}

			    	leftCut = ((stems_t*)(getIndexData(group,0)))->begin - (uint32_t)((line_w+3)/6);
			    	rightCut = ((stems_t*)(getIndexData(group,(group->length)-1)))->end + (uint32_t)((line_w+3)/6);
			    
			    	/*segfault precaution:*/
			    	if (leftCut < 0){ leftCut = 0; }
			    	if (rightCut > w-1){ rightCut = w-1; }
			    	if (topCut < 0){ topCut = 0; }
			    	if (bottomCut > h-1){ bottomCut = h-1; }
			    
			    	for(cH=topCut; cH<=bottomCut; cH++){
					for(cW=leftCut; cW<=rightCut; cW++){
						setPixel(img,cH,cW,0);
					}
				}      
			}  
			delete_list(group); 
		}
	}

	/*REMOVE MEASURE LINES*/

	for (i =0; i<(measures_list->length);i++){
		currMeasure = ((measures_t*)(getIndexData(measures_list,i)));

	     	leftCut = currMeasure->begin - line_thickness;
	     	rightCut = currMeasure->end + line_thickness;
	     	topCut = (uint32_t)(stafflines[0] - 2*line_thickness);
	     	bottomCut = (uint32_t)(stafflines[4] + 2*line_thickness);

	     	/*seg fault precaution:*/
	     	if(leftCut < 0){ leftCut = 0; }
	     	if(rightCut > w-1){ rightCut = w-1; }
	     	if(topCut < 0){ topCut = 0; }
	     	if (bottomCut > h-1){ bottomCut = h-1; }

	     	for(cH=topCut; cH<=bottomCut; cH++){
			for(cW=leftCut; cW<=rightCut; cW++){
				setPixel(img,cH,cW,0);
			}
		}
	}
}


void combineSymbols(linked_list *symbols, params* parameters){
	symbol_t *currSymbol, *cmpSymbol, *closestSymbol;
	int32_t right1, height1, top1, left2, height2, top2, closestSymb;
	uint16_t i, j, line_spacing, minDist, currDist;

	line_spacing = (uint16_t)(parameters->spacing);

	i = 0;
	while(i<symbols->length){

		currSymbol = ((symbol_t*)(getIndexData(symbols,i)));
		right1 = (int32_t)currSymbol->right;
    		height1 = (int32_t)currSymbol->height;
    		top1 = (int32_t)currSymbol->top;

		minDist = 0xFFFF;
		closestSymb = -1;
		
		for(j=0; j<symbols->length; j++){
			if(j!=i){
				cmpSymbol = ((symbol_t*)(getIndexData(symbols,j)));
				left2 = (int32_t)cmpSymbol->left;
            			height2 = (int32_t)cmpSymbol->height;
            			top2 = (int32_t)cmpSymbol->top;
				
            			currDist = (uint16_t)((((top1+(height1+1)/2)-(top2+(height2+1)/2))*((top1+(height1+1)/2)-(top2+(height2+1)/2))) + 
					((right1-left2)*(right1-left2)));

            			if ( left2-right1 > 0 && currDist < minDist){   /*symbol2 is located just to the right*/

                			minDist = currDist;
                			closestSymb = j;
            			}
			}
		}
		if(closestSymb != -1){

			closestSymbol = ((symbol_t*)(getIndexData(symbols,closestSymb)));
			height2 = closestSymbol->height;
			top2 = closestSymbol->top;
			
			/*WORK WITH THESE THRESHOLDS vvv*/
			if ((minDist<3*line_spacing*line_spacing) && 
				(abs(height1-height2) < ((2*line_spacing)/3)) && (abs(top1-top2) < (2*line_spacing))){
			   
				if(closestSymb>i){
					closestSymbol->left = currSymbol->left;
					if(currSymbol->top < closestSymbol->top){ 
						closestSymbol->top=currSymbol->top;}
					if(currSymbol->bottom > closestSymbol->bottom){ 
						closestSymbol->bottom=currSymbol->bottom;}
					closestSymbol->height = closestSymbol->bottom - closestSymbol->top + 1;
					closestSymbol->width = closestSymbol->right - closestSymbol->left + 1;

					deleteIndexData(symbols,i);
				}else{
					currSymbol->right = closestSymbol->right;
					if(closestSymbol->top < currSymbol->top){
						currSymbol->top=closestSymbol->top;}
					if(closestSymbol->bottom > currSymbol->bottom){
						currSymbol->bottom=closestSymbol->bottom;}
					currSymbol->height = currSymbol->bottom - currSymbol->top + 1;
					currSymbol->width = currSymbol->right - currSymbol->left + 1;

					deleteIndexData(symbols,closestSymb);
				}
				i=i-1;
			}
		}
		i = i+1;
	}
}

void classify_symbols(linked_list *symbols, linked_list *notes, linked_list *measures, params* parameters, image_t *lineless_img, uint32_t* staff_lines){
	/*classify all remaining symbols

	 symbols struct:
	   .top
	   .bot
	   .lef
	   .rig
	   .img
	   .class (-1 coming in)

	 CLASSES
	  0 - trash
	  1 - 1/4 rest (squiggly)
	  2 - wide things (ties)
	  3 - dot
	  4 - measure marker
	  5 - 1/2 rest (hat w/ company)
	  6 - full rest (lonely hat)
	  7 - sharp (#)
	  8 - flat (b)
	  9 - natural (box badly drawn)
	  10 - whole notes
	  11 - 1/8 rest*/
	symbol_t *currSymbol;
	uint32_t line_w, line_thickness, line_spacing;
	uint16_t top, bot, lef, rig, sH, sW, i, mm, BWratio_num, BWratio_den, rightOfNote,
		leftOfNote, note, vertClose, horClose, leftMM, rightMM, notesInMeasure, midOfMeasure,
		midOfSym;
	stems_t *currNote;
	measures_t *currMeasure, *leftMMmeasure, *rightMMmeasure;
	image_t *sub_img; 
	
	line_thickness = (uint32_t)(parameters->thickness);
	line_spacing = (uint32_t)(parameters->spacing);
	line_w = (uint32_t)((2*parameters->thickness) + parameters->spacing);

	for (i=0; i<symbols->length; i++){
    		currSymbol = ((symbol_t*)(getIndexData(symbols,i)));

    		top = currSymbol->top;
    		bot = currSymbol->bottom;
    		lef = currSymbol->left;
    		rig = currSymbol->right;

    		sH = currSymbol->height;
    		sW = currSymbol->width;
    
    		BWratio_num = currSymbol->NumBlack;
		BWratio_den = (sH*sW - currSymbol->NumBlack + 1);


		rightOfNote = 0;
    		leftOfNote = 0;
    		for(note=0; note<notes->length; note++){
        		/*check for closeness of symbol to notes:*/
			currNote = ((stems_t*)(getIndexData(notes,note)));

        
        		/*check to right of note*/
        		if (currNote->position_left){
				if(abs((top+bot+1)/2 - currNote->bottom) < (4*(currNote->bottom - currNote->top) + 5)/10 &&
					(currNote->bottom - top + line_w/2) > 0){/*close to notehead vertically*/
					vertClose = 1;
				}else{
					vertClose = 0;
				}
            
				if((lef-currNote->end) > 0 && (lef-currNote->end) < line_w){
					horClose = 1;
				}else{
					horClose = 0;
				}
        		}else{

				if(abs((top+bot+1)/2 - currNote->top) < (4*(currNote->bottom - currNote->top) + 5)/10 &&
					(bot - currNote->top + (line_w+1)/2) > 0){
					vertClose = 1;
				}else{
					vertClose = 0;
				}
            
				if((lef-currNote->end) > 0 && (lef-currNote->end) < (5*line_w + 1)/2){
					horClose = 1;
				}else{
					horClose = 0;
				}
        		}

			if (vertClose && horClose){
            			rightOfNote = 1;
        		}
        
        		/*check to left of a note*/
        		if (currNote->position_left){
				if(abs((top+bot+1)/2 - currNote->bottom) < (3*(currNote->bottom - currNote->top + 1 + 5))/10 &&
					(currNote->bottom - top -1) > 0){/*close to notehead vertically*/
					vertClose = 1;
				}else{
					vertClose = 0;
				}
            
				if((rig-currNote->begin) <= 0 && (currNote->begin - rig) < (5*line_w + 1)/2){
					horClose = 1;
				}else{
					horClose = 0;
				}
        		}else{

				if(abs((top+bot+1)/2 - currNote->top) < (3*(currNote->bottom - currNote->top + 1) + 5)/10 &&
					(bot - currNote->top -1) > 0){
					vertClose = 1;
				}else{
					vertClose = 0;
				}
            
				if((rig-currNote->begin) <=0 && (currNote->begin - rig) < line_w){
					horClose = 1;
				}else{
					horClose = 0;
				}
        		}

        		if (vertClose && horClose){
            			leftOfNote = 1;
        		}
		}

		printf("left_of_note:%d	right_of_note:%d	line_w:%d	line_spacing:%d	height:%d	width:%d\n",leftOfNote, rightOfNote, line_w, line_spacing, currSymbol->height, currSymbol->width);
        	/*if symbol is directly to right of a note*/
   		if (rightOfNote && 2*sH>sW && sH <= (line_w + 5) && sW <  (3*line_spacing+1)/2){
       			currSymbol->class_label = 3; /*dot*/
       
   		/*if symbol is directly to the left of a note*/
   		}else if (leftOfNote && 2*sH>sW && sH > line_w && sW > (line_w + 2)/3 ){
       			/*accidental found*/
       			
			sub_img = get_sub_img(lineless_img, (int16_t)currSymbol->top, (int16_t)currSymbol->bottom,
					(int16_t)currSymbol->left,(int16_t)currSymbol->right); 

			currSymbol->class_label = classify_accidental(sub_img);
       
   		/*else other symbol  (whole notes, 1/4 rest, 1/2 rest, full rest, eighth rest(?) )*/
   		}else{
       
        		if(sH > (3*line_w + 1)/2 && 2*sH>3*sW && top >= staff_lines[0]-line_thickness*2 && bot <= staff_lines[4]){
            			/*squiggly*/
            			currSymbol->class_label = 1; /*quarter rest*/
            
        		}else{  /*1/2 or full rest or whole note*/
            
            			/*find left & right measure markers*/
            			leftMM = 0;
            			rightMM = 0;
            			for (mm = 0; mm<measures->length; mm++){
					currMeasure = ((measures_t*)(getIndexData(measures,mm)));

                			if (currMeasure->begin < lef){
                    				leftMM = mm;
                			}
                			if (rightMM==0 && currMeasure->end > rig){
                    				rightMM = mm;
               				 }
            			}

				/*count how many notes found within current measure*/
		    		notesInMeasure = 0;
				leftMMmeasure = ((measures_t*)(getIndexData(measures,leftMM)));
				rightMMmeasure = ((measures_t*)(getIndexData(measures,rightMM)));

            			for (note=0; note<notes->length; note++){
					currNote = ((stems_t*)(getIndexData(notes,note)));

		        		if (currNote->end > leftMMmeasure->begin && currNote->begin < rightMMmeasure->end){
		            			notesInMeasure = notesInMeasure + 1;
		        		}
		    		}
            
            			if (notesInMeasure == 0){ /*either a whole note or whole rest*/
				 
					sub_img = get_sub_img(lineless_img, (int16_t)currSymbol->top, (int16_t)currSymbol->bottom,
					(int16_t)currSymbol->left,(int16_t)currSymbol->right);  
           		
					if(is_note_open(sub_img)==1 && sH > (8*line_w + 5)/10 && sH < (13*line_w + 5)/10 && sW < 3*line_w){
						/*whole note found*/
                    				currSymbol->class_label = 10;
		       			} else{
		            			if (top > staff_lines[0] && bot < staff_lines[3]){ /*within staff lines*/
		                			midOfMeasure = (leftMMmeasure->begin + rightMMmeasure->begin + 1)/2;
		                			midOfSym = (lef + rig + 1)/2;
						}
		                		if (abs(midOfMeasure - midOfSym) < 2*line_w && sW > line_w){ /*in middle of measures*/
		                    			/*whole rest found*/
		                    			currSymbol->class_label = 6;
		                		}
		            		}
		        	}else{ /*half or eighth(?) rest*/
		        		if (top > staff_lines[0] && bot < staff_lines[3] &&
						abs((top+bot+1)/2-staff_lines[2]) < line_w && sW > (8*line_w + 5)/10){ /*within middle of staff*/
					    	if (BWratio_num > BWratio_den){
							/*half rest found*/
							currSymbol->class_label = 5;
					    	}else{
							/*eighth rest found*/
							currSymbol->class_label = 11;
					    	}
		        		}
		    		}

	        	} /*end else 1/2 or full rest or whole note*/
	            
	   	} /*end else other symbol*/
	}
}


int16_t  classify_accidental(image_t* img){
	/* classifies accidentals into:{
	%   class 7 - sharp
	%   class 8 - flat
	%   class 9 - natural*/
    	uint16_t height;
    	uint16_t width;
    	projection_t* xproj;
    	uint16_t firstPeak, secondPeak;
    	uint16_t firstPeakLoc,secondPeakLoc;
    	uint16_t leftCut,rightCut;
    	uint16_t firstPeakY, secondPeakY;
    	uint16_t i;
    	uint8_t firstStop, secondStop;
    	/*end var*/
  	    height=img->height;
    	width=img->width;
    
    	xproj =project(img,1);
    
    	/* find how many peaks (flat has just 1)*/
    	firstPeak=max_array(xproj);
    	firstPeakLoc=index_of_max(xproj);
    
    	if((firstPeakLoc-3)<0)leftCut=0;
    	else leftCut= firstPeakLoc-3;
    
    	if((firstPeakLoc+3)>=width)rightCut=width-1;
    	else rightCut= firstPeakLoc+3;
    	for (i=leftCut;i<=rightCut;i++){
        	/*erase so as to not find same peak twice*/
        	xproj->data[i]=0;
    	}
    	/* look for a second*/
    	secondPeak=max_array(xproj);
    	secondPeakLoc=index_of_max(xproj);
    	if (secondPeak < (85*firstPeak+99)/100) return 8;
    
    	/* now find where two peaks begin vertically*/
    	firstStop=0;
    	secondStop=0;
    	for (i=0; i<height; i++){
        	if( firstStop==0 && getPixel(img,i,firstPeakLoc)==1) {
            	firstPeakY=i;
            	firstStop=1;
        }
        if( secondStop==0 && getPixel(img,i,secondPeakLoc)==1) {
            	secondPeakY=i;
            	secondStop=1;
        }
        if(firstStop==1&& secondStop==1) break;
    	}                                  
    
    	/* sharp's second peak should start about the same or slightly higher than
    	% the first. A natural's should start lower.*/
    	if (firstPeakLoc<secondPeakLoc){
       		if(secondPeakY <= firstPeakY+2) return 7;
       		else return 9;
    	}
    	if(firstPeakY<=secondPeakY+2)return 7;
    	return 9;
}

void contextualizer_other(linked_list* notes, linked_list* measures, linked_list* symbols){
    /* make modification to notes based on classification of accidentals and
    % dots
    %
    % input structs:
    %%% symbols struct:
    %   .top
    %   .bot
    %   .lef
    %   .rig
    %   .img
    %   .class (-1 coming in)
    %
    % CLASSES
    %  0 - trash
    %  1 - 1/4 rest (squiggly)
    %  2 - wide things (ties)
    %  3 - dot
    %  4 - measure marker
    %  5 - 1/2 rest (hat w/ company)
    %  6 - full rest (lonely hat)
    %  7 - sharp (#)
    %  8 - flat (b)
    %  9 - natural (box badly drawn)
    %  10 - whole notes
    %  11 - 1/8 rest
    %
    %%% notes struct:
    %  .begin           - beginning of stem (left)
    %  .end             - end of stem (right)
    %  .position        - either 'left' or 'right' depending which side notehead_img is on
    %  .center_of_mass  - y position of center of notehead_img
    %  .top             - top of stem
    %  .bottom          - bottom of stem
    %  .dur             - duration of note in beats (0.5,1,2,4 etc)
    %  .eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
    %  .midi            - midi number (field modified later)
    %  .letter          - letter (ie 'G3') (not necessary for C)
    %  .mod             - modifier (+1 for sharp, -1 for flat, 0 for natural)*/
    
    int16_t i,n, mod;
    symbol_t* current_symbol;
    int16_t note_num,rightMM, midi_to_mod;
    
    while (is_list_empty(symbols)==0){
          current_symbol=pop_top(symbols);
    
        
      
        
        switch (current_symbol->class_label){
            case 3: // dot
                 printf("dot::\n");
                note_num = 0;
                for (n=1; n<(notes->length);n++){
                    if(   (((stems_t*)getIndexData(notes,n))->end -current_symbol->right)>0 )break;
                    note_num=n;
                }
    
                //increase duration of dot
                if (((stems_t*)getIndexData(notes,note_num))->duration == EIGHTH)((stems_t*)getIndexData(notes,note_num))->duration=EIGHTH_DOT;
                else if (((stems_t*)getIndexData(notes,note_num))->duration == QUARTER)((stems_t*)getIndexData(notes,note_num))->duration=QUARTER_DOT;
                else if (((stems_t*)getIndexData(notes,note_num))->duration == HALF)((stems_t*)getIndexData(notes,note_num))->duration=HALF_DOT;
                break;
    
    
            case 7:// accidental
            case 8:
            case 9: 
                switch (current_symbol->class_label){
                    case 7: //sharp
                         printf("sharp::\n");
                        mod = 1;
                        break;
                    case 8: //flat
                         printf("flat::\n");
                        mod = -1;
                        break;
                    case 9: //natural
                         printf("natural::\n");
                        mod = 0;
                        break;
                    default:
                            break;
                }            
                
                // find closest note on right
                note_num = notes->length-1;
                for (n=note_num-1; n >=0;n--){
                    if ( (current_symbol->left  -((stems_t*)getIndexData(notes,n))->begin)>0) break;
                    note_num=n;
                }
                printf("mod: %d notenum: %d, midi: %d\n",mod, note_num,((stems_t*)getIndexData(notes,note_num))->midi);
                // find first measure marker to right of accidental
                rightMM = measures->length -1;
                for (n=rightMM-1; n>=0;n--){
                    if( (current_symbol->right)>(((measures_t*)getIndexData(measures,n))->end) )break;
                    rightMM=n;
                }
                
                // loop thru notes again, modify all notes within measure with
                // same pitch as accidental's partner note
                midi_to_mod = ((stems_t*)getIndexData(notes,note_num))->midi;
                printf("midi to mod: %d\n",midi_to_mod);
                if( midi_to_mod != 0){
                    for (n = 0; n<notes->length; n++){
                        printf("checks:: midi mod: %d, notes end: %d symbol left:%d, notes begin:%d, measures:%d\n",midi_to_mod,((stems_t*)getIndexData(notes,n))->end,current_symbol->left,((stems_t*)getIndexData(notes,n))->begin,((measures_t*)getIndexData(measures,rightMM))->end);
                        
                        
                        if ( (((stems_t*)getIndexData(notes,n))->end) > current_symbol->left && (((stems_t*)getIndexData(notes,n))->begin) < (((measures_t*)getIndexData(measures,rightMM))->end)){
                            printf("midi to mod:%d midi check: %d\n",midi_to_mod,((stems_t*)getIndexData(notes,n))->midi);
                            if ((((stems_t*)getIndexData(notes,n))->midi) == midi_to_mod){
                                                                          printf("modding MIDI!!\n");
                                (((stems_t*)getIndexData(notes,n))->mod) = mod;
                            }//end above if
                        }
                    }//end for
                }//end if midi 2 mod
                break;
            default:
                    break;
            
                
                
        }//end switch
        free(current_symbol);
    
        
    }//end while




}


uint16_t contextualizer_notes_rests(linked_list *notes, linked_list *symbols){
    /* make modification to notes based on classification of whole notes and
    % rests
    %
    % input structs:
    %%% symbols struct:
    %   .top
    %   .bot
    %   .lef
    %   .rig
    %   .img
    %   .class (-1 coming in)
    %
    % CLASSES
    %  0 - trash
    %  1 - 1/4 rest (squiggly)
    %  2 - wide things (ties)
    %  3 - dot
    %  4 - measure marker
    %  5 - 1/2 rest (hat w/ company)
    %  6 - full rest (lonely hat)
    %  7 - sharp (#)
    %  8 - flat (b)
    %  9 - natural (box badly drawn)
    %  10 - whole notes
    %  11 - 1/8 rest
    %
    %%% notes struct:
    %  .begin           - beginning of stem (left)
    %  .end             - end of stem (right)
    %  .position        - either 'left' or 'right' depending which side notehead_img is on
    %  .center_of_mass  - y position of center of notehead_img
    %  .top             - top of stem
    %  .bottom          - bottom of stem
    %  .dur             - duration of note in beats (0.5,1,2,4 etc)
    %  .eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
    %  .midi            - midi number (field modified later)
    %  .letter          - letter (ie 'G3') (not necessary for C)
    %  .mod             - modifier (+1 for sharp, -1 for flat, 0 for natural)
    */
    
	symbol_t*		current_symbol;
	stems_t*		whole_note_struct;
	stems_t*		rest_struct;
	int16_t			note_num;
	int16_t			n;
	note_duration	duration;
	int16_t			i;

	uint16_t wholeFound = 0;
	for (i=0; i<symbols->length; i++) {
		// loop through all of the symbols looking for notes and rests
		
		current_symbol = (symbol_t*) linked_list_getIndexData(symbols, i);
		
		switch (current_symbol->type) {
			
			case WHOLE_NOTE: // whole note
				wholeFound = 1;
				whole_note_struct=malloc(sizeof(stems_t));
				whole_note_struct->begin=current_symbol->left;
				whole_note_struct->end=current_symbol->right;
				whole_note_struct->center_of_mass=(current_symbol->top +current_symbol->bottom + 1)/2;
				whole_note_struct->top=current_symbol->top;
				whole_note_struct->bottom=current_symbol->bottom;
				whole_note_struct->duration=WHOLE;
				whole_note_struct->eighthEnd=0;
				whole_note_struct->midi=0;
				whole_note_struct->mod=0;
				whole_note_struct->position_left=0;

				// find closest note to the left
				note_num = -1;
				for (n=0; n<notes->length; n++){ // find closest note to the left of the dot
					if (  (((stems_t*)getIndexData(notes,n))->end - current_symbol->right) > 0)break; // note is to the right
					note_num = n;
				}

				// insert whole note into notes struct array at correct location
				if (note_num == -1) push_top(notes,whole_note_struct);
				else linked_list_insert_before_index(notes,note_num+1,whole_note_struct);
				deleteIndexData(symbols,i);
				i--;
				break;    
			case 1:
			case 5:
			case 6:
			case 11:
				// rest found
				switch (current_symbol->class_label){
					case 1:
						duration = QUARTER;
						printf("quarter rest\n");
						break;
					case 5:
						duration = HALF;
						printf("half rest\n");
						break;
					case 6:
						duration = WHOLE; 
						printf("full rest\n");
						break;
					case 11:
						duration = EIGHTH;
						printf("eight rest\n");
						break;
				}
				rest_struct=malloc(sizeof(stems_t));
				rest_struct->begin=current_symbol->left;
				rest_struct->end=current_symbol->right;
				rest_struct->center_of_mass=0;
				rest_struct->top=current_symbol->top;
				rest_struct->bottom=current_symbol->bottom;
				rest_struct->duration=duration;
				rest_struct->eighthEnd=0;
				rest_struct->midi=0xF000;
				rest_struct->mod=0;
				rest_struct->position_left=0;

				// find closest note to the left
				note_num = -1; 
				for (n=0; n<notes->length; n++){ // find closest note to the left of the dot
					if (  (((stems_t*)getIndexData(notes,n))->end - current_symbol->right) > 0)break; // note is to the right
					note_num = n;
				}

				// insert whole note into notes struct array at correct location
				if (note_num == -1) push_top(notes,rest_struct);
				else linked_list_insert_before_index(notes,note_num+1,rest_struct);
				
				deleteIndexData(symbols,i);
				i--;
				break;            
		}//end switch
	}//end while
	return wholeFound; 
}
                

void update_with_key_signature( linked_list* notes, int key_sig) {

	// TYPES are not correct	
	int16_t i;
	int16_t accum,ind;

	int16_t note_lookup[12]={0};
	// A A# B C C# D D# E F F# G  G#
	// 0 1  2 3 4  5 6  7 8 9  10 11

	// set up: set corresponding array values
	// to 1 for sharp and -1 for flat
	accum = 8;
	for (i = 0; i < key_sig; i++) {
		note_lookup[accum] = 1;
		accum = (accum + 7) % 12;
	}
	accum = 2;
	for (i = 0; i > key_sig; i--) {
		note_lookup[accum] = -1;
		accum = (accum + 5) % 12;
	}

	// set note mods to corresponding values:
	// ADJUST implementation for linked list...
	for (i = 0; i < notes->length; i++) {
        if (((stems_t*)getIndexData(notes,i))->midi !=0){
           ind = (   (((stems_t*)getIndexData(notes,i))->midi) - 57) % 12;
           ((stems_t*)getIndexData(notes,i))->mod=note_lookup[ind];
        }
	}

}
