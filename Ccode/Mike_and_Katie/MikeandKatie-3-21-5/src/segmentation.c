#include "segmentation.h"
#include "preprocessing.h"
#include <stdio.h>
#include "utility_functions.h"

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
		       delete_flex_array(compare_array);
            }
            
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
       if(l%5){
		       fprintf(stderr,"Error, found stafflines not a multiple of 5");
		       exit(1);
       }
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

image_t* get_staff(const image_t* img, const staff_info* staff,uint16_t count,params* parameters)
{
         /*Var Declarations*/
         uint16_t top,bottom;
         image_t* new_img, *out_img;
         /*End Var Declarations*/
         
         /*isolate staff*/
	
         top=staff->staff_bounds[count][0];
         bottom=staff->staff_bounds[count][1];
         new_img=get_sub_img(img,top,bottom,-1,-1);
         
         /*trim staff*/
         new_img=trim_staff(new_img);
         out_img=get_sub_img(new_img,-1,-1,parameters->ks_x,-1);
         delete_image(new_img);
         return out_img;
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
        /*implement this once created...*/
        /*[img(:,beginCut:endCut),shift_variable,stafflines] = ...*/
          /*  fix_lines_and_remove_smart(fixThatImage,params,last_stafflines,shift_variable,vertSplice);*/
            
        /*modify last_stafflines in place */ 
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

linked_list* find_top_bottom(const image_t* img,uint16_t height_min,uint16_t leftCutoff,linked_list* groupings){
    /* finds all vertical lines (stems, measure markers)
     Returns:
    groupings - indices within goodLines array of start and end of each vertical line
       ex: [40 42
            55 58
            100 110]
    
     goodLines - array of structs for each vertical found
       .top
       .bottom
       .left
       .right*/
    
    /*Var Declarations*/
    uint16_t height,width,col,row,test_length,i,real_length;
    linked_list *goodlines_first;/*since unsure of size, trim down later*/
    flex_array_t *starts;
    uint8_t inLine,shift,step;
    uint16_t cursor1,cursor2;
    good_lines_t *lines;
    /*End Var Declarations*/
    
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
        
        for (i=0;i<test_length;i++) {/*start = starts;*/
            inLine = 1;
            cursor1=starts->data[i];
            cursor2=col;
            shift = 0;
            
            while(inLine){
                step = 0;
                if ( getPixel(img,cursor1+1,cursor2)==1 ){ /*right below*/
                    cursor1++;
                    step = 1;
                }
    
                if ( cursor2+1 < width && !step ){ /*to the bottom right*/
                    if (getPixel(img,cursor1+1,cursor2+1) ){
                        cursor1++;
                        cursor2++;
                        step = 1;
                        shift++;
                    }
                }
                    
                if ( cursor2-1 >= 0 && !step){ /*to the bottom left*/
                    if (getPixel(img,cursor1+1,cursor2-1) ){
                        cursor1++;
                        cursor2--;
                        step = 1;
                        shift ++;
                    }
                }
                    
                if (!step || shift > 3){ /*can't continue black run*/
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
                        push_bottom(goodlines_first,lines);
                   }
                   inLine = 0;
                }
                
            } /*end while in line*/
        
        } /*end for thru each starting location*/
        delete_flex_array(starts);   
        
    } /*end for thru each column*/
    starts=make_flex_array(real_length);
    for (i=0;i<real_length;i++){
        starts->data[i]=((good_lines_t*)getIndexData(goodlines_first,i))->left;
    }
    /*GROUP LINES TOGETHER*/
    fill_group_indices(groupings,starts,5); /*2nd arg chosen to group close lines together*/
    
    delete_flex_array(starts);
    return goodlines_first;

}

