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

@interface MasterViewController : UITableViewController<ADBannerViewDelegate,UISplitViewControllerDelegate>
{
    NSMutableArray          *teaserSectionOneImageArray;
    NSMutableArray          *teaserSectionTwoImageArray;
    NSMutableArray          *teaserSectionOneArray;
    NSMutableArray          *teaserSectionTwoArray;
    IBOutlet ADBannerView   *adView;
    UIView                  *iAdView;
    float                   table_Y_Position;
    IBOutlet UIView         *infoView;
    BOOL                    isiAdClicked;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) ADBannerView          *adView;
@property (strong, nonatomic) UIView                *iAdView;


- (BOOL)isiPad;
- (IBAction)infoButtonAction:(id)sender;
- (void)autoFeaturedCellSelected:(NSInteger) indexValue;


@end
