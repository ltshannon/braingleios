//
//  BraingleTests.m
//  BraingleTests
//
//  Created by ocs on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrainTeaserTests.h"
@implementation BrainTeaserTests

- (void)setUp
{
    [super setUp];
    
    NSLog(@"%@ setUp", self.name);
    brainTeaserViewController = [[BrainTeaserViewController alloc] init];
    STAssertNotNil(brainTeaserViewController, @"Cannot create BrainTeaserViewController instance");

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testURLConnection
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:CATEGORYTYPE_URL(@"Cryptography",@"1bc8b7bf1f5b5a55b82b2a55ce47053978623593")]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    STAssertNotNil(response, @"We should have response");
    STAssertNil(error, @"We should not have an error");
    STAssertTrue([data length] > 100, @"We should have data");
}

- (void)testCheckFileCreateTime
{
    NSString *fileName = [NSString stringWithFormat:@"Cryptography"];
    docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    pathToDocuments  = [[docDir objectAtIndex:0] copy];

    if (![[NSFileManager defaultManager] fileExistsAtPath:[pathToDocuments stringByAppendingPathComponent:fileName]])
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:CATEGORYTYPE_URL(@"Science",@"1bc8b7bf1f5b5a55b82b2a55ce47053978623593")]];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        STAssertNotNil(response, @"We should have response");
        STAssertNil(error, @"We should not have an error");
        STAssertTrue([data length] > 100, @"We should have data");
    } 
    else 
    {
        NSString* filePath = [pathToDocuments stringByAppendingPathComponent:fileName];
        NSError* error;
        NSDictionary* properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:filePath
                                    error:&error];
        NSDate* modificationDate = [properties objectForKey:NSFileModificationDate];
        NSDate* createDate = [properties objectForKey:NSFileModificationDate];
        NSLog(@"createDate = %@",createDate);
        NSLog(@"modificationDate = %@",modificationDate);
        
        NSDate* firstDate = modificationDate;
        NSDate* secondDate = [NSDate date];
        
        NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
        
        double seconds = timeDifference;
        double minutes = seconds/60;
        double hours = minutes/60;
        double days = minutes/1440;
        
        NSLog(@"days = %.0f, hours = %.0f, minutes = %.0f, seconds = %.0f", days, hours, minutes, seconds);
        
        if (hours > 86400.0)
        {
            NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:[NSString stringWithFormat:@"Cryptography"]]];
            STAssertNotNil(data, @"We should have response");
            STAssertNil(error, @"We should not have an error");
            STAssertTrue([data length] > 100, @"We should have data");
        } 
        else 
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:CATEGORYTYPE_URL(@"Science",@"1bc8b7bf1f5b5a55b82b2a55ce47053978623593")]];
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            STAssertNotNil(response, @"We should have response");
            STAssertNil(error, @"We should not have an error");
            STAssertTrue([data length] > 100, @"We should have data");
        }
    }
}

@end