image_t* mini_img_cut(const image_t* img,uint16_t top,uint16_t bottom,uint16_t xbegin,uint16_t xend,const params* parameters, note_cuts* cuts)
{
    /* cuts out small image around stem/measure marker*/
    
    /*Var Declarations*/
    uint16_t height, width,line_spacing,extend,count, line_w, count_thresh,sum_thresh;
    int16_t left,right;
    int16_t topCut,bottomCut,leftCut,rightCut;
    int16_t extUp,extDown,extLeft,extRight;
    image_t* sub_img;
    projection_t* proj;
    /*End Var Declarations*/
    
    height=img->height;
    width=img->width;
    
    line_spacing = parameters->spacing;
    line_w= parameters->thickness + line_spacing;
    
    extend = (7*line_w+2)/5;
    
    /*left and right cuts*/
    count_thresh= (4*line_w+5)/10;
    extLeft = 1;
    count = 0;
    while (extLeft < extend && xbegin-extLeft>=0){
          sub_img=get_sub_img(img,top,bottom,xbegin-extLeft,xbegin-extLeft);
          proj=project(sub_img,1);
          delete_image(sub_img);
          if(proj->data[0] == 0) count ++;
          else count=0;
          delete_flex_array(proj);
          if(count > count_thresh) break;
          extLeft++;
    }
    leftCut = xbegin - extLeft + count;
    
    extRight = 1;
    count = 0;
    while (extRight < extend && xend+extRight<width){
          sub_img=get_sub_img(img,top,bottom, xend+extRight, xend+extRight);
          proj=project(sub_img,1);
          delete_image(sub_img);
          if(proj->data[0] == 0) count ++;
          else count=0;
          delete_flex_array(proj);
          if(count > count_thresh) break;
          extRight++;
    }
    rightCut = xend + extRight - count;
    
    /*top and bottom cuts*/
    count_thresh=0;
    sum_thresh= (line_w+3)/6+1;
    

    
    extUp = 1;
    count = 0;
    while (extUp < line_spacing && top-extUp >= 0){
          sub_img=get_sub_img(img,top-extUp,top-extUp,leftCut,rightCut);
          proj=project(sub_img,2);
          delete_image(sub_img);
          if(proj->data[0] <=sum_thresh) count ++;
          delete_flex_array(proj);
          if(count > count_thresh) break;
          extUp++;
    }
    topCut = top - extUp + count;

    extDown = 1;
    count = 0;
    while (extDown < line_spacing && bottom+extDown <height){
          sub_img=get_sub_img(img,bottom+extDown,bottom+extDown,leftCut,rightCut);
          proj=project(sub_img,2);
          delete_image(sub_img);
          if(proj->data[0] <=sum_thresh) count ++;
          delete_flex_array(proj);
          if(count > count_thresh) break;
          extDown++;
    }
    bottomCut = bottom + extDown - count;
    
    
    
    /*precautions to prevent segfaults:*/
    if (topCut < 0) topCut = 0;
    if (bottomCut >= height)  bottomCut = height-1;
    if (leftCut < 0) leftCut = 0;
    if (rightCut >= width) rightCut = width-1;
    
    cuts->bottom_cut=bottomCut;
    cuts->left_cut=leftCut;
    cuts->right_cut=rightCut;
    cuts->top_cut=topCut;
    
    
    
    /*output - cut box*/
    return get_sub_img(img,topCut,bottomCut,leftCut,rightCut);
}


/*********************************************************************************/

