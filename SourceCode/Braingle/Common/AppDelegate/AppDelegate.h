//
//  AppDelegate.h
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    IBOutlet UIImageView *splashView;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (nonatomic, retain) UIBarButtonItem *masterPopoverButtonItem;



- (void)showSplashView;
- (void)hideSplashView;
- (BOOL)isiPad;
@end
