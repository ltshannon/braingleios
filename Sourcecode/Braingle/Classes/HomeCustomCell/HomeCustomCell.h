//
//  HomeCustomCell.h
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomCell : UITableViewCell
{
    IBOutlet UILabel      * sectionLabel;
    IBOutlet UIImageView   *sectionImage;
    IBOutlet UIImageView    *backgroundImage;
}
-(void)setLabel:(NSString *)_text;
-(void)setImage:(NSString *)image;
- (void)setBackgroundImage:(NSString *) imageType sectionNo:(NSInteger) section;
@end
