//
//  BrainTeaserViewController.m
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrainTeaserViewController.h"

@implementation BrainTeaserViewController
@synthesize strCategoryType;

#pragma mark - View Life Cycle

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortButtonAction:)];
    self.navigationItem.rightBarButtonItem = sortButton;
    [sortButton release];
    
    favoritesArray = [[NSMutableArray alloc] init];
    dataBase     =  [[Database alloc] initialise];
    self.title = @"Brain Teaser";;
    docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    pathToDocuments  = [[docDir objectAtIndex:0] copy];
    if (![self isiPad])
    {
        [self CreateBannerForPage];
    }
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

- (void)checkCategoryType
{
    if ([strCategoryType isEqualToString:@"Favorites"]) {
        checkFavorite = YES;
        favoritesArray = [dataBase getFavoriteData];
        NSLog(@"favoritesArray = %@",favoritesArray);
        [brainTeaserTableView reloadData];
    } else {
        [self checkFileCreateTime];
        checkFavorite = NO;
        [brainTeaserTableView reloadData];
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


#pragma mark - Load URL

-(void)loadURL{
    responseData = [[NSMutableData alloc]initWithLength:0];
    NSString *strTempCategory = [strCategoryType stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    NSString *strURL = CATEGORYTYPE_URL(strTempCategory,[OpenUDID  value]);
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
    }
}


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
    [brainTeaserTableView reloadData];
    NSLog(@"listArray = %@",listArray);
    [self removeLoadIcon];
}

-(void)CreateBannerForPage
{
    UIView *vw_Adds=[[UIView alloc]init];
    [vw_Adds setFrame:CGRectMake(0, 365, 320, 50)];
    [vw_Adds setClipsToBounds:YES];
    [vw_Adds setClearsContextBeforeDrawing:YES];
    adView=[[ADBannerView alloc]init];
    adView.frame = CGRectOffset(adView.frame, 0, -50);
    adView.delegate=self;
    [vw_Adds addSubview:adView];
    [self.view addSubview:vw_Adds];
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

#pragma mark - Sorting Action

- (IBAction)sortButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hardest", @"Easiest",@"Most Popular",@"Most Recent",nil ];
    [actionSheet setActionSheetStyle:UIBarStyleDefault];
    if ([self isiPad]) {
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    } else {
        [actionSheet showInView:self.view];
    }
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    [self sortingList:buttonIndex];
}
- (void) sortingList:(NSInteger)indexValue
{
    NSLog(@"indexValue = %d",indexValue);
    
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
        [brainTeaserTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [brainTeaserTableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

#pragma mark - Table View

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



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

    UILabel *titleLabel = [[UILabel alloc] init];
    starImage1=[[UIImageView alloc]init];
    starImage2=[[UIImageView alloc]init];
    starImage3=[[UIImageView alloc]init];
    starImage4=[[UIImageView alloc]init];
    
    gearImage1=[[UIImageView alloc]init];
    gearImage2=[[UIImageView alloc]init];
    gearImage3=[[UIImageView alloc]init];
    gearImage4=[[UIImageView alloc]init];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 4, 192, 43)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:17];
    titleLabel.text = [[listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    [cell.contentView addSubview:titleLabel];
    
    starImage1.frame=CGRectMake(207, 8, 16, 16);
    starImage2.frame=CGRectMake(227, 8, 16, 16);
    starImage3.frame=CGRectMake(247, 8, 16, 16);
    starImage4.frame=CGRectMake(267, 8, 16, 16);
    
    gearImage1.frame=CGRectMake(207, 28, 16, 16);
    gearImage2.frame=CGRectMake(227, 28, 16, 16);
    gearImage3.frame=CGRectMake(247, 28, 16, 16);
    gearImage4.frame=CGRectMake(267, 28, 16, 16);
    
    if (checkFavorite) {
        titleLabel.text = [[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        [self setPopularityImages:[[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"popularity"]];
        [self setDifficultyImages:[[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"difficulty"]];

    } else {
        titleLabel.text = [[listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        [self setPopularityImages:[[listArray objectAtIndex:indexPath.row] valueForKey:@"popularity"]];
        [self setDifficultyImages:[[listArray objectAtIndex:indexPath.row] valueForKey:@"difficulty"]];
    }
    
    [cell.contentView addSubview:starImage1];
    [cell.contentView addSubview:starImage2];
    [cell.contentView addSubview:starImage3];
    [cell.contentView addSubview:starImage4];
    
    [cell.contentView addSubview:gearImage1];
    [cell.contentView addSubview:gearImage2];
    [cell.contentView addSubview:gearImage3];
    [cell.contentView addSubview:gearImage4];
    
    
    

    
    
    return cell;
}

- (void)setPopularityImages:(NSString *) popularityValue
{
    double popularity = [popularityValue doubleValue];
    if(floor(popularity) == 0.0)
    {
        starImage1.image = [UIImage imageNamed:@"star0.png"];
        
        if (popularity == 0.0) {
            starImage1.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 0.1) {
            starImage1.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 0.2) {
            starImage1.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 0.3) {
            starImage1.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 0.4) {
            starImage1.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 0.5) {
            starImage1.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 0.6) {
            starImage1.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 0.7) {
            starImage1.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 0.8) {
            starImage1.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 0.9) {
            starImage1.image = [UIImage imageNamed:@"s9.png"];
        }
        starImage2.image = [UIImage imageNamed:@"star0.png"];
        starImage3.image = [UIImage imageNamed:@"star0.png"];
        starImage4.image = [UIImage imageNamed:@"star0.png"];
        
    }
    else if(floor(popularity) == 1.0)
    {
        starImage1.image = [UIImage imageNamed:@"s10.png"];
        if (popularity == 1.0) {
            starImage2.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 1.1) {
            starImage2.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 1.2) {
            starImage2.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 1.3) {
            starImage2.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 1.4) {
            starImage2.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 1.5) {
            starImage2.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 1.6) {
            starImage2.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 1.7) {
            starImage2.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 1.8) {
            starImage2.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 1.9) {
            starImage2.image = [UIImage imageNamed:@"s9.png"];
        }
        starImage3.image = [UIImage imageNamed:@"star0.png"];
        starImage4.image = [UIImage imageNamed:@"star0.png"];
    }
    else if(floor(popularity) == 2.0)
    {
        starImage1.image = [UIImage imageNamed:@"s10.png"];
        starImage2.image = [UIImage imageNamed:@"s10.png"];
        
        if (popularity == 2.0) {
            starImage3.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 2.1) {
            starImage3.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 2.2) {
            starImage3.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 2.3) {
            starImage3.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 2.4) {
            starImage3.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 2.5) {
            starImage3.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 2.6) {
            starImage3.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 2.7) {
            starImage3.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 2.8) {
            starImage3.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 2.9) {
            starImage3.image = [UIImage imageNamed:@"s9.png"];
        }
        starImage4.image = [UIImage imageNamed:@"star0.png"];
    }
    else if(floor(popularity) == 3.0)
    {
        starImage1.image = [UIImage imageNamed:@"s10.png"];
        starImage2.image = [UIImage imageNamed:@"s10.png"];
        starImage3.image = [UIImage imageNamed:@"s10.png"];
        
        if (popularity == 3.0) {
            starImage4.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 3.1) {
            starImage4.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 3.2) {
            starImage4.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 3.3) {
            starImage4.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 3.4) {
            starImage4.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 3.5) {
            starImage4.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 3.6) {
            starImage4.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 3.7) {
            starImage4.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 3.8) {
            starImage4.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 3.9) {
            starImage4.image = [UIImage imageNamed:@"s9.png"];
        }
    }
    
}
- (void)setDifficultyImages:(NSString *) difficultyValue
{
    double difficulty = [difficultyValue doubleValue];
    if(floor(difficulty) == 0.0)
    {
        gearImage1.image = [UIImage imageNamed:@"gear0.png"];
        if (difficulty == 0.0) {
            gearImage1.image = [UIImage imageNamed:@"gear0.png"];
        }else if (difficulty == 0.1) {
            gearImage1.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 0.2) {
            gearImage1.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 0.3) {
            gearImage1.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 0.4) {
            gearImage1.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 0.5) {
            gearImage1.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 0.6) {
            gearImage1.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 0.7) {
            gearImage1.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 0.8) {
            gearImage1.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 0.9) {
            gearImage1.image = [UIImage imageNamed:@"g9.png"];
        }
        gearImage2.image = [UIImage imageNamed:@"gear0.png"];
        gearImage3.image = [UIImage imageNamed:@"gear0.png"];
        gearImage4.image = [UIImage imageNamed:@"gear0.png"];
    }
    else if(floor(difficulty) == 1.0)
    {
        gearImage1.image = [UIImage imageNamed:@"g10.png"];
        if (difficulty == 1.0) {
            gearImage2.image = [UIImage imageNamed:@"gear0.png"];
        }else if (difficulty == 1.1) {
            gearImage2.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 1.2) {
            gearImage2.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 1.3) {
            gearImage2.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 1.4) {
            gearImage2.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 1.5) {
            gearImage2.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 1.6) {
            gearImage2.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 1.7) {
            gearImage2.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 1.8) {
            gearImage2.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 1.9) {
            gearImage2.image = [UIImage imageNamed:@"g9.png"];
        }
        gearImage3.image = [UIImage imageNamed:@"gear0.png"];
        gearImage4.image = [UIImage imageNamed:@"gear0.png"];
        
    }
    else if(floor(difficulty) == 2.0)
    {
        gearImage1.image = [UIImage imageNamed:@"g10.png"];
        gearImage2.image = [UIImage imageNamed:@"g10.png"];
        
        if (difficulty == 2.0) {
            gearImage3.image = [UIImage imageNamed:@"gear0.png"];
        }else if (difficulty == 2.1) {
            gearImage3.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 2.2) {
            gearImage3.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 2.3) {
            gearImage3.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 2.4) {
            gearImage3.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 2.5) {
            gearImage3.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 2.6) {
            gearImage3.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 2.7) {
            gearImage3.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 2.8) {
            gearImage3.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 2.9) {
            gearImage3.image = [UIImage imageNamed:@"g9.png"];
        }
        gearImage4.image = [UIImage imageNamed:@"gear0.png"];
    }
    else if(floor(difficulty) == 3.0)
    {
        gearImage1.image = [UIImage imageNamed:@"g10.png"];
        gearImage2.image = [UIImage imageNamed:@"g10.png"];
        gearImage3.image = [UIImage imageNamed:@"g10.png"];
        
        if (difficulty == 3.0) {
            gearImage4.image = [UIImage imageNamed:@"gear0.png"];
        } else if (difficulty == 3.1) {
            gearImage4.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 3.2) {
            gearImage4.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 3.3) {
            gearImage4.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 3.4) {
            gearImage4.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 3.5) {
            gearImage4.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 3.6) {
            gearImage4.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 3.7) {
            gearImage4.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 3.8) {
            gearImage4.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 3.9) {
            gearImage4.image = [UIImage imageNamed:@"g9.png"];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailViewController *detailViewController;            
    if ([self isiPad]) 
    {
        detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];
        if (checkFavorite) {
            detailViewController.strDetailId = [[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
            detailViewController.selectedDictionary = [favoritesArray objectAtIndex:indexPath.row];
        } else {
            detailViewController.strDetailId = [[listArray objectAtIndex:indexPath.row] valueForKey:@"id"];
            detailViewController.selectedDictionary = [listArray objectAtIndex:indexPath.row];
        }
        [self.splitViewController.splitViewController viewWillDisappear:YES];
        NSMutableArray *viewControllerArray = [[NSMutableArray alloc] initWithArray:[[self.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
        [viewControllerArray removeAllObjects];
        [viewControllerArray addObject:detailViewController];
        self.splitViewController.delegate = detailViewController;
        [[self.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:YES];
        [self.splitViewController.splitViewController viewWillAppear:YES];
    }
    else 
    {
        detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
        if (checkFavorite) {
            detailViewController.strDetailId = [[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
            detailViewController.selectedDictionary = [favoritesArray objectAtIndex:indexPath.row];
        } else {
            detailViewController.strDetailId = [[listArray objectAtIndex:indexPath.row] valueForKey:@"id"];
            detailViewController.selectedDictionary = [listArray objectAtIndex:indexPath.row];
        }
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    [detailViewController release];
    
    }

#pragma mark - Check Device

- (BOOL)isiPad {
    //Check the Device
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}




@end