linked_list* connComponents(const image_t *imgGy,int32_t minNumPixels){

	int32_t i,j;
	struct pixel seed;
	uint8_t T;
	uint8_t **dummy;
	int32_t Nset, ClassLabel;
	int32_t dummyClass;
	symbol_t *symbol, *symbol_tmp;
	linked_list *symbols_list;
	int32_t height, width;

	height = imgGy->height;
	width = imgGy->width;

	/* Set up segmented image structure */
	dummy=(uint8_t **) multialloc (sizeof (uint8_t), 2, (int)height, (int)width);
	symbols_list = create_linked_list();
	symbol_tmp = malloc(sizeof(symbol_t));

	/********************** Segment Image ******************/

	/* set threshold  */
	T=1;

	/* Initialize segmentation image */
	for ( i = 0; i < height; i++ ){
		for ( j = 0; j < width; j++ )
		{
			dummy[i][j] = 0;
		}
	}

	dummyClass = -1;

	/* Start class labeling at 1 */
	ClassLabel = 1;

	for ( i = 0; i < height; i++ )
		for ( j = 0; j < width; j++ )
		{
			/* If not yet classified */
			if (dummy[i][j] == 0 && getPixel(imgGy,i,j) == 1)
			{
				seed.row=i;
				seed.col=j;
				/* using this only to find Nset; will also indicate tested regions */
				ConnectedSet(seed, T, imgGy, width, height,
				             &dummyClass, dummy, &Nset, symbol_tmp);
				/* If more than 100 pixels, classify set*/
				if (Nset > minNumPixels)
				{
					symbol = malloc(sizeof(symbol_t));
					symbol->top=(uint16_t)height; symbol->bottom=0; 
					symbol->left=(uint16_t)width; symbol->right=0;

					ConnectedSet(seed, T, imgGy, width,
					             height, &ClassLabel, dummy, &Nset, symbol);

					symbol->height = (uint16_t)(symbol->bottom - symbol->top + 1);
					symbol->width = (uint16_t)(symbol->right - symbol->left + 1);
					symbol->HtW = (uint16_t)(symbol->height/symbol->width);
					symbol->NumBlack = (uint16_t)(Nset);
		
					symbol->class_label = -1;

					push_bottom(symbols_list, symbol);
	
					ClassLabel = ClassLabel + 1;
					if (ClassLabel > 255)
					{
						printf("Error: More than 256 classes.\n");
						printf("Need to increase minimum pixels per class.\n");
						exit(1);
					}
				}
			}
		}

	ClassLabel = ClassLabel - 1;

	
	multifree(dummy, 2);
	free(symbol_tmp);

	return symbols_list;
}


void ConnectedNeighbors(struct pixel s,uint8_t T,const image_t *imgGy,int32_t width,int32_t height,int32_t *M,struct pixel c[4]){
	*M=0;

	if (s.row != 0)
	{    /* if not on top row, above pixel */
		if (abs(getPixel(imgGy,s.row,s.col) - getPixel(imgGy,s.row-1,s.col)) < T)
		{
			c[*M].row=s.row-1;  /*   is valid neighbor */
			c[*M].col=s.col;
			(*M)++;
		}
	}
	if (s.col != 0)
	{
		if (abs(getPixel(imgGy,s.row,s.col)- getPixel(imgGy,s.row,s.col-1)) < T)
		{
			c[*M].row=s.row;
			c[*M].col=s.col-1;
			(*M)++;
		}
	}
	if (s.row != height-1)
	{
		if (abs(getPixel(imgGy,s.row,s.col) - getPixel(imgGy,s.row+1,s.col)) < T)
		{
			c[*M].row=s.row+1;
			c[*M].col=s.col;
			(*M)++;
		}
	}
	if (s.col != width-1)
	{
		if (abs(getPixel(imgGy,s.row,s.col) - getPixel(imgGy,s.row,s.col+1)) < T)
		{
			c[*M].row=s.row;
			c[*M].col=s.col+1;
			(*M)++;
		}
	}

}


