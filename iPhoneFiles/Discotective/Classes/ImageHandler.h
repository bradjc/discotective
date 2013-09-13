//
//  ImageHandler.h
//  Discotective
//
//  Created by Mike Hand on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageHandler : NSObject {
	IBOutlet UIImageView *sheetMusicImage;
}
+ (ImageHandler*)getImageHandler;
-(uint8_t*) UIImageToRGBAArray:(UIImage*) image outWidth:(int*)width outHeight:(int*)height ;
-(UIImage*) createUIImageFromBinaryImage:(uint8_t*)pixels withWidth:(uint16_t) width andHeight:(uint16_t) height;
-(void) linkImageView:(UIImageView*)imageView;
-(UIImageView*)getImageView;
@end
