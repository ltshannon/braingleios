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

@class DetailViewController;

@interface HomeViewController : UIViewController<ADBannerViewDelegate>
{
    NSMutableArray           *TeasersectionOneArray;
    NSMutableArray           *TeasersectionTwoArray;
    IBOutlet HomeCustomCell  *customcell;
    IBOutlet UITableView     *homeTable;
    NSMutableArray           *teaserImageOneArray;
    NSMutableArray           *teaserImageTwoArray;
    IBOutlet ADBannerView    *adView;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

- (void)loadNavigation;
- (BOOL)isiPad;
- (void)CreateBannerForPage;

@end
