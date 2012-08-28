//
//  MasterViewTests.m
//  Braingle
//
//  Created by Manikandan K on 28/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewTests.h"

@implementation MasterViewTests

- (void)setUp
{
    [super setUp];
    
    NSLog(@"%@ setUp", self.name);
    masterViewControlle = [[MasterViewController alloc] init];
    STAssertNotNil(masterViewControlle, @"Cannot create MasterViewController instance");
    teaserSectionTwoArray=[NSMutableArray arrayWithObjects: @"Cryptography",@"Group",@"Language",@"Letter Equations",@"Logic",@"Math",@"Mystery",@"Optical Illusions",@"Other",@"Probability",@"Rebus",@"Riddles",@"Science",@"Series",@"Situation",@"Trick",@"Trivia",nil];
    teaserSectionOneArray=[NSMutableArray arrayWithObjects:@"Featured",@"Favorites",nil];
}

- (void)tearDown
{    
    [super tearDown];
}

-(void) testSize 
{
    STAssertTrue([teaserSectionTwoArray count] > 0, @"Size must be Values.");
    STAssertTrue([teaserSectionOneArray count] > 0,  @"Size must be True.");
}

@end
