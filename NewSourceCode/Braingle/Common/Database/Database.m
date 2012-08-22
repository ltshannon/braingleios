//
//  Database.m
//  Rupinis
//
//  Created by OCSMOB-4 on 5/17/12.
//  Copyright (c) 2012 COMPANY. All rights reserved.
//

#import "Database.h"

@implementation Database

-(id) initialise
{
	if(![self openDatabase])
	{
		//NSLog(@"Open database failed.");
	}
    //NSLog(@"Open database");
	return self;
}
/*
- (void)dealloc
{
    [super dealloc];
    [Detail release];
}
 */

-(BOOL) openDatabase
{
	databaseName = @"Braingle_DB.sqlite";
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //NSLog(@"pathg is ...=%@",documentPaths);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	if(sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) 
	{
		//NSLog(@"open database failed.");
		return NO;
	}
    [self GetFileUpdates];
	return YES;
}


-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    // Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	// If the database already exists then return without doing anything
	if(success) return;
	// If not then proceed to copy the database from the application to the users filesystem
	// Get the path to the database in the application package
	NSString *databasePathFromApp =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	//[fileManager release]; 
}

- (void) GetFileUpdates
{
    NSString *updatefile        = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dbUpdate.txt"];
    BOOL success;
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    success                     = [fileManager fileExistsAtPath:updatefile];
    
    if(success)
    {
        NSString *strFile = [NSString stringWithContentsOfFile:updatefile usedEncoding:nil error:nil];
        
        NSArray *ArrQuery = [strFile componentsSeparatedByString:@";"];
        
        for(int i=0;i<[ArrQuery count]-1;i++)
        {
            NSString *query=[NSString stringWithFormat:@"%@",[ArrQuery objectAtIndex:i]];
            
            sqlite3_stmt *compiledStatement;
            
            const char *sqlStatement = [query UTF8String];
            
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                //NSLog(@"FileDB");
                if(sqlite3_step(compiledStatement) == SQLITE_DONE)
                {
                    sqlite3_finalize(compiledStatement);
                }
            }
        }
        [[NSFileManager defaultManager] removeItemAtPath:updatefile error:nil];
    }
}

- (NSString *)dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //NSLog(@"path for data...=%@",paths);
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}


#pragma Mark -Insert Data


- (BOOL)addFavoriteData:(NSMutableDictionary *)Dict
{
    NSString *values=@""; 
    NSString *strSplit=@"";
    
    strSplit = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"id"]];
    strSplit = [strSplit stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@',",strSplit]];
    
    strSplit = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"date"]];
    strSplit = [strSplit stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@',",strSplit]];
    
    strSplit = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"title"]];
    strSplit = [strSplit stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@',",strSplit]];
    
    strSplit = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"difficulty"]];
    strSplit = [strSplit stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@',",strSplit]];
    
    strSplit = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"popularity"]];
    strSplit = [strSplit stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@'",strSplit]];
        
    NSString *query=[NSString stringWithFormat:@"INSERT INTO Favorites_Table(favorites_id,date,title,difficulty,popularity) VALUES (%@)",values];  
    
	const char *sqlStatement = [query UTF8String];
	sqlite3_stmt *compiledStatement;
    
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
	{
		if(sqlite3_step(compiledStatement) == SQLITE_DONE)
		{
			sqlite3_finalize(compiledStatement);
			return YES;
		}        
        else
        {
            
        }
	}
    else
    {
        
    }
	return NO;
}

- (NSMutableArray *)getFavoriteData;
{
    Detail = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT favorites_id,date,title,difficulty,popularity FROM Favorites_Table"];
    
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) 
    {
        int i = 0;
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
        { 
            NSMutableDictionary *ListDict = [[NSMutableDictionary alloc] init];
            
            if((char *)sqlite3_column_text(compiledStatement, 0) != nil)
                [ListDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"id"];
            
            if((char *)sqlite3_column_text(compiledStatement, 1) != nil )
                [ListDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"date"];
            
            if((char *)sqlite3_column_text(compiledStatement, 2) != nil )
                [ListDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"title"];
            
            if((char *)sqlite3_column_text(compiledStatement, 3) != nil )
                [ListDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"difficulty"];
            
            if((char *)sqlite3_column_text(compiledStatement, 4) != nil )
                [ListDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] forKey:@"popularity"];
            
            [Detail addObject:ListDict];
            i = i+1;
        }
    }
    sqlite3_finalize(compiledStatement);
    return Detail;
}

-(BOOL)removeFavoriteData:(NSString *)deleteFavoriteID;
{
    NSString *deleteQuery=[NSString stringWithFormat:@"DELETE FROM Favorites_Table WHERE favorites_id=%@",deleteFavoriteID];
    
    const char *strSQL = [deleteQuery UTF8String];
    sqlite3_stmt *strStatement;
    if(sqlite3_prepare_v2(database, strSQL, -1, &strStatement, NULL) == SQLITE_OK) {
        if (sqlite3_step(strStatement) == SQLITE_DONE) {
            sqlite3_finalize(strStatement);
            return YES;
        } else {
            //NSLog(@"error:%s",sqlite3_errmsg(database));
        }
    } else {
       // NSLog(@"error:%s",sqlite3_errmsg(database));
    }
    return NO;
}

@end
