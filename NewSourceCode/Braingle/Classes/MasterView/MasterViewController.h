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
#import "BraingleTableViewController.h"
#import "AppDelegate.h"

@interface MasterViewController : UITableViewController<ADBannerViewDelegate,UISplitViewControllerDelegate>
{
    NSMutableArray          *teaserSectionOneImageArray;
    NSMutableArray          *teaserSectionTwoImageArray;
    NSMutableArray          *teaserSectionOneArray;
    NSMutableArray          *teaserSectionTwoArray;
    IBOutlet UIView         *infoView;

    float                   table_Y_Position;
    BOOL                    isiAdClicked;
    AppDelegate             *appDelegate;
    BOOL                    isFirstCellHilight;

}

@property (strong, nonatomic) DetailViewController *detailViewController;

- (BOOL)isiPad;
- (IBAction)infoButtonAction:(id)sender;
- (void)autoFeaturedCellSelected:(NSInteger) indexValue;
- (void)showFirstCellHilighted;

@end
