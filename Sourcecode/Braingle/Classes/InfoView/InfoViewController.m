//
//  InfoViewController.m
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomNavigation.h"
#import "HomeViewController.h"
@implementation InfoViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigation];
    NSString *URlStr=[NSString stringWithFormat:@"%@/InfoDesc.html",[[NSBundle mainBundle] resourcePath]];
    [infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:URlStr]]];

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

#pragma mark - Add Navigation

- (void) loadNavigation {
    CustomNavigation *myCustomNavigation =[[CustomNavigation alloc] initWithNibName:@"CustomNavigation"bundle:nil];
    [self.view addSubview:[myCustomNavigation view]];
    [myCustomNavigation setNavImageView:[UIImage imageNamed:@"logo.png"]];
    [myCustomNavigation setBackActive:NO];
    [myCustomNavigation setListActive:NO];
    [myCustomNavigation setInfoActive:NO];
    [myCustomNavigation setMenubtn:YES];
    [myCustomNavigation setbtnHeart:NO heartImage:NO];
    [myCustomNavigation release];
}
-(IBAction)infoBtnAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
}
#pragma mark - Button Action


#pragma mark - Check Device

- (BOOL)isiPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}


@end
