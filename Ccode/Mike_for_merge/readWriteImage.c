#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include <stdio.h>
#include "preprocessing.h"
#include "image_data.h"
#include "linked_list.h"
#include "disco_types.h"
#include "utility_functions.h"
#include "segmentation.h"
#include "classify.h"

#define NARGS   2       /* This is the number of arguments the program takes */

#define dB_test 1

int test_main(){
    
    image_t* img;
    image_t* mini;
    note_cuts* cuts;
    params* parameters;
    parameters=(params*)malloc(sizeof(params));
    parameters->ks=0;
    parameters->spacing=5;
    parameters->thickness=1;
    parameters->staff_h=30;
    cuts=(note_cuts*)malloc(sizeof(note_cuts));
    img=make_image(9,16);
    img->pixels[0][0]=0x00;
    img->pixels[0][1]=0x00;
    img->pixels[1][0]=0x00;
    img->pixels[1][1]=0xC0;
    img->pixels[2][0]=0x00;
    img->pixels[2][1]=0xC0;
    img->pixels[3][0]=0x00;
    img->pixels[3][1]=0xC0;
    img->pixels[4][0]=0x3F;
    img->pixels[4][1]=0xC0;
    img->pixels[5][0]=0x7F;
    img->pixels[5][1]=0xC0;
    img->pixels[6][0]=0x7F;
    img->pixels[6][1]=0xC0;
    img->pixels[7][0]=0x3F;
    img->pixels[7][1]=0xC0;
    img->pixels[8][0]=0x00;
    img->pixels[8][1]=0x00;
    print_image(img);
    system("PAUSE");
    mini=mini_img_cut(img,0,9,0,16,parameters,cuts);
    system("PAUSE");
    print_image(mini);
    if(is_note_open(mini))printf("open\n");
    else printf("filled\n");
    delete_image(img);
    delete_image(mini);
    free(parameters);
    free(cuts);
    //flex_pointer_array_t* array;
    //int16_t* array2;
    //linked_list* stack;
    //uint16_t i;
    /*uint16_t *a, *b,*c,*d,*e,*f;
    uint16_t z,y,x,w,v,u;
    a=(uint16_t*)malloc(sizeof(uint16_t));
    b=(uint16_t*)malloc(sizeof(uint16_t));
    c=(uint16_t*)malloc(sizeof(uint16_t));
    d=(uint16_t*)malloc(sizeof(uint16_t));
    e=(uint16_t*)malloc(sizeof(uint16_t));
    f=(uint16_t*)malloc(sizeof(uint16_t));
    u=10;
    v=3;
    w=4;
    x=450;
    y=11;
    z=13;
    a=&u;
    b=&v;
    c=&w;
    d=&x;
    e=&y;
    f=&z; 
    array=(flex_pointer_array_t*)make_flex_pointer_array(6,sizeof(uint16_t*));
    array->data[0]=a;
    array->data[1]=b;
    array->data[2]=c;
    array->data[3]=d;
    array->data[4]=e;
    array->data[5]=f;
    array->data[6]=4;
    array->data[7]=25;
    array->data[8]=1;
    array->data[9]=10;*/
    //flex_mergesort(array,0,array->length-1);
    /*for (i=0;i<array->length;i++){
        printf("%d\n",*((uint16_t*)array->data[i]));
    }*/
    
    //stack=group(array,1);
    //delete_flex_pointer_array(array);
    
   /* while (is_list_empty( stack)==0){
          array2=pop_top(stack);
          printf("%d, %d\n",array2[0],array2[1]);
          free(array2);
    }*/
    system("PAUSE");
    return 0;
    
}

