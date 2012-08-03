//
//  Database.h
//  Rupinis
//
//  Created by OCSMOB-4 on 5/17/12.
//  Copyright (c) 2012 COMPANY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define kFilename @"Braingle_DB.sqlite"

@interface Database : NSObject{
    
    sqlite3 *database;
	NSString *databaseName;
	NSString *databasePath;
}

- (id) initialise;
- (BOOL) openDatabase;
- (void) checkAndCreateDatabase;
- (void) GetFileUpdates;

- (BOOL)addFavoriteData:(NSMutableDictionary *)Dict;
- (NSMutableArray *)getFavoriteData;
- (BOOL)removeFavoriteData:(NSString *)deleteFavoriteID;

@end