void ConnectedSet(struct pixel s,uint8_t T,const image_t *imgGy,int32_t width,int32_t height,int32_t *ClassLabel,uint8_t **seg,int32_t *NumConPixels, symbol_t *symbol){

	void ConnectedNeighbors(struct pixel, uint8_t, const image_t *, int32_t, int32_t, int32_t *, struct pixel[4]);
	struct pixel *list;      /* pixels that have not been searched */
	int32_t list_index;          /* index into list[]           */
	int32_t list_size=3276800;     /* max size of list			I CHANGED FROM 32768*/
	int32_t Nset=1;              /* number of pixels in connected set */
	struct pixel c[4];       /* connected neighbors of pixel s */
	int32_t M;                   /* number of connected neighbors of current pixel */
	int32_t i;

	list = (struct pixel *) mget_spc(list_size,sizeof(struct pixel));

	/* initialize "to be searched" pixel list, start with seed s */
	list[0].row=s.row;
	list[0].col=s.col;
	list_index=0;

	/* Initialize seed in segmented image */
	seg[s.row][s.col] = (uint8_t)(*ClassLabel);

	/* find connected neighbors while there are pixels in the list */
	while (list_index >= 0)
	{

		/* find connected neighbors of s */
		ConnectedNeighbors(list[list_index], T, imgGy, width, height, &M, c);
		list_index = list_index-1;
		for (i=0; i<M; i++)
		{
			if ((seg[c[i].row][c[i].col] != (uint8_t)(*ClassLabel)))
			{
				seg[c[i].row][c[i].col]=(uint8_t)(*ClassLabel);
				Nset++;
				list_index++;
				list[list_index].row=c[i].row;
				list[list_index].col=c[i].col;
				if(*ClassLabel != -1){
					if(c[i].row < symbol->top){
						symbol->top = (uint16_t)(c[i].row);
					}
					if(c[i].row > symbol->bottom){
						symbol->bottom = (uint16_t)(c[i].row);
					}
					if(c[i].col < symbol->left){
						symbol->left = (uint16_t)(c[i].col);
					}
					if(c[i].col > symbol->right){
						symbol->right = (uint16_t)(c[i].col);
					}
				}
			}
			if (list_index == list_size)
			{
				printf("PROGRAM FAILED: Need to add more elements to list[]\n");
				printf("in ConnectSets()\n");
				exit(1);
			}
		}

	} /* end while loop */

	free(list);

	/* pass back output */
	*NumConPixels=Nset;

}