int main (int32_t argc, char **argv) {
    FILE *fp;       /* File poionter for opening and writing image file */
	
    /* Define structures for holding input and output images */
    struct TIFF_img inputImage, outputImage;
	
    /* These are matricies which will be used to hold intermediate
     * versions of the image being processed
     */
    uint8_t **image;
    image_t *binIMG, *tbCropIMG, *cropIMG, *verDeskew, *horDeskew;
	
    int32_t i,j;  /* Just some counters and pixel value holder */
    int32_t tmp;
	int32_t height, width, newHeight, newWidth, startCrop_h, startCrop_w, crop_t, crop_l;
	int32_t outheight,outwidth;
	
    char    *inputFilename;         /* Filename of input image */
    char    *outputFilename;        /* Filename to save output image to */
    
	params* staffParams;
	staff_info *staff;
	uint16_t staff_counter;
	image_t* staffIMG;
	image_t* newStaffIMG;
	uint16_t** STAFFLINES;
	flex_pointer_array_t* stems_array;
	linked_list* groupings;
	int16_t* group_mike;
	
	/* for testing new code*/
	if(dB_test) return test_main();
	
    /* Check to make sure the program is called properly */
    if ( argc != (NARGS+1) ) {
        /* If the program is not called properly, print a usage
		 message */
        fprintf( stderr, "Usage: %s <input file> <output file>\n", argv[0]);
        fprintf( stderr, "This program makes a copy of an image located\n");
        fprintf( stderr, "in <input file> and saves it in <output file>\n");
        fprintf( stderr, "\n");
        scanf("%d",&i);
		
        /* Exit from the program with an error */
        exit ( 1 );
    }
	
    /* Assign program arguments */
    inputFilename = argv[1];
    outputFilename = argv[2];
	
    /* open image file */
    if ( ( fp = fopen ( inputFilename, "rb" ) ) == NULL ) {
        /* If the image file cannot be opened, print an error message */
        fprintf ( stderr, "cannot open file %s\n", inputFilename );
        scanf("%d",&i);
        exit ( 1 );
    }
	
    /* read image */
    if ( read_TIFF ( fp, &inputImage ) ) {
        /* IF the input image cannot be read, print an error message */
        fprintf ( stderr, "error reading file %s\n", inputFilename );
        scanf("%d",&i);
        exit ( 1 );
    }
	
    /* close input image file */
    fclose ( fp );
	
    /* check the type of input image data */
    if ( inputImage.TIFF_type != 'g' ) {
        /* If the image type is not grayscale, print an error
		 and exit */
        fprintf ( stderr, "error:  image must be grayscale\n" );
        scanf("%d",&i);
        exit ( 1 );
    }
    
    
	
	/*****************************************************************************************/
	/*****************************************************************************************/
	height = inputImage.height;
	width = inputImage.width;
	
	image = (uint8_t**)get_img(width,height,sizeof(uint8_t));
	/*****************************************************************************************/
	/*****************************************************************************************/
	
	for ( i = 0; i < height; i++ ) {
        for ( j = 0; j < width; j++ ) {
            image[i][j] = inputImage.mono[i][j];
        }
    }
    
    
	
	binIMG = make_image(height,width); /*(uint8_t **)multialloc (sizeof (uint8_t), 2, height, width);*/
	binarizeIMG(image, height, width, binIMG, -20);
	multifree(image,2);
	printf("done binarization...\n");
	
	tbCrop(binIMG, height, width, &startCrop_h, &newHeight);
	tbCropIMG = make_image(newHeight,width);
	for(i=startCrop_h; i<startCrop_h+newHeight; i++){
		for (j=0; j<width; j++){
            setPixel(tbCropIMG,i-startCrop_h,j,getPixel(binIMG,i,j));
		}
	}
	delete_image(binIMG);
	printf("done tb crop...\n");
	
	lrCrop(tbCropIMG, newHeight, width, &startCrop_w, &newWidth);
	cropIMG = make_image(newHeight,newWidth);
	for(j=startCrop_w; j<startCrop_w+newWidth; j++){
		for (i=0; i<newHeight; i++){
            setPixel(cropIMG,i,j-startCrop_w,getPixel(tbCropIMG,i,j));
		}
	}
	delete_image(tbCropIMG);
	printf("done lr crop...\n");
	
	blob_kill(cropIMG,1,1);
	printf("done blob kill...\n");
	
	height = newHeight;
	width = newWidth;
	
	verDeskew = make_image(height,width);
	ver_deskew(cropIMG, height, width, verDeskew);
	delete_image(cropIMG);
	printf("done vertical deskew...\n");
	
	blob_kill(verDeskew,1,1);
	printf("done second blob kill...\n");
	
	horDeskew = make_image(height,width);
	hor_deskew(verDeskew, height, width, horDeskew);
	delete_image(verDeskew);
	printf("done horizontal deskew...\n");
	
	
	w_crop(horDeskew, height, width, 0, &crop_t, &newHeight, &crop_l, &newWidth);
	
	cropIMG = make_image(newHeight,newWidth);

	for(i=crop_t; i<crop_t+newHeight; i++){
		for (j=crop_l; j<crop_l+newWidth; j++){
            setPixel(cropIMG,i-crop_t,j-crop_l,getPixel(horDeskew,i,j));
		}
	}
	delete_image(horDeskew);
	printf("done final crop...\n");
	
	/*****************************************************************************************/
	/*****************************************************************************************/
	
	staff=malloc(sizeof(staff_info));
    staffParams=staff_segment(cropIMG,staff);
    for (staff_counter=0;staff_counter<(staff->number_staffs);staff_counter++){
        printf("starting staff %d of %d\n", staff_counter,(staff->number_staffs)-1);
        staffIMG=get_staff(cropIMG, staff, staff_counter);
        printf("got staff %d\n",staff_counter);
        groupings=create_linked_list();
        stems_array=find_top_bottom(staffIMG,(7*(staffParams->staff_h)+3)/10,1,groupings);
        
        //printf("length: %d\n",stems_array->length);
        /*for( i=0;i< (stems_array->length);i++){
             printf(" indices: %d\n", ((good_lines_t*)(stems_array->data[i]))->index);
        }*/
        while(!is_list_empty(groupings)){
                 group_mike=pop_top(groupings);
                 printf("groupings: %d %d\n",group_mike[0],group_mike[1]);
                 free(group_mike);
        }
        system("PAUSE");
        delete_list(groupings);
        delete_flex_pointer_array(stems_array);
        
        //STAFFLINES=multialloc(sizeof(uint16_t),2,5,2);
        //newStaffIMG=remove_lines_smart(staffIMG,staffParams,10,STAFFLINES);
        //printf("removed staff lines\n");
        
        //multifree(STAFFLINES,2);
        delete_image(staffIMG);
        //delete_image(newStaffIMG);
    }
    system("PAUSE");
	
	/*****************************************************************************************/
	/*****************************************************************************************/
	
	outheight = newHeight;
	outwidth = newWidth;
	
    /* set up structure for output image */
    /* to allocate a grayscale image use type 'g' */
    get_TIFF ( &outputImage, outheight, outwidth, 'g' );
	
    /* copy img1 to output images */
    for ( i = 0; i < outheight; i++ ) {
        for ( j = 0; j < outwidth; j++ ) {
			/*CURRENTLY MULTIPY BY 255 SO THAT WE CAN SEE BINARIZED IMAGES MORE EASILY*/
            tmp = (int32_t)255*(1-getPixel(cropIMG,i,j));
            /*if the value is less than 0 it assigns the value to be 0*/
            if(tmp<0) {
                tmp = 0;
            }
            /*if the value is greater than 255 it assigns the value to be 255*/
            if(tmp>255) {
                tmp = 255;
            }
            outputImage.mono[i][j] = tmp;
            /* outputImage.mono[i][j] = img1[i][j]; */
        }
    }
	
    /* open output image file */
    if ( ( fp = fopen ( outputFilename, "wb" ) ) == NULL ) {
        /* If output image file cannot be opened, print error */
        fprintf ( stderr, "cannot open file %s\n", outputFilename);
        exit ( 1 );
    }
	
    /* write image */
    if ( write_TIFF ( fp, &outputImage ) ) {
        /* If output image file cannot be written to, print error */
        fprintf ( stderr, "error writing TIFF file %s\n",
				 outputFilename );
        exit ( 1 );
    }
	
    /* close output image file */
    fclose ( fp );
	
    /* de-allocate space which was used for the images */
    delete_image(cropIMG);
	
    /* Exit the main function without an error */
    return(0);
}
