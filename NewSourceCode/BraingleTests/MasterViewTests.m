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

- (void)testControllerReturnsCorrectNumberOfRows
{
	masterViewControlle = [[MasterViewController alloc] initWithStyle:UITableViewStylePlain];
	
	STAssertEquals(1, [masterViewControlle tableView:nil numberOfRowsInSection:0], @"Should have returned correct number of rows.");
}

@end
