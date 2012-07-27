//
//  InfoViewController.h
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
{
    IBOutlet UIWebView *infoWebView;    
}

- (void)loadNavigation;
- (BOOL)isiPad;

@end
