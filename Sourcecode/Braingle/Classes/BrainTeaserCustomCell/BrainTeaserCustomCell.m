//
//  BrainTeaserCustomCell.m
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrainTeaserCustomCell.h"

@implementation BrainTeaserCustomCell

-(void)riddleslbl:(NSString *)_text 
{
    RiddlesLabel.text=_text;
}

- (void)setPopularityImage:(NSString *)popularityValue
{
    double popularity = [popularityValue doubleValue];
    if(floor(popularity) == 0.0)
    {
        starImage1.image = [UIImage imageNamed:@"star0.png"];
        
        if (popularity == 0.0) {
            starImage1.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 0.1) {
            starImage1.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 0.2) {
            starImage1.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 0.3) {
            starImage1.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 0.4) {
            starImage1.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 0.5) {
            starImage1.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 0.6) {
            starImage1.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 0.7) {
            starImage1.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 0.8) {
            starImage1.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 0.9) {
            starImage1.image = [UIImage imageNamed:@"s9.png"];
        }
        starImage2.image = [UIImage imageNamed:@"star0.png"];
        starImage3.image = [UIImage imageNamed:@"star0.png"];
        starImage4.image = [UIImage imageNamed:@"star0.png"];

    }
    else if(floor(popularity) == 1.0)
    {
        starImage1.image = [UIImage imageNamed:@"s10.png"];
        if (popularity == 1.0) {
            starImage2.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 1.1) {
            starImage2.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 1.2) {
            starImage2.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 1.3) {
            starImage2.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 1.4) {
            starImage2.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 1.5) {
            starImage2.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 1.6) {
            starImage2.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 1.7) {
            starImage2.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 1.8) {
            starImage2.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 1.9) {
            starImage2.image = [UIImage imageNamed:@"s9.png"];
        }
        starImage3.image = [UIImage imageNamed:@"star0.png"];
        starImage4.image = [UIImage imageNamed:@"star0.png"];
    }
    else if(floor(popularity) == 2.0)
    {
        starImage1.image = [UIImage imageNamed:@"s10.png"];
        starImage2.image = [UIImage imageNamed:@"s10.png"];

        if (popularity == 2.0) {
            starImage3.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 2.1) {
            starImage3.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 2.2) {
            starImage3.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 2.3) {
            starImage3.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 2.4) {
            starImage3.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 2.5) {
            starImage3.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 2.6) {
            starImage3.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 2.7) {
            starImage3.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 2.8) {
            starImage3.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 2.9) {
            starImage3.image = [UIImage imageNamed:@"s9.png"];
        }
        starImage4.image = [UIImage imageNamed:@"star0.png"];
    }
    else if(floor(popularity) == 3.0)
    {
        starImage1.image = [UIImage imageNamed:@"s10.png"];
        starImage2.image = [UIImage imageNamed:@"s10.png"];
        starImage3.image = [UIImage imageNamed:@"s10.png"];

        if (popularity == 3.0) {
            starImage4.image = [UIImage imageNamed:@"star0.png"];
        }else if (popularity == 3.1) {
            starImage4.image = [UIImage imageNamed:@"s1.png"];
        }else if (popularity == 3.2) {
            starImage4.image = [UIImage imageNamed:@"s2.png"];
        }else if (popularity == 3.3) {
            starImage4.image = [UIImage imageNamed:@"s3.png"];
        }else if (popularity == 3.4) {
            starImage4.image = [UIImage imageNamed:@"s4.png"];
        }else if (popularity == 3.5) {
            starImage4.image = [UIImage imageNamed:@"s5.png"];
        }else if (popularity == 3.6) {
            starImage4.image = [UIImage imageNamed:@"s6.png"];
        }else if (popularity == 3.7) {
            starImage4.image = [UIImage imageNamed:@"s7.png"];
        }else if (popularity == 3.8) {
            starImage4.image = [UIImage imageNamed:@"s8.png"];
        }else if (popularity == 3.9) {
            starImage4.image = [UIImage imageNamed:@"s9.png"];
        }
    }
}

