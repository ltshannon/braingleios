//
//  InfoViewController.m
//  Braingle
//
//  Created by ocs on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"INFO";
    
    //Add info Button
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonAction:)];
    self.navigationItem.rightBarButtonItem = infoButton;
    [infoButton release];

    //Load webview
    
    NSString *URlStr=[NSString stringWithFormat:@"%@/InfoDesc.html",[[NSBundle mainBundle] resourcePath]];
    [infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:URlStr]]];
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

#pragma mark - Button Action

- (IBAction)doneButtonAction:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
         
#pragma mark - Check Device
         
- (BOOL)isiPad {
    //Check the Device
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

@end
