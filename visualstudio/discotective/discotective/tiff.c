/* The TIFF writer contained in this code */
/* assumed that the machine on which it   */
/* is running stores numbers with the     */
/* most-significant byte first, i.e., in  */
/* the "big-endian" byte-order.           */

#include  "tiff.h"

struct Rational {
  unsigned long Numer;
  unsigned long Denom;
};

union TIFF_value {		/* don't know the type of the     */
  unsigned char UChar;		/* data value(s) in advance       */
  unsigned short UShort;
  unsigned long ULong;
  struct Rational Rat;

  unsigned char *UCharArray;
  unsigned short *UShortArray;
  unsigned long *ULongArray;
  struct Rational *RatArray;
};

struct TIFF_field {
  unsigned short Tag;			/* tag for TIFF field             */
  unsigned short Type;			/* type for values in field       */
  unsigned long  Count;			/* number of values in field      */
  union TIFF_value Value;		/* the ValueOrOffset word in the  */
					/* field contains the Value       */
					/* instead of pointing to the     */
					/* Value if and only if the Value */
					/* fits into 4 bytes; in this     */
					/* case the value is stored in    */
					/* the lower-numbered bytes;      */
					/* if value does not fit into 4   */
					/* bytes, the entry there is the  */
					/* offset (wrt beginning of file) */
					/* to the value                   */
  int SizeOfType;			/* number of bytes per element of */
					/* the Value                      */
};

struct IFD {
  unsigned short NumberOfFields;	/* number of IFD entries for this */
					/* image                          */
  struct TIFF_field *Fields;		/* this array should have         */
					/* NumberOfFields elements        */
};

struct TIFF_header {
  unsigned short ByteOrder;		/* for interpreting multi-byte    */
					/* numbers                        */
					/* 0x4949 = little-endian         */
					/* 0x4D4D = big-endian            */

  unsigned short FortyTwo;		/* the second word in a TIFF      */
					/* image header is always 42      */

  unsigned long OffsetOfFirstIFD; 	/* offset of first Image File     */
                                        /* Directory (IFD) (wrt beginning */
					/* of file; i.e., in bytes,       */
					/* counting the first byte of     */
					/* the file as number 0)          */
};

struct DataLocation {
  unsigned long StripsPerImage;
  unsigned long rows_per_strip;
  unsigned long *strip_offsets;
  unsigned long *strip_byte_counts;
  unsigned long offset_of_byte_after_data;
  unsigned long bytes_per_row;
};


/* subroutines */
static int FreeIFD ( struct IFD *ifd );
static int FreeFieldValues ( struct TIFF_field *field );
static int WriteHeaderAndIFD ( FILE *fp, struct IFD *ifd,
                               struct TIFF_header *header );
static int WriteIFD ( FILE *fp, struct IFD *ifd,
                      struct TIFF_header *header );
static int WriteField ( FILE *fp, struct TIFF_field *field,
                        unsigned long starting_offset,
                        unsigned long *outside_IFD_offset );
static int WriteValue ( FILE *fp, struct TIFF_field *field,
                        unsigned long *outside_IFD_offset );
static int WriteArrayOfValues ( FILE *fp, struct TIFF_field *field );
static int WriteSingleValue ( FILE *fp, struct TIFF_field *field );
static int WriteHeader ( FILE *fp, struct TIFF_header *header );
static int WriteRational ( FILE *fp, struct Rational *Rat );
static int WriteUnsignedLong ( FILE *fp, unsigned long *UnsignedLong );
static int WriteUnsignedShort ( FILE *fp, unsigned short *UnsignedShort );
static int WriteUnsignedChar ( FILE *fp, unsigned char *UnsignedChar );
static int WriteImageData ( FILE *fp, struct TIFF_img *img,
                            struct DataLocation *DataLoc );
static void FreeStripBuffer ( unsigned char *buffer );
static void AllocateStripBuffer ( unsigned char **buffer,
                                  struct DataLocation *DataLoc,
                                  int width );
static int PutStrip ( FILE *fp, struct TIFF_img *img,
                      struct DataLocation *DataLoc,
                      unsigned char *strip_buf,
                      unsigned long strip_index );
static int PackStrip ( struct TIFF_img *img,
                       struct DataLocation *DataLoc,
                       unsigned char *buffer,
                       unsigned long strip_index );
static int WriteStrip ( FILE *fp, struct DataLocation *DataLoc,
                        unsigned char *strip_buf,
                        unsigned long strip_index );
static int MakeImageDataLocInfo ( struct TIFF_img *img,
                                  struct DataLocation *DataLoc );
static int ComputeStripsPerImage ( int height, struct DataLocation *DataLoc );
static int DetermineRowsPerStrip ( struct TIFF_img *img,
                                   struct DataLocation *DataLoc );
static int DetermineBytesPerRow ( struct TIFF_img *img,
                                  struct DataLocation *DataLoc );
static int PrepareHeaderAndIFD ( struct TIFF_img *img, struct IFD *ifd,
                                 struct TIFF_header *header,
                                 struct DataLocation *DataLoc );
static int PrepareHeader ( struct TIFF_header *header,
                           struct DataLocation *DataLoc );
static int PrepareIFD ( struct TIFF_img *img,
                        struct IFD *ifd,
                        struct DataLocation *DataLoc );
static int AddSpecialFieldEntries ( struct TIFF_img *img,
                                    struct IFD *ifd );
static int AddGrayscaleFields ( struct IFD *ifd, char TIFF_type );
static int AddPaletteColorFields ( struct TIFF_img *img, 
                                   struct IFD *ifd );
static int AddColorFields ( struct IFD *ifd, char TIFF_type );
static int SortFields ( struct IFD *ifd );
static void SwitchFields ( struct TIFF_field *FieldOne,
                           struct TIFF_field *FieldTwo );
static int AddCoreFieldEntries ( struct TIFF_img *img,
                                 struct IFD *ifd,
                                 struct DataLocation *DataLoc );
static int MakeSamplesPerPixelField ( struct IFD *ifd );
static int MakeBitsPerSampleField ( struct IFD *ifd, char TIFF_type );
static int MakeResolutionUnitField ( struct IFD *ifd );
static int MakeResolutionField ( struct IFD *ifd, unsigned short Tag );
static int MakeStripByteCountsField ( struct IFD *ifd,
                                      struct DataLocation *DataLoc );
static int MakeRowsPerStripField ( struct IFD *ifd,
                                   struct DataLocation *DataLoc );
static int MakeStripOffsetsField ( struct IFD *ifd,
                                   struct DataLocation *DataLoc );
static int MakePhotometricInterpretationField ( struct IFD *ifd, char TIFF_type );
static int MakeCompressionField ( struct IFD *ifd, char compress_type );
static int MakeImageWidthOrLengthField ( struct IFD *ifd,
                                         unsigned short Tag,
                                         int dimension );
static int MakeDefaultRowsPerStripField ( struct IFD *ifd );
static int MakeColorMapField ( struct TIFF_img *img,
                               struct IFD *ifd );
static unsigned long GetMaxValUL ( unsigned long *array,
                                   unsigned long n_elements );
static int GetImageData ( FILE *fp, struct TIFF_img *img, struct IFD *ifd );
static int ReadImageData ( FILE *fp, struct TIFF_img *img, struct IFD *ifd );
static int PutColorMapValuesIntoTable ( struct TIFF_img *img, 
                                        struct IFD *ifd );
static void FreeDataLocation ( struct DataLocation *DataLoc );
static int GetStrip ( FILE *fp, struct TIFF_img *img,
                      struct DataLocation *DataLoc,
                      unsigned char *strip_buf,
                      unsigned long strip_index );
static int UnpackStrip ( struct TIFF_img *img,
                         struct DataLocation *DataLoc,
                         unsigned long strip_index,
                         unsigned char *buffer );
static int ReadStrip ( FILE *fp, struct DataLocation *DataLoc,
                       unsigned long strip_index,
                       unsigned char *strip_buf );
static int GetUShortValueFromField ( struct IFD *ifd, unsigned short Tag,
                                     unsigned short *Value );
static int GetImageDataLocInfo ( struct IFD *ifd,
                                 struct DataLocation *DataLoc );
static int GetStripOffsets ( struct IFD *ifd,
                             struct DataLocation *DataLoc );
static int GetStripByteCounts ( struct IFD *ifd,
                                struct DataLocation *DataLoc );
static int PutValuesIntoULongArray ( struct TIFF_field *field,
                                     unsigned long **array,
                                     unsigned long num_elements );
static int GetNumberOfStrips ( struct IFD *ifd,
                               unsigned long *StripsPerImage );
static int GetRowsPerStrip ( struct IFD *ifd,
                             unsigned long *rows_per_strip );
static void WrongValueType ( char *FunctionName, unsigned short Tag,
                             unsigned short Type );
static int AllocateImageDataArray ( struct TIFF_img *img, struct IFD *ifd );
static int AllocateColorMap ( unsigned char ***cmap, struct IFD *ifd );
static int GetHeightAndWidth ( struct IFD *ifd, int *height, int *width );
static int GetCompression ( struct IFD *ifd, char *compress_type );
static int VerifyIFD ( struct IFD *ifd, char *TIFF_type );
static int GetImageType ( struct IFD *ifd, char *TIFF_type );
static int IsImageFullColor ( struct IFD *ifd );
static int IsImagePaletteColor ( struct IFD *ifd );
static int IsImageGrayscale ( struct IFD *ifd );
static struct TIFF_field *GetFieldStructure ( struct IFD *ifd,
                                              unsigned short Tag );
static int CheckForCoreFields ( struct IFD *ifd );
static int WhatAboutCoreField ( struct IFD *ifd, unsigned short Tag );
static int AddDefaultField ( struct IFD *ifd, unsigned short Tag );
static void TellUserACoreFieldIsNecessary ( unsigned short Tag );
static int IsThereADefaultFor ( unsigned short Tag );
static int IsThereAFieldFor ( struct IFD *ifd, unsigned short Tag );
static int ReadIFD ( FILE *fp, struct IFD *ifd,
                     struct TIFF_header *header, char *TIFF_type );
static int SeeIfThereAreOtherIFDs ( FILE *fp, unsigned long OffsetOfIFD,
                                    unsigned short MaxNumberOfFields );
static int SetFilePositionAtFirstByteOfIthField ( FILE *fp,
                                                  unsigned long OffsetOfIFD,
                                                  unsigned short i );
static int CopyFieldIfTagIsRecognized ( FILE *fp, struct IFD *ifd );
static int AllocateAndCopyField ( FILE *fp, struct IFD *ifd,
                                  unsigned short Tag, unsigned short Type );
static int IsTypeExpectedWithTag ( unsigned short Tag, unsigned short Type );
static int IsTypeRecognized ( unsigned short Type );
static int CopyField ( FILE *fp, struct TIFF_field *field,
                       unsigned short Tag, unsigned short Type );
static int GetSizeOfType ( struct TIFF_field *field );
static int CopyValue ( FILE *fp, struct TIFF_field *field );
static int GetArrayOfValues ( FILE *fp, struct TIFF_field *field );
static int GetSingleValue ( FILE *fp, struct TIFF_field *field );
static int AllocateArrayOfValues ( struct TIFF_field *field );
static int CopyCount ( FILE *fp, struct TIFF_field *field );
static int AllocateNewField ( struct IFD *ifd );
static int IsTagRecognized ( unsigned short TempTag );
static int GetRational ( FILE *fp, struct Rational *Rat );
static int GetUnsignedLong ( FILE *fp, unsigned long *UnsignedLong );
static int GetUnsignedShort ( FILE *fp, unsigned short *UnsignedShort );
static int GetUnsignedChar ( FILE *fp, unsigned char *UnsignedChar );
static int GetNumberOfFieldsInInput ( FILE *fp, unsigned long OffsetOfIFD,
                                      unsigned short *NumFieldsInInputFile );
static int SetFilePosition ( FILE *fp, unsigned long position );
static int ReadHeader ( FILE *fp, struct TIFF_header *header );
static int CheckTypeSizes ( void );
static int GetByteOrder ( FILE *fp, struct TIFF_header *header );
static int CheckFortyTwo ( FILE *fp, struct TIFF_header *header );
static int GetOffsetOfFirstIFD ( FILE *fp, struct TIFF_header *header );
/* static void PrintIFD ( struct IFD *ifd );*/
/* static void PrintField ( struct TIFF_field *field );*/
static void *mget_spc(int num,size_t size);
static void **get_img(int wd,int ht,size_t size);
static void free_img(void **pt);

/* TIFF field tags */
#define	ImageWidth 			256	/* width                  */

#define	ImageLength			257	/* length (height)        */

#define	BitsPerSample			258	/* for image data, number */
						/* of bits per component  */
						/* (4 and 8 are the two   */
						/* allowable values for   */
						/* grayscale and          */ 
						/* palette-color)         */
						/* (for full-color RGB,   */
						/* 8 bits per component;  */
						/* so 8,8,8)              */

#define Compression			259	/* data can be stored     */
#define	NoCompression			1	/* uncompressed or        */
#define	PackBits			32773	/* compressed             */
#define	OneDimModifiedHuffman		2	/* (1DModHuff compression */
						/* is not available for   */
						/* grayscale, palette-    */
						/* color, or full RGB     */
						/* color)                 */

