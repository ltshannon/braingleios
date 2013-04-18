//
//  BraingleTableViewController.m
//  Braingle
//
//  Created by LAWRENCE SHANNON on 4/18/13.
//
//

#import "BraingleTableViewController.h"

@interface BraingleTableViewController ()

@end

@implementation BraingleTableViewController

@synthesize strCategoryType;
@synthesize masterPopoverController;
@synthesize detailViewController = _detailViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    selectedRow = -1;
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortButtonAction:)];
    self.navigationItem.rightBarButtonItem = sortButton;
    
    favoritesArray = [[NSMutableArray alloc] init];
    rowDict = [[NSMutableDictionary alloc] init];
    dataBase = [[Database alloc] initialise];
    braingleDB = [[BraingleDB alloc] initialise];
    braingleArray = [[NSMutableArray alloc] init];
    if (!sortSQL)
    {
        sortSQL = @"";
    }
    
    self.title = strCategoryType;
    docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    pathToDocuments  = [[docDir objectAtIndex:0] copy];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkCategoryType];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([self isiPad])
    {
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [loadingView setFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
        }
        else
        {
            [loadingView setFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
        }
    }
    else
    {
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [loadingView setFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
        }
        else
        {
            [loadingView setFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Check & Load webview

- (void)checkCategoryType
{
    if ([strCategoryType isEqualToString:@"Favorites"]) {
        checkFavorite = YES;
        favoritesArray = [dataBase getFavoriteData];
        if (sortDescriptor)
        {
            [favoritesArray sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        }
        [self.tableView reloadData];
    }
    else
    {
        checkFavorite = NO;
        
        if (![braingleDB getBraingleDataCount:strCategoryType])
        {
            [self LoadIcon];
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
            braingleArray = [braingleDB getBraingleData:strCategoryType sorttOrder:sortSQL];
        }
        
        [self.tableView reloadData];
        
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
}


- (void)removeLoadIcon
{
    [loadingView removeFromSuperview];
}


#pragma mark - Load URL

-(void)loadURL{
    responseData = [[NSMutableData alloc]initWithLength:0];
    NSString *strTempCategory = strCategoryType;
    if ([strTempCategory isEqualToString:@"Optical Illusions"]) {
        strTempCategory = @"Optical Illusion";
    }
    else if([strTempCategory isEqualToString:@"Riddles"]) {
        strTempCategory = @"Riddle";
    }
    strTempCategory = [strTempCategory stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    NSString *strURL = CATEGORYTYPE_URL(strTempCategory,[OpenUDID  value]);
    NSLog(@"URL : %@\n", strURL);
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strURL = %@",strURL);
    NSURL *url=[NSURL URLWithString:strURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    urlConnection =  [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - Sorting Action

- (IBAction)sortButtonAction:(id)sender
{
    sortActionSheet = [[UIActionSheet alloc] initWithTitle:@""  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hardest", @"Easiest",@"Most Popular",@"Most Recent",nil ];
    [sortActionSheet setActionSheetStyle:UIBarStyleDefault];
    if ([self isiPad]) {
        [sortActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        [sortActionSheet showFromToolbar:self.navigationController.toolbar];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self sortingList:buttonIndex];
}
- (void) sortingList:(NSInteger)indexValue
{
    //    if ([fetchedObjects count] > 0 || [favoritesArray count] > 0) {
    
    switch (indexValue) {
        case 0:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"difficulty"  ascending:NO];
            sortSQL = [NSString stringWithFormat:@"order by difficulty desc"];
            break;
        case 1:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"difficulty"  ascending:YES];
            sortSQL = [NSString stringWithFormat:@"order by difficulty"];
            break;
        case 2:
            sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"popularity" ascending:NO];
            sortSQL = [NSString stringWithFormat:@"order by popularity desc"];
            break;
        case 3:
            sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
            sortSQL = [NSString stringWithFormat:@"order by date desc"];
            break;
        case 4:
            sortDescriptor=nil;
            sortSQL = @"";
            break;
        default:
            break;
    }
    NSArray *descriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    if (checkFavorite)
    {
        [favoritesArray sortUsingDescriptors:descriptors];
    }
    else
    {
        [self checkCategoryType];
        return;
    }
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    //    }
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
    }
    else
    {
        return braingleArray.count;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    titleLabel = [[UILabel alloc] init];
    starImage1=[[UIImageView alloc]init];
    starImage2=[[UIImageView alloc]init];
    starImage3=[[UIImageView alloc]init];
    starImage4=[[UIImageView alloc]init];
    
    gearImage1=[[UIImageView alloc]init];
    gearImage2=[[UIImageView alloc]init];
    gearImage3=[[UIImageView alloc]init];
    gearImage4=[[UIImageView alloc]init];
    
    float adj = 0;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && !self.isiPad)
    {
        CGRect frame = self.view.frame;
        adj = frame.size.width - (192 + 128); // 192 is the size of the UILabel & 128 is 4 * 16 for each image
    }
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 4, 192 + adj, 43)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:17];
    
    [cell.contentView addSubview:titleLabel];
    
    starImage1.frame=CGRectMake(207 + adj, 8, 16, 16);
    starImage2.frame=CGRectMake(227 + adj, 8, 16, 16);
    starImage3.frame=CGRectMake(247 + adj, 8, 16, 16);
    starImage4.frame=CGRectMake(267 + adj, 8, 16, 16);
    
    gearImage1.frame=CGRectMake(207 + adj, 28, 16, 16);
    gearImage2.frame=CGRectMake(227 + adj, 28, 16, 16);
    gearImage3.frame=CGRectMake(247 + adj, 28, 16, 16);
    gearImage4.frame=CGRectMake(267 + adj, 28, 16, 16);
    
    if (checkFavorite) {
        titleLabel.text = [[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        [self setPopularityImages:[[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"popularity"]];
        [self setDifficultyImages:[[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"difficulty"]];
    }
    else
    {
        Braingle *braingle = (Braingle *) [braingleArray objectAtIndex:indexPath.row];
        titleLabel.text = braingle.title;
        if (braingle.visited == YES)
        {
            titleLabel.alpha = .3;
        }
        [self setPopularityImages:braingle.popularity];
        [self setDifficultyImages:braingle.difficulty];
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
    
    //Check the cell clicked or not.
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([self isiPad] && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeLeft))
    {
        if (selectedRow == indexPath.row) {
            return;
        }
    }
    
    selectedRow = indexPath.row;
    if ([self isiPad])
    {
        if (checkFavorite) {
            self.detailViewController.strDetailId = [[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
            self.detailViewController.selectedDictionary = [favoritesArray objectAtIndex:indexPath.row];
            self.detailViewController.strTypeOfCategory = @"Favorite";
        } else {
            Braingle *braingle = [braingleArray objectAtIndex:indexPath.row];
            [rowDict setObject:[NSString stringWithFormat:@"%i", braingle.id] forKey:@"id"];
            [rowDict setObject:braingle.date forKey:@"date" ];
            [rowDict setObject:braingle.title forKey:@"title"];
            [rowDict setObject:braingle.popularity forKey:@"popularity"];
            [rowDict setObject:braingle.difficulty forKey:@"difficulty"];
            [rowDict setObject:[NSString stringWithFormat:@"%i", braingle.visited] forKey:@"visited"];
            self.detailViewController.selectedDictionary = rowDict;
            self.detailViewController.strDetailId = [self.detailViewController.selectedDictionary valueForKey:@"id"];
            self.detailViewController.strTypeOfCategory = strCategoryType;
        }
        self.detailViewController.brainDelegate = self;
        [self.detailViewController webViewAction];
        [self.detailViewController dismissMasterView];
    }
    else
    {
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
        if (checkFavorite) {
            detailViewController.strDetailId = [[favoritesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
            detailViewController.selectedDictionary = [favoritesArray objectAtIndex:indexPath.row];
            detailViewController.strTypeOfCategory = @"Favorite";
        } else {
            Braingle *braingle = [braingleArray objectAtIndex:indexPath.row];
            [rowDict setObject:[NSString stringWithFormat:@"%i", braingle.id] forKey:@"id"];
            [rowDict setObject:braingle.date forKey:@"date" ];
            [rowDict setObject:braingle.title forKey:@"title"];
            [rowDict setObject:braingle.popularity forKey:@"popularity"];
            [rowDict setObject:braingle.difficulty forKey:@"difficulty"];
            [rowDict setObject:[NSString stringWithFormat:@"%i", braingle.visited] forKey:@"visited"];
            detailViewController.selectedDictionary = rowDict;
            detailViewController.strDetailId = [detailViewController.selectedDictionary valueForKey:@"id"];
            detailViewController.strTypeOfCategory = strCategoryType;
        }
        detailViewController.brainDelegate = self;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - Check Device

- (BOOL)isiPad {
    //Check the Device
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

#pragma mark - DetailView Delegate Method

- (void)reloadTableView
{
    if ([self isiPad])
    {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
            [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            [self.tableView reloadData];
        }
    }
    else
    {
        //Reload the table from detailview when click the favorite button
        favoritesArray = [dataBase getFavoriteData];
        [self.tableView reloadData];
        selectedRow = -1;
    }
}

-(void)parseXMLFileAtURL:(NSMutableData *)URL
{
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
        //        NSString *fileName = [NSString stringWithFormat:@"%@",strCategoryType];
        //        [responseData writeToFile:[NSString stringWithFormat:@"%@",[pathToDocuments stringByAppendingPathComponent:fileName]]  atomically:YES];
        
        //        NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strCategoryType]]];
        //        [self parseXMLFileAtURL:data];
        [self parseXMLFileAtURL:responseData];
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
        listArray = [[NSMutableArray alloc]init];
    }
    if([elementName isEqualToString:@"row"])
    {
        rowDict = [[NSMutableDictionary alloc]init];
        strid = [[NSMutableString alloc]init];
        strDate = [[NSMutableString alloc]init];
        strTitle = [[NSMutableString alloc]init];
        strPopularity = [[NSMutableString alloc]init];
        strDifficulty = [[NSMutableString alloc]init];
        
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
    NSNumber *t_id;
    NSString *t_date;
    NSString *t_title;
    NSString *t_popularity;
    NSString *t_difficulty;
    
    if (![braingleDB getBraingleDataCount:strCategoryType])
    {
        [braingleDB addBraingleData:listArray forCategory:strCategoryType];
    }
    else
    {
        if (listArray.count)
        {
            NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
            NSArray *descriptors = [NSArray arrayWithObjects:sort, nil];
            [listArray sortUsingDescriptors:descriptors];
            for (int i = 0; i < [listArray count]; i++)
            {
                if (![braingleDB getBraingleItem:strCategoryType atID:[[[listArray objectAtIndex:i] valueForKey:@"id"] intValue]])
                {
                    NSLog(@"Didn't find : %@", [[listArray objectAtIndex:i] valueForKey:@"id"]);
                    t_id  = [[NSNumber alloc] initWithInt:[[[listArray objectAtIndex:i] valueForKey:@"id"] intValue]];
                    t_date = [[listArray objectAtIndex:i] valueForKey:@"date"];
                    t_date = [t_date stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    t_date = [t_date stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    t_title = [[listArray objectAtIndex:i] valueForKey:@"title"];
                    t_title = [t_title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    t_title = [t_title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    t_title = [t_title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    t_popularity = [[listArray objectAtIndex:i] valueForKey:@"popularity"];
                    t_popularity = [t_popularity stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    t_popularity = [t_popularity stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    t_popularity = [t_popularity stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    t_difficulty = [[listArray objectAtIndex:i] valueForKey:@"difficulty"];
                    t_difficulty = [t_difficulty stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                    t_difficulty = [t_difficulty stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    t_difficulty = [t_difficulty stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    
                    Braingle *b = [[Braingle alloc] init];
                    b.id = [[[listArray objectAtIndex:i] valueForKey:@"id"] intValue];
                    b.date = t_date;
                    b.title = t_title;
                    b.popularity = t_popularity;
                    b.difficulty = t_difficulty;
                    
                    [braingleDB addBraingleItem:b forCategory:strCategoryType];
                }
                else
                {
                    NSLog(@"Found : %@", [[listArray objectAtIndex:i] valueForKey:@"id"]);
                    break;
                }
            }
        }
    }
    
    [self checkCategoryType];
    [self removeLoadIcon];
}

-(void) refresh
{
    [self LoadIcon];
    if (([[Reachability sharedReachability] internetConnectionStatus] == NotReachable))
    {
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Braingle" message:@"No Network Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [self removeLoadIcon];
    }
    else
    {
        [self loadURL];
    }
    [self.refreshControl endRefreshing];
}
@end
