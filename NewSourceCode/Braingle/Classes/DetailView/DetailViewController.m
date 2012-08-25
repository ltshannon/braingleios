//
//  DetailViewController.m
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "DetailViewController.h"


@implementation DetailViewController
@synthesize strDetailId,strTypeOfCategory;
@synthesize selectedDictionary;
@synthesize brainDelegate;

@synthesize masterPopoverController = _masterPopoverController;
@synthesize applicationDelegate = _applicationDelegate;

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
    [self.view addSubview:appDelegate.iAdView_iPhone];    
    [self webViewAction];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [appDelegate.iAdView_iPhone removeFromSuperview];    
    strDetailId = @"";
    if([detailWebView isLoading])
    {
        [detailWebView stopLoading];
        detailWebView.delegate = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self isiPad]) 
    {
        if (self.isViewControllerRootViewController && self.isViewControllerDetailViewController)
        { 
            if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) 
            {
                self.navigationItem.leftBarButtonItem = nil;
            } 
            else 
            {
                [[self navigationItem] setLeftBarButtonItem:self.applicationDelegate.masterPopoverButtonItem];
            }
        }
        return YES;
    } 
    else 
    {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
            appDelegate.iAdBanner_iPhone.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        else
            appDelegate.iAdBanner_iPhone.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        return YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //    [self CreateBannerForPage];
    
    if (![self isiPad])
    {
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
        {
            [appDelegate.iAdView_iPhone setFrame:CGRectMake(0, 367, 320, 50)];
            appDelegate.iAdBanner_iPhone.frame = CGRectMake(0, 0, 320, 50);
            [loadingView setFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
        }
        else 
        {
            [appDelegate.iAdView_iPhone setFrame:CGRectMake(0, 237, 480, 50)];
            appDelegate.iAdBanner_iPhone.frame = CGRectMake(0, 0, 480, 50);
            [loadingView setFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
        }
    }
 
    if ([self isiPad])
    {
        if(strTypeOfCategory != NULL)
        {
            if ([strTypeOfCategory isEqualToString:@"Static"]) {
                heartButton.hidden = YES;
                [self loadStaticHTML];
            }
        }
    }
}

#pragma mark - Dismiss Master View

- (void)dismissMasterView
{
    //Dismiss master view
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    } 
}

#pragma mark - Check & Load the Web View

- (void)webViewAction
{
    self.title = @"Brain Teaser";
    isFavorite = NO;
    favoritesArray=[[NSMutableArray alloc]init];
    dataBase=[[Database alloc]initialise];
    heartButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [heartButton setFrame:CGRectMake(271, 11, 32, 29)];
    [heartButton addTarget:self action:@selector(favoritesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [heartButton setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:heartButton];
    
    if (strDetailId == NULL || [strDetailId isEqualToString:@""] || [strDetailId isEqualToString:@"(null)"]) {
        strDetailId = @"Featured";
    }
    
    favoritesArray=[dataBase getFavoriteData];
    docDir=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    pathToDocuments=[[docDir objectAtIndex:0]copy];
    NSString *fileName=[NSString stringWithFormat:@"FeatureID"];
    if([strTypeOfCategory isEqualToString:@"Static"])
    {
        heartButton.hidden = YES;
        [self loadStaticHTML];
    }
    else
    {
        if ([strDetailId isEqualToString:@"Featured"]) 
        {
            //Check the file exist or not.
            
            heartButton.hidden = YES;
            if (![[NSFileManager defaultManager] fileExistsAtPath:[pathToDocuments stringByAppendingPathComponent:fileName]])
            {
                if(([[Reachability sharedReachability] internetConnectionStatus] == NotReachable))
                {
                    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Braingle" message:@"No Network Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [errorAlert show];
                    [self removeLoadIcon];
                }
                else 
                {
                    [self loadURL];
                }
            }
            else 
            {
                [self checkFileCreateTime];
            }
        } else 
        {
            heartButton.hidden = NO;
            [self loadWebView];
        }
        
        for (int i = 0; i < [favoritesArray count]; i++)
        {
            if ([[[favoritesArray objectAtIndex:i] valueForKey:@"id"] isEqualToString:[selectedDictionary valueForKey:@"id"]]) 
            {
                [heartButton setImage:[UIImage imageNamed:@"fav-active.png"] forState:UIControlStateNormal];
                isFavorite = YES;
            } 
        }
    }
}

#pragma mark - Split view methods


- (BOOL)isViewControllerDetailViewController {
    
    NSArray *controllersArray = [[self.applicationDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers];
    
    return (self == [controllersArray lastObject]) ? YES : NO;
}

- (BOOL)isViewControllerRootViewController {
    
    return  ([self.navigationController.viewControllers objectAtIndex:0] == self) ? YES : NO;
}

#pragma mark - Load Webview

    
- (void)loadWebView
{
    NSLog(@"strDetailId = %@",strDetailId);
    NSString *fileName = [NSString stringWithFormat:@"%@.html",strDetailId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[pathToDocuments stringByAppendingPathComponent:fileName]])
    {
        NSLog(@"Load from URL");
        NSString *urlAddress = DETAILVIEW_URL(strDetailId, [OpenUDID value]);
        NSLog(@"urlAddress = %@",urlAddress);
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAddress]];

        if(([[Reachability sharedReachability] internetConnectionStatus] == NotReachable))
        {
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Braingle" message:@"Network not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            [self removeLoadIcon];
        }
        else 
        {
            NSURL *url = [NSURL URLWithString:urlAddress];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [detailWebView loadRequest:requestObj];
            [htmlData writeToFile:[NSString stringWithFormat:@"%@",[pathToDocuments stringByAppendingPathComponent:fileName]]  atomically:YES];
        }

    }
    else 
    {
        NSLog(@"Load from local");
        NSURL *url = [NSURL fileURLWithPath:[pathToDocuments stringByAppendingPathComponent:fileName]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [detailWebView loadRequest:request];
    }
}
- (void)loadStaticHTML
{
    if([strTypeOfCategory isEqualToString:@"Static"])
    {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
        {
            NSString *URlStr=[NSString stringWithFormat:@"%@/TeaserDetailPortrait.html",[[NSBundle mainBundle] resourcePath]];
            [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:URlStr]]];
            NSLog(@"Portrait");
        }
        else
        {
            NSString *URlStr=[NSString stringWithFormat:@"%@/TeaserDetailLandscape.html",[[NSBundle mainBundle] resourcePath]];
            [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:URlStr]]];
            NSLog(@"Landscape");
            
        }
    }
}