#define	PhotometricInterpretation	262	/* differentiates between */
#define	WhiteIsZero			0	/* white-on-black or      */
#define	BlackIsZero			1	/* black-on-white for     */
						/* binary images,         */
#define	RGB				2	/* full-color RGB, and    */
#define	PaletteColor			3	/* palette-color          */

#define	StripOffsets			273	/* for each strip, the    */
						/* byte offset for that   */
						/* strip (wrt beginning   */
						/* of file)               */

#define	SamplesPerPixel			277	/* number of components   */
						/* per pixel; for full-   */
						/* color RGB this must be */
						/* at least 3             */

#define	RowsPerStrip			278	/* number of rows in each */
 						/* strip (except possibly */
						/* the last strip)        */

#define	StripByteCounts			279	/* for each strip, the    */
						/* number of bytes in     */
						/* that strip, after any  */
						/* compression            */

#define	XResolution			282	/* number of pixels per   */
						/* ResolutionUnit (see    */
						/* above) in ImageWidth   */
						/* direction              */

#define	YResolution			283	/* number of pixels per   */
						/* ResolutionUnit (see    */
						/* above) in ImageLength  */
						/* direction              */

#define	ResolutionUnit			296	/* absolute unit of meas. */
#define	NoAbsoluteUnit			1
#define	Inch				2 	/* (this is the default)  */
#define	Centimeter 			3

#define	ColorMap			320	/* color map for palette- */
						/* color images           */
						/* (the count for this    */
						/* field has to be        */
						/* 3*(2^BitsPerSample))   */

/* TIFF field types */
#define BYTE 		1			/* 1-byte unsigned int    */
#define SHORT 		3			/* 2-byte unsigned int    */
#define LONG 		4			/* 4-byte unsigned int    */
#define RATIONAL	5			/* two LONGS:  first is   */
						/* numerator, second is   */
						/* denominator            */

/* TIFF byte-order possibilities */
#define LittleEndian	0x4949
#define BigEndian	0x4d4d

/* other useful defs */
#define	ERROR		1
#define	NO_ERROR	0

#define	NO		0
#define	YES		1

#define HostByteOrder	((charsequence[0] == 1) ? BigEndian : LittleEndian)

#define LongReverse(x) \
        ((unsigned long int)((((unsigned long int)(x) & 0x000000ffU) << 24) | \
                             (((unsigned long int)(x) & 0x0000ff00U) <<  8) | \
                             (((unsigned long int)(x) & 0x00ff0000U) >>  8) | \
                             (((unsigned long int)(x) & 0xff000000U) >> 24)))
#define ShortReverse(x) \
        ((unsigned short int)((((unsigned short int)(x) & 0x00ffU) << 8) | \
                              (((unsigned short int)(x) & 0xff00U) >> 8)))


unsigned long longsequence[1] = {0x01020304u};
unsigned char *charsequence = (unsigned char *) longsequence;
unsigned short FileByteOrder = BigEndian;

