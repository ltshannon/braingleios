//
//  BrainTeaserViewController.h
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "Config.h"
#import "OpenUDID.h"
#import "Reachability.h"
#import "Database.h"
#import <iAd/iAd.h>
#import "AppDelegate.h"

@interface BrainTeaserViewController : UIViewController<NSXMLParserDelegate, UIActionSheetDelegate, ADBannerViewDelegate, UISplitViewControllerDelegate,BrainTeaserViewControllerDelegate>
{
    IBOutlet UITableView      *brainTeaserTableView;
    NSString                  *strCategoryType;
    BOOL                      isiAdClicked;
    //XML
    NSXMLParser               *rssParser;
    NSMutableData             *responseData;
    NSURLConnection           *urlConnection;
    NSString                  *currentElement;
    NSMutableString           *strid;
    NSMutableString           *strDate;
    NSMutableString           *strTitle;
    NSMutableString           *strPopularity;
    NSMutableString           *strDifficulty;
    NSMutableArray            *listArray;
    NSMutableDictionary       *rowDict;
    NSArray                   *docDir ;
    NSString                  *pathToDocuments ;
    //Database
    Database                  *dataBase;
    NSMutableArray            *favoritesArray;
    BOOL                      checkFavorite;
    NSSortDescriptor          *sortDescriptor;
    //Rating icon
    UILabel                 *titleLabel;
    UIImageView             *starImage1;
    UIImageView             *starImage2;
    UIImageView             *starImage3;
    UIImageView             *starImage4;
    UIImageView             *gearImage1;
    UIImageView             *gearImage2;
    UIImageView             *gearImage3;
    UIImageView             *gearImage4;
    //Loading icon
    IBOutlet UIActivityIndicatorView    *activityView;
    IBOutlet UIView                     *loadingView;
    NSUInteger                          selectedRow;
    UIActionSheet                       *sortActionSheet;
    //iAd
    AppDelegate                         *appDelegate;
    
    ADBannerView                        *brainTeaser_iAdBanner;
    UIView                              *brainTeaser_iAdView;
}
@property(nonatomic, retain) NSString    *strCategoryType;
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) DetailViewController *detailViewController;

- (IBAction)sortButtonAction:(id)sender;
- (void)parseXMLFileAtURL:(NSMutableData *)URL;
- (void)loadURL;
- (void)checkFileCreateTime;
- (void)LoadIcon;
- (void)removeLoadIcon;
- (void)checkCategoryType;
- (void)sortingList:(NSInteger)indexValue;
- (void)setPopularityImages:(NSString *) popularityValue;
- (void)setDifficultyImages:(NSString *) difficultyValue;
- (BOOL)isiPad;
- (void)brainTeaserAddBannerView;

@end

