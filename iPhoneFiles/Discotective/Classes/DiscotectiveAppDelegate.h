//
//  DiscotectiveAppDelegate.h
//  Discotective
//
//  Created by Mike Hand on 4/29/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscotectiveViewController;

@interface DiscotectiveAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DiscotectiveViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DiscotectiveViewController *viewController;

@end

