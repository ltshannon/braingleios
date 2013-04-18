//
//  BraingleDB.h
//  Braingle
//
//  Created by LAWRENCE SHANNON on 4/18/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Braingle.h"

@interface BraingleDB : NSObject
{
    sqlite3 *database;
	NSString *databaseName;
	NSString *databasePath;
    NSMutableArray *Detail;
}

-(id) initialise;
-(BOOL)openDatabase;
-(BOOL)addBraingleData:(NSMutableArray *)listArray forCategory: (NSString *) strCategoryType;
-(NSMutableArray *)getBraingleData: (NSString *) strCategoryType sorttOrder: (NSString *) sortSQL;
-(int)getBraingleDataCount: (NSString *) strCategoryType;
-(Braingle *)getBraingleItem: (NSString *) strCategoryType atID: (int) id;
-(BOOL)setBraingleVisited: (NSString *) strCategoryType forID: (int) id;
- (BOOL)addBraingleItem:(Braingle *)braingle forCategory: (NSString *) strCategoryType;
@end
