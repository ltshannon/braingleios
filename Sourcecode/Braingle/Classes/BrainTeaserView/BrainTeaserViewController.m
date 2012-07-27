//
//  BrainTeaserViewController.m
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrainTeaserViewController.h"
#import "CustomNavigation.h"
#import <QuartzCore/QuartzCore.h>

@implementation BrainTeaserViewController
@synthesize strCategoryType;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    favoritesArray = [[NSMutableArray alloc] init];
    dataBase     =  [[Database alloc] initialise];
    [self loadNavigation];
    [self CreateBannerForPage];

    docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    pathToDocuments  = [[docDir objectAtIndex:0] copy];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkCategoryType];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self isiPad]) {
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


- (void)dealloc
{
    [super dealloc];
}



- (void)checkCategoryType
{
    if ([strCategoryType isEqualToString:@"Favorites"]) {
        checkFavorite = YES;
        favoritesArray = [dataBase getFavoriteData];
        [RiddlesTableView reloadData];
    } else {
        [self checkFileCreateTime];
        checkFavorite = NO;
        [RiddlesTableView reloadData];
    }
}

- (void)checkFileCreateTime
{
    [self LoadIcon];
    
    NSString *fileName = [NSString stringWithFormat:@"%@",strCategoryType];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[pathToDocuments stringByAppendingPathComponent:fileName]])
    {
        [self loadURL];
    } 
    else 
    {
        NSString* filePath = [pathToDocuments stringByAppendingPathComponent:fileName];
        NSError* error;
        NSDictionary* properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:filePath
                                    error:&error];
        NSDate* modificationDate = [properties objectForKey:NSFileModificationDate];
        NSDate* createDate = [properties objectForKey:NSFileModificationDate];
        
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
        
        if (hours > 86400.0)
        {
            [self loadURL];
        } else {
            NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strCategoryType]]];
            [self parseXMLFileAtURL:data];
        }
    }
}


#pragma mark - Add Action Sheet

-(IBAction)showActionSheet:(id)sender 
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hardest", @"Easiest",@"Most Popular",@"Most Recent",nil ];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:self.view];
    [actionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    [self sortingList:buttonIndex];
}
- (void) sortingList:(NSInteger)indexValue
{
    if ([listArray count] != 0 || favoritesArray != 0) {
        NSSortDescriptor *sortDescriptor;
        
        if (indexValue == 0)
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"difficulty"  ascending:NO];
        }
        else if (indexValue == 1)
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"difficulty"  ascending:YES];
            
        }
        else if (indexValue == 2)
        {
            sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"popularity" ascending:NO];   
        }
        else if(indexValue == 3)
        {
            sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
        }
        else if(indexValue == 4)
        {
            sortDescriptor=nil;
        }
        
        NSArray *descriptors = [[NSArray alloc] init];
        descriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        if (checkFavorite) {
            [favoritesArray sortUsingDescriptors:descriptors];
        } else {
            [listArray sortUsingDescriptors:descriptors];
        }
        [RiddlesTableView reloadData];
    }
}

#pragma mark - Loading Icon Methods

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

#pragma mark - Add Navigation

- (void) loadNavigation {
    self.navigationController.navigationBarHidden=YES;
    CustomNavigation *myCustomNavigation =[[CustomNavigation alloc] initWithNibName:@"CustomNavigation"bundle:nil];
    [self.view addSubview:[myCustomNavigation view]];
    [myCustomNavigation setNavImageView:[UIImage imageNamed:@""]];
    [myCustomNavigation setnavigationImage:NO];
    [myCustomNavigation setBackActive:YES];
    [myCustomNavigation setListActive:YES];
    [myCustomNavigation setInfoActive:NO];    
    [myCustomNavigation setMenubtn:NO];
    [myCustomNavigation setbtnHeart:NO heartImage:NO];
    [myCustomNavigation setLabelNav:YES setText:strCategoryType];
    [myCustomNavigation release];
}

#pragma mark - Button Action

