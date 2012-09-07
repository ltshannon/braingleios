//
//  BraingleTests.h
//  BraingleTests
//
//  Created by ocs on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BrainTeaserViewController.h"
#import "Config.h"

@interface BrainTeaserTests : SenTestCase
{
    BrainTeaserViewController *brainTeaserViewController;
    
    NSArray                   *docDir ;
    NSString                  *pathToDocuments ;

}

@end