void remove_lines_2(image_t* img,params* parameters,uint32_t numCuts,image_t* lineless_img, uint32_t* stafflines, staff_info* staff){
/*initlize stafflines to a 5 elt array*/	
	uint32_t line_thickness, line_spacing, line_w, beginCut, endCut, *yprojection, linesFound, *stafflines_tmp,
		**STAFFLINES, i, j, vertSplice, sum, max_project, loc, eraseTop,
		 eraseBottom, min_thisLineY,max_thisLineY, shift_variable,h,w, **last_stafflines, ii, jj;
	int32_t min_thisLineY_tmp;
	image_t *fixThatImage;
	
	h = img->height;
	w = img->width;
/*CHANGES: GET RID OF*/
/*	line_thickness = (uint32_t)(parameters->thickness);
	line_spacing = (uint32_t)(parameters->spacing);*/
/*END CHANGES*/
	line_w = (uint32_t)(parameters->thickness + parameters->spacing);
	beginCut = 0;
/*CHANGES: W-1 => W*/
	endCut = (uint32_t)((w)/numCuts);
/*END CHANGES*/
	yprojection= (uint32_t *)mget_spc((uint32_t)h, sizeof(uint32_t));
	for(i=0;i<h;i++){
		sum = 0;
		for(j=0;j<w;j++){
			sum += getPixel(img,i,j);
		}
		yprojection[i] = sum;
	}
	linesFound = 0;	
	stafflines_tmp = (uint32_t *)mget_spc((uint32_t)10, sizeof(uint32_t));
	while(linesFound < 5){
		max_project = yprojection[0];
		loc = 0;
		for(i=1; i<h; i++){
			if(yprojection[i]>max_project){
				max_project = yprojection[i];
				loc = i;
			}
		}
    		linesFound = linesFound + 1;
    
    		/*all y coordinates of a line that is part of same staff line:*/
    		eraseTop = loc-(uint32_t)((line_w+1)/3 );
    		eraseBottom = loc+(uint32_t)((line_w+1)/3);
    		if (eraseTop < 0){ eraseTop = 0; } /*avoid segfault*/
    		if (eraseBottom > h-1){ eraseBottom = h-1; } /*avoid segfault*/
		
		min_thisLineY_tmp = -1;
		for(i=eraseTop; i<=eraseBottom; i++){
			if(yprojection[i]>=(9*max_project)/10){
				if(min_thisLineY_tmp == -1){				
					min_thisLineY_tmp = i;
				}
				max_thisLineY = i;
			}
			/*erase to avoid line in futher iterations*/
			yprojection[i] = 0;		
		}
		min_thisLineY = (uint32_t)(min_thisLineY_tmp);

		stafflines_tmp[2*(linesFound-1)] = min_thisLineY;
		stafflines_tmp[2*(linesFound-1)+1] = max_thisLineY;
	}
	free(yprojection);
	quickSort(stafflines_tmp,0,9);
	last_stafflines = (uint32_t **)multialloc (sizeof(uint32_t),2, 5,2);
	STAFFLINES = (uint32_t **)multialloc (sizeof (uint32_t),2, 5,2);
	
	for(i=0; i<5; i++){
		last_stafflines[i][0] = stafflines_tmp[2*i];
		last_stafflines[i][1] = stafflines_tmp[2*i + 1];
	}
	free(stafflines_tmp);
	/*LOOP THRU VERTICAL CUTS*/
	shift_variable=0;
	for(vertSplice =0; vertSplice<numCuts; vertSplice++){
		fixThatImage = get_sub_img(img,-1,-1,beginCut,endCut);
    		/*pretty up staff lines*/
		fix_lines_and_remove(fixThatImage,parameters,last_stafflines,&shift_variable, vertSplice);
		for(ii=0;ii<h;ii++){
			for(jj=beginCut;jj<=endCut;jj++){
				setPixel(img,ii,jj,getPixel(fixThatImage,ii,jj-beginCut));
			}
		}
		delete_image(fixThatImage);

    		if (vertSplice==0){
			for(i=0; i<5; i++){
                     
				STAFFLINES[i][0] = last_stafflines[i][0];
				STAFFLINES[i][1] = last_stafflines[i][1];
			}
    		}


    		beginCut = endCut + 1;
/*CHANGED: W-1 TO W*/
    		endCut = endCut + (uint32_t)((w)/numCuts) + 1;
/*END CHANGED*/
    		if (endCut > w-1){
        		endCut = w-1;
    		}
	}

	/*copy over image*/
	for(i=0; i<h;i++){
		for(j=0; j<w;j++){
			setPixel(lineless_img,i,j,getPixel(img,i,j));
		}
	}


	for(i=0;i<5;i++){
/*CHANGED 1->0 2->1*/
		stafflines[i] = (uint32_t)(((STAFFLINES[i][0]+STAFFLINES[i][1]+1)/2)); /*shift because of zero padding above*/
/*END CHANGE*/
	}

	multifree(STAFFLINES,2);
	multifree(last_stafflines,2);
}