-(IBAction)gotoBack:(id)sender
{
    CATransition *transition = [CATransition animation]; 
    transition.duration = 0.4; 
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
    transition.type = kCATransitionPush; 
    transition.subtype = kCATransitionFromLeft; 
    [self.navigationController.view.layer addAnimation:transition forKey:nil]; 
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Load URL

-(void)loadURL{
    responseData = [[NSMutableData alloc]initWithLength:0];
    NSString *strURL = CATEGORYTYPE_URL(strCategoryType,[OpenUDID  value]);
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strURL = %@",strURL);
    NSURL *url=[NSURL URLWithString:strURL];	
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    urlConnection =  [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)parseXMLFileAtURL:(NSMutableData *)URL{
    NSMutableData *xmlURL   =   [[NSMutableData alloc]initWithData:URL];
    rssParser               = [[NSXMLParser alloc] initWithData:xmlURL];
    [rssParser setDelegate:self];
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    [rssParser parse];
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
    [self removeLoadIcon];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    [connection cancel];
    NSString *strResponseData   = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    if ([strResponseData isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Braingle" message:@"Sorry Feed not Available!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *fileName = [NSString stringWithFormat:[NSString stringWithFormat:@"%@",strCategoryType]];
        [responseData writeToFile:[NSString stringWithFormat:@"%@",[pathToDocuments stringByAppendingPathComponent:fileName]]  atomically:YES];
        
        NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strCategoryType]]];
        [self parseXMLFileAtURL:data];
        
//        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[pathToDocuments stringByAppendingPathComponent:fileName]]];
    }
}


//- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
//{
//    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
//    
//    NSError *error = nil;
//    
//    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
//                    
//                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
//    
//    if(!success){
//        
//        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
//    }
//    
//    return success;
//}

#pragma mark - XML Parsing Delegates


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSString * errorString = [NSString stringWithFormat:@"Unable to download feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
    [self removeLoadIcon];

}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement=[elementName copy];
    
    if([elementName isEqualToString:@"list"])
    {
        listArray=[[NSMutableArray alloc]init];        
    }
    if([elementName isEqualToString:@"row"])
    {
        rowDict=[[NSMutableDictionary alloc]init];
        strid=[[NSMutableString alloc]init];
        strDate=[[NSMutableString alloc]init];
        strTitle=[[NSMutableString alloc]init];
        strPopularity=[[NSMutableString alloc]init];
        strDifficulty=[[NSMutableString alloc]init];
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([currentElement isEqualToString:@"id"])
    {
        [strid appendString:string];
    }
    if([currentElement isEqualToString:@"date"])
    {
        [strDate appendString:string];
        
    }
    if([currentElement isEqualToString:@"title"])
    {
        [strTitle appendString:string];
    }
    if([currentElement isEqualToString:@"popularity"])
    {
        [strPopularity appendString:string];
    }
    if([currentElement isEqualToString:@"difficulty"])
    {
        [strDifficulty appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"row"])
    {
        NSString *idstring=strid;
        idstring=[idstring stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        idstring=[idstring stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *datestring=strDate;
        datestring=[datestring stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        datestring=[datestring stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *titleString=strTitle;
        titleString=[titleString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        titleString=[titleString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *popularitystring=strPopularity;
        popularitystring=[popularitystring stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        popularitystring=[popularitystring stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *difficultystring=strDifficulty;
        difficultystring=[difficultystring stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        difficultystring=[difficultystring stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [rowDict setObject:idstring forKey:@"id"];
		[rowDict setObject:datestring forKey:@"date" ];
        [rowDict setObject:titleString forKey:@"title"];
        [rowDict setObject:popularitystring forKey:@"popularity"];
        [rowDict setObject:difficultystring forKey:@"difficulty"];
        [listArray addObject:rowDict];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{	
    [RiddlesTableView reloadData];
    [self removeLoadIcon];
}

#pragma mark - Table View Delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (checkFavorite) {
        return [favoritesArray count];
    } else {
        return [listArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BrainTeaserCustomCell *cell =(BrainTeaserCustomCell *) [RiddlesTableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BrainTeaserCustomCell" owner:self options:nil];
        cell= Riddlescustom;
    }
    if (checkFavorite) {
        [cell riddleslbl:[[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"title"]];
        [cell setDifficultyImage:[[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"difficulty"]];
        [cell setPopularityImage:[[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"popularity"]];
    } else {
        [cell riddleslbl:[[listArray objectAtIndex:indexPath.row] valueForKey:@"title"]];
        [cell setDifficultyImage:[[listArray objectAtIndex:indexPath.row] valueForKey:@"difficulty"]];
        [cell setPopularityImage:[[listArray objectAtIndex:indexPath.row] valueForKey:@"popularity"]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
    if (checkFavorite) {
        detailViewController.strDetailId = [[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
        detailViewController.selectedDictionary = [favoritesArray objectAtIndex:indexPath.row];
    } else {
        detailViewController.strDetailId = [[listArray objectAtIndex:indexPath.row] valueForKey:@"id"];
        detailViewController.selectedDictionary = [listArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
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
