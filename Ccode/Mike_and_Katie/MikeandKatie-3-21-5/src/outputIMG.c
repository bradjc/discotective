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

void outputIMG(image_t *img, char *outputFilename){	

    	int32_t i,j, tmp;  /* Just some counters and pixel value holder */
	int32_t outheight,outwidth;
	struct TIFF_img outputImage;
	FILE *fp;       /* File poionter for opening and writing image file */

	outheight = img->height;
	outwidth = img->width;
	
    	/* set up structure for output image */
    /* to allocate a grayscale image use type 'g' */
    get_TIFF ( &outputImage, outheight, outwidth, 'g' );
	
    /* copy img1 to output images */
    for ( i = 0; i < outheight; i++ ) {
        for ( j = 0; j < outwidth; j++ ) {
		tmp = (int32_t)255*(1-getPixel(img,i,j));
            /*if the value is less than 0 it assigns the value to be 0*/
            if(tmp<0) {
                tmp = 0;
            }
            /*if the value is greater than 255 it assigns the value to be 255*/
            if(tmp>255) {
                tmp = 255;
            }
            outputImage.mono[i][j] = tmp;
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
}


void outputIMG_notbinary(uint8_t **img, char *outputFilename, int32_t outheight, int32_t outwidth){	

    	int32_t i,j, tmp;  /* Just some counters and pixel value holder */
	struct TIFF_img outputImage;
	FILE *fp;       /* File poionter for opening and writing image file */

    	/* set up structure for output image */
    /* to allocate a grayscale image use type 'g' */
    get_TIFF ( &outputImage, outheight, outwidth, 'g' );
	
    /* copy img1 to output images */
    for ( i = 0; i < outheight; i++ ) {
        for ( j = 0; j < outwidth; j++ ) {
		tmp = (int32_t)255*(img[i][j]);
            /*if the value is less than 0 it assigns the value to be 0*/
            if(tmp<0) {
                tmp = 0;
            }
            /*if the value is greater than 255 it assigns the value to be 255*/
            if(tmp>255) {
                tmp = 255;
            }
            outputImage.mono[i][j] = tmp;
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
}
