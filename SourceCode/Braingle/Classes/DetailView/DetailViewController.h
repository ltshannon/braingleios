//
//  DetailViewController.h
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
#import "Database.h"
#import "Config.h"
#import "OpenUDID.h"
#import "AppDelegate.h"
#import "InfoViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, NSXMLParserDelegate, ADBannerViewDelegate>
{
    IBOutlet UIWebView                  *detailWebView;
    NSString                            *strDetailId;
    
    Database                            *dataBase;
    NSString                            *strFavoriteID;
    NSMutableDictionary                 *selectedDictionary;
    
    NSArray                             *docDir ;
    NSString                            *pathToDocuments ;
    
    NSMutableData                       *responseData;
    NSURLConnection                     *urlConnection;
    
    NSMutableArray                      *favoritesArray;
    BOOL                                isFavorite;
    IBOutlet ADBannerView               *adView;
    
    IBOutlet UIActivityIndicatorView    *activityView;
    IBOutlet UIView                     *loadingView;
    UIButton                            *heartButton;
    NSString                            *strCategory;
    UIBarButtonItem                     *menuBarButtonItem;
}
@property (nonatomic, retain) NSString *strDetailId;
@property (nonatomic,retain) NSMutableDictionary *selectedDictionary;
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, retain)  AppDelegate*applicationDelegate;
@property (nonatomic, readonly) BOOL isViewControllerRootViewController;
@property (nonatomic, readonly) BOOL isViewControllerDetailViewController;

- (void)checkFileCreateTime;
- (void)LoadIcon;
- (void)removeLoadIcon;
- (void)loadURL;
- (void)loadWebView;
- (IBAction)favoritesButtonAction:(id)sender;
- (void)CreateBannerForPage;
- (BOOL)isiPad;

@end


