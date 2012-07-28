//
//  CustomNavigation.m
//  Braingle
//
//  Created by O Clock on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigation.h"

@implementation CustomNavigation
@synthesize btnHeart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) setInfoActive:(BOOL)isActive {
    [buttonInfo setHidden:!isActive];
}

- (void) setListActive:(BOOL) isActive
{
    [buttonList setHidden:!isActive];
}

- (void) setBackActive:(BOOL)isActive {
    [buttonBack setHidden:!isActive];
}

- (void) setbtnHeart:(BOOL)isActive heartImage:(BOOL)isImageActive
{
    [btnHeart setHidden:!isActive];
    if (isImageActive) {
        [btnHeart setImage:[UIImage imageNamed:@"fav-active.png"] forState:UIControlStateNormal];
    } else {
        [btnHeart setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];

    }
}

-(void) setNavImageView:(UIImage *) imgTittle
{
    [imgTitle setImage:imgTittle];
}

-(void) setLabelNav:(BOOL) isActive setText:(NSString *)_text
{
    
    [labelHeader setHidden:!isActive];
     [labelHeader setText:_text];
}

- (void) setnavigationImage:(BOOL) isActive
{
    [imgTitle setHidden:!isActive];
}

- (void) setMenubtn:(BOOL) isActive
{
    [btnMenu setHidden:!isActive];

}
- (void) setDoneBtn:(BOOL) isActive
{
    [btnDone setHidden:!isActive];
}

- (void) setLblHeader:(BOOL) isActive setText:(NSString *)_text
{
    [detailLblHeader setText:_text];
}

//- (void) setLabelHeader:(NSString *)strHeaderText
//{
//  
//    [labelHeader setText:strHeaderText];
//    
//}
- (BOOL)isiPad; {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}


@end
