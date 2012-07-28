//
//  AppDelegate.h
//  Braingle
//
//  Created by ocs on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,ADBannerViewDelegate>
{
    IBOutlet UIImageView *splashView;
    UIInterfaceOrientation deviceOrientation;

}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (nonatomic,retain) IBOutlet  UIImageView *splashView;

@property (nonatomic, retain) UIBarButtonItem *masterPopoverButtonItem;

- (BOOL)isiPad;
@end
