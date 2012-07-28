//
//  DetailViewController.h
//  Braingle
//
//  Created by ocs on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "OpenUDID.h"
#import "Database.h"
#import "CustomNavigation.h"
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"


@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,NSXMLParserDelegate,ADBannerViewDelegate>
{
    IBOutlet UIWebView *detailWebView;
    NSString *strDetailId;
    
    NSArray                             *docDir ;
    NSString                            *pathToDocuments ;
    
    NSMutableData                       *responseData;
    NSURLConnection                     *urlConnection;
    
    Database                            *dataBase;
    NSString                            *strFavoriteID;
    NSMutableDictionary                 *selectedDictionary;
    
    IBOutlet UIActivityIndicatorView    *activityView;
    IBOutlet UIView                     *loadingView;
    
    NSMutableArray                      *favoritesArray;
    CustomNavigation                    *myCustomNavigation;
    BOOL                                isFavorite;
    IBOutlet ADBannerView               *adView;
    UIInterfaceOrientation              deviceOrientation;

}
@property(nonatomic, retain) NSString *strDetailId;
@property(nonatomic, retain) NSMutableDictionary *selectedDictionary;
@property (nonatomic,retain)UIPopoverController       *masterPopoverController;
@property (nonatomic,retain)AppDelegate               *appdelegate;
@property (nonatomic, readonly) BOOL isViewControllerRootViewController;
@property (nonatomic, readonly) BOOL isViewControllerDetailViewController;


- (void)loadURL;
- (void)loadWebView;
- (void)checkFileCreateTime;
- (void)loadNavigation ;
- (IBAction)gotoBack:(id)sender;
- (void)LoadIcon;
- (void)removeLoadIcon;
- (void)CreateBannerForPage;
- (BOOL)isiPad;

@end
