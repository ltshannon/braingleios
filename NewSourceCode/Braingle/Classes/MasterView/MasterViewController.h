//
//  MasterViewController.h
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "InfoViewController.h"
#import "BrainTeaserViewController.h"
#import "AppDelegate.h"

@interface MasterViewController : UITableViewController<ADBannerViewDelegate,UISplitViewControllerDelegate>
{
    NSMutableArray          *teaserSectionOneImageArray;
    NSMutableArray          *teaserSectionTwoImageArray;
    NSMutableArray          *teaserSectionOneArray;
    NSMutableArray          *teaserSectionTwoArray;
    IBOutlet UIView         *infoView;

    //iAd
    ADBannerView            *master_iAdBanner;
    UIView                  *master_iAdView;
    float                   table_Y_Position;
    BOOL                    isiAdClicked;
    AppDelegate             *appDelegate;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

- (BOOL)isiPad;
- (IBAction)infoButtonAction:(id)sender;
- (void)autoFeaturedCellSelected:(NSInteger) indexValue;
- (void)addBannerView;
- (void)masterAddBannerView;
- (void)addBannerView;

@end
