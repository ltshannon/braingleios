//
//  MasterViewController.m
//  Braingle
//
//  Created by ocs on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

@synthesize detailViewController = _detailViewController;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.navigationController.navigationBarHidden=YES;
    TeasersectionOneArray=[[NSMutableArray alloc]initWithObjects:@"Featured",@"Favorites",nil ];
    TeasersectionTwoArray=[[NSMutableArray alloc]initWithObjects: @"Cryptography",@"Group",@"Language",@"Letter Equations",@"Logic",@"Math",@"Mystery",@"OpticalIllusions",@"Other",@"Probability",@"Rebus",@"Riddles",@"Science",@"Series",@"Situation",@"Trick",@"Trivia",nil];
    teaserImageOneArray=[[NSMutableArray alloc]initWithObjects:@"Featured.png",@"Favorites.png",nil];
    teaserImageTwoArray=[[NSMutableArray alloc]initWithObjects:@"Cryptography.png",@"Group.png",@"Language.png",@"Letter.png",@"Logic.png",@"Math.png",@"Mystery.png",@"Optical.png",@"Other.png",@"Probability.png",@"Rebus.png",@"Riddles.png",@"Science.png",@"Series.png",@"Situation.png",@"Trick.png",@"Trivia.png", nil];
    [self loadNavigation];
    [self CreateBannerForPage];

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

#pragma mark - Add Navigation

- (void) loadNavigation {
    CustomNavigation *myCustomNavigation =[[CustomNavigation alloc] initWithNibName:@"CustomNavigation"bundle:nil];
    [self.view addSubview:[myCustomNavigation view]];
    [myCustomNavigation setNavImageView:[UIImage imageNamed:@"logo.png"]];
    [myCustomNavigation setnavigationImage:YES];
    [myCustomNavigation setBackActive:NO];
    [myCustomNavigation setListActive:NO];
    [myCustomNavigation setInfoActive:YES];
    [myCustomNavigation setMenubtn:NO];
    [myCustomNavigation setbtnHeart:NO heartImage:NO];
    [myCustomNavigation setLabelNav:NO setText:@""];
    [myCustomNavigation release];
}

#pragma mark - Button Action

-(IBAction)infoButtonAction:(id)sender
{
    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    [self presentModalViewController:infoViewController animated:YES];
}

#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [TeasersectionOneArray count];

    } else
    {
        return [TeasersectionTwoArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    HomeCustomCell *cell =(HomeCustomCell *) [homeTable dequeueReusableCellWithIdentifier:CellIdentifier];    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"HomeCustomCell" owner:self options:nil];
        cell= customcell;
    }
    if(indexPath.section ==0)
    {
        [cell setLabel:[TeasersectionOneArray objectAtIndex:indexPath.row]];
        [cell setImage:[teaserImageOneArray objectAtIndex:indexPath.row]];

        if(indexPath.row==0)
        {
            [cell setBackgroundImage:@"top" sectionNo:indexPath.section];
        }
        if(indexPath.row == [teaserImageOneArray count]-1)
        {
            [cell setBackgroundImage:@"bottom" sectionNo:indexPath.section];
        }
    }
    if(indexPath.section==1)
    {
        [cell setLabel:[TeasersectionTwoArray objectAtIndex:indexPath.row]];
        [cell setImage:[teaserImageTwoArray objectAtIndex:indexPath.row]];

        if(indexPath.row==0)
        {
            [cell setBackgroundImage:@"top" sectionNo:indexPath.section];
        } else if(indexPath.row == [TeasersectionTwoArray count]-1){
            [cell setBackgroundImage:@"bottom" sectionNo:indexPath.section];
        } else{
            [cell setBackgroundImage:@"mid" sectionNo:indexPath.section];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
            detailViewController.strDetailId = [TeasersectionOneArray objectAtIndex:indexPath.row] ;
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        if (indexPath.row==1) {
            BrainTeaserViewController *brainTeaserViewController=[[BrainTeaserViewController alloc]initWithNibName:@"BrainTeaserViewController" bundle:nil];
            brainTeaserViewController.strCategoryType = [TeasersectionOneArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:brainTeaserViewController animated:YES];
            [brainTeaserViewController release];
        }
    }
    if (indexPath.section==1) 
    {
        BrainTeaserViewController *brainTeaserViewController=[[BrainTeaserViewController alloc]initWithNibName:@"BrainTeaserViewController" bundle:nil];
        brainTeaserViewController.strCategoryType = [TeasersectionTwoArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:brainTeaserViewController animated:YES];
        [brainTeaserViewController release];
    }
}

#pragma mark - iAd Method

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
