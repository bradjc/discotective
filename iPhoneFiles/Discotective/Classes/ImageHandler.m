//
//  ImageHandler.m
//  Discotective
//
//  Created by Mike Hand on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageHandler.h"


@implementation ImageHandler
static ImageHandler *sharedImageHandler = nil;
-(UIImageView*)getImageView{
	return sheetMusicImage;
}
-(UIImage*) createUIImageFromBinaryImage:(uint8_t*)pixels withWidth:(uint16_t) width andHeight:(uint16_t) height{
	/*uint8_t* pixels=(uint8_t*)malloc(sizeof(uint8_t)*(binIMG->height)*(binIMG->width));
	
	for (int x=0; x<(binIMG->width); x++) {
		for (int y=0; y<(binIMG->height); y++) {
			if (getPixel(binIMG, x, y)==0) {
				pixels[y*(binIMG->width)+x]=BIN_WHITE_BYTE;
			}
			else {
				pixels[y*(binIMG->width)+x]=BIN_BLACK_BYTE;
			}
			
		}
	}*/
	
	CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
	
    bitmapBytesPerRow   = width;
    bitmapByteCount     = (bitmapBytesPerRow * height);
    colorSpace = CGColorSpaceCreateDeviceGray();// 2
    context = CGBitmapContextCreate (pixels,// 4
									 width,
									 height,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaNone);
    if (context== NULL)
    {
        free (pixels);// 5
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );
	CGImageRef myImage;
	myImage = CGBitmapContextCreateImage (context);
	free(pixels);
	return	[[UIImage imageWithCGImage:myImage] retain];
}

-(uint8_t*) UIImageToRGBAArray:(UIImage*) image outWidth:(int*)width outHeight:(int*)height {
	// setup and convert a UIImage to an array of raw values
	CGImageRef		imageRef			= [image CGImage];
	*width				= CGImageGetWidth(imageRef);
	*height				= CGImageGetHeight(imageRef);
	
    CGColorSpaceRef	colorSpace			= CGColorSpaceCreateDeviceRGB();
    uint8_t			*rawData			= malloc((*height) * (*width) * 4);
    NSUInteger		bytesPerPixel		= 4;
    NSUInteger		bytesPerRow			= bytesPerPixel * (*width);
    NSUInteger		bitsPerComponent	= 8;
    CGContextRef	context				= CGBitmapContextCreate(rawData, *width, *height,
																bitsPerComponent, bytesPerRow, colorSpace,
																kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, *width, *height), imageRef);
    CGContextRelease(context);
	
	// create grayscale image
	//	grayimage_t*	gray_img;
	//	convert_rgb_to_gray_scale(rawData, height, width, gray_img);
	
	// convert 
	/*	uint8_t** grayscaleImage=multialloc(sizeof(uint8_t), 2,(int32_t)height,(int32_t)width);
	 int h=0;
	 int w=0;
	 for (int i=0; i<height*width; i++) {
	 // im confused about this next line. - brad
	 // it seems to use the same locations in the array for muliple pixels
	 // should it be rawData[4*i], rawData[4*i+1], and rawData[4*i+2] ?
	 grayscaleImage[h][w]=(uint8_t)(0.2126*rawData[4*i]+0.7152*rawData[4*(i+1)]+0.0722*rawData[4*(i+2)]);
	 w++;
	 if (w>=width) {
	 w=0;
	 h++;
	 }
	 }*/
	
	//	free(rawData);
	
	return rawData;
	
	// create binary image
	/*	image16_t *binIMG=malloc(sizeof(image16_t));
	 binIMG->height		= (uint16_t) height;
	 binIMG->width		= (uint16_t) width;
	 binIMG->byte_width	= (int16_t) ((width+7)/8);
	 binIMG->pixels		= (uint32_t) malloc(sizeof(uint8_t)*height*(binIMG->byte_width));*/
	
	// binaryize the image
	//	binarizeIMG(grayscaleImage, binIMG);
	
	
	//	multifree(grayscaleImage, 2);
	//	grayscale_image_delete(gray_img);
	
	//	return binIMG;
	
}
-(void) linkImageView:(UIImageView*)imageView{
	sheetMusicImage=imageView;
}

+ (ImageHandler*)getImageHandler
{
    if (sharedImageHandler == nil) {
        sharedImageHandler = [[super allocWithZone:NULL] init];
    }
    return sharedImageHandler;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self getImageHandler] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


@end
