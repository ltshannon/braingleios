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
}

- (void)tearDown
{    
    [super tearDown];
}

@end
