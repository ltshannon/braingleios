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

- (void)dealloc
{
    [_detailViewController release];
    [teaserSectionOneArray release];
    [teaserSectionTwoArray release];
    [teaserSectionOneImageArray release];
    [teaserSectionTwoImageArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Braingle";
    teaserSectionOneArray=[[NSMutableArray alloc]initWithObjects:@"Featured",@"Favorites",nil ];
    teaserSectionTwoArray=[[NSMutableArray alloc]initWithObjects: @"Cryptography",@"Group",@"Language",@"Letter Equations",@"Logic",@"Math",@"Mystery",@"Optical Illusions",@"Other",@"Probability",@"Rebus",@"Riddles",@"Science",@"Series",@"Situation",@"Trick",@"Trivia",nil];
    teaserSectionOneImageArray=[[NSMutableArray alloc]initWithObjects:@"Featured.png",@"Favorites.png",nil];
    teaserSectionTwoImageArray=[[NSMutableArray alloc]initWithObjects:@"Cryptography.png",@"Group.png",@"Language.png",@"Letter.png",@"Logic.png",@"Math.png",@"Mystery.png",@"Optical.png",@"Other.png",@"Probability.png",@"Rebus.png",@"Riddles.png",@"Science.png",@"Series.png",@"Situation.png",@"Trick.png",@"Trivia.png", nil];
    
    //Add Info Button
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(infoButtonAction:)];
    self.navigationItem.leftBarButtonItem = infoButton;
    [infoButton release];
    
    if (![self isiPad]) {
        [self CreateBannerForPage];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    if ([self isiPad]) {
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [infoNavigationController release];
        [infoViewController release];
    }
}

#pragma mark - Add iAd

-(void)CreateBannerForPage
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    iAdView=[[UIView alloc]init];
    if ([self isiPad]) {
        if (interfaceOrientation == (UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown)) {
            [iAdView setFrame:CGRectMake(0, 900, 748, 50)];
        } else {
            [iAdView setFrame:CGRectMake(0, 695, 1004, 50)];
        }
    } else {
        [iAdView setFrame:CGRectMake(0, 365, 320, 50)];
    }
    [iAdView setClipsToBounds:YES];
    [iAdView setClearsContextBeforeDrawing:YES];
    adView=[[ADBannerView alloc]initWithFrame:CGRectMake(0, 0, 748, 50)];
    adView.frame = CGRectOffset(adView.frame, 0, -50);
    adView.delegate=self;
    [iAdView addSubview:adView];
    if ([self isiPad]) {
        [self.splitViewController.view addSubview:iAdView];
    } else {
        [self.tableView addSubview:iAdView];
    }
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
            
            DetailViewController *detailViewController;            
            if ([self isiPad]) 
            {
                detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];

                [self.splitViewController.splitViewController viewWillDisappear:YES];
                detailViewController.strDetailId = [teaserSectionOneArray objectAtIndex:indexPath.row] ;
                NSMutableArray *viewControllerArray = [[NSMutableArray alloc] initWithArray:[[self.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
                [viewControllerArray removeAllObjects];
                [viewControllerArray addObject:detailViewController];
                [[self.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:YES];
                [self.splitViewController.splitViewController viewWillAppear:YES];
                [viewControllerArray release];
            }
            else 
            {
                detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];

                detailViewController.strDetailId = [teaserSectionOneArray objectAtIndex:indexPath.row] ;
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
            [detailViewController release];
        }
        if(indexPath.row==1)
        {
            //Favorite Details

            BrainTeaserViewController *brainTeaserViewController;
            if ([self isiPad]) {
                brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPad" bundle:nil];
            } else {
                brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPhone" bundle:nil];
            }
            brainTeaserViewController.strCategoryType = [teaserSectionOneArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:brainTeaserViewController animated:YES];
            [brainTeaserViewController release];
        }
    }
    else if(indexPath.section==1)
    {
        //Brain Teaser Details
        
        BrainTeaserViewController *brainTeaserViewController;
        if ([self isiPad]) {
            brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPad" bundle:nil];
        } else {
            brainTeaserViewController = [[BrainTeaserViewController alloc] initWithNibName:@"BrainTeaserViewController_iPhone" bundle:nil];
        }
        brainTeaserViewController.strCategoryType = [teaserSectionTwoArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:brainTeaserViewController animated:YES];
        [brainTeaserViewController release];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Adding the iAd on the table view.
    
    if (![self isiPad]) {
        if (self.tableView) {
            table_Y_Position = scrollView.contentOffset.y;
            [iAdView setFrame:CGRectMake(0, 365+table_Y_Position, 320, 50)];
        }
    }
}

#pragma mark - Check Device

- (BOOL)isiPad 
{
    //Check the device
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

@end