- (void)setDifficultyImage:(NSString *)difficultyValue
{
    double difficulty = [difficultyValue doubleValue];
    if(floor(difficulty) == 0.0)
    {
        gearImage1.image = [UIImage imageNamed:@"gear0.png"];
        if (difficulty == 0.0) {
            gearImage1.image = [UIImage imageNamed:@"gear0.png"];
        }else if (difficulty == 0.1) {
            gearImage1.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 0.2) {
            gearImage1.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 0.3) {
            gearImage1.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 0.4) {
            gearImage1.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 0.5) {
            gearImage1.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 0.6) {
            gearImage1.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 0.7) {
            gearImage1.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 0.8) {
            gearImage1.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 0.9) {
            gearImage1.image = [UIImage imageNamed:@"g9.png"];
        }
        gearImage2.image = [UIImage imageNamed:@"gear0.png"];
        gearImage3.image = [UIImage imageNamed:@"gear0.png"];
        gearImage4.image = [UIImage imageNamed:@"gear0.png"];
    }
    else if(floor(difficulty) == 1.0)
    {
        gearImage1.image = [UIImage imageNamed:@"g10.png"];
        if (difficulty == 1.0) {
            gearImage2.image = [UIImage imageNamed:@"gear0.png"];
        }else if (difficulty == 1.1) {
            gearImage2.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 1.2) {
            gearImage2.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 1.3) {
            gearImage2.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 1.4) {
            gearImage2.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 1.5) {
            gearImage2.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 1.6) {
            gearImage2.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 1.7) {
            gearImage2.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 1.8) {
            gearImage2.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 1.9) {
            gearImage2.image = [UIImage imageNamed:@"g9.png"];
        }
        gearImage3.image = [UIImage imageNamed:@"gear0.png"];
        gearImage4.image = [UIImage imageNamed:@"gear0.png"];

    }
    else if(floor(difficulty) == 2.0)
    {
        gearImage1.image = [UIImage imageNamed:@"g10.png"];
        gearImage2.image = [UIImage imageNamed:@"g10.png"];
        
        if (difficulty == 2.0) {
            gearImage3.image = [UIImage imageNamed:@"gear0.png"];
        }else if (difficulty == 2.1) {
            gearImage3.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 2.2) {
            gearImage3.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 2.3) {
            gearImage3.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 2.4) {
            gearImage3.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 2.5) {
            gearImage3.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 2.6) {
            gearImage3.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 2.7) {
            gearImage3.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 2.8) {
            gearImage3.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 2.9) {
            gearImage3.image = [UIImage imageNamed:@"g9.png"];
        }
        gearImage4.image = [UIImage imageNamed:@"gear0.png"];
    }
    else if(floor(difficulty) == 3.0)
    {
        gearImage1.image = [UIImage imageNamed:@"g10.png"];
        gearImage2.image = [UIImage imageNamed:@"g10.png"];
        gearImage3.image = [UIImage imageNamed:@"g10.png"];
        
        if (difficulty == 3.0) {
            gearImage4.image = [UIImage imageNamed:@"gear0.png"];
        } else if (difficulty == 3.1) {
            gearImage4.image = [UIImage imageNamed:@"g1.png"];
        }else if (difficulty == 3.2) {
            gearImage4.image = [UIImage imageNamed:@"g2.png"];
        }else if (difficulty == 3.3) {
            gearImage4.image = [UIImage imageNamed:@"g3.png"];
        }else if (difficulty == 3.4) {
            gearImage4.image = [UIImage imageNamed:@"g4.png"];
        }else if (difficulty == 3.5) {
            gearImage4.image = [UIImage imageNamed:@"g5.png"];
        }else if (difficulty == 3.6) {
            gearImage4.image = [UIImage imageNamed:@"g6.png"];
        }else if (difficulty == 3.7) {
            gearImage4.image = [UIImage imageNamed:@"g7.png"];
        }else if (difficulty == 3.8) {
            gearImage4.image = [UIImage imageNamed:@"g8.png"];
        }else if (difficulty == 3.9) {
            gearImage4.image = [UIImage imageNamed:@"g9.png"];
        }
    }
}

@end
