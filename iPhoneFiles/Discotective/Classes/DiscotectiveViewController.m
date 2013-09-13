//
//  DiscotectiveViewController.m
//  Discotective
//
//  Created by Mike Hand on 4/29/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "DiscotectiveViewController.h"
#import "ImageHandler.h"
#import "allocate.h"
#import "preprocessing.h"
#import "global.h"
#import "image_functions.h"
#import "segmentation.h"
#import "scanning.h"
#import "classification.h"
#import "run.h"
#import	<stdint.h>
#import <unistd.h>
#import <dispatch/dispatch.h>
#define SIMULATED


@implementation DiscotectiveViewController
@synthesize sheetMusicImage,grayScaleImage,binaryUIImage,readMusicButton,camera,cameraButton,albumButton,pictureLabel;


-(IBAction) readMusicButtonPressed:(id)sender{
	//Preprocessing..........................
	dispatch_queue_t binarizeQueue;
	binarizeQueue=dispatch_queue_create("discotective.binarizeQueue", NULL);
	
	readMusicButton.enabled=FALSE;
	
	dispatch_async(binarizeQueue, ^{
		
		uint8_t*		RGBAArray;
		linked_list*	all_notes;
	
		// get the image from the ?
		int *width=malloc(sizeof(int));
		int *height=malloc(sizeof(int));
		RGBAArray = [[ImageHandler getImageHandler] UIImageToRGBAArray:grayScaleImage outWidth:width outHeight:height];
		
		
		all_notes = run(RGBAArray,*height,*width);
		
	});
	
	
	
		
	
	
}
-(IBAction) cameraButtonPressed:(id)sender{
	camera.sourceType=UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:camera  animated:YES];
}
-(IBAction) albumButtonPressed:(id)sender{
	camera.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	[self presentModalViewController:camera animated: YES];
}

-(IBAction) playMusicButtonPressed:(id)sender{
}
				 
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
	NSLog(@"picked Image"	);

	grayScaleImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
	sheetMusicImage.image=[grayScaleImage retain];
	sheetMusicImage.hidden=NO;
	cameraButton.hidden=YES;
	albumButton.hidden=YES;
	pictureLabel.hidden=YES;
	[self dismissModalViewControllerAnimated:YES];
	readMusicButton.hidden=NO;
	
	
 }

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	camera=[[UIImagePickerController alloc] init];
	camera.allowsEditing=NO;
	readMusicButton.hidden=YES;
	camera.delegate=self;
	if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		cameraButton.enabled=NO;
		cameraButton.hidden=YES;
		camera.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}else {
		camera.sourceType=UIImagePickerControllerSourceTypeCamera;
	}
	
#ifdef SIMULATED
	[[ImageHandler getImageHandler] linkImageView: sheetMusicImage];
    [super viewDidLoad];
	NSBundle *myBundle=[NSBundle mainBundle];
	NSLog(@"%@",myBundle);
	NSString *imagePath=[myBundle pathForResource:@"grandma" ofType:@"jpg"];
	grayScaleImage=[[UIImage alloc]initWithContentsOfFile:imagePath];
	//UIImageWriteToSavedPhotosAlbum(grayScaleImage,nil,nil,nil);
	NSLog(@"%@",imagePath);
	sheetMusicImage.image=[grayScaleImage retain];
	sheetMusicImage.hidden=NO;
	cameraButton.hidden=YES;
	albumButton.hidden=YES;
	pictureLabel.hidden=YES;
	readMusicButton.hidden=NO;
#else
	 [super viewDidLoad];
#endif
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[grayScaleImage release];
	[sheetMusicImage release];
    [super dealloc];
}

@end
