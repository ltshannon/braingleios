//
//  CustomNavigation.h
//  Braingle
//
//  Created by O Clock on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigation : UIViewController
{
    IBOutlet UIButton         *buttonList;
    IBOutlet UIButton         *buttonBack;
    IBOutlet UIButton         *buttonInfo;
    IBOutlet UIImageView      *imgTitle;
    IBOutlet UILabel          *labelHeader;
    IBOutlet UILabel          *headerLabelActive;
    IBOutlet UIButton         *btnHeart;
}

@property(nonatomic, retain) UIButton         *btnHeart;
- (void) setListActive:(BOOL) isActive;
- (void) setInfoActive:(BOOL) isActive;
- (void) setBackActive:(BOOL) isActive;
- (void) setbtnHeart:(BOOL) isActive heartImage:(BOOL) isImageActive;
- (void) setLabelNav:(BOOL) isActive setText:(NSString *) _text;
- (void) setnavigationImage:(BOOL) isActive; 
- (void) setNavImageView:(UIImage *) imgTittle;



@end
