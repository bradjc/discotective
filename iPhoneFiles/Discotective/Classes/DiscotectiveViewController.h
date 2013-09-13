//
//  DiscotectiveViewController.h
//  Discotective
//
//  Created by Mike Hand on 4/29/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"

@interface DiscotectiveViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
	IBOutlet UIImageView *sheetMusicImage;
	IBOutlet UIButton *readMusicButton;
	IBOutlet UIButton *cameraButton;
	IBOutlet UIButton *albumButton;
	IBOutlet UILabel  *pictureLabel;
	UIImage *grayScaleImage;
	UIImage *binaryUIImage;
	UIImagePickerController *camera;

}

@property(nonatomic,retain) UIImageView *sheetMusicImage;
@property(nonatomic,retain) UIImagePickerController *camera;
@property(nonatomic,retain) UIButton *readMusicButton;
@property(nonatomic,retain) UIButton *cameraButton;
@property(nonatomic,retain) UIButton *albumButton;
@property(nonatomic,retain) UIImage *grayScaleImage;
@property(nonatomic,retain) UIImage *binaryUIImage;
@property(nonatomic,retain)  UILabel  *pictureLabel;
-(IBAction) readMusicButtonPressed:(id)sender;
-(IBAction) playMusicButtonPressed:(id)sender;
-(IBAction) cameraButtonPressed:(id)sender;
-(IBAction) albumButtonPressed:(id)sender;

@end

