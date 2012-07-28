//
//  MasterViewController.h
//  Braingle
//
//  Created by ocs on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCustomCell.h"
#import <iAd/iAd.h>
#import "DetailViewController.h"
#import "HomeCustomCell.h"
#import "BrainTeaserViewController.h"
#import "InfoViewController.h"
#import "CustomNavigation.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@class DetailViewController;

@interface HomeViewController : UIViewController<ADBannerViewDelegate,UISplitViewControllerDelegate>
{
    NSMutableArray           *TeasersectionOneArray;
    NSMutableArray           *TeasersectionTwoArray;
    IBOutlet HomeCustomCell  *customcell;
    IBOutlet UITableView     *homeTable;
    NSMutableArray           *teaserImageOneArray;
    NSMutableArray           *teaserImageTwoArray;
    UIPopoverController      *masterPopoverController;
    CustomNavigation         *myCustomNavigation;
    IBOutlet ADBannerView    *adView;
    AppDelegate              *appdelegate;
}

@property (strong, nonatomic) DetailViewController    *detailViewController;
@property (nonatomic,retain)UIPopoverController       *masterPopoverController;
@property (nonatomic,retain)AppDelegate               *appdelegate;
@property (nonatomic, readonly) BOOL isViewControllerRootViewController;
@property (nonatomic, readonly) BOOL isViewControllerDetailViewController;

- (void)loadNavigation;
- (BOOL)isiPad;
- (void)CreateBannerForPage;

@end