void fix_lines_and_remove(image_t* img,params* parameters, uint32_t** last_STAFFLINES, uint32_t *previous_start, uint32_t cutNum){
/*function [result,new_start,STAFFLINES] = fix_lines_and_remove(img,params,last_STAFFLINES,previous_start,cutNum)*/
/*remvoe lines from small portion of staff. also straightens staff.*/
	flex_array_t *stafflines_tmp;	
	uint32_t *yprojection, line_thickness, line_spacing, line_w, *last_STAFFLINES_avg, max_project, sum, h, w,
		i, j, ii, count, **STAFFLINES, dummy, loc, shift, findLine, match, lineBegin,
		lineEnd, found_thickness, middle, tooThick, tooHigh, any_stafflines_zero, now_avg, last_avg, goodLine,
		tooLow, curr, extend, lastDelete, cW, cH, topStop, botStop, thickness, paramThickness, thickness_th,
		topLine, shift_loop,k;
	int16_t *tempData,*temp_array;
	int32_t lineY;
	uint8_t pixelData;
	linked_list *staffLines, *allLINES, *temp;
		
	STAFFLINES=multialloc(sizeof(uint32_t),2,5,2);

	h = img->height;
	w = img->width;
	line_thickness = (uint32_t)(parameters->thickness);
	line_spacing = (uint32_t)(parameters->spacing);
	line_w = (uint32_t)(parameters->thickness + parameters->spacing);
	
	last_STAFFLINES_avg = (uint32_t *)malloc(sizeof(uint32_t)*5);/*mget_spc((uint32_t)5, sizeof(uint32_t));*/
	for(i=0; i<5; i++){
		last_STAFFLINES_avg[i] = (uint32_t)((last_STAFFLINES[i][0] + last_STAFFLINES[i][1] + 1)/2);
	}
	yprojection= (uint32_t *)mget_spc((uint32_t)h, sizeof(uint32_t));
	max_project = 0;
	for(i=0;i<h;i++){
		sum = 0;
		for(j=0;j<w;j++){
			sum += getPixel(img,i,j);
		}
		yprojection[i] = sum;
		if(yprojection[i] > max_project){
			max_project = yprojection[i];		
		}
	}
	count = 0;
	for(i=0;i<h;i++){
    		if (yprojection[i] >= (9*max_project)/10){    /*delete staff line, twiddle with the 80% later (90%)*/
       			count++;
    		}
	}
	stafflines_tmp=make_flex_array(count);
	count = 0;
	for(i=0;i<h;i++){
    		if (yprojection[i] >= (9*max_project)/10){    /*delete staff line, twiddle with the 80% later (90%)*/
			stafflines_tmp->data[count] = i;       			
			count++;
    		}
	}
	free(yprojection);
	staffLines = group(stafflines_tmp, 3);
/*CHANGE: CUTNUM = 1 TO 0*/
	if (cutNum == 0 && staffLines->length == 5 ){
/*END CHANGE*/
		i=0;
	    	while(is_list_empty(staffLines)==0){
			tempData=(int16_t*)pop_top(staffLines);
			STAFFLINES[i][0] = tempData[0];
			STAFFLINES[i][1] = tempData[1];
			i++;
			free(tempData);
		}
	}
	else if ((staffLines->length) == 0){		
		for(i=0;i<5;i++){
			STAFFLINES[i][0] = last_STAFFLINES[i][0];
			STAFFLINES[i][1] = last_STAFFLINES[i][1];
		}
	}
/*CHANGE: CUTNUM = 1 TO 0*/
	else if (cutNum == 0 && (staffLines->length) < 5){
/*END CHANGE*/
	    	/*choose one line, then find closest line in last_STAFFLINES*/
		tempData = (int16_t*)(getIndexData(staffLines, 0));
	    	goodLine = (uint32_t)((tempData[0]+tempData[1]+1)/2);
		
		dummy = abs(last_STAFFLINES_avg[0] - goodLine);
		loc = 0;		
		for(i=1;i<5;i++){
			curr = abs(last_STAFFLINES_avg[i] - goodLine);
			if(curr<dummy){
				dummy = curr;				
				loc = i;
			}
		}
	    	shift = goodLine - last_STAFFLINES_avg[loc];
	    
	    	for(i=0;i<5;i++){
			STAFFLINES[i][0] = last_STAFFLINES[i][0]+shift;
			STAFFLINES[i][1] = last_STAFFLINES[i][1]+shift;
		}
	}
	

	else{
		count = 0;
		for(findLine=0;findLine<5;findLine++){

			match = 0;
			for(i=0;i<(staffLines->length);i++){
				tempData = (int16_t*)(getIndexData(staffLines, i));
			    	lineBegin = (uint32_t)tempData[0];
			    	lineEnd = (uint32_t)tempData[1];
				/*lineBegin is top of line, lineEnd is bottom*/

			    	found_thickness = lineEnd-lineBegin+1;
/*CHANGED: 0.5 TO 1/2*/
			    	middle = (uint32_t)((lineBegin + lineEnd+1)/2);
/*END CHANGED*/

			    	/*determine if the line is of expected location/size*/
				tooThick = 0;
				tooHigh = 0;
				tooLow = 0;
			    	if(found_thickness > (line_thickness+2)) tooThick=1;
				if(middle < (last_STAFFLINES_avg[findLine] - 3)) tooHigh=1;
				if(middle > (last_STAFFLINES_avg[findLine] + 3)) tooLow=1;
/*CHANGED: 1 TO 0*/
			    	if (cutNum == 0){
/*END CHANGED*/
					tooHigh = 0;
					tooLow = 0;
					if(middle < (last_STAFFLINES_avg[0] - 2*line_spacing)){tooHigh=1;}
/*CHANGED + TO - ALSO, avg[5] -> avg[4] */
					if(middle > (last_STAFFLINES_avg[4] + 2*line_spacing)){tooLow=1;}
/*END CHANGED*/
			    	}

			    	if (tooThick || tooHigh || tooLow){
					continue;
			    	}
			    	else{ /*we found good match for staffline*/
					match = 1;
					/*SAVE STAFF LINE LOCATIONS*/
					STAFFLINES[count][0] = lineBegin;
					STAFFLINES[count][1] = lineEnd;
					count++;
					deleteIndexData(staffLines,i);
					break;
			    	}        



			} /*end looping thru found lines*/

			if(!match){ /*CHANGED*/
		    		/*flag that no match was found*/
		    		STAFFLINES[count][0] = 0;
				STAFFLINES[count][1] = 0;
				count++;
			} 

	    	} /*end looping through matching staff lines*/
	    
	    	/*CHANGED BELOW*/
	    
	    	/*check for lines that did not get match*/
		any_stafflines_zero = 0;
		for(i=0;i<5;i++){
			if(STAFFLINES[i][0] == 0){
				any_stafflines_zero = 1;
				break;
			}
		}
	    	if (any_stafflines_zero){
			/*find shift value first*/
			shift = 100; /*big value*/
			for (findLine = 0; findLine<5;findLine++){
			/*loop to find nonzero entry in STAFFLINES, then calculate shift*/
			    if (STAFFLINES[findLine][0]){ /*if nonzero*/
				now_avg = (uint32_t)((STAFFLINES[findLine][0]+STAFFLINES[findLine][1]+1)/2);
				last_avg = last_STAFFLINES_avg[findLine];
				shift = now_avg - last_avg;
				break;
			    }
			}
			if (shift==100){ shift = 0;}
			/*replace any flagged (with 0) entries in STAFFLINES*/
			for(findLine=0;findLine<5;findLine++){
			    	if (STAFFLINES[findLine][0] == 0){
					STAFFLINES[findLine][0] = last_STAFFLINES[findLine][0]+shift;
					STAFFLINES[findLine][1] = last_STAFFLINES[findLine][1]+shift;
			    	}
			}
		}
	}

	extend = (uint32_t)((line_w+2)/4)+1;
	/*create stafflines above*/
	allLINES=create_linked_list();
	lineY = (int32_t)(((STAFFLINES[0][0] + STAFFLINES[0][1]+1)/2) - line_w); /*first above line*/
	while (1){
   		if (lineY < (int32_t)(extend + 2)){
       			break;
		}   		
		else{
			temp_array=malloc(sizeof(int16_t)*2);
			temp_array[0]=(int16_t)lineY;
			temp_array[1]=(int16_t)lineY;
			push_top(allLINES,temp_array);
       			lineY = (int32_t)(lineY - (int32_t)line_w );
   		}
	}
	for(i=0;i<5;i++){
		temp_array=malloc(sizeof(uint32_t)*2);
		temp_array[0]=(int16_t)STAFFLINES[i][0];
		temp_array[1]=(int16_t)STAFFLINES[i][1];
		push_bottom(allLINES,temp_array);
	}
	/*create stafflines below*/
	lineY = (uint32_t)(((STAFFLINES[4][0] + STAFFLINES[4][1]+1)/2) + line_w); /*first above line*/
	while (1){
   		if (lineY > (h - extend - 3)){
       			break;
		}   		
		else{
			temp_array=malloc(sizeof(int16_t)*2);
			temp_array[0]=(int16_t)lineY;
			temp_array[1]=(int16_t)lineY;
			push_bottom(allLINES,temp_array);
			lineY = (uint32_t)(lineY + (int32_t)line_w);
   		}
	}
	/*REMOVE STAFF LINES*/

	while( is_list_empty(allLINES)==0){
		tempData = (int16_t*)pop_top(allLINES);
		lineBegin = tempData[0];
		lineEnd = tempData[1];
		middle = (lineBegin + lineEnd + 1)/2;
		lastDelete = 0;
		free(tempData);
    
    
    		for(j=0;j<w;j++){
        
        		/*top of staff line*/
        		topStop = 0;
/*CHANGED*/
        		for(ii = (lineBegin-1); ii>=(lineBegin-extend); ii--){
/*END CHANGED*/
            			if (ii < 0){
                			break;
            			}
            			if (getPixel(img,ii,j)==0){ /*then erase*/
                			topStop = ii+1;
                			break;
            			}
        		}
    
			/*bottom of staff line*/
			botStop = h-1;
/*CHANGED*/
			for(ii = lineEnd+1; ii<=(lineEnd+extend); ii++){
/*END CHANGED*/
	     	      	 	if (ii > h-1){
	      	          		break;
		    		}
		    		if(getPixel(img,ii,j)==0){
		        		botStop = ii-1;              
		        		break;
		    		}
			}
	    
		
			/*check thickness of line, delete if skinny*/
	       	 	thickness = botStop - topStop + 1;
	       	 	if (parameters->thickness < 3){
		    		paramThickness = parameters->thickness + 1;
			}
			else{
		    		paramThickness = parameters->thickness;
			}
			if (lastDelete){ /*there was a line deletion last iteration*/
		    		thickness_th = paramThickness*2; /*higher threshold*/
			}
			else{
		    		thickness_th = paramThickness*2-2;
			}
			if (thickness <= thickness_th){
				for(ii=topStop; ii<=botStop; ii++){ 
		    			setPixel(img,ii,j,0);
				}
		    		lastDelete = 1;
			}
			else{
		    		lastDelete = 0;
			}
    
    		}
        
	} /*end staff line*/
	topLine = STAFFLINES[0][0];
	if(*previous_start){
    		if(*previous_start<topLine){
        		shift=topLine-(*previous_start);
/*CHANGED H-SHIFT-1 TO H-SHIFT*/
			for(shift_loop=0; shift_loop<(h-shift); shift_loop++){
/*END CHANGED*/
				for(cW=0; cW<w; cW++){
					pixelData=getPixel(img,shift_loop+shift,cW);
		    			setPixel(img,shift_loop,cW,pixelData);
				}
			}
			for(cH=h-shift-1; cH<h; cH++){
				for(cW=0; cW<w; cW++){
		    			setPixel(img,cH,cW,0);
				}
			}      	
		}
    		else if(*previous_start>topLine){
        		shift=*previous_start-topLine;
		
			for(shift_loop=h-1; shift_loop>=shift; shift_loop--){
				for(cW=0; cW<w; cW++){
					pixelData=getPixel(img,shift_loop-shift,cW);
		    			setPixel(img,shift_loop,cW, pixelData);
				}
			}
/*CHANGED: SHIFT-1 TO SHIFT*/
			for(cH=0; cH<shift; cH++){
/*END CHANGED*/
				for(cW=0; cW<w; cW++){
		    			setPixel(img,cH,cW,0);
				}
			}
		}	
	}
	else{
	    	*previous_start=topLine;
	}

	for(i=0; i<5;i++){
		last_STAFFLINES[i][0] = STAFFLINES[i][0];
		last_STAFFLINES[i][1] = STAFFLINES[i][1];
	}
	delete_list(staffLines);
	delete_list(allLINES);
	multifree(STAFFLINES,2);
}


