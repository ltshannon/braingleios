//
//  MasterViewController.m
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;

#pragma mark - View Life Cycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self isiPad]) {
        [self addBannerView];
    }
    
    if (![self isiPad]) {
        [self masterAddBannerView];
    } 

    isiAdClicked = NO;
    self.title = @"Braingle";
    teaserSectionOneArray=[[NSMutableArray alloc]initWithObjects:@"Featured",@"Favorites",nil ];
    teaserSectionTwoArray=[[NSMutableArray alloc]initWithObjects: @"Cryptography",@"Group",@"Language",@"Letter Equations",@"Logic",@"Math",@"Mystery",@"Optical Illusions",@"Other",@"Probability",@"Rebus",@"Riddles",@"Science",@"Series",@"Situation",@"Trick",@"Trivia",nil];
    teaserSectionOneImageArray=[[NSMutableArray alloc]initWithObjects:@"Featured.png",@"Favorites.png",nil];
    teaserSectionTwoImageArray=[[NSMutableArray alloc]initWithObjects:@"Cryptography.png",@"Group.png",@"Language.png",@"Letter.png",@"Logic.png",@"Math.png",@"Mystery.png",@"Optical.png",@"Other.png",@"Probability.png",@"Rebus.png",@"Riddles.png",@"Science.png",@"Series.png",@"Situation.png",@"Trick.png",@"Trivia.png", nil];
    
    //Add Info Button
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(infoButtonAction:)];
    self.navigationItem.leftBarButtonItem = infoButton;
    
    self.tableView.allowsSelection = YES; 
    self.tableView.allowsSelectionDuringEditing = YES; 
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    isFirstCellHilight = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if (isFirstCellHilight) {
        [self showFirstCellHilighted];
    }
    if (![self isiPad]) {
        [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0];
    }

    [self.tableView setContentOffset:CGPointZero animated:NO];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
}


- (void)showFirstCellHilighted
{
    if ([self isiPad]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        if (!isiAdClicked) {
            [self autoFeaturedCellSelected:indexPath.row];
        }
        isiAdClicked = NO;
    }
    isFirstCellHilight = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if ([self isiPad]) 
    {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
            appDelegate.iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        else
            appDelegate.iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        return YES;
    }
    else 
    {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
            master_iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        else
            master_iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        return YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([self isiPad]) 
    {
        CGRect rect = self.splitViewController.view.bounds;
        
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
        {
            [appDelegate.iAdView setFrame:CGRectMake(0, rect.size.height-66, 768, 66)];
            appDelegate.iAdBanner.frame = CGRectMake(0, 0, 768, 66);
        } else 
        {
            [appDelegate.iAdView setFrame:CGRectMake(0, rect.size.height-66, 10024, 66)];
            appDelegate.iAdBanner.frame = CGRectMake(0, 0, 1024, 66);
        }
    }
    else 
    {
        
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
            master_iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        else
            master_iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;

        [self.tableView setContentOffset:CGPointZero animated:NO];
        
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
        {
            [master_iAdView setFrame:CGRectMake(0, 367, 320, 50)];
            master_iAdBanner.frame = CGRectMake(0, 0, 320, 50);
        }
        else 
        {
            [master_iAdView setFrame:CGRectMake(0, 237, 480, 32)];
            master_iAdBanner.frame = CGRectMake(0, 0, 480, 32);
        }
    }
}

#pragma mark - Add iAd

//Adding iAd only for iPad.
- (void)addBannerView
{
    appDelegate.iAdView=[[UIView alloc]init];
    appDelegate.iAdBanner = [[ADBannerView alloc]init];
    [appDelegate.iAdView setClipsToBounds:YES];
    [appDelegate.iAdView setClearsContextBeforeDrawing:YES];
    appDelegate.iAdView.hidden = YES;
    appDelegate.iAdBanner.frame = CGRectOffset(appDelegate.iAdBanner.frame, 0, -50);
    appDelegate.iAdBanner.delegate=self;
    appDelegate.iAdView.backgroundColor = [UIColor clearColor];
    [appDelegate.iAdView addSubview:appDelegate.iAdBanner];
    CGRect rect = self.splitViewController.view.bounds;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([self isiPad]) 
    {
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
        {
            [appDelegate.iAdView setFrame:CGRectMake(0, rect.size.height-66, 768, 66)];
            appDelegate.iAdBanner.frame = CGRectMake(0, 0, 768, 66);
        }
        else 
        {
            [appDelegate.iAdView setFrame:CGRectMake(0, rect.size.height-66, 10024, 66)];
            appDelegate.iAdBanner.frame = CGRectMake(0, 0, 1024, 66);
        }

        [self.splitViewController.view addSubview:appDelegate.iAdView];
    }
}

//Adding iAd only for iPhone.
- (void)masterAddBannerView
{
    master_iAdView =[[UIView alloc]init];
    master_iAdBanner = [[ADBannerView alloc]init];
    [master_iAdView setClipsToBounds:YES];
    [master_iAdView setClearsContextBeforeDrawing:YES];
    master_iAdView.hidden = YES;
    master_iAdBanner.frame = CGRectOffset(master_iAdBanner.frame, 0, -50);
    master_iAdBanner.delegate=self;
    master_iAdView.backgroundColor = [UIColor clearColor];
    [master_iAdView addSubview:master_iAdBanner];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (![self isiPad]) 
    {
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
        {
            [master_iAdView setFrame:CGRectMake(0, 367, 320, 50)];
            master_iAdBanner.frame = CGRectMake(0, 0, 320, 50);
        }
        else 
        {
            [master_iAdView setFrame:CGRectMake(0, 237, 480, 32)];
            master_iAdBanner.frame = CGRectMake(0, 0, 480, 32);
        }
        [self.tableView addSubview:master_iAdView];
    }
}

#pragma mark - Button Action

- (IBAction)infoButtonAction:(id)sender
{
    UINavigationController *infoNavigationController;
    InfoViewController *infoViewController;
    if ([self isiPad]) {
        infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController_iPad" bundle:nil];
        infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoViewController];
        infoNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        infoNavigationController.title = @"INFO";
        infoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;  //transition shouldn't matter
        [self presentModalViewController:infoNavigationController animated:YES];
    } else {
        infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController_iPhone" bundle:nil];
        infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoViewController];
        [self.navigationController presentModalViewController:infoNavigationController animated:YES];
    }
}

