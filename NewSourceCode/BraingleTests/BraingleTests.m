//
//  BraingleTests.m
//  BraingleTests
//
//  Created by ocs on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BraingleTests.h"
@implementation BraingleTests

- (void)setUp
{
    [super setUp];
    
    NSLog(@"%@ setUp", self.name);
    brainTeaserViewController = [[BrainTeaserViewController alloc] init];
    STAssertNotNil(brainTeaserViewController, @"Cannot create Calculator instance");

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in BraingleTests");
}

- (void)testURLConnection
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:CATEGORYTYPE_URL(@"Science",@"1bc8b7bf1f5b5a55b82b2a55ce47053978623593")]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    STAssertNotNil(response, @"We should have response");
    STAssertNil(error, @"We should not have an error");
    STAssertTrue([data length] > 100, @"We should have data");
    
}
@end
