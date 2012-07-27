//
//  BrainTeaserCustomCell.h
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrainTeaserCustomCell : UITableViewCell
{
    IBOutlet UILabel       *RiddlesLabel;
    IBOutlet UIImageView   *starImage1;
    IBOutlet UIImageView   *starImage2;
    IBOutlet UIImageView   *starImage3;
    IBOutlet UIImageView   *starImage4;
    IBOutlet UIImageView   *gearImage1;
    IBOutlet UIImageView   *gearImage2;
    IBOutlet UIImageView   *gearImage3;
    IBOutlet UIImageView   *gearImage4;
}
- (void)riddleslbl:(NSString *)_text;
- (void)setPopularityImage:(NSString *)popularityValue;
- (void)setDifficultyImage:(NSString *)difficultyValue;

@end
