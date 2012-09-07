//
//  AppDelegate.m
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

#import "DetailViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize masterPopoverButtonItem;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController_iPhone" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        _bannerViewController = [[BannerViewController alloc] initWithContentViewController:self.navigationController];
        self.window.rootViewController = _bannerViewController;

    } else {
        MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController_iPad" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    	
    	masterViewController.detailViewController = detailViewController;
    	
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];        
        _bannerViewController = [[BannerViewController alloc] initWithContentViewController:_splitViewController];
        self.window.rootViewController = _bannerViewController;

    }
    [self.window makeKeyAndVisible];
    [self showSplashView];
    return YES;
}

- (void)showSplashView 
{
    if ([self isiPad]) {
        splashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1004, 768)];
        splashView.image = [UIImage imageNamed:@"Default-Landscape.png"];
    } else {
        splashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        splashView.image = [UIImage imageNamed:@"Default.png"];
    }
    [self.window addSubview:splashView];
	[self.window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:3.0];
    splashView.alpha = 1.0;
	[UIView setAnimationDidStopSelector:@selector(hideSplashView)];
	[UIView commitAnimations];
}

- (void)hideSplashView 
{
	[splashView removeFromSuperview];
	splashView = nil;
}

- (BOOL)isiPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}



@end
