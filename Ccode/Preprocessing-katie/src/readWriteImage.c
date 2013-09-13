#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include <stdio.h>
#include "preprocessing.h"

#define NARGS   2       /* This is the number of arguments the program takes */


int main (int argc, char **argv) {
    FILE *fp;       /* File poionter for opening and writing image file */
	
    /* Define structures for holding input and output images */
    struct TIFF_img inputImage, outputImage;
	
    /* These are matricies which will be used to hold intermediate
     * versions of the image being processed
     */
    double **image, **binIMG, **tbCropIMG, **cropIMG, **verDeskew, **horDeskew;
	
    int i,j;  /* Just some counters and pixel value holder */
    int tmp;
	int height, width, newHeight, newWidth, startCrop_h, startCrop_w, crop_t, crop_l;
	int outheight,outwidth;
	
    char    *inputFilename;         /* Filename of input image */
    char    *outputFilename;        /* Filename to save output image to */
	
	
    /* Check to make sure the program is called properly */
    if ( argc != (NARGS+1) ) {
        /* If the program is not called properly, print a usage
		 message */
        fprintf( stderr, "Usage: %s <input file> <output file>\n", argv[0]);
        fprintf( stderr, "This program makes a copy of an image located\n");
        fprintf( stderr, "in <input file> and saves it in <output file>\n");
        fprintf( stderr, "\n");
		
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
        exit ( 1 );
    }
	
    /* read image */
    if ( read_TIFF ( fp, &inputImage ) ) {
        /* IF the input image cannot be read, print an error message */
        fprintf ( stderr, "error reading file %s\n", inputFilename );
        exit ( 1 );
    }
	
    /* close input image file */
    fclose ( fp );
	
    /* check the type of input image data */
    if ( inputImage.TIFF_type != 'g' ) {
        /* If the image type is not grayscale, print an error
		 and exit */
        fprintf ( stderr, "error:  image must be grayscale\n" );
        exit ( 1 );
    }
	
	/*****************************************************************************************/
	/*****************************************************************************************/
	height = inputImage.height;
	width = inputImage.width;
	
	image = (double**)get_img(width,height,sizeof(double));
	/*****************************************************************************************/
	/*****************************************************************************************/
	
	for ( i = 0; i < height; i++ ) {
        for ( j = 0; j < width; j++ ) {
            image[i][j] = inputImage.mono[i][j];
        }
    }
    
    
	
	binIMG = (double **)multialloc (sizeof (double), 2, height, width);
	binarizeIMG(image, height, width, binIMG, -20);
	multifree(image,2);
	printf("done binarization...\n");
	
	tbCrop(binIMG, height, width, &startCrop_h, &newHeight);
	tbCropIMG = (double **)multialloc (sizeof (double), 2, newHeight, width);
	for(i=startCrop_h; i<startCrop_h+newHeight; i++){
		for (j=0; j<width; j++){
			tbCropIMG[i-startCrop_h][j] = binIMG[i][j];
		}
	}
	multifree(binIMG,2);
	printf("done tb crop...\n");
		
	lrCrop(tbCropIMG, newHeight, width, &startCrop_w, &newWidth);
	cropIMG = (double **)multialloc (sizeof (double), 2, newHeight, newWidth);
	for(j=startCrop_w; j<startCrop_w+newWidth; j++){
		for (i=0; i<newHeight; i++){
			cropIMG[i][j-startCrop_w] = tbCropIMG[i][j];
		}
	}
	multifree(tbCropIMG,2);
	printf("done lr crop...\n");
	
	height = newHeight;
	width = newWidth;
	
	verDeskew = (double **)multialloc (sizeof (double), 2, height, width);
	ver_deskew(cropIMG, height, width, verDeskew);
	multifree(cropIMG,2);
	printf("done vertical deskew...\n");
	
	horDeskew = (double **)multialloc (sizeof (double), 2, height, width);
	hor_deskew(verDeskew, height, width, horDeskew);
	multifree(verDeskew,2);
	printf("done horizontal deskew...\n");
	
	w_crop(horDeskew, height, width, 0, &crop_t, &newHeight, &crop_l, &newWidth);
	
	cropIMG = (double **)multialloc (sizeof (double), 2, newHeight, newWidth);

	for(i=crop_t; i<crop_t+newHeight; i++){
		for (j=crop_l; j<crop_l+newWidth; j++){
			cropIMG[i-crop_t][j-crop_l] = horDeskew[i][j];
		}
	}
	multifree(horDeskew,2);
	printf("done final crop...\n");
	
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
            tmp = (int)255*cropIMG[i][j];
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
    multifree(cropIMG,2);
	
    /* Exit the main function without an error */
    return(0);
}
