#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <math.h>

struct TIFF_img {
  int			height;
  int			width;
  char			TIFF_type;  	/* 'g' = grayscale;               */
					/* 'p' = palette-color;           */
					/* 'c' = RGB full color           */

  unsigned char		**mono;		/* monochrome data, or indices    */
					/* into color-map; indexed as     */
					/* mono[row][col]                 */

  unsigned char		***color;	/* full-color RGB data; indexed   */
					/* as color[plane][row][col],     */
					/* with planes 0, 1, 2 being red, */
					/* green, and blue, respectively  */

  char 			compress_type;	/* 'u' = uncompressed             */

  unsigned char		**cmap;		/* for palette-color images;      */
					/* for writing, this array MUST   */
					/* have been allocated with       */
					/* height=256 and width=3         */
};


/* For the following routines: 1 = error reading file; 0 = success  */

/* This routine allocates space and reads TIFF image */
int read_TIFF ( FILE *fp, struct TIFF_img *img ); 

/* This routine writes out a valid TIFF image */
int write_TIFF ( FILE *fp, struct TIFF_img *img );

/* This routine allocates a TIFF image.     */
/* height, width, TIFF_type must be defined */
int get_TIFF ( struct TIFF_img *img, int height, 
               int width, char TIFF_type );

/* This routine frees memory allocated for TIFF image */
void free_TIFF ( struct TIFF_img *img );