- (void)checkFileCreateTime
{
    NSString *fileName = [NSString stringWithFormat:@"FeatureID"];
    NSString* filePath = [pathToDocuments stringByAppendingPathComponent:fileName];
    NSError* error;
    NSDictionary* properties = [[NSFileManager defaultManager]
                                attributesOfItemAtPath:filePath
                                error:&error];
    NSDate *modificationDate = [properties objectForKey:NSFileModificationDate];
    NSDate *createDate = [properties objectForKey:NSFileCreationDate];
    
    NSLog(@"createDate = %@",createDate);
    NSLog(@"modificationDate = %@",modificationDate);
    
    NSDate* firstDate = modificationDate;
    NSDate* secondDate = [NSDate date];
    
    NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
    
    double seconds = timeDifference;
    double minutes = seconds/60;
    double hours = minutes/60;
    double days = minutes/1440;
    
    NSLog(@"days = %.0f, hours = %.0f, minutes = %.0f, seconds = %.0f", days, hours, minutes, seconds);
    
    //If check the file create 24hrs.  
    
    if (seconds > 86400.0)
    {
        if(([[Reachability sharedReachability] internetConnectionStatus] == NotReachable))
        {
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Braingle" message:@"No Network Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            [self removeLoadIcon];
        }
        else 
        {
            [self loadURL];
        }
    } else {
        
        NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:fileName]];
        
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        strDetailId = strData;
        
        [self loadWebView];
    }
}

-(void)loadURL{
    
    //Loading the URL.
    
    responseData = [[NSMutableData alloc]initWithLength:0];
    NSString *strURL = FEATURED_URL([OpenUDID  value]);
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strURL = %@",strURL);
    NSURL *url=[NSURL URLWithString:strURL];	
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    urlConnection =  [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - Connection Delegates


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSLog(@"%@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Retrieving the data
    [connection cancel];
    NSString *strResponseData   = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    NSString *fileName = [NSString stringWithFormat:@"FeatureID"];
    [responseData writeToFile:[NSString stringWithFormat:@"%@",[pathToDocuments stringByAppendingPathComponent:fileName]]  atomically:YES];
    strDetailId = strResponseData;
    [self loadWebView];
}
#pragma mark - Web View Delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self LoadIcon];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeLoadIcon];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [self removeLoadIcon];
}

#pragma mark - Loading icon methods


-(void)LoadIcon
{
    //Remove Loading icon.
    if (loadingView != NULL) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    //Add loading icon
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
	[loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	[loadingView.layer setMasksToBounds:YES];
	[loadingView.layer setCornerRadius:10.0];    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityView setFrame:CGRectMake(21, 21, 37, 37)];
	[activityView setHidesWhenStopped:YES];
	[activityView startAnimating];
	[loadingView addSubview:activityView];
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
}

- (void)removeLoadIcon
{
    [loadingView removeFromSuperview];
}

#pragma mark - ADBannerView Delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{    
    if ([self isiPad]) {
        [appDelegate.iAdView setHidden:NO];
    }
    else {
        [appDelegate.iAdView_iPhone setHidden:NO];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if ([self isiPad]) {
        [appDelegate.iAdView setHidden:YES];
    }
    else {
        [appDelegate.iAdView_iPhone setHidden:YES];
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

#pragma mark - Button Action


- (IBAction)favoritesButtonAction:(id)sender
{
    if (isFavorite) {
        
        //Add to favorites.
        
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
        [dataBase removeFavoriteData:[selectedDictionary valueForKey:@"id"]]; 
        isFavorite = NO;
    } else {
        
        //Remove from favorites.
        
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"fav-active.png"] forState:UIControlStateNormal];
        [dataBase addFavoriteData:selectedDictionary]; 
        isFavorite = YES;

    }  
    if ([strTypeOfCategory isEqualToString:@"Favorite"]) {
        [self.brainDelegate reloadTableView];
    }
}
							
#pragma mark - Split view Delegates

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{    
    //Add menu button
    menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:barButtonItem.target action:barButtonItem.action];
    [self.navigationItem setLeftBarButtonItem:menuBarButtonItem animated:YES];
    self.masterPopoverController = popoverController;
    self.applicationDelegate.masterPopoverButtonItem = menuBarButtonItem;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //Remove menu button
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Check Device
         
- (BOOL)isiPad 
{
    //Check device
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

@end
