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

#define NARGS   1       /* This is the number of arguments the program takes */

/*set to 0 to run code 
set to 1 to use test_main instead*/ 
#define dB_test 0


void outputIMG(image_t *img, char *outputFilename);
void outputIMG_notbinary(uint8_t **img, char *outputFilename, int32_t outheight, int32_t outwidth);

int test_main(){
    linked_list*  test_list;
    test_list=create_linked_list( );
    int *a;
    a=malloc(sizeof(int));
    *a=1;
    push_top(test_list,a); 
    a=malloc(sizeof(int));
    *a=2;
    push_top(test_list,a);
    a=malloc(sizeof(int));
    *a=3;
    push_top(test_list,a);
    a=malloc(sizeof(int));
    *a=4;
    push_top(test_list,a);
    a=malloc(sizeof(int));
    *a=14;
    linked_list_insert_before_index(test_list,4,a);
    while( is_list_empty(test_list)==0){
           a=pop_bottom(test_list);
           printf("test pop: %d\n",*a);
           free(a);
    }
    system("PAUSE");
    return 0;
    
}


int main (int32_t argc, char **argv) {
    FILE *fp;       /* File poionter for opening and writing image file */
	
    /* Define structures for holding input and output images */
    struct TIFF_img inputImage;
	
    /* These are matricies which will be used to hold intermediate
     * versions of the image being processed
     */
    uint8_t **image, **seg;
    image_t *binIMG, *tbCropIMG, *cropIMG, *verDeskew, *horDeskew, *lineless_img;
	
    int32_t i,j, tmp;  /* Just some counters and pixel value holder */
	int32_t height, width, newHeight, newWidth, startCrop_h, startCrop_w, crop_t, crop_l;
	int32_t outheight,outwidth;
	
    char    *inputFilename;         /* Filename of input image */
    char    outputFilename[50];        /* Filename to save output image to */
    
	params* staffParams;
	staff_info *staff;
	uint16_t staff_counter;
	image_t* staffIMG;
	image_t* newStaffIMG;
	uint32_t* stafflines;
	flex_pointer_array_t* stems_array;
	linked_list* groupings;
	int16_t* group_mike;
	linked_list *stems_list, *measures_list, *symbols_list;
	stems_t* test_note_thing;
	
	/* for testing new code*/
	if(dB_test) return test_main();
	
    /* Check to make sure the program is called properly */
    if ( argc != (NARGS+1) ) {
        /* If the program is not called properly, print a usage
		 message */
        fprintf( stderr, "Usage: %s <input file> \n", argv[0]);
        fprintf( stderr, "This program makes a copy of an image located\n");
        fprintf( stderr, "in <input file> \n");
        fprintf( stderr, "\n");
        scanf("%d",&i);
		
        /* Exit from the program with an error */
        exit ( 1 );
    }
	
    /* Assign program arguments */
    inputFilename = argv[1];
	
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

	height = newHeight;
	width = newWidth;
	
	/*****************************************************************************************/
	/*****************************************************************************************/
	
	staff=malloc(sizeof(staff_info));
	staffParams=staff_segment(cropIMG,staff);
	staffParams->thickness=4;
	staffParams->spacing=12;
	get_key_sig(cropIMG,staff, staffParams);
	printf("key sig x %d\n",staffParams->ks_x);
    	for (staff_counter=0;staff_counter<(staff->number_staffs);staff_counter++){	
        	printf("starting staff %d of %d\n", staff_counter,(staff->number_staffs)-1);
        	staffIMG=get_staff(cropIMG, staff, staff_counter,staffParams);
        	printf("got staff %d\n",staff_counter);

		tmp = sprintf(outputFilename,"staff_img%d.tif",staff_counter);
		outputIMG(staffIMG, &outputFilename);

		/*KATIE*/
		stafflines = (uint32_t *) mget_spc(5,sizeof(uint32_t));
		lineless_img = make_image(staffIMG->height, staffIMG->width);

		remove_lines_2(staffIMG,staffParams,30,lineless_img, stafflines, staff);
		printf("remove lines done...\n");
		delete_image(staffIMG);

		tmp = sprintf(outputFilename,"removelines_img%d.tif",staff_counter);
		outputIMG(lineless_img, &outputFilename);

		stems_list    	=	create_linked_list();
		measures_list	= 	create_linked_list();
		find_lines(lineless_img, staffParams, staff_counter, stafflines, stems_list, measures_list);
		printf("find lines done...\n");
		/*if(staff_counter<(staff->number_staffs)-1) delete_image(lineless_img);*/
        	tmp = sprintf(outputFilename,"after_find_lines_img%d.tif",staff_counter);
		outputIMG(lineless_img, &outputFilename);


		tmp = sprintf(outputFilename,"removeLines_img%d.tif",staff_counter);
		outputIMG(lineless_img, &outputFilename);

		get_MIDI(lineless_img,lineless_img->height, lineless_img->width, staffParams, stafflines,stems_list);
		printf("get midi done...\n");
		for(i=0; i<stems_list->length;i++){
			printf("midi:%d dur: %d\n",((stems_t*)(getIndexData(stems_list,i)))->midi,
				((stems_t*)(getIndexData(stems_list,i)))->duration);
		}

		remove_notes_measures(lineless_img,lineless_img->height, lineless_img->width,stems_list,
			measures_list,staffParams,stafflines);

		printf("remove notes measures done...\n");
		tmp = sprintf(outputFilename,"removeNM_img%d.tif",staff_counter);
		outputIMG(lineless_img, &outputFilename);
		
		seg=(uint8_t **) multialloc (sizeof (uint8_t), 2, (int)lineless_img->height, (int)lineless_img->width);
		symbols_list = connComponents(lineless_img,10);
		printf("symbol cc done...\n");

		for(i=0; i<symbols_list->length;i++){
			printf("before: top:%d	bot:%d	lef:%d	rig:%d\n",((symbol_t*)(getIndexData(symbols_list,i)))->top,
				((symbol_t*)(getIndexData(symbols_list,i)))->bottom, 
				((symbol_t*)(getIndexData(symbols_list,i)))->left,
				((symbol_t*)(getIndexData(symbols_list,i)))->right);
		}

		combineSymbols(symbols_list,staffParams);
  
		classify_symbols(symbols_list, stems_list, measures_list, staffParams, lineless_img, stafflines);
		printf("classify symbols done...\n");
		if (contextualizer_notes_rests(stems_list,symbols_list)==1){//output checks if whole note was found
           get_MIDI( lineless_img,  lineless_img->height,lineless_img->width,staffParams,stafflines,stems_list);                                                        
        }
        printf("contextualize notes done...\n");
                                            
        update_with_key_signature( stems_list , staffParams->ks);
        printf("update key signature done...\n");
        contextualizer_other( stems_list,measures_list, symbols_list);
        printf("contextualize other symbols done...\n");

        while (is_list_empty(stems_list)==0){
              test_note_thing=pop_top(stems_list);
              printf("testing notes: midi: %d dur: %d mod:%d\n",test_note_thing->midi,test_note_thing->duration,test_note_thing->mod);
              free(test_note_thing);
        }
        system("PAUSE");
		delete_list(symbols_list);
		delete_list(stems_list);
		delete_list(measures_list);
    	}

	
    /* de-allocate space which was used for the images */
    delete_image(cropIMG);
    /* Exit the main function without an error */
    system("PAUSE");
    return(0);
}
