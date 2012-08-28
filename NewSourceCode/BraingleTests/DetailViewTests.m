//
//  DetailViewTests.m
//  Braingle
//
//  Created by Manikandan K on 28/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewTests.h"

@implementation DetailViewTests

- (void)setUp
{
    [super setUp];
    NSLog(@"%@ setUp", self.name);
    detailViewController = [[DetailViewController alloc] init];
    STAssertNotNil(detailViewController, @"Cannot create DetailViewController instance");
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCheckHTMLData
{
    docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    pathToDocuments  = [[docDir objectAtIndex:0] copy];
    NSError *error = nil;
    NSString *fileName = [NSString stringWithFormat:@"22072.html"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[pathToDocuments stringByAppendingPathComponent:fileName]])
    {
        NSLog(@"Load from URL");
        NSString *urlAddress = DETAILVIEW_URL(@"22072", [OpenUDID value]);
        NSLog(@"urlAddress = %@",urlAddress);
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAddress]];
        
        [htmlData writeToFile:[NSString stringWithFormat:@"%@",[pathToDocuments stringByAppendingPathComponent:fileName]]  atomically:YES];
        STAssertNil(error, @"We should not have an error");
        STAssertTrue([htmlData length] > 100, @"We should have html data");
    }
    else 
    {
        NSMutableData *data = [NSData dataWithContentsOfFile:[pathToDocuments stringByAppendingPathComponent:fileName]];
        STAssertNil(error, @"We should not have an error");
        STAssertTrue([data length] > 100, @"We should have html data");
    }
}

@end
