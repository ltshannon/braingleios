//
//  DetailViewController.m
//  Braingle
//
//  Created by ocs on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
@implementation DetailViewController
@synthesize strDetailId,selectedDictionary;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    favoritesArray = [[NSMutableArray alloc] init];
    dataBase     =  [[Database alloc] initialise];
    myCustomNavigation =[[CustomNavigation alloc] initWithNibName:@"CustomNavigation"bundle:nil];
    favoritesArray = [dataBase getFavoriteData];

    [self loadNavigation];
    [self CreateBannerForPage];

    docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    pathToDocuments  = [[docDir objectAtIndex:0] copy];
    NSString *fileName = [NSString stringWithFormat:@"FeatureID"];
    NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:fileName]];
    
    NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"strData = %@",strData);
    
    if ([strDetailId isEqualToString:@"Featured"]) 
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[pathToDocuments stringByAppendingPathComponent:fileName]])
        {
            [self loadURL];
        }
        else 
        {
            [self checkFileCreateTime];
        }
    } else 
    {
        [self loadWebView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if([detailWebView isLoading])
    {
        [detailWebView stopLoading];
        detailWebView.delegate = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self isiPad]) {
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

#pragma mark - Add Navigation

- (void) loadNavigation {
    isFavorite = NO;
    self.navigationController.navigationBarHidden=YES;
    [self.view addSubview:[myCustomNavigation view]];
    [myCustomNavigation setNavImageView:[UIImage imageNamed:@"logo.png"]];
    [myCustomNavigation setBackActive:YES];
    [myCustomNavigation setListActive:NO];
    [myCustomNavigation setInfoActive:NO];
    [myCustomNavigation setMenubtn:NO];
    
    if ([strDetailId isEqualToString:@"Featured"]) 
    {
        [myCustomNavigation setbtnHeart:NO heartImage:NO];
    } 
    else 
    {
        [myCustomNavigation setbtnHeart:YES heartImage:NO];
        for (int i = 0; i < [favoritesArray count]; i++)
        {
            if ([[[favoritesArray objectAtIndex:i] valueForKey:@"id"] isEqualToString:[selectedDictionary valueForKey:@"id"]]) 
            {
                [myCustomNavigation setbtnHeart:YES heartImage:YES];
                isFavorite = YES;
            } 
        }
    }
    [myCustomNavigation setLabelNav:YES setText:@""];
    [myCustomNavigation release];
}

#pragma mark - Button Action

-(IBAction)gotoBack:(id)sender
{
    if([detailWebView isLoading])
    {
        [detailWebView stopLoading];
        detailWebView.delegate = nil;
    }
    
    CATransition *transition = [CATransition animation]; 
    transition.duration = 0.4; 
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
    transition.type = kCATransitionPush; 
    transition.subtype = kCATransitionFromLeft; 
    [self.navigationController.view.layer addAnimation:transition forKey:nil]; 
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Load Web View

- (void)loadWebView
{
    NSString *urlAddress = DETAILVIEW_URL(strDetailId, [OpenUDID value]);
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAddress]];
    NSString *fileName = [NSString stringWithFormat:@"%@.html",strDetailId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[pathToDocuments stringByAppendingPathComponent:fileName]])
    {
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [detailWebView loadRequest:requestObj];
        [htmlData writeToFile:[NSString stringWithFormat:@"%@",[pathToDocuments stringByAppendingPathComponent:fileName]]  atomically:YES];
    }
    else 
    {
        NSURL *url = [NSURL fileURLWithPath:[pathToDocuments stringByAppendingPathComponent:fileName]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [detailWebView loadRequest:request];
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
    
    if (seconds > 86400.0)
    {
        [self loadURL];
    } else {
        
        NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:fileName]];
        
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        strDetailId = strData;
        
        [self loadWebView];
    }
}

-(void)loadURL{
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
    [connection cancel];
    NSString *strResponseData   = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    NSString *fileName = [NSString stringWithFormat:@"FeatureID"];
    [responseData writeToFile:[NSString stringWithFormat:@"%@",[pathToDocuments stringByAppendingPathComponent:fileName]]  atomically:YES];
    strDetailId = strResponseData;
    [self loadWebView];
}

- (IBAction)favoritesButtonAction:(id)sender
{    
    if (isFavorite) {
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
        [dataBase removeFavoriteData:[selectedDictionary valueForKey:@"id"]]; 
                
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Braingle" message:@"Successfully removed from favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];

        
    } else {
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"fav-active.png"] forState:UIControlStateNormal];
        [dataBase addFavoriteData:selectedDictionary]; 
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Braingle" message:@"Successfully added to favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }    
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
    if (loadingView != NULL) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
	[loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	//Enable maskstobound so that corner radius would work.
	[loadingView.layer setMasksToBounds:YES];
	//Set the corner radius
	[loadingView.layer setCornerRadius:10.0];    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityView setFrame:CGRectMake(21, 21, 37, 37)];
	[activityView setHidesWhenStopped:YES];
	[activityView startAnimating];
    //    [loadingView setAlpha:0.5];
	[loadingView addSubview:activityView];
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
	[activityView release];
}

- (void)removeLoadIcon
{
    [loadingView removeFromSuperview];
}

#pragma mark - Load iAd

-(void)CreateBannerForPage
{
    UIView *vw_Adds=[[UIView alloc]init];
    [vw_Adds setFrame:CGRectMake(0, 410, 320, 50)];
    [vw_Adds setClipsToBounds:YES];
    [vw_Adds setClearsContextBeforeDrawing:YES];
    adView=[[ADBannerView alloc]init];
    adView.frame = CGRectOffset(adView.frame, 0, -50);
    adView.delegate=self;
    
    [vw_Adds addSubview:adView];
    [self.view addSubview:vw_Adds];
    [vw_Adds release];
}

#pragma mark - ADBannerView Delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [adView setHidden:NO];
    banner.frame = CGRectOffset(banner.frame, 0, 50);
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    banner.frame = CGRectOffset(banner.frame, 0, -50);
    [adView setHidden:YES];
}

#pragma mark - Check Device

- (BOOL)isiPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

@end
