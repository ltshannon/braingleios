//
//  AppDelegate.m
//  Braingle
//
//  Created by ocs on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"

#import "DetailViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize splashView;
@synthesize masterPopoverButtonItem;
- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [_splitViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        HomeViewController *masterViewController = [[[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone" bundle:nil] autorelease];
        self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
        self.window.rootViewController = self.navigationController;
    } else {
        HomeViewController *masterViewController = [[[HomeViewController alloc] initWithNibName:@"HomeViewController_iPad" bundle:nil] autorelease];
        UINavigationController *masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
        
        DetailViewController *detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil] autorelease];
        UINavigationController *detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];
    	
    	masterViewController.detailViewController = detailViewController;
    	
        self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        
        self.window.rootViewController = self.splitViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}




-(void)showSplashView {
    //set a image frame for splashscreen.
    if([self isiPad])
    {
        if (deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Portrait.png"]]];
        }        
        else {
            [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Landscape.png"]]];
        } 

    }
    else
    {
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];	
	
	//And then load a content.
	splashView.image = [UIImage imageNamed:@"Default.png"];
    }
	//image should placed a window. 
	[self.window addSubview:splashView];
	[self.window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
	
	//add a delegate.
	[UIView setAnimationDelegate:self];
	
	//set a timer for splashscreen image.
	[UIView setAnimationDuration:3.0];
	[UIView setAnimationDidStopSelector:@selector(hideSplashView)];
	//imageSplashView.alpha = 0.99;
	[UIView commitAnimations];
	
}

- (void)hideSplashView 
{	
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.splashView removeFromSuperview];
    self.splashView                 = nil;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)isiPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;

    {
        if( [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait || 
           [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
        {
        }
                  
        else  if( [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft || 
                 [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)
        {
                  }
    }
}
    - (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
    {
        if(toInterfaceOrientation==UIInterfaceOrientationPortrait || toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
        {
            
        }
        else if((toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft ) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight))
        {
        }
    }

@end
