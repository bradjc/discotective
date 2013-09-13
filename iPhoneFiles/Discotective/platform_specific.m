//
//  platform_specific.m
//  Discotective
//
//  Created by Mike Hand on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "platform_specific.h"
#import "ImageHandler.h"
#import <unistd.h>

#include <stdlib.h>
#include <stdarg.h>
#import <dispatch/dispatch.h>
#import<AVFoundation/AVFoundation.h>

#define	audioFilePath @"audio.wave"


void disco_log (const char *fmt, ...){
	va_list		arg;
	
	va_start(arg, fmt);
	vprintf(fmt, arg);
	printf("\n");
	va_end(arg);
}

void disco_log_nol (const char *fmt, ...){
	va_list		arg;
	
	va_start(arg, fmt);
	vprintf(fmt, arg);
	va_end(arg);
}

void display_image (uint8_t *data, uint16_t height, uint16_t width){
	dispatch_queue_t	mainQueue;
	mainQueue		= dispatch_get_main_queue();
	UIImage* binaryUIImage	= [[ImageHandler getImageHandler] createUIImageFromBinaryImage:data withWidth:width andHeight:height];
	[[[ImageHandler getImageHandler] getImageView].image release];
	
	//Finished Preprocessing..........................
	
	dispatch_sync(mainQueue, ^{
		[[ImageHandler getImageHandler] getImageView].image	= [binaryUIImage retain];
	});
	
	//free(data);
}

void trigger_error (){
	int a=8;
	int b=0;
	int c;
	c=a/b;
}


void createAudioFile(uint8_t* data, uint32_t length){
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath=[documentsDirectory stringByAppendingPathComponent:audioFilePath];
	NSData* dataForFile=[NSData dataWithBytesNoCopy:data length:length];
	[dataForFile writeToFile:filePath atomically:YES];
}

void playAudioFile(const char* fileName){
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* file=[NSString stringWithCString:fileName encoding:NSASCIIStringEncoding];
	NSLog(@"%@",file);
	NSString *filePath=[documentsDirectory stringByAppendingPathComponent:file];
	NSLog(@"%@", filePath);
	NSURL* fileURL=[[NSURL alloc]initFileURLWithPath:filePath];
	//TODO this doesn't appear to work
	NSLog(@"%@",fileURL);
	NSError** err=nil;
	AVAudioPlayer* audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:err];
	NSLog(@"%@",err);
	if(!err){
		NSLog(@"PLAYING");
		[audioPlayer play];
	}
}





