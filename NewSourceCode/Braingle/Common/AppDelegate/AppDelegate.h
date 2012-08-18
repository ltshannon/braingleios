//
//  AppDelegate.h
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate>
{
    IBOutlet UIImageView *splashView;
    
    //iAd
    ADBannerView            *iAdBanner;
    UIView                  *iAdView;
    ADBannerView            *iAdBanner_iPhone;
    UIView                  *iAdView_iPhone;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (nonatomic, retain) UIBarButtonItem *masterPopoverButtonItem;

@property (strong, nonatomic) ADBannerView *iAdBanner;

@property (strong, nonatomic) UIView *iAdView;

@property (strong, nonatomic) ADBannerView *iAdBanner_iPhone;

@property (strong, nonatomic) UIView *iAdView_iPhone;

- (void)showSplashView;
- (void)hideSplashView;
- (BOOL)isiPad;
@end
