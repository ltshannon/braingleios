//
//  AppDelegate.h
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "BannerViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate>
{
    IBOutlet UIImageView *splashView;
    BannerViewController    *_bannerViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (nonatomic, retain) UIBarButtonItem *masterPopoverButtonItem;

- (void)showSplashView;
- (void)hideSplashView;
- (BOOL)isiPad;
@end