int write_TIFF ( FILE *fp, struct TIFF_img *img )
{
  struct IFD ifd;
  struct TIFF_header header;
  struct DataLocation DataLoc;

  /* ensure that each type will be stored */
  /* in the expected number of bytes      */
  if ( CheckTypeSizes ( ) == ERROR ) return ( ERROR );

  /* write image data, store information about */
  /* location of the data in DataLoc structure */
  if ( WriteImageData ( fp, img, &(DataLoc) ) == ERROR ) 
    return ( ERROR );

  /* prepare header and image file directory */
  if ( PrepareHeaderAndIFD ( img, &(ifd), &(header), &(DataLoc) ) 
       == ERROR ) return ( ERROR );

  /* write header and image file directory */
  if ( WriteHeaderAndIFD ( fp, &(ifd), &(header) ) == ERROR ) 
    return ( ERROR );

  /* free arrays in DataLocation and IFD structures */
  FreeDataLocation ( &(DataLoc) );
  if ( FreeIFD ( &(ifd) ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

int get_TIFF ( struct TIFF_img *img, int height, int width , char TIFF_type )
{
  int i;

  /* set height, width, TIFF_type, and compress_type */
  img->height = height;
  img->width = width;
  img->TIFF_type = TIFF_type;
  img->compress_type = 'u';

  /* check image height/width */
  if ( ( img->height <= 0 ) || ( img->width <= 0 ) ) {
    fprintf ( stderr, "tiff.c:  function get_TIFF:\n" );
    fprintf ( stderr, "image height and width must be positive\n" );
    return ( ERROR );
  }

  /* if image is grayscale */
  if ( img->TIFF_type == 'g' ) {
    img->mono = ( unsigned char ** )
                get_img ( img->width, img->height, sizeof ( unsigned char ) );
    return ( NO_ERROR );
  }

  /* if image is palette-color */
  if ( img->TIFF_type == 'p' ) {
    img->mono = ( unsigned char ** )
                get_img ( img->width, img->height, sizeof ( unsigned char ) );
    img->cmap = ( unsigned char ** ) get_img ( 3, 256, sizeof ( unsigned char ) );
    return ( NO_ERROR );
  }

  /* if image is full color */
  if ( img->TIFF_type == 'c' ) {
    img->color = ( unsigned char *** )
                 mget_spc ( 3, sizeof ( unsigned char ** ) );
    for ( i = 0; i < 3; i++ )
      img->color[i] = ( unsigned char ** )
                      get_img ( img->width, img->height,
                                sizeof ( unsigned char ) );
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function get_TIFF:\n" );
  fprintf ( stderr, "allocation for image of type %c is not supported", 
            img->TIFF_type );
  return ( ERROR );
}

void free_TIFF ( struct TIFF_img *img )
{
  int i;

  /* grayscale */
  if ( img->TIFF_type == 'g' ) {
    free_img ( ( void ** ) ( img->mono ) );
  }

  /* palette-color */
  if ( img->TIFF_type == 'p' ) {
    free_img ( ( void ** ) ( img->mono ) );
    free_img ( ( void ** ) ( img->cmap ) );
  }

  /* full color */
  if ( img->TIFF_type == 'c' ) {
    for ( i = 0; i < 3; i++ ) free_img ( ( void ** ) ( img->color[i] ) );
  }
}

static int FreeIFD ( struct IFD *ifd )
{
  unsigned long i;

  /* free array(s) of values */
  for ( i = 0; i < ifd->NumberOfFields; i++ )
    if ( ifd->Fields[i].Count > 1 )
      if ( FreeFieldValues ( &(ifd->Fields[i]) ) == ERROR )
        return ( ERROR );

  /* free IFD fields */
  free ( ( void * ) ifd->Fields );

  return ( NO_ERROR );
}

static int FreeFieldValues ( struct TIFF_field *field )
{
  if ( field->Type == BYTE ) {
    free ( ( void * ) field->Value.UCharArray );
    return ( NO_ERROR );
  }

  if ( field->Type == SHORT ) {
    free ( ( void * ) field->Value.UShortArray );
    return ( NO_ERROR );
  }

  if ( field->Type == LONG ) {
    free ( ( void * ) field->Value.ULongArray );
    return ( NO_ERROR );
  }

  if ( field->Type == RATIONAL ) {
    free ( ( void * ) field->Value.RatArray );
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function FreeFieldValues:\n" );
  fprintf ( stderr, "not prepared to free value array of type %d", 
            field->Type );
  return ( ERROR );
}

static int WriteHeaderAndIFD ( FILE *fp, struct IFD *ifd, 
                               struct TIFF_header *header )
{
  /* write header */
  if ( WriteHeader ( fp, header ) == ERROR ) return ( ERROR );

  /* write IFD */
  if ( WriteIFD ( fp, ifd, header ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int WriteIFD ( FILE *fp, struct IFD *ifd, 
                      struct TIFF_header *header )
{
  unsigned long outside_IFD_offset, i; 
  unsigned long starting_offset, zero;

  /* compute location of first byte after IFD and four  */
  /* bytes of zeros; this number will be maintained as  */
  /* the address at which field values (which don't fit */
  /* into four bytes) should be written                 */
  outside_IFD_offset = header->OffsetOfFirstIFD + 2 +
                       ( unsigned long ) 
                       ( ifd->NumberOfFields * 12 ) + 4;

  /* set file position */
  if ( SetFilePosition ( fp, header->OffsetOfFirstIFD ) 
       == ERROR ) {
    fprintf ( stderr, "tiff.c:  function WriteIFD:\n" );
    fprintf ( stderr, "error setting file position\n" );
    return ( ERROR );
  }

  /* write number of fields */
  if ( WriteUnsignedShort ( fp, &(ifd->NumberOfFields) ) 
       == ERROR ) return ( ERROR );

  /* loop through fields */
  for ( i = 0; i < ifd->NumberOfFields; i++ ) {

    /* compute starting offset for field */
    starting_offset = header->OffsetOfFirstIFD + 2 + (12 * i);

    /* write field */
    if ( WriteField ( fp, &(ifd->Fields[i]), starting_offset,
                      &(outside_IFD_offset) ) == ERROR ) 
      return ( ERROR );

  }

  /* write four bytes of zero to signify that this */
  /* is that last (only) IFD to have been written  */
  zero = 0;
  if ( WriteUnsignedLong ( fp, &(zero) ) == ERROR ) 
    return ( ERROR );

  return ( NO_ERROR );
}

static int WriteField ( FILE *fp, struct TIFF_field *field, 
                        unsigned long starting_offset,
                        unsigned long *outside_IFD_offset )
{
  /* set file position at starting_offset */
  if ( SetFilePosition ( fp, starting_offset ) == ERROR )
    return ( ERROR );

  /* write tag */
  if ( WriteUnsignedShort ( fp, &(field->Tag) ) == ERROR )
    return ( ERROR );

  /* write type */
  if ( WriteUnsignedShort ( fp, &(field->Type) ) == ERROR )
    return ( ERROR );

  /* write Count */
  if ( WriteUnsignedLong ( fp, &(field->Count) ) == ERROR )
    return ( ERROR );

  /* write value if value fits into 4   */
  /* bytes; else write offset to value, */
  /* and go to the offset to write down */
  /* the actual field value(s)          */
  if ( WriteValue ( fp, field, outside_IFD_offset ) == ERROR ) 
    return ( ERROR );

  return ( NO_ERROR );
}

static int WriteValue ( FILE *fp, struct TIFF_field *field,
                        unsigned long *outside_IFD_offset )
{
  /* get size of type */
  if ( GetSizeOfType ( field ) == ERROR ) return ( ERROR );

  /* if value will not fit inside four bytes */
  if ( 4 < field->Count * field->SizeOfType ) {

    /* write offset to place where value(s) will be written */
    if ( WriteUnsignedLong ( fp, outside_IFD_offset ) 
         == ERROR ) return ( ERROR );

    /* set file position where value(s) should be written */
    if ( SetFilePosition ( fp, *outside_IFD_offset ) == ERROR ) {
      fprintf ( stderr, "tiff.c:  function WriteValue:\n" );
      fprintf ( stderr, "error setting file position\n" );
      return ( ERROR );
    }

    /* update *outside_IFD_offset; fix it so that the next */
    /* value written outside the ValueOrOffset (the 4-byte */
    /* field entry in IFD) will begin on a word boundary   */
    *outside_IFD_offset += field->Count * field->SizeOfType;
    if ( ( *outside_IFD_offset % 2 ) != 0 ) 
      *outside_IFD_offset = *outside_IFD_offset + 1;
  
  }

  /* either there is only 1 value or there are multiple values */
  if ( field->Count == 1 ) {
    if ( WriteSingleValue ( fp, field ) == ERROR ) {
      fprintf ( stderr, "cound not write data value ");
      fprintf ( stderr, "for tag number %d\n", field->Tag);
      return ( ERROR );
    }
  }
  else if ( field->Count > 1 ) {
    if ( WriteArrayOfValues ( fp, field ) == ERROR ) {
      fprintf ( stderr, "cound not write data values ");
      fprintf ( stderr, "for tag number %d\n", field->Tag);
      return ( ERROR );
    }
  }
  else {
    fprintf ( stderr, "tiff.c:  function WriteValue:\ncount for " );
    fprintf ( stderr, "field with tag %d is zero\n", field->Tag );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int WriteArrayOfValues ( FILE *fp, struct TIFF_field *field )
{
  unsigned long int i;

  if ( field->Type == BYTE ) {
    for ( i = 0; i < field->Count; i++ )
      if ( WriteUnsignedChar ( fp, &(field->Value.UCharArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == SHORT ) {
    for ( i = 0; i < field->Count; i++ )
      if ( WriteUnsignedShort ( fp, &(field->Value.UShortArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == LONG ) {
    for ( i = 0; i < field->Count; i++ )
      if ( WriteUnsignedLong ( fp, &(field->Value.ULongArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == RATIONAL ) {
    for ( i = 0; i < field->Count; i++ )
      if ( WriteRational ( fp, &(field->Value.RatArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function WriteArrayOfValues:\n" );
  fprintf ( stderr, "writer not prepared to write values of\n" );
  fprintf ( stderr, "type %d\n", field->Type );
  return ( ERROR );
}

static int WriteSingleValue ( FILE *fp, struct TIFF_field *field )
{
  if ( field->Type == BYTE ) {
    if ( WriteUnsignedChar ( fp, &(field->Value.UChar) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == SHORT ) {
    if ( WriteUnsignedShort ( fp, &(field->Value.UShort) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == LONG ) {
    if ( WriteUnsignedLong ( fp, &(field->Value.ULong) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == RATIONAL ) {
    if ( WriteRational ( fp, &(field->Value.Rat) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function WriteSingleValue:\n" );
  fprintf ( stderr, "writer not prepared to write value of\n" );
  fprintf ( stderr, "type %d\n", field->Type );
  return ( ERROR );
}

static int WriteHeader ( FILE *fp, struct TIFF_header *header )
{
  /* set file position at beginning of file */
  if ( SetFilePosition ( fp, 0 ) == ERROR ) return ( ERROR );

  /* write byte-order word */
  if ( WriteUnsignedShort ( fp, &(header->ByteOrder) ) == ERROR )
    return ( ERROR );

  /* write forty-two */
  if ( WriteUnsignedShort ( fp, &(header->FortyTwo) ) == ERROR )
    return ( ERROR );

  /* write offset of first IFD */
  if ( WriteUnsignedLong ( fp, &(header->OffsetOfFirstIFD) ) 
       == ERROR )
    return ( ERROR );

  return ( NO_ERROR );
}

static int WriteRational ( FILE *fp, struct Rational *Rat )
{
  unsigned long numerator, denumerator;

  if (HostByteOrder == BigEndian) {
    numerator   = Rat->Numer;
    denumerator = Rat->Denom;
  } else {
    numerator   = LongReverse(Rat->Numer);
    denumerator = LongReverse(Rat->Denom);
  }

  if ( ( 1 != fwrite ( &numerator,
                       sizeof ( unsigned long ), 1, fp ) ) ||
       ( 1 != fwrite ( &denumerator,
                       sizeof ( unsigned long ), 1, fp ) ) ) {
    fprintf ( stderr,"error writing rational number\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int WriteUnsignedLong ( FILE *fp, unsigned long *UnsignedLong )
{
  unsigned long unsignedlong;

  if (HostByteOrder == BigEndian)
    unsignedlong = *UnsignedLong;
  else
    unsignedlong = LongReverse(*UnsignedLong);

  if ( 1 != fwrite ( ( unsigned long * ) &unsignedlong,
                     sizeof ( unsigned long ), 1, fp ) ) {
    fprintf ( stderr,"error writing unsigned long\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int WriteUnsignedShort ( FILE *fp, unsigned short *UnsignedShort )
{
  unsigned short unsignedshort;

  if (HostByteOrder == BigEndian)
    unsignedshort = *UnsignedShort;
  else
    unsignedshort = ShortReverse(*UnsignedShort);

  if ( 1 != fwrite ( ( unsigned short * ) &unsignedshort,
                     sizeof ( unsigned short ), 1, fp ) ) {
    fprintf ( stderr,"error writing unsigned short\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int WriteUnsignedChar ( FILE *fp, unsigned char *UnsignedChar )
{
  if ( 1 != fwrite ( ( unsigned char * ) UnsignedChar,
                     sizeof ( unsigned char ), 1, fp ) ) {
    fprintf ( stderr,"error writing unsigned char\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int WriteImageData ( FILE *fp, struct TIFF_img *img,
                            struct DataLocation *DataLoc )
{
  unsigned char *strip_buf;
  unsigned long strip_index;

  /* precompute rows per strip, bytes per row, and the number    */
  /* of strips; allocate space for the arrays (strip_offsets and */
  /* strip_byte_count) in the DataLocation structure             */
  if ( MakeImageDataLocInfo ( img, DataLoc ) == ERROR )
    return ( ERROR );

  AllocateStripBuffer ( &(strip_buf), DataLoc, img->width );

  /* write down one strip at a time */
  for ( strip_index = 0; strip_index < DataLoc->StripsPerImage; strip_index++ ) 
    if ( PutStrip ( fp, img, DataLoc, strip_buf, strip_index ) == ERROR )
      return ( ERROR );

  FreeStripBuffer ( strip_buf );

  return ( NO_ERROR );
}

static void FreeStripBuffer ( unsigned char *buffer )
{
  free ( ( void * ) buffer );
}

static void AllocateStripBuffer ( unsigned char **buffer, 
                                  struct DataLocation *DataLoc,
                                  int width )
{
  unsigned long upper_bd_on_bytes_in_one_strip;

  /* compute an upper bound on the number of bytes */
  /* for one strip of image data; this is computed */
  /* as twice the number of bytes in a strip of    */
  /* uncompressed color data                       */
  upper_bd_on_bytes_in_one_strip =
    ( unsigned long ) ( 2 * DataLoc->rows_per_strip * 3 * width );

  /* allocate temporary space for a strip of image data */
  *buffer = ( unsigned char * )
            mget_spc ( ( int ) upper_bd_on_bytes_in_one_strip,
                       sizeof ( unsigned char ) );
}

static int PutStrip ( FILE *fp, struct TIFF_img *img, 
                      struct DataLocation *DataLoc, 
                      unsigned char *strip_buf,
                      unsigned long strip_index ) 
{
  if ( img->compress_type == 'u' ) {
    if ( PackStrip ( img, DataLoc, strip_buf, strip_index ) == ERROR ) 
      return ( ERROR );
  }
  else {
    fprintf ( stderr, "tiff.c:  function PutStrip:\n" );
    fprintf ( stderr, "TIFF writer not prepared to compress data\n" );
    fprintf ( stderr, "with compress_type %c\n", img->compress_type );
    return ( ERROR );
  }

  if ( WriteStrip ( fp, DataLoc, strip_buf, strip_index ) == ERROR ) 
    return ( ERROR );

  return ( NO_ERROR );
}

static int PackStrip ( struct TIFF_img *img,
                       struct DataLocation *DataLoc,
                       unsigned char *buffer,
                       unsigned long strip_index )
{
  unsigned long i, first_row, bytes_packed, current_row;
  int j;

  /* compute index of first row for this strip */
  first_row = strip_index * DataLoc->rows_per_strip;

  bytes_packed = 0;
  for ( i = 0; i < DataLoc->rows_per_strip; i++ ) {

    current_row = first_row + i;

    if ( current_row < ( unsigned long ) img->height ) 
      for ( j = 0; j < img->width; j++ ) {
        if ( ( img->TIFF_type == 'g' ) || ( img->TIFF_type == 'p' ) )
          buffer[bytes_packed++] = img->mono[current_row][j];
        else if ( img->TIFF_type == 'c' ) {
          buffer[bytes_packed++] = img->color[0][current_row][j];
          buffer[bytes_packed++] = img->color[1][current_row][j];
          buffer[bytes_packed++] = img->color[2][current_row][j];
        }
        else {
          fprintf ( stderr, "tiff.c:  function PackStrip:\n" );
          fprintf ( stderr, "tiff reader not prepared to pack data\n" );
          fprintf ( stderr, "for image of TIFF type %c\n", img->TIFF_type );
          return ( ERROR );
        }
      }

  }

  DataLoc->strip_byte_counts[strip_index] = bytes_packed;

  return ( NO_ERROR );
}

static int WriteStrip ( FILE *fp, struct DataLocation *DataLoc,
                        unsigned char *strip_buf, 
                        unsigned long strip_index )
{
  static unsigned long strip_offset;

  /* first strip should begin on the eighth byte of */
  /* the image file (right after the image header)  */
  if ( strip_index == 0 ) strip_offset = 8;

  /* record offset for strip */
  DataLoc->strip_offsets[strip_index] = strip_offset;

  /* set file-position at desired location of first byte of strip */
  if ( SetFilePosition ( fp, DataLoc->strip_offsets[strip_index] )
       == ERROR ) return ( ERROR );

  /* write strip of data */
  if ( DataLoc->strip_byte_counts[strip_index] !=
       fwrite ( ( unsigned char * ) strip_buf, sizeof ( unsigned char ),
                ( size_t ) DataLoc->strip_byte_counts[strip_index], fp ) ) {
    fprintf ( stderr, "tiff.c:  function WriteStrip:\n" );
    fprintf ( stderr, "error writing strip number %ld\n", strip_index );
    return ( ERROR );
  }

  /* update strip_offset number */
  strip_offset += DataLoc->strip_byte_counts[strip_index];

  /* store the offset of the byte after the data (this may be the */
  /* offset of the IFD, but remember that the IFD has to begin on */
  /* a word boundary - this is checked in PrepareHeader)          */
  DataLoc->offset_of_byte_after_data = strip_offset;

  return ( NO_ERROR );
}

static int MakeImageDataLocInfo ( struct TIFF_img *img, 
                                  struct DataLocation *DataLoc )
{
  /* compute number of rows per strip so that there */
  /* are around 8000 bytes of data in each strip    */
  if ( DetermineRowsPerStrip ( img, DataLoc ) == ERROR ) return ( ERROR );

  /* compute number of strips necessary for    */
  /* storing image, store in DataLoc structure */
  if ( ComputeStripsPerImage ( img->height, DataLoc ) == ERROR )
    return ( ERROR );

  /* allocate arrays for DataLoc structure */
  DataLoc->strip_byte_counts = ( unsigned long * ) 
                               mget_spc ( ( int ) DataLoc->StripsPerImage,
                                          sizeof ( unsigned long ) );
  DataLoc->strip_offsets = ( unsigned long * ) 
                           mget_spc ( ( int ) DataLoc->StripsPerImage,
                                      sizeof ( unsigned long ) );

  return ( NO_ERROR );
}

static int ComputeStripsPerImage ( int height, struct DataLocation *DataLoc )
{
  unsigned long ULheight;

  if ( height <= 0 ) {
    fprintf ( stderr, "tiff.c:  function ComputeStripsPerImage:\n" );
    fprintf ( stderr, "height entry in TIFF image structure\n" );
    fprintf ( stderr, "claims that image height is not positive\n" );
    return ( ERROR );
  }

  ULheight = ( unsigned long ) height;

  if ( ( ULheight % DataLoc->rows_per_strip ) == 0 )
    DataLoc->StripsPerImage = ULheight / DataLoc->rows_per_strip;
  else 
    DataLoc->StripsPerImage = 1 + ( unsigned long ) 
                                  ( height / DataLoc->rows_per_strip );

  return ( NO_ERROR );
}

static int DetermineRowsPerStrip ( struct TIFF_img *img,
                                   struct DataLocation *DataLoc )
{
  unsigned long byte_count;

  /**********************************************/
  /* determine bytes per row before compression */
  /* MAY WANT TO CHANGE THIS WHEN A COMPRESSION */
  /* SCHEME IS ADDED                            */
  /**********************************************/
  if ( DetermineBytesPerRow ( img, DataLoc ) == ERROR ) return ( ERROR );

  /* compute rows_per_strip so that each strip will take up */
  /* about 8K of memory (cf. TIFF specification document);  */
  /* this number may be as low as 1 (for wide images) but   */
  /* not greater than the image height                      */
  DataLoc->rows_per_strip = 1;
  byte_count = DataLoc->bytes_per_row;
  while ( byte_count < 8000 ) {
    byte_count += DataLoc->bytes_per_row;
    DataLoc->rows_per_strip++;
  }

  if ( DataLoc->rows_per_strip > ( (unsigned long) img->height ) ) 
    DataLoc->rows_per_strip = (unsigned long) img->height;

  return ( NO_ERROR );
}

static int DetermineBytesPerRow ( struct TIFF_img *img,
                                  struct DataLocation *DataLoc )
{
  /* grayscale image data:  1 byte per pixel     */
  /* palette-color image data:  1 byte per pixel */
  /* full-color image data:  3 bytes per pixel   */

  if ( ( img->TIFF_type == 'g' ) || ( img->TIFF_type == 'p' ) ) {
    DataLoc->bytes_per_row = ( unsigned long ) ( img->width );
  }
  else if ( img->TIFF_type == 'c' ) {
    DataLoc->bytes_per_row = ( unsigned long ) ( 3 * img->width );
  }
  else {
    fprintf ( stderr, "tiff.c:  function DetermineBytesPerRow:\n" );
    fprintf ( stderr, "writer is not prepared to compute bytes_per_row\n" );
    fprintf ( stderr, "for image of TIFF_type '%c'\n", img->TIFF_type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int PrepareHeaderAndIFD ( struct TIFF_img *img, struct IFD *ifd,
                                 struct TIFF_header *header,
                                 struct DataLocation *DataLoc )
{
  /* prepare header */
  if ( PrepareHeader ( header, DataLoc ) == ERROR ) return ( ERROR );

  /* prepare IFD */
  if ( PrepareIFD ( img, ifd, DataLoc ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int PrepareHeader ( struct TIFF_header *header,
                           struct DataLocation *DataLoc )
{

  /********************************/
  /* This may have to be changed  */
  /* when the code is modified so */
  /* that it figures out          */
  /* byte-order details by itself */
  /********************************/

  /* put in byte-order word */
  header->ByteOrder = BigEndian;

  /* put in forty-two byte */
  header->FortyTwo = 42;

  /* compute offset to first byte of IFD; IFD */
  /* should be written right after image data */
  if ( DataLoc->offset_of_byte_after_data < 8 ) {
    fprintf ( stderr, "tiff.c:  function PrepareHeader:\ninvalid" );
    fprintf ( stderr, " entry for offset of IFD\n" );
    return ( ERROR ); 
  }
  header->OffsetOfFirstIFD = DataLoc->offset_of_byte_after_data;

  /* IFD should begin on a word boundary */
  if ( ( header->OffsetOfFirstIFD % 2 ) != 0 )
    header->OffsetOfFirstIFD++;

  return ( NO_ERROR );
}

static int PrepareIFD ( struct TIFF_img *img, 
                        struct IFD *ifd,
                        struct DataLocation *DataLoc )
{
  /* initialize IFD structure */
  ifd->NumberOfFields = 0;
  ifd->Fields = NULL;

  /* add field entries to IFD structure */
  if ( AddCoreFieldEntries ( img, ifd, DataLoc ) == ERROR ) 
    return ( ERROR );

  /* add fields which are required */
  /* for this specific image type  */
  if ( AddSpecialFieldEntries ( img, ifd ) == ERROR ) 
    return ( ERROR );

  /* sort fields into ascending order of tag value */
  if ( SortFields ( ifd ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int AddSpecialFieldEntries ( struct TIFF_img *img, 
                                    struct IFD *ifd )
{
  /* for grayscale image */
  if ( img->TIFF_type == 'g' ) 
    return ( AddGrayscaleFields ( ifd, img->TIFF_type ) );

  /* for palette-color image */
  if ( img->TIFF_type == 'p' ) 
    return ( AddPaletteColorFields ( img, ifd ) );

  /* for color image */
  if ( img->TIFF_type == 'c' ) 
    return ( AddColorFields ( ifd, img->TIFF_type ) );

  fprintf ( stderr, "tiff.c:  function AddSpecialFieldEntries:\n" );
  fprintf ( stderr, "writer is not prepared to add specialized\n" );
  fprintf ( stderr, "field entry for image of type %c\n", 
            img->TIFF_type );
  return ( ERROR );
}

static int AddGrayscaleFields ( struct IFD *ifd, char TIFF_type )
{
  /* add MakeBitsPerSample field */
  if ( MakeBitsPerSampleField ( ifd, TIFF_type ) == ERROR ) 
    return ( ERROR );

  return ( NO_ERROR );
}

static int AddPaletteColorFields ( struct TIFF_img *img,  
                                   struct IFD *ifd )
{
  /* add BitsPerSample field */
  if ( MakeBitsPerSampleField ( ifd, img->TIFF_type ) == ERROR ) 
    return ( ERROR );

  /* add ColorMap field */
  if ( MakeColorMapField ( img, ifd ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int AddColorFields ( struct IFD *ifd, char TIFF_type )
{
  /* add MakeBitsPerSample field */
  if ( MakeBitsPerSampleField ( ifd, TIFF_type ) == ERROR ) 
    return ( ERROR );

  /* add SamplesPerPixel field */
  if ( MakeSamplesPerPixelField ( ifd ) == ERROR ) 
    return ( ERROR );

  return ( NO_ERROR );
}

static int SortFields ( struct IFD *ifd )
{
  unsigned short i, j, min_tag_index;

  /* for i = 0, ..., ifd->NOF-2, go through fields */
  /* j = i+1, ..., ifd->NOF - 1; find the j for    */
  /* which the tag value is lowest (among j's); if */
  /* this tag value is lower than tag of ith       */
  /* field, than switch the two fields             */

  for ( i = 0; i < ifd->NumberOfFields - 1; i++ ) {

    min_tag_index = i;

    for ( j = i + 1; j < ifd->NumberOfFields; j++ )
      if ( ifd->Fields[j].Tag < ifd->Fields[min_tag_index].Tag )
        min_tag_index = j;

    if ( min_tag_index != i ) 
      SwitchFields ( &(ifd->Fields[i]), 
                     &(ifd->Fields[min_tag_index]) );

  }

  return ( NO_ERROR );
}

static void SwitchFields ( struct TIFF_field *FieldOne, 
                           struct TIFF_field *FieldTwo ) 
{
  struct TIFF_field temp;

  temp = *FieldOne;
  *FieldOne = *FieldTwo;
  *FieldTwo = temp;
}

static int AddCoreFieldEntries ( struct TIFF_img *img,
                                 struct IFD *ifd,
                                 struct DataLocation *DataLoc )
{
  /* add ImageWidth field */
  if ( MakeImageWidthOrLengthField ( ifd, ImageWidth, img->width ) 
       == ERROR ) return ( ERROR );

  /* add ImageLength field */
  if ( MakeImageWidthOrLengthField ( ifd, ImageLength, img->height ) 
       == ERROR ) return ( ERROR );

  /* add Compression field */
  if ( MakeCompressionField ( ifd, img->compress_type ) == ERROR ) 
    return ( ERROR );

  /* add PhotometricInterpretation field */
  if ( MakePhotometricInterpretationField ( ifd, img->TIFF_type ) 
       == ERROR ) return ( ERROR );

  /* add StripOffsets field */
  if ( MakeStripOffsetsField ( ifd, DataLoc ) == ERROR )
    return ( ERROR );

  /* add RowsPerStrip field */
  if ( MakeRowsPerStripField ( ifd, DataLoc ) == ERROR )
    return ( ERROR );

  /* add StripByteCounts field */
  if ( MakeStripByteCountsField ( ifd, DataLoc ) == ERROR )
    return ( ERROR );

  /* add XResolution field */
  if ( MakeResolutionField ( ifd, XResolution ) == ERROR )
    return ( ERROR );

  /* add YResolution field */
  if ( MakeResolutionField ( ifd, YResolution ) == ERROR )
    return ( ERROR );

  /* add ResolutionUnit field */
  if ( MakeResolutionUnitField ( ifd ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int MakeSamplesPerPixelField ( struct IFD *ifd )
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = SamplesPerPixel;
  field->Type = SHORT;
  field->Count = 1;
  field->Value.UShort = 3;

  return ( NO_ERROR );
}

static int MakeBitsPerSampleField ( struct IFD *ifd, char TIFF_type )
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = BitsPerSample;
  field->Type = SHORT;
 
  /* if image is grayscale or palette-color */
  if ( ( TIFF_type == 'g' ) || ( TIFF_type == 'p' ) ) {
    field->Count = 1;
    field->Value.UShort = 8;
    return ( NO_ERROR );
  }

  /* if image is color */
  if ( TIFF_type == 'c' ) {
    field->Count = 3;

    /* allocate array of values */
    if ( AllocateArrayOfValues ( field ) == ERROR ) {
      fprintf ( stderr, "tiff.c:  function MakeBitsPerSample" );
      fprintf ( stderr, "Field:\ncouldn't alloc values for field\n" );
      return ( ERROR );
    }

    field->Value.UShortArray[0] = 8;
    field->Value.UShortArray[1] = 8;
    field->Value.UShortArray[2] = 8;
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function MakeBitsPerSampleField:\n" );
  fprintf ( stderr, "writer not prepared to write field value(s)\n" );
  fprintf ( stderr, "for BitsPerSample field for image of type %c\n", 
            TIFF_type );
  return ( ERROR );
}

static int MakeResolutionUnitField ( struct IFD *ifd )
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;
 
  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  /* put in default values */
  field->Tag = ResolutionUnit;
  field->Type = SHORT;
  field->Count = 1;
  field->Value.UShort = Inch;

  return ( NO_ERROR );
}

static int MakeResolutionField ( struct IFD *ifd, unsigned short Tag ) 
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  /* assign output-image resolution to be 100 dpi */
  field->Tag = Tag;
  field->Type = RATIONAL;
  field->Count = 1;
  field->Value.Rat.Numer = 100;
  field->Value.Rat.Denom = 1;

  return ( NO_ERROR );
}

static int MakeStripByteCountsField ( struct IFD *ifd,
                                      struct DataLocation *DataLoc )
{
  struct TIFF_field *field;
  unsigned long max_bytes_in_one_strip, i;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = StripByteCounts;
  field->Count = DataLoc->StripsPerImage;

  max_bytes_in_one_strip = 
    GetMaxValUL ( DataLoc->strip_byte_counts, DataLoc->StripsPerImage );

  /* number of strip offsets should fit into LONG or SHORT */
  if ( max_bytes_in_one_strip < 65536 ) {
    field->Type = SHORT;

    if ( field->Count == 1 )
      field->Value.UShort = ( unsigned short ) 
                            DataLoc->strip_byte_counts[0];
    else {
      if ( AllocateArrayOfValues ( field ) == ERROR ) return ( ERROR );
      for ( i = 0; i < field->Count; i++ )
        field->Value.UShortArray[i] =
          ( unsigned short ) DataLoc->strip_byte_counts[i];
    }
  }
  else {
    field->Type = LONG;

    if ( field->Count == 1 ) 
      field->Value.ULong = DataLoc->strip_byte_counts[0];
    else {
      if ( AllocateArrayOfValues ( field ) == ERROR ) return ( ERROR );
      for ( i = 0; i < field->Count; i++ )
        field->Value.ULongArray[i] = DataLoc->strip_byte_counts[i];
    }
  }

  return ( NO_ERROR );
}

static int MakeRowsPerStripField ( struct IFD *ifd,
                                   struct DataLocation *DataLoc )
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = RowsPerStrip;
  field->Count = 1;

  /* number of RowsPerStrip should fit into LONG or SHORT */
  if ( DataLoc->rows_per_strip == 0 ) {
    fprintf ( stderr, "tiff.c:  function MakeRowsPerStripField:\n" );
    fprintf ( stderr, "element in DataLocation structure claims\n" );
    fprintf ( stderr, "that the number of RowsPerStrip is zero\n" );
    return ( ERROR );
  }
  if ( DataLoc->rows_per_strip < 65536 ) {
    field->Type = SHORT;
    field->Value.UShort = ( unsigned short ) DataLoc->rows_per_strip;
  }
  else {
    field->Type = LONG;
    field->Value.ULong = DataLoc->rows_per_strip;
  }

  return ( NO_ERROR );
}

static int MakeStripOffsetsField ( struct IFD *ifd, 
                                   struct DataLocation *DataLoc )
{
  struct TIFF_field *field;
  unsigned long i;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = StripOffsets;
  field->Type = LONG;
  field->Count = DataLoc->StripsPerImage;

  /* number of strip offsets should not be zero */
  if ( field->Count == 1 ) 
    field->Value.ULong = DataLoc->strip_offsets[0];
  else if ( field->Count > 1 ) {
    if ( AllocateArrayOfValues ( field ) == ERROR ) return ( ERROR );
    for ( i= 0; i < field->Count; i++ )
      field->Value.ULongArray[i] = DataLoc->strip_offsets[i];
  }
  else {
    fprintf ( stderr, "tiff.c:  function MakeStripOffsets" );
    fprintf ( stderr, "Field:\nelement in DataLocation structure " );
    fprintf ( stderr, "claims that\nthe number of strips " );
    fprintf ( stderr, "which were written out is zero\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int MakePhotometricInterpretationField ( struct IFD *ifd, char TIFF_type )
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = PhotometricInterpretation;
  field->Type = SHORT;
  field->Count = 1;

  if ( TIFF_type == 'g' ) field->Value.UShort = BlackIsZero;
  else if ( TIFF_type == 'p' ) field->Value.UShort = PaletteColor;
  else if ( TIFF_type == 'c' ) field->Value.UShort = RGB;
  else {
    fprintf ( stderr, "tiff.c:  function MakePhotometricInterpretation" );
    fprintf ( stderr, "Field:\ndesired image type " );
    fprintf ( stderr, "(TIFF_type '%c') not supported by writer\n",
              TIFF_type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int MakeCompressionField ( struct IFD *ifd, char compress_type )
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = Compression;
  field->Type = SHORT;
  field->Count = 1;

  if ( compress_type == 'u' ) field->Value.UShort = NoCompression;
  else {
    fprintf ( stderr, "tiff.c:  function MakeCompressionField:\n" );
    fprintf ( stderr, "desired compression scheme " );
    fprintf ( stderr, "(compress_type '%c') not supported by writer\n",
              compress_type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int MakeImageWidthOrLengthField ( struct IFD *ifd, 
                                         unsigned short Tag,
                                         int dimension )
{
  struct TIFF_field *field;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);


  field->Tag = Tag;
  field->Count = 1;

  /* dimension should not be too low */
  if ( dimension < 1 ) {
    fprintf ( stderr, "tiff.c:  function MakeImageWidthOrLength" );
    fprintf ( stderr, "Field:\nimage dimension is less than 1\n" );
    return ( ERROR );
  }

  /* dimension should fit into a SHORT or a LONG */
  if ( dimension < 65536 ) {
    field->Type = SHORT;
    field->Value.UShort = ( unsigned short ) dimension;
  }
  else {
    field->Type = LONG;
    field->Value.ULong = ( unsigned long ) dimension;
  }

  return ( NO_ERROR );
}

static int MakeDefaultRowsPerStripField ( struct IFD *ifd )
{
  int height, width;
  struct TIFF_field *field;

  /* get image height; this is the default RowsPerStrip */
  if ( GetHeightAndWidth ( ifd, &(height), &(width) ) == ERROR ) 
    return ( ERROR );

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  /* put in default values */
  field->Tag = RowsPerStrip;
  field->Count = 1;

  /* height should fit into a SHORT or a LONG */
  if ( height < 65536 ) {
    field->Type = SHORT;
    field->Value.UShort = ( unsigned short ) height;
  }
  else {
    field->Type = LONG;
    field->Value.ULong = ( unsigned long ) height;
  }

  return ( NO_ERROR );
}

static int MakeColorMapField ( struct TIFF_img *img,
                               struct IFD *ifd )
{
  struct TIFF_field *field;
  unsigned long cmap_length, i, j;
  unsigned short s;
  unsigned char *first_byte, *second_byte;

  cmap_length = 256;

  /* increment NumberOfFields in IFD struct */
  ifd->NumberOfFields++;

  /* allocate field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );
  field = &(ifd->Fields[ifd->NumberOfFields - 1]);

  field->Tag = ColorMap;
  field->Type = SHORT;
  field->Count = 3 * cmap_length;

  /* allocate array for values of colormap */
  if ( AllocateArrayOfValues ( field ) == ERROR ) return ( ERROR );

  /* put the same colormap entry in both bytes of s */
  first_byte = ( unsigned char * ) ( &(s) );
  second_byte = 1 + ( unsigned char * ) ( &(s) );

  /* write in following order:  red val's, */
  /* then green val's, then blue val's     */
  for ( i = 0; i < cmap_length; i++ ) 
    for ( j = 0; j < 3; j++ ) {
      *first_byte = img->cmap[i][j];
      *second_byte = img->cmap[i][j];
      field->Value.UShortArray[i + (j * cmap_length)] = s;
    }
  
  return ( NO_ERROR );
}

static unsigned long GetMaxValUL ( unsigned long *array, 
                                   unsigned long n_elements )
{
  unsigned long i, max_index;

  max_index = 0;
  for ( i = 1; i < n_elements; i++ )
    if ( array[max_index] < array[i] )
      max_index = i;

  return ( array[max_index] );
}

int read_TIFF ( FILE *fp, struct TIFF_img *img )
{
  struct IFD ifd;
  struct TIFF_header header;

  /* ensure that each type will be stored */
  /* in the expected number of bytes      */
  if ( CheckTypeSizes ( ) == ERROR ) return ( ERROR );

//  printf("checktype");

  /* read header */
  if ( ReadHeader ( fp, &(header) ) == ERROR ) return ( ERROR );

  /* read image file directory; also infer the */
  /* "TIFF_type" of the image from the IFD     */
  if ( ReadIFD ( fp, &(ifd), &(header), &(img->TIFF_type) ) == ERROR ) 
    return ( ERROR );

  /* read image data */
  if ( GetImageData ( fp, img, &(ifd) ) == ERROR ) return ( ERROR );

  /* free arrays in IFD structure */
  if ( FreeIFD ( &(ifd) ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int GetImageData ( FILE *fp, struct TIFF_img *img, struct IFD *ifd )
{
  /* ensure compression scheme is recognized; */
  /* if it is, record compress_type           */
  if ( GetCompression ( ifd, &(img->compress_type) ) == ERROR ) 
    return ( ERROR );

  /* record image height and width */
  if ( GetHeightAndWidth ( ifd, &(img->height), &(img->width) ) 
       == ERROR ) return ( ERROR );

  /* allocate array for image data */
  if ( AllocateImageDataArray ( img, ifd ) == ERROR ) return ( ERROR );

  /* copy image data into the array */
  if ( ReadImageData ( fp, img, ifd ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int ReadImageData ( FILE *fp, struct TIFF_img *img, struct IFD *ifd )
{
  struct DataLocation DataLoc;
  unsigned char *strip_buf;
  unsigned long i;

  /* if palette-color image, convert color-map  */
  /* field values to unsigned char's, and stuff */
  /* them into the format of a 2-d lookup table */
  if ( img->TIFF_type == 'p' )
    if ( PutColorMapValuesIntoTable ( img, ifd ) == ERROR )
      return ( ERROR );

  /* get information about location(s) of data strip(s) */
  if ( GetImageDataLocInfo ( ifd, &(DataLoc) ) == ERROR ) return ( ERROR );

  AllocateStripBuffer ( &(strip_buf), &(DataLoc), img->width );

  /* read in one strip at a time */
  for ( i = 0; i < DataLoc.StripsPerImage; i++ )
    if ( GetStrip ( fp, img, &(DataLoc), strip_buf, i ) == ERROR )
      return ( ERROR );

  FreeStripBuffer ( strip_buf );
  FreeDataLocation ( &(DataLoc) );

  return ( NO_ERROR );
}

static int PutColorMapValuesIntoTable ( struct TIFF_img *img, 
                                        struct IFD *ifd )
{
  struct TIFF_field *field;
  unsigned long cmap_length, i;
  unsigned char *cp;

  /* get pointer to ColorMap field */
  if ( ( field = GetFieldStructure ( ifd, ColorMap ) ) == NULL )
    return ( ERROR );

  cmap_length = field->Count / 3;

  /********************************/
  /* This may have to be changed  */
  /* when the code is modified so */
  /* that it figures out          */
  /* byte-order details by itself */
  /********************************/

  /* convert ColorMap field values to unsigned */
  /* char's by taking most significant byte    */
  for ( i = 0; i < cmap_length; i++ ) {

    /* red entry */
    cp = ( unsigned char * ) 
         ( &(field->Value.UShortArray[i]) );
    img->cmap[i][0] = *cp;

    /* green entry */
    cp = ( unsigned char * ) 
         ( &(field->Value.UShortArray[i+cmap_length]) );
    img->cmap[i][1] = *cp;

    /* blue entry */
    cp = ( unsigned char * ) 
         ( &(field->Value.UShortArray[i+cmap_length+cmap_length]) );
    img->cmap[i][2] = *cp;

  }

  return ( NO_ERROR );
}

static void FreeDataLocation ( struct DataLocation *DataLoc )
{
  free ( ( void * ) DataLoc->strip_offsets );
  free ( ( void * ) DataLoc->strip_byte_counts );
}

static int GetStrip ( FILE *fp, struct TIFF_img *img, 
                      struct DataLocation *DataLoc,
                      unsigned char *strip_buf,
                      unsigned long strip_index )
{
  if ( ReadStrip ( fp, DataLoc, strip_index, strip_buf ) == ERROR ) 
    return ( ERROR );

  if ( img->compress_type == 'u' ) {
    if ( UnpackStrip ( img, DataLoc, strip_index, strip_buf ) == ERROR )
      return ( ERROR );
  }
  else {
    fprintf ( stderr, "tiff.c:  function GetStrip:\n" );
    fprintf ( stderr, "TIFF reader not prepared to decompress data\n" );
    fprintf ( stderr, "stored with compress_type %c\n", img->compress_type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int UnpackStrip ( struct TIFF_img *img, 
                         struct DataLocation *DataLoc,
                         unsigned long strip_index, 
                         unsigned char *buffer )
{
  unsigned long i, first_row, bytes_unpacked, current_row;
  int j;
 
  /* compute index of first row for this strip */
  first_row = strip_index * DataLoc->rows_per_strip;

  bytes_unpacked = 0; 
  for ( i = 0; i < DataLoc->rows_per_strip; i++ )
    if ( bytes_unpacked < DataLoc->strip_byte_counts[strip_index] ) {

      current_row = first_row + i;

      for ( j = 0; j < img->width; j++ ) {
        if ( ( img->TIFF_type == 'g' ) || ( img->TIFF_type == 'p' ) )
          img->mono[current_row][j] = buffer[bytes_unpacked++];
        else if ( img->TIFF_type == 'c' ) {
          img->color[0][current_row][j] = buffer[bytes_unpacked++];
          img->color[1][current_row][j] = buffer[bytes_unpacked++];
          img->color[2][current_row][j] = buffer[bytes_unpacked++];
        }
        else {
          fprintf ( stderr, "tiff.c:  function UnpackStrip:\n" );
          fprintf ( stderr, "tiff reader not prepared to unpack data\n" );
          fprintf ( stderr, "for image of TIFF type %c\n", img->TIFF_type );
          return ( ERROR );
        }
      }

    }

  return ( NO_ERROR );
}

static int ReadStrip ( FILE *fp, struct DataLocation *DataLoc,
                       unsigned long strip_index, 
                       unsigned char *strip_buf )
{
  /* set file-position at first byte of strip */
  if ( SetFilePosition ( fp, DataLoc->strip_offsets[strip_index] )
       == ERROR ) return ( ERROR );

  /* read strip data into buffer */
  if ( DataLoc->strip_byte_counts[strip_index] !=
       fread ( strip_buf, sizeof ( unsigned char ),
               DataLoc->strip_byte_counts[strip_index], fp ) ) {
    fprintf ( stderr, "tiff.c:  function ReadStrip:\n" );
    fprintf ( stderr, "error reading strip number %ld\n", strip_index );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int GetUShortValueFromField ( struct IFD *ifd, unsigned short Tag,
                                     unsigned short *Value )
{
  struct TIFF_field *field;

  /* get pointer to field */
  if ( ( field = GetFieldStructure ( ifd, Tag ) ) == NULL )
    return ( ERROR );

  if ( field->Type == SHORT ) *Value = field->Value.UShort;
  else {
    WrongValueType ( "GetUShortValueFromField", Tag, field->Type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int GetImageDataLocInfo ( struct IFD *ifd, 
                                 struct DataLocation *DataLoc )
{
  /* get RowsPerStrip value */
  if ( GetRowsPerStrip ( ifd, &(DataLoc->rows_per_strip) ) == ERROR )
    return ( ERROR );

  /* get number of strips */
  if ( GetNumberOfStrips ( ifd, &(DataLoc->StripsPerImage) ) == ERROR )
    return ( ERROR );

  /* get array of strip offsets */
  if ( GetStripOffsets ( ifd, DataLoc ) == ERROR )
    return ( ERROR );

  /* get array of strip byte counts */
  if ( GetStripByteCounts ( ifd, DataLoc ) == ERROR )
    return ( ERROR );

  return ( NO_ERROR );
}

static int GetStripOffsets ( struct IFD *ifd,
                             struct DataLocation *DataLoc )
{
  struct TIFF_field *field;

  /* get pointer to StripOffsets field */
  if ( ( field = GetFieldStructure ( ifd, StripOffsets ) )
       == NULL ) return ( ERROR );

  /* stuff field values into array in DataLocation structure */
  if ( PutValuesIntoULongArray ( field, &(DataLoc->strip_offsets), 
                                 DataLoc->StripsPerImage ) == ERROR )
    return ( ERROR );

  return ( NO_ERROR );
}

static int GetStripByteCounts ( struct IFD *ifd,
                                struct DataLocation *DataLoc )
{
  struct TIFF_field *field;

  /* get pointer to StripByteCounts field */
  if ( ( field = GetFieldStructure ( ifd, StripByteCounts ) )
       == NULL ) return ( ERROR );

  /* stuff field values into array in DataLocation structure */
  if ( PutValuesIntoULongArray ( field, &(DataLoc->strip_byte_counts), 
                                 DataLoc->StripsPerImage ) == ERROR )
    return ( ERROR );

  return ( NO_ERROR );
}

static int PutValuesIntoULongArray ( struct TIFF_field *field,
                                     unsigned long **array,
                                     unsigned long num_elements )
{
  int unsigned long i;

  /* allocate array */
  if ( ( *array = ( unsigned long * ) 
                  calloc ( ( size_t ) num_elements,
                           sizeof ( unsigned long ) ) )
       == NULL ) {
    fprintf ( stderr, "tiff.c:  function PutValuesInto" );
    fprintf ( stderr, "ULongArray:\n" );
    fprintf ( stderr, "couldn't allocate array of unsigned long\n");
    return ( ERROR );
  }

  /* ensure array of field values has expected numer of elements */
  if ( field->Count != num_elements ) {
    fprintf ( stderr, "tiff.c:  function PutValuesIntoULongArray:\n" );
    fprintf ( stderr, "field count (%ld) for tag %d ", 
              field->Count, field->Tag ); 
    fprintf ( stderr, "differs from StripsPerImage element (%ld)\n",
              num_elements );
    fprintf ( stderr, "in DataLocation structure\n" );
    return ( ERROR );
  }

  /* stuff field values into array */
  if ( field->Type == SHORT ) {
    if ( field->Count == 1 ) 
      (*array)[0] = ( unsigned long ) field->Value.UShort;
    else {
      for ( i = 0; i < num_elements; i++ ) 
        (*array)[i] = ( unsigned long ) ( field->Value.UShortArray[i] );
    }
  }
  else if ( field->Type == LONG ) {
    if ( field->Count == 1 ) (*array)[0] = field->Value.ULong;
    else {
      for ( i = 0; i < num_elements; i++ )
        (*array)[i] = field->Value.ULongArray[i];
    }
  }
  else {
    WrongValueType ( "PutValuesIntoULongArray",
                     field->Tag, field->Type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int GetNumberOfStrips ( struct IFD *ifd,
                               unsigned long *StripsPerImage )
{
  struct TIFF_field *field;

  /* get pointer to StripOffsets field */
  if ( ( field = GetFieldStructure ( ifd, StripOffsets ) )
       == NULL ) return ( ERROR );

  /* get number of strips from field Count */
  *StripsPerImage = field->Count;

  return ( NO_ERROR );
}

static int GetRowsPerStrip ( struct IFD *ifd, 
                             unsigned long *rows_per_strip )
{
  struct TIFF_field *field;

  /* get pointer to RowsPerStrip field */
  if ( ( field = GetFieldStructure ( ifd, RowsPerStrip ) )
       == NULL ) return ( ERROR );

  /* get number of rows per strip */
  if ( field->Type == SHORT )
    *rows_per_strip = ( unsigned long ) field->Value.UShort;
  else if ( field->Type == LONG ) *rows_per_strip = field->Value.ULong;
  else {
    WrongValueType ( "GetRowsPerStrip", field->Tag, field->Type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static void WrongValueType ( char *FunctionName, unsigned short Tag,
                             unsigned short Type )
{
    fprintf ( stderr, "tiff.c:  function %s:\n", FunctionName );
    fprintf ( stderr, "tiff reader is not prepared for interpreting\n" );
    fprintf ( stderr, "value type %d for field with tag %d\n", Type, Tag );
}

static int AllocateImageDataArray ( struct TIFF_img *img, struct IFD *ifd )
{
  int i;

  /* if image is grayscale or palette-color */
  if ( img->TIFF_type == 'g' ) {
    img->mono = ( unsigned char ** )
                get_img ( img->width, img->height, sizeof ( unsigned char ) );
    return ( NO_ERROR );
  }

  /* if image is palette-color */
  if ( img->TIFF_type == 'p' ) {
    /* colormap */
    if ( AllocateColorMap ( &(img->cmap), ifd ) == ERROR ) return ( ERROR );
    /* array of indices into colormap */
    img->mono = ( unsigned char ** )
                get_img ( img->width, img->height, sizeof ( unsigned char ) );
    return ( NO_ERROR );
  }

  /* if image is full color */
  if ( img->TIFF_type == 'c' ) {
    img->color = ( unsigned char *** ) 
                 mget_spc ( 3, sizeof ( unsigned char ** ) );
    for ( i = 0; i < 3; i++ )
      img->color[i] = ( unsigned char ** ) 
                      get_img ( img->width, img->height,
                                sizeof ( unsigned char ) );
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function AllocateImageDataArray:\n" );
  fprintf ( stderr, "space allocation for image of type %c ", 
            img->TIFF_type );
  fprintf ( stderr, "is not supported\n" );
  return ( ERROR );
}

static int AllocateColorMap ( unsigned char ***cmap, struct IFD *ifd )
{
  struct TIFF_field *field;
  unsigned short bits_per_sample;
  unsigned long cmap_length;

  /* get BitsPerSample value */
  if ( GetUShortValueFromField ( ifd, BitsPerSample, &bits_per_sample )
       == ERROR ) return ( ERROR );

  /* compute colormap length (cf. TIFF specification document) */
  cmap_length = ( unsigned long ) pow ( 2.0, ( double ) bits_per_sample );

  /* ensure the ColorMap field has same number for its count */
  if ( ( field = GetFieldStructure ( ifd, ColorMap ) ) == NULL )
    return ( ERROR );
  if ( field->Count != ( unsigned long ) ( 3 * cmap_length ) ) {
    fprintf ( stderr, "tiff.c:  function AllocateColorMap:\n" );
    fprintf ( stderr, "unexpected number of entries in colormap\n" );
    return ( ERROR );
  }

  *cmap = ( unsigned char ** ) 
          get_img ( 3, cmap_length, sizeof ( unsigned char ) );

  return ( NO_ERROR );
}

static int GetHeightAndWidth ( struct IFD *ifd, int *height, int *width )
{
  struct TIFF_field *field;

  /* get pointer to ImageLength field */
  if ( ( field = GetFieldStructure ( ifd, ImageLength ) )
       == NULL ) return ( ERROR );

  /* get image height */
  if ( field->Type == SHORT ) *height = ( int ) field->Value.UShort;
  else if ( field->Type == LONG ) *height = ( int ) field->Value.ULong;
  else {
    WrongValueType ( "GetHeightAndWidth", field->Tag, field->Type );
    return ( ERROR );
  }

  /* get pointer to ImageWidth field */
  if ( ( field = GetFieldStructure ( ifd, ImageWidth ) )
       == NULL ) return ( ERROR );

  /* get image width */
  if ( field->Type == SHORT ) *width = ( int ) field->Value.UShort;
  else if ( field->Type == LONG ) *width = ( int ) field->Value.ULong;
  else {
    WrongValueType ( "GetHeightAndWidth", field->Tag, field->Type );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int GetCompression ( struct IFD *ifd, char *compress_type )
{
  unsigned short CompressionValue;

  /* get compression value */
  if ( GetUShortValueFromField ( ifd, Compression, &CompressionValue ) 
       == ERROR ) return ( ERROR );

  if ( CompressionValue == NoCompression ) {
    *compress_type = 'u';
    return ( NO_ERROR );
  }

  if ( CompressionValue == PackBits ) {
    fprintf ( stderr, "tiff.c:  function GetCompression:\n" );
    fprintf ( stderr, "PackBits compression not supported\n" );
    return ( ERROR );
  }

  if ( CompressionValue == OneDimModifiedHuffman ) {
    fprintf ( stderr, "tiff.c:  function GetCompression:\n" );
    fprintf ( stderr, "1-D modified Huffman compression not supported\n" );
    return ( ERROR );
  }

  fprintf ( stderr, "tiff.c:  function GetCompression:\n" );
  fprintf ( stderr, "Compression value %d not recognized; could not", 
            CompressionValue );
  fprintf ( stderr, " assign\ncompress_type to TIFF_img structure\n" );
  return ( ERROR );
}

static int VerifyIFD ( struct IFD *ifd, char *TIFF_type )
{
  /* ensure that there are IFD entries for all */
  /* "core" fields (those which are required   */
  /* for each of the baseline image types); if */
  /* any of these is missing and has a default */
  /* value, add the field (with default value) */
  /* to the IFD                                */
  if ( CheckForCoreFields ( ifd ) == ERROR ) return ( ERROR ); 

  /* fill in TIFF_img structure element for  */
  /* image type (this involves considerable  */
  /* error checking, which is why it is part */
  /* of the IFD verification procedure)      */
  if ( GetImageType ( ifd, TIFF_type ) == ERROR ) return ( ERROR );
  
  return ( NO_ERROR );
}

static int GetImageType ( struct IFD *ifd, char *TIFF_type )
{
  /* grayscale */
  if ( IsImageGrayscale ( ifd ) == YES ) {
    *TIFF_type = 'g';
    return ( NO_ERROR );
  }

  /* palette-color */
  if ( IsImagePaletteColor ( ifd ) == YES ) {
    *TIFF_type = 'p';
    return ( NO_ERROR );
  }

  /* full 24-bit color */
  if ( IsImageFullColor ( ifd ) == YES ) {
    *TIFF_type = 'c';
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function GetImageType:\nreader " );
  fprintf ( stderr, "can't infer image type from IFD\n" );
  return ( ERROR );
}

static int IsImageFullColor ( struct IFD *ifd )
{
  struct TIFF_field *field;

  /* there must be fields for BitsPerSample and SamplesPerPixel */
  if ( IsThereAFieldFor ( ifd, BitsPerSample ) == NO ) return ( NO );
  if ( IsThereAFieldFor ( ifd, SamplesPerPixel ) == NO ) return ( NO );

  /* Compression must have NoCompression or PackBits as a value */
  if ( ( field = GetFieldStructure ( ifd, Compression ) )
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != NoCompression ) &&
       ( field->Value.UShort != PackBits ) ) return ( NO );

  /* PhotometricInterpretation must have 2 as a value */
  if ( ( field = GetFieldStructure ( ifd, PhotometricInterpretation ) )
       == NULL ) return ( NO );
  if ( field->Value.UShort != 2 ) return ( NO );

  /* SamplesPerPixel must not have a value less than 3 */
  if ( ( field = GetFieldStructure ( ifd, SamplesPerPixel ) )
       == NULL ) return ( NO );
  if ( field->Value.UShort < 3 ) return ( NO );

  /* ResolutionUnit must have 1 or 2 or 3 as a value */
  if ( ( field = GetFieldStructure ( ifd, ResolutionUnit ) )
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != NoAbsoluteUnit ) &&
       ( field->Value.UShort != Inch ) &&
       ( field->Value.UShort != Centimeter ) ) return ( NO );

  /* BitsPerSample must have 8, 8, 8 as values */
  if ( ( field = GetFieldStructure ( ifd, BitsPerSample ) )
       == NULL ) return ( NO );
  if ( field->Count != 3 ) return ( NO );
  else if ( ( field->Value.UShortArray[0] != 8 ) ||
            ( field->Value.UShortArray[1] != 8 ) ||
            ( field->Value.UShortArray[2] != 8 ) ) {
    fprintf ( stderr, "tiff.c:  function IsImageFullColor:\n" );
    fprintf ( stderr, "image in TIFF file is full color, but image\n" );
    fprintf ( stderr, "data is not stored at 8 bits per sample;\n" );
    fprintf ( stderr, "TIFF reader is not prepared for this\n" );
    return ( NO );
  }

  return ( YES );
}

static int IsImagePaletteColor ( struct IFD *ifd )
{
  struct TIFF_field *field;

  /* there must be fields for BitsPerSample and ColorMap */
  if ( IsThereAFieldFor ( ifd, BitsPerSample ) == NO ) return ( NO );
  if ( IsThereAFieldFor ( ifd, ColorMap ) == NO ) return ( NO );

  /* Compression must have NoCompression or PackBits as a value */
  if ( ( field = GetFieldStructure ( ifd, Compression ) )
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != NoCompression ) &&
       ( field->Value.UShort != PackBits ) ) return ( NO );

  /* PhotometricInterpretation must have 3 as a value */
  if ( ( field = GetFieldStructure ( ifd, PhotometricInterpretation ) )
       == NULL ) return ( NO );
  if ( field->Value.UShort != 3 ) return ( NO );

  /* ResolutionUnit must have 1 or 2 or 3 as a value */
  if ( ( field = GetFieldStructure ( ifd, ResolutionUnit ) )
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != 1 ) &&
       ( field->Value.UShort != 2 ) &&
       ( field->Value.UShort != 3 ) ) return ( NO );

  /* BitsPerSample must have 4 or 8 as a value */
  if ( ( field = GetFieldStructure ( ifd, BitsPerSample ) )
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != 4 ) &&
       ( field->Value.UShort != 8 ) ) return ( NO );

  /* four BitsPerSample not supported */
  if ( ( field = GetFieldStructure ( ifd, BitsPerSample ) )
       == NULL ) return ( NO );
  if ( field->Value.UShort == 4 ) {
    fprintf ( stderr, "tiff.c:  function IsImagePaletteColor:\n" );
    fprintf ( stderr, "image in TIFF file is palette-color, but image\n" );
    fprintf ( stderr, "data is stored at 4 bits per sample, which\n" );
    fprintf ( stderr, "is not supported by this reader\n" );
    return ( NO );
  }

  return ( YES );
}

static int IsImageGrayscale ( struct IFD *ifd ) 
{
  struct TIFF_field *field;

  /* there must be a field for BitsPerSample */
  if ( IsThereAFieldFor ( ifd, BitsPerSample ) == NO ) return ( NO );

  /* Compression must have NoCompression or PackBits as a value */
  if ( ( field = GetFieldStructure ( ifd, Compression ) ) 
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != NoCompression ) &&
       ( field->Value.UShort != PackBits ) ) return ( NO );

  /* PhotometricInterpretation   */
  /* must have 0 or 1 as a value */
  if ( ( field = GetFieldStructure ( ifd, PhotometricInterpretation ) ) 
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != 0 ) &&
       ( field->Value.UShort != 1 ) ) return ( NO );

  /* ResolutionUnit must have 1 or 2 or 3 as a value */
  if ( ( field = GetFieldStructure ( ifd, ResolutionUnit ) ) 
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != NoAbsoluteUnit ) &&
       ( field->Value.UShort != Inch ) &&
       ( field->Value.UShort != Centimeter ) ) return ( NO );

  /* BitsPerSample must have 4 or 8 as a value */
  if ( ( field = GetFieldStructure ( ifd, BitsPerSample ) ) 
       == NULL ) return ( NO );
  if ( ( field->Value.UShort != 4 ) &&
       ( field->Value.UShort != 8 ) ) return ( NO );

  /* four BitsPerSample not supported */
  if ( ( field = GetFieldStructure ( ifd, BitsPerSample ) )
       == NULL ) return ( NO );
  if ( field->Value.UShort == 4 ) {
    fprintf ( stderr, "image in TIFF file is grayscale, but image\n" );
    fprintf ( stderr, "data is stored at 4 bits per sample, which\n" );
    fprintf ( stderr, "is not supported by this reader\n" );
    return ( NO );
  }

  return ( YES );
}

static struct TIFF_field *GetFieldStructure ( struct IFD *ifd,
                                              unsigned short Tag )
{
  unsigned short i;
 
  for ( i = 0; i < ifd->NumberOfFields; i++ )
    if ( ifd->Fields[i].Tag == Tag ) return ( &(ifd->Fields[i]) );

  fprintf ( stderr, "tiff.c:  function GetFieldStructure:\n" );
  fprintf ( stderr, "faied to find field with tag %d\n", Tag );
  return ( NULL );
}

static int CheckForCoreFields ( struct IFD *ifd )
{
  if ( ( WhatAboutCoreField ( ifd, ImageWidth ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, ImageLength ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, Compression ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, PhotometricInterpretation ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, StripOffsets ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, RowsPerStrip ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, StripByteCounts ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, XResolution ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, YResolution ) == ERROR ) ||
       ( WhatAboutCoreField ( ifd, ResolutionUnit ) == ERROR ) )
    return ( ERROR );

  return ( NO_ERROR );
}

static int WhatAboutCoreField ( struct IFD *ifd, unsigned short Tag )
{
  if ( IsThereAFieldFor ( ifd, Tag ) == NO ) {
    if ( IsThereADefaultFor ( Tag ) == YES ) {
      if ( AddDefaultField ( ifd, Tag ) == ERROR )
        return ( ERROR );
    }
    else {
      TellUserACoreFieldIsNecessary ( Tag );
      return ( ERROR );
    }
  }

  return ( NO_ERROR );
}

static int AddDefaultField ( struct IFD *ifd, unsigned short Tag )
{
  if ( Tag == ResolutionUnit )
    return ( MakeResolutionUnitField ( ifd ) ); 
  if ( Tag == RowsPerStrip )
    return ( MakeDefaultRowsPerStripField ( ifd ) ); 

  fprintf ( stderr, "tiff.c:  function AddDefaultField:\n" );
  fprintf ( stderr, "can not add default field for tag %d\n", Tag );
  return ( ERROR );
}

static void TellUserACoreFieldIsNecessary ( unsigned short Tag )
{
  fprintf ( stderr, "tiff reader:  function CheckForCoreFields:\n" );
  fprintf ( stderr, "field for tag %d does not appear\n", Tag );
  fprintf ( stderr, "in IFD (and has no default)\n" );
}

static int IsThereADefaultFor ( unsigned short Tag )
{
  if ( Tag == ResolutionUnit ) return ( YES );
  if ( Tag == RowsPerStrip ) return ( YES );

  return ( NO );
}

static int IsThereAFieldFor ( struct IFD *ifd, unsigned short Tag )
{
  unsigned short i;

  for ( i = 0; i < ifd->NumberOfFields; i++ )
    if ( ifd->Fields[i].Tag == Tag ) return ( YES );

  return ( NO );
}

static int ReadIFD ( FILE *fp, struct IFD *ifd,
                     struct TIFF_header *header, char *TIFF_type )
{
  unsigned short i, NumFieldsInInputFile;

  /* initialize IFD structure */
  ifd->NumberOfFields = 0;
  ifd->Fields = NULL;

  /* get number of fields in IFD of input file */
  if ( GetNumberOfFieldsInInput ( fp, header->OffsetOfFirstIFD, 
                                  &NumFieldsInInputFile ) 
       == ERROR ) return ( ERROR );

  /* loop through fields in IFD */
  for ( i = 0; i < NumFieldsInInputFile; i++ ) {

    /* set file-position at first byte in field */
    if ( SetFilePositionAtFirstByteOfIthField 
         ( fp, header->OffsetOfFirstIFD, i ) == ERROR )
      return ( ERROR );

    /* if tag is recognized, copy field into a structure */
    if ( CopyFieldIfTagIsRecognized ( fp, ifd ) == ERROR ) 
      return ( ERROR );

  }

  /* check to see if this is the last   */
  /* IFD; if it isn't, inform user that */
  /* the others will be ignored         */
  if ( SeeIfThereAreOtherIFDs 
       ( fp, header->OffsetOfFirstIFD, NumFieldsInInputFile ) == ERROR ) 
    return ( ERROR );

  /* verify that IFD is complete; fill in for    */
  /* missing fields which have default value(s); */
  /* determine and record "TIFF_type" of image   */
  if ( VerifyIFD ( ifd, TIFF_type ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int SeeIfThereAreOtherIFDs ( FILE *fp, unsigned long OffsetOfIFD,
                                    unsigned short NumFieldsInInputFile )
{
  unsigned long PositionValue, ZeroOrOffset;

  /* compute offset of first byte after end of last IFD */
  PositionValue = OffsetOfIFD + 2 + 
                  ( (unsigned long) (NumFieldsInInputFile) * 12 );

  /* set file-position at first byte after end of last IFD */
  if ( SetFilePosition ( fp, PositionValue ) == ERROR ) {
    fprintf ( stderr, "error going to first byte " );
    fprintf ( stderr, "after end of IFD\n" );
    return ( ERROR );
  }

  /* get 4 bytes */
  if ( GetUnsignedLong ( fp, &ZeroOrOffset ) == ERROR ) {
    fprintf ( stderr, "error getting the four bytes " );
    fprintf ( stderr, "after the end of IFD\n" );
    return ( ERROR );
  }

  /* either this number is zero or   */
  /* it is an offset to another IFD; */
  /* if so, warn user that the other */
  /* IFD(s) will be ignored          */
  if ( ZeroOrOffset != 0 ) {
    fprintf ( stderr, "WARNING:  this TIFF file " );
    fprintf ( stderr, "contains multiple images;\n" );
    fprintf ( stderr, "all but the first image will be " );
    fprintf ( stderr, "ignored by the TIFF reader\n" );
  }
  
  return ( NO_ERROR );
}

static int SetFilePositionAtFirstByteOfIthField ( FILE *fp, 
                                                  unsigned long OffsetOfIFD,
                                                  unsigned short i )
{
  unsigned long PositionValue;

  /* compute offset of first byte in field */
  PositionValue = OffsetOfIFD + 2 + ( (unsigned long) (i) * 12 );

  /* set file-position at first byte in field */
  if ( SetFilePosition ( fp, PositionValue ) == ERROR ) {
    fprintf ( stderr, "error going to first byte " );
    fprintf ( stderr, "of %d-th field in IFD\n", i );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int CopyFieldIfTagIsRecognized ( FILE *fp, struct IFD *ifd ) 
{
  unsigned short TempTag, TempType;
  
  /* get field tag, store in temporary space */
  if ( GetUnsignedShort ( fp, &TempTag ) == ERROR ) {
    fprintf ( stderr, "error reading tag\n" );
    return ( ERROR );
  }

  /* determine whether the tag is recognized; if it */
  /* is not, then the whole field should be ignored */
  if ( IsTagRecognized ( TempTag ) == YES ) {

    /* get value type, store in temporary space */
    if ( GetUnsignedShort ( fp, &TempType ) == ERROR ) {
      fprintf ( stderr, "error reading type of field " );
      fprintf ( stderr, "with tag %d\n", TempTag );
      return ( ERROR );
    }

    /* determine whether the type is recognized; if it */
    /* is not, then the whole field should be ignored  */
    if ( IsTypeRecognized ( TempType ) == YES ) {

      /* determine whether this type is expected for a field */
      /* with this tag; if it is not, then the whole field   */
      /* should be ignored                                   */
      if ( IsTypeExpectedWithTag ( TempTag, TempType ) == YES ) {

        /* allocate new field structure, and copy */ 
        /* all field info into the new structure  */
        if ( AllocateAndCopyField ( fp, ifd, TempTag, TempType )
             == ERROR ) return ( ERROR );

      } /* if type is expected with the tag */

    } /* if type is recognized */

  } /* if tag is recognized */

  return ( NO_ERROR );
}

static int AllocateAndCopyField ( FILE *fp, struct IFD *ifd, 
                                  unsigned short Tag, unsigned short Type )
{
  /* increment number of recognized fields */
  ifd->NumberOfFields++;

  /* allocate a new field structure */
  if ( AllocateNewField ( ifd ) == ERROR ) return ( ERROR );

  /* copy all field info into the new structure */
  if ( CopyField ( fp, &(ifd->Fields[ifd->NumberOfFields - 1]),
                   Tag, Type ) == ERROR ) {
    fprintf ( stderr, "error reading field entry ");
    fprintf ( stderr, "for tag number %d\n", Tag );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int IsTypeExpectedWithTag ( unsigned short Tag, unsigned short Type )
{
  if ( Tag == ImageWidth ) {
    if ( Type == SHORT ) return ( YES );
    if ( Type == LONG ) return ( YES );
  }

  if ( Tag == ImageLength ) {
    if ( Type == SHORT ) return ( YES );
    if ( Type == LONG ) return ( YES );
  }

  if ( Tag == BitsPerSample )
    if ( Type == SHORT ) return ( YES );

  if ( Tag == Compression )
    if ( Type == SHORT ) return ( YES );

  if ( Tag == PhotometricInterpretation )
    if ( Type == SHORT ) return ( YES );

  if ( Tag == StripOffsets ) {
    if ( Type == SHORT ) return ( YES );
    if ( Type == LONG ) return ( YES );
  }

  if ( Tag == SamplesPerPixel )
    if ( Type == SHORT ) return ( YES );

  if ( Tag == RowsPerStrip ) {
    if ( Type == SHORT ) return ( YES );
    if ( Type == LONG ) return ( YES );
  }

  if ( Tag == StripByteCounts ) {
    if ( Type == SHORT ) return ( YES );
    if ( Type == LONG ) return ( YES );
  }

  if ( Tag == XResolution )
    if ( Type == RATIONAL ) return ( YES );

  if ( Tag == YResolution )
    if ( Type == RATIONAL ) return ( YES );

  if ( Tag == ResolutionUnit )
    if ( Type == SHORT ) return ( YES );

  if ( Tag == ColorMap )
    if ( Type == SHORT ) return ( YES );

  WrongValueType ( "IsTypeExpectedWithTag", Tag, Type );
  fprintf ( stderr, "field will be ignored\n" );
  return ( NO );
}

static int IsTypeRecognized ( unsigned short Type )
{
  if ( Type == BYTE ) return ( YES );
  if ( Type == SHORT ) return ( YES );
  if ( Type == LONG ) return ( YES );
  if ( Type == RATIONAL ) return ( YES );

  return ( NO );
}

static int CopyField ( FILE *fp, struct TIFF_field *field, 
                       unsigned short Tag, unsigned short Type )
{
  /* put in tag and type */
  field->Tag = Tag; 
  field->Type = Type; 

  /* get number of data values for the field */
  if ( CopyCount ( fp, field ) == ERROR ) {
    fprintf ( stderr, "error reading field count\n" ); 
    return ( ERROR );
  }

  /* get data value(s) */
  if ( CopyValue ( fp, field ) == ERROR ) {
    fprintf ( stderr, "error reading field data value(s)\n" ); 
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int GetSizeOfType ( struct TIFF_field *field )
{
  if ( field->Type == BYTE ) {
    field->SizeOfType = 1;
    return ( NO_ERROR );
  }
  if ( field->Type == SHORT ) {
    field->SizeOfType = 2; 
    return ( NO_ERROR );
  }
  if ( field->Type == LONG ) {
    field->SizeOfType = 4;
    return ( NO_ERROR );
  }
  if ( field->Type == RATIONAL ) {
    field->SizeOfType = 8;
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function GetSizeOfType:\n" );
  fprintf ( stderr, "field type %d is not supported\n", 
            field->Type );
  return ( ERROR );
}

static int CopyValue ( FILE *fp, struct TIFF_field *field )
{
  unsigned long Offset;

  /* get size of type */
  if ( GetSizeOfType ( field ) == ERROR ) return ( ERROR );

  /* if value will not fit inside four bytes */
  if ( 4 < field->Count * field->SizeOfType ) {

    /* get offset of location of data value(s) */
    if ( GetUnsignedLong ( fp, &(Offset) ) == ERROR ) {
      fprintf ( stderr, "error reading offset " );
      fprintf ( stderr, "for tag number %d\n", field->Tag );
      return ( ERROR );
    }

    /* set file position where value(s) should be obtained */
    if ( SetFilePosition ( fp, Offset ) == ERROR ) {
      fprintf ( stderr,"error setting file position at data value " );
      fprintf ( stderr, "for tag number %d\n", field->Tag );
      return ( ERROR );
    }

  }

  /* either there is only 1 value or there are multiple values */
  if ( field->Count == 1 ) {
    if ( GetSingleValue ( fp, field ) == ERROR ) {
      fprintf ( stderr, "cound not get data value ");
      fprintf ( stderr, "for tag number %d\n", field->Tag);
      return ( ERROR );
    }
  }
  else {
    if ( AllocateArrayOfValues ( field ) == ERROR ) {
      fprintf ( stderr, "could not allocate values ");
      fprintf ( stderr, "for tag %d\n", field->Tag);
      return ( ERROR );
    }
    if ( GetArrayOfValues ( fp, field ) == ERROR ) {
      fprintf ( stderr, "cound not get data values ");
      fprintf ( stderr, "for tag number %d\n", field->Tag);
      return ( ERROR );
    }
  }

  return ( NO_ERROR );
}

static int GetArrayOfValues ( FILE *fp, struct TIFF_field *field )
{
  unsigned long int i;

  if ( field->Type == BYTE ) {
    for ( i = 0; i < field->Count; i++ )
      if ( GetUnsignedChar ( fp, &(field->Value.UCharArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == SHORT ) {
    for ( i = 0; i < field->Count; i++ )
      if ( GetUnsignedShort ( fp, &(field->Value.UShortArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == LONG ) {
    for ( i = 0; i < field->Count; i++ )
      if ( GetUnsignedLong ( fp, &(field->Value.ULongArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == RATIONAL ) {
    for ( i = 0; i < field->Count; i++ )
      if ( GetRational ( fp, &(field->Value.RatArray[i]) )
           == ERROR ) return ( ERROR );
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function GetArrayOfValues:\n" );
  fprintf ( stderr, "reader not prepared to get values of\n" );
  fprintf ( stderr, "type %d\n", field->Type );
  return ( ERROR );
}

static int GetSingleValue ( FILE *fp, struct TIFF_field *field )
{
  if ( field->Type == BYTE ) {
    if ( GetUnsignedChar ( fp, &(field->Value.UChar) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == SHORT ) {
    if ( GetUnsignedShort ( fp, &(field->Value.UShort) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == LONG ) {
    if ( GetUnsignedLong ( fp, &(field->Value.ULong) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }
  else if ( field->Type == RATIONAL ) {
    if ( GetRational ( fp, &(field->Value.Rat) ) == ERROR )
      return ( ERROR );
    return ( NO_ERROR );
  }

  fprintf ( stderr, "tiff.c:  function GetSingleValue:\n" );
  fprintf ( stderr, "reader not prepared to get value of\n" ); 
  fprintf ( stderr, "type %d\n", field->Type ); 
  return ( ERROR );
}

static int AllocateArrayOfValues ( struct TIFF_field *field )
{
  if ( field->Type == BYTE )
    if ( ( field->Value.UCharArray = 
           ( unsigned char * ) 
           calloc ( ( size_t ) field->Count, sizeof ( unsigned char ) ) ) 
         == NULL )
      return ( ERROR );

  if ( field->Type == SHORT )
    if ( ( field->Value.UShortArray =
           ( unsigned short * )
           calloc ( ( size_t ) field->Count, sizeof ( unsigned short ) ) ) 
         == NULL )
      return ( ERROR );

  if ( field->Type == LONG )
    if ( ( field->Value.ULongArray =
           ( unsigned long * )
           calloc ( ( size_t ) field->Count, sizeof ( unsigned long ) ) ) 
         == NULL )
      return ( ERROR );

  if ( field->Type == RATIONAL )
    if ( ( field->Value.RatArray =
           ( struct Rational * )
           calloc ( ( size_t ) field->Count, sizeof ( struct Rational ) ) ) 
         == NULL )
      return ( ERROR );

  return ( NO_ERROR );
}

static int CopyCount ( FILE *fp, struct TIFF_field *field )
{
  if ( GetUnsignedLong ( fp, &(field->Count) ) == ERROR ) {
    fprintf ( stderr, "error reading field count " );
    fprintf ( stderr, "for tag number %d\n", field->Tag );
    return ( ERROR );
  }

  /* count should be positive */
  if ( field->Count == 0 ) {
    fprintf ( stderr, "encountered 0 as field count " );
    fprintf ( stderr, "for tag number %d\n", field->Tag );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int AllocateNewField ( struct IFD *ifd )
{
  if ( ( ifd->Fields = (struct TIFF_field *)
                       realloc ( (struct TIFF_field *) ifd->Fields,
                                 ( size_t ) ( ifd->NumberOfFields *
                                 sizeof (struct TIFF_field) ) ) )
       == NULL ) {
    fprintf ( stderr, "tiff.c:  function AllocateNewField\n");
    fprintf ( stderr, "couldn't allocate struct for a new field\n");
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int IsTagRecognized ( unsigned short TempTag )
{
  if ( TempTag == ImageWidth ) return ( YES );
  if ( TempTag == ImageLength ) return ( YES );
  if ( TempTag == BitsPerSample ) return ( YES );
  if ( TempTag == Compression ) return ( YES );
  if ( TempTag == PhotometricInterpretation ) return ( YES );
  if ( TempTag == StripOffsets ) return ( YES );
  if ( TempTag == SamplesPerPixel ) return ( YES );
  if ( TempTag == RowsPerStrip ) return ( YES );
  if ( TempTag == StripByteCounts ) return ( YES );
  if ( TempTag == XResolution ) return ( YES );
  if ( TempTag == YResolution ) return ( YES );
  if ( TempTag == ResolutionUnit ) return ( YES );
  if ( TempTag == ColorMap ) return ( YES );

  return ( NO );
}

static int GetRational ( FILE *fp, struct Rational *Rat )
{
  unsigned long numerator, denumerator;


  if ( 2 != fscanf ( fp, "%4c%4c", (char *)(&numerator), 
                                   (char *)(&denumerator) ) ) {
    fprintf ( stderr,"error reading rational number\n" );
    return ( ERROR );
  }

  if (FileByteOrder == HostByteOrder) {
    Rat->Numer = numerator;
    Rat->Denom = denumerator;
  } else {
    Rat->Numer = LongReverse(numerator);
    Rat->Denom = LongReverse(denumerator);
  }

  return ( NO_ERROR );
}

static int GetUnsignedLong ( FILE *fp, unsigned long *UnsignedLong )
{
  unsigned long unsignedlong;

  if ( 1 != fscanf ( fp, "%4c", (char *)(&unsignedlong) ) ) {
    fprintf ( stderr,"error reading unsigned long\n" );
    return ( ERROR );
  }

  if (FileByteOrder == HostByteOrder)
    *UnsignedLong = unsignedlong;
  else
    *UnsignedLong = LongReverse(unsignedlong);


  return ( NO_ERROR );
}

static int GetUnsignedShort ( FILE *fp, unsigned short *UnsignedShort )
{
  unsigned short unsignedshort;
//  printf("fda: %d", fscanf_s ( fp, "%c", (char *)(&unsignedshort), 1 ));
 // if ( 1 != fscanf_s ( fp, "%2c", (char *)(&unsignedshort) ) ) {
  if ( 1 != fscanf ( fp, "%2c", (char *)(&unsignedshort) ) ) {
    fprintf ( stderr,"error reading unsigned short\n" );
    return ( ERROR );
  }

  if (FileByteOrder == HostByteOrder)
    *UnsignedShort = unsignedshort;
  else
    *UnsignedShort = ShortReverse(unsignedshort);


  return ( NO_ERROR );
}

static int GetUnsignedChar ( FILE *fp, unsigned char *UnsignedChar )
{
  if ( 1 != fscanf ( fp, "%c", UnsignedChar ) ) {
    fprintf ( stderr,"error reading unsigned char\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int GetNumberOfFieldsInInput ( FILE *fp, unsigned long OffsetOfIFD,
                                      unsigned short *NumFieldsInInputFile )
{

  /* set file-position at beginning of IFD */
  if ( SetFilePosition ( fp, OffsetOfIFD ) == ERROR ) {
    fprintf ( stderr,"error finding num of fields for IFD\n" );
    return ( ERROR );
  }

  /* read number of fields in IFD */
  if ( GetUnsignedShort ( fp, NumFieldsInInputFile ) == ERROR ) {
    fprintf ( stderr,"error reading number of fields for IFD\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int SetFilePosition ( FILE *fp, unsigned long position )
{
  if ( fseek ( fp, ( long int ) position, SEEK_SET ) < 0 ) {
    fprintf ( stderr,"error setting file-position\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int ReadHeader ( FILE *fp, struct TIFF_header *header )
{
  /* set file position at beginning of file */
  if ( SetFilePosition ( fp, 0 ) == ERROR ) return ( ERROR );

  /* get byte-order word */
  if ( GetByteOrder ( fp, header ) == ERROR ) return ( ERROR );
  
  /* ensure second word in header is 42 */
  if ( CheckFortyTwo ( fp, header ) == ERROR ) return ( ERROR );

  /* get offset for first IFD */
  if ( GetOffsetOfFirstIFD ( fp, header ) == ERROR ) return ( ERROR );

  return ( NO_ERROR );
}

static int CheckTypeSizes ( void )
{
  if ( ( 1 != sizeof ( unsigned char ) ) ||
       ( 2 != sizeof ( unsigned short ) ) ||
       ( 4 != sizeof ( unsigned long ) ) ) {
    fprintf ( stderr, "machine data sizes are not " );
    fprintf ( stderr, "appropriate for TIFF reader/writer\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

static int GetByteOrder ( FILE *fp, struct TIFF_header *header )
{
  /* get byte sequence */
  if ( GetUnsignedShort ( fp, &(header->ByteOrder) ) == ERROR ) {
    fprintf ( stderr, "error reading image header\n" );
    return ( ERROR );
  }

  /* ensure that sequence denotes either */
  /* big- or little- endian byte order   */
  FileByteOrder = header->ByteOrder;
  if ( header->ByteOrder == BigEndian ) return ( NO_ERROR );
  if ( header->ByteOrder == LittleEndian ) return ( NO_ERROR );
 
  return ( ERROR );
}

static int CheckFortyTwo ( FILE *fp, struct TIFF_header *header )
{
  /* get byte sequence */
  if ( GetUnsignedShort ( fp, &(header->FortyTwo) ) == ERROR ) {
    fprintf ( stderr, "error reading image header\n" );
    return ( ERROR );
  }

  /* compare to the number 42 */
  if ( header->FortyTwo == 42 ) return ( NO_ERROR );
 
  return ( ERROR );
}

static int GetOffsetOfFirstIFD ( FILE *fp, struct TIFF_header *header )
{
  /* get offset for first IFD */
  if ( GetUnsignedLong ( fp, &(header->OffsetOfFirstIFD) ) == ERROR ) {
    fprintf ( stderr, "error reading image header\n" );
    return ( ERROR );
  }

  return ( NO_ERROR );
}

/*
static void PrintIFD ( struct IFD *ifd )
{
  int i;
  
  fprintf ( stdout, "\nno. of fields:\t\t%d\n", ifd->NumberOfFields );

  for ( i = 0; i < ( int ) ( ifd->NumberOfFields ); i++ ) 
    PrintField ( &(ifd->Fields[i]) );

  fprintf ( stdout, "\n" );
}
*/

/*
static void PrintField ( struct TIFF_field *field )
{
  int i;

  fprintf ( stdout, "\ntag:\t\t\t%d\n", field->Tag );
  fprintf ( stdout, "type:\t\t\t%d\n", field->Type );
  fprintf ( stdout, "count:\t\t\t%ld\n", field->Count );
    
  if ( field->Count == 1 ) {
    if ( field->Type == BYTE )
      fprintf ( stdout, "value:\t\t\t%d\n", field->Value.UChar );

    if ( field->Type == SHORT )
      fprintf ( stdout, "value:\t\t\t%d\n", field->Value.UShort );

    if ( field->Type == LONG )
      fprintf ( stdout, "value:\t\t\t%ld\n", field->Value.ULong );

    if ( field->Type == RATIONAL )
      fprintf ( stdout, "value:\t\t\tnumer:  %ld; denom:  %ld\n", 
                field->Value.Rat.Numer, field->Value.Rat.Denom );
  }

  if ( field->Count > 1 ) 
    for ( i = 0; i < field->Count; i++ ) {
      if ( field->Type == BYTE )
        fprintf ( stdout, "value[%d]:\t\t%d\n", i, 
                  field->Value.UCharArray[i] );

      if ( field->Type == SHORT )
        fprintf ( stdout, "value[%d]:\t\t%d\n", i, 
                  field->Value.UShortArray[i] );

      if ( field->Type == LONG )
        fprintf ( stdout, "value[%d]:\t\t%ld\n", i, 
                  field->Value.ULongArray[i] );

      if ( field->Type == RATIONAL )
        fprintf ( stdout, "value[%d]:\t\tnumer:  %ld; denom:  %ld\n", 
                  i, field->Value.RatArray[i].Numer,
                  field->Value.RatArray[i].Denom );
    }
}
*/

static void *mget_spc(int num,size_t size)
{
        void *pt;

        if( (pt=malloc((size_t)(num*size))) == NULL ) {
                fprintf(stderr, "==> malloc() error\n");
                exit(-1);
                }
        return(pt);
}

static void **get_img(int wd,int ht,size_t size)
{
        int i;
        void  **ppt;
        char   *pt;

        ppt = (void **)mget_spc(ht,sizeof(void *));
        pt = (char *)mget_spc(wd*ht,size);

        for(i=0; i<ht; i++) ppt[i] = pt + i*wd*size;

        return(ppt);
}

static void free_img(void **pt)
{
        free( (void *)pt[0]);
        free( (void *)pt);
}

