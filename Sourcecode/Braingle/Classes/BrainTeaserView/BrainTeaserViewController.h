//
//  BrainTeaserViewController.h
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrainTeaserCustomCell.h"
#import "DetailViewController.h"
#import "Config.h"
#import "OpenUDID.h"
#import "Database.h"
#import <iAd/iAd.h>

@interface BrainTeaserViewController : UIViewController<NSXMLParserDelegate,UIActionSheetDelegate,UITableViewDelegate,ADBannerViewDelegate>
{
    NSMutableArray *RiddlesArray;
    IBOutlet BrainTeaserCustomCell *Riddlescustom;
    IBOutlet UITableView *RiddlesTableView;
    
    
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
    NSString                  *strCategoryType;
    
    NSArray                   *docDir ;
    NSString                  *pathToDocuments ;
    
    
    IBOutlet UIActivityIndicatorView *activityView;
    IBOutlet UIView *loadingView;
    
    Database                  *dataBase;
    NSMutableArray            *favoritesArray;
    BOOL                      checkFavorite;
    IBOutlet ADBannerView     *adView;

}

@property(nonatomic, retain) NSString   *strCategoryType;

- (void)loadURL;
- (void)loadNavigation;
- (void)checkFileCreateTime;
- (IBAction)gotoBack:(id)sender;
- (void)LoadIcon;
- (void)removeLoadIcon;
- (void) sortingList:(NSInteger)indexValue;
//- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
- (void)CreateBannerForPage;
- (void)checkCategoryType;
- (BOOL)isiPad;
-(void)parseXMLFileAtURL:(NSMutableData *)URL;

@end
