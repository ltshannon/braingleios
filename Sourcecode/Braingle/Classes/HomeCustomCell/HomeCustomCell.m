//
//  HomeCustomCell.m
//  Braingle
//
//  Created by O Clock on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeCustomCell.h"

@implementation HomeCustomCell
-(void)setLabel:(NSString *)_text
{
    sectionLabel.text=_text;    
}
-(void)setImage:(NSString *)image
{
    sectionImage.image=[UIImage imageNamed:image];
}

- (void)setBackgroundImage:(NSString *) imageType sectionNo:(NSInteger) section
{
    if (section == 0)
    {
        if([imageType isEqualToString:@"top"])
        {
            backgroundImage.image = [UIImage imageNamed:@"dark-blue-top.png"];
        } else if([imageType isEqualToString:@"bottom"])
        {
            backgroundImage.image = [UIImage imageNamed:@"dark-blue-bottom.png"];
        }
    } 
    else if(section == 1)
    {
        if([imageType isEqualToString:@"top"]){
            backgroundImage.image = [UIImage imageNamed:@"light-blue-top.png"];
        } else if([imageType isEqualToString:@"mid"]){
            backgroundImage.image = [UIImage imageNamed:@"light-blue-mid.png"];
        } else if([imageType isEqualToString:@"bottom"]){
            backgroundImage.image = [UIImage imageNamed:@"light-blue-bottom.png"];
        }
    }
}

@end