#pragma mark - ADBannerView Delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"animateAdBannerOn");
    if ([self isiPad]) {
        [appDelegate.iAdView setHidden:NO];
    }
    else {
        [master_iAdView setHidden:NO];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"animateAdBannerOFF");
    if ([self isiPad]) {
        [appDelegate.iAdView setHidden:YES];
    }
    else {
        [master_iAdView setHidden:YES];
    }
}
 
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    isiAdClicked = YES;
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

#pragma mark - Table View Delagates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [teaserSectionOneArray count];
    }
    else {
        return [teaserSectionTwoArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [teaserSectionOneArray objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[teaserSectionOneImageArray objectAtIndex:indexPath.row]];
    } else if(indexPath.section == 1) {
        cell.textLabel.text = [teaserSectionTwoArray objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[teaserSectionTwoImageArray objectAtIndex:indexPath.row]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            //Featured Details
            
            [self autoFeaturedCellSelected:indexPath.row];
            [self.detailViewController dismissMasterView];

        }
        if(indexPath.row==1)
        {
            //Favorite Details
            BrainTeaserViewController *brainTeaserViewController;
            DetailViewController *detailViewController;            
            if ([self isiPad]) {
                brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPad" bundle:nil];
                detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];

                brainTeaserViewController.strCategoryType = [teaserSectionOneArray objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:brainTeaserViewController animated:YES];
                
                self.detailViewController.strTypeOfCategory = @"Static";
                [self.detailViewController webViewAction];

            } else {
                brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPhone" bundle:nil];
                brainTeaserViewController.strCategoryType = [teaserSectionOneArray objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:brainTeaserViewController animated:YES];
            }
        }
    }
    else if(indexPath.section==1)
    {
        //Brain Teaser Details
        BrainTeaserViewController *brainTeaserViewController;
        DetailViewController *detailViewController;            
        
        if ([self isiPad]) {
            brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPad" bundle:nil];
            detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];

            brainTeaserViewController.strCategoryType = [teaserSectionTwoArray objectAtIndex:indexPath.row];

            [self.navigationController pushViewController:brainTeaserViewController animated:YES];
            self.detailViewController.strTypeOfCategory = @"Static";
            [self.detailViewController webViewAction];

        } else {
            brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPhone" bundle:nil];
            brainTeaserViewController.strCategoryType = [teaserSectionTwoArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:brainTeaserViewController animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Adding the iAd on the table view.
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (![self isiPad])     
    {
        table_Y_Position = scrollView.contentOffset.y;
        if (self.tableView) 
        {
            if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) 
            {
                [master_iAdView setFrame:CGRectMake(0, 367+table_Y_Position, 320, 50)];
            }
            else 
            {
                [master_iAdView setFrame:CGRectMake(0, 237+table_Y_Position, 480, 50)];
            }
        }
    }
}


#pragma mark - Check Device

- (BOOL)isiPad 
{
    //Check the device
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

- (void)autoFeaturedCellSelected:(NSInteger) indexValue
{
    if ([self isiPad]) 
    {
        self.detailViewController.strDetailId = [teaserSectionOneArray objectAtIndex:indexValue];
        self.detailViewController.strTypeOfCategory = @"Featured";
        [self.detailViewController webViewAction];
    }
    else 
    {
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
        detailViewController.strDetailId = [teaserSectionOneArray objectAtIndex:indexValue] ;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}
@end
