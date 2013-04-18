//
//  BraingleDB.m
//  Braingle
//
//  Created by LAWRENCE SHANNON on 4/18/13.
//
//

#import "BraingleDB.h"

@implementation BraingleDB

-(id) initialise
{
	if(![self openDatabase])
	{
		//NSLog(@"Open database failed.");
	}
    //NSLog(@"Open database");
    
	return self;
}

-(BOOL) openDatabase
{
    if (!database)
    {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Braingle.db"];
        int result = sqlite3_open([path UTF8String], &database);
        if (result != SQLITE_OK)
        {
            NSLog(@"Braingle DB Open/Create failed!");
            return NO;
        }
        
        const char *sql = "create table if not exists braingle_table (id integer,category text,date text,difficulty text,html text,popularity text,title text,url text,visited integer);";
        char *errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Braingle create DB failed!");
            return NO;
        }
    }
    
    return YES;
    
}

- (int)getBraingleDataCount: (NSString *) strCategoryType
{
    int count = 0;
    NSString *query=[NSString stringWithFormat:@"select count(*) from braingle_table where category = '%@'", strCategoryType];
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Braingle sqlite prepare failed!");
        return 0;
    }
    if (sqlite3_step(stmt))
    {
        count = sqlite3_column_int(stmt, 0);
    }
    sqlite3_finalize(stmt);
    
    return count;
}

-(BOOL)setBraingleVisited: (NSString *) strCategoryType forID: (int) id
{
    NSString *query = [NSString stringWithFormat:@"update braingle_table set visited = 1 where category = '%@' and id = %i", strCategoryType, id];
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Braingle sqlite prepare for setBraingleVisited failed!");
        return NO;
    }
    int success = sqlite3_step(stmt);
    if (success != SQLITE_DONE)
    {
        NSLog(@"Braingle sqlite update for setBraingleVisited failed: %s", sqlite3_errmsg(database));
        return NO;
    }
    sqlite3_finalize(stmt);
    
    return YES;
}

-(Braingle *)getBraingleItem: (NSString *) strCategoryType atID: (int) id
{
    NSString *query = [NSString stringWithFormat:@"select * from braingle_table where category = '%@' and id = %i", strCategoryType, id];
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Braingle sqlite prepare for getBraingleItem failed!");
        return nil;
    }
    
    Braingle *braingle = nil;
    if (sqlite3_step(stmt) == SQLITE_ROW)
    {
        braingle = [[Braingle alloc] init];
        braingle.id = sqlite3_column_int(stmt, 0);
        if ((char *)sqlite3_column_text(stmt, 1) != nil)
        {
            braingle.category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        }
        if ((char *)sqlite3_column_text(stmt, 2) != nil)
        {
            braingle.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
        }
        if ((char *)sqlite3_column_text(stmt, 6) != nil)
        {
            braingle.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
        }
        if ((char *)sqlite3_column_text(stmt, 3) != nil)
        {
            braingle.difficulty = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
        }
        if ((char *)sqlite3_column_text(stmt, 5) != nil)
        {
            braingle.popularity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
        }
        braingle.visited = sqlite3_column_int(stmt, 8);
    }
    sqlite3_finalize(stmt);
    
    return braingle;
}

- (NSMutableArray *)getBraingleData: (NSString *) strCategoryType sorttOrder: (NSString *) sortSQL
{
    Detail = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"select * from braingle_table where category = '%@' %@", strCategoryType, sortSQL];
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Braingle sqlite prepare for getBrainData failed!");
        return nil;
    }
    
    Braingle *braingle;
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        braingle = [[Braingle alloc] init];
        braingle.id = sqlite3_column_int(stmt, 0);
        if ((char *)sqlite3_column_text(stmt, 1) != nil)
        {
            braingle.category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        }
        if ((char *)sqlite3_column_text(stmt, 2) != nil)
        {
            braingle.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
        }
        if ((char *)sqlite3_column_text(stmt, 6) != nil)
        {
            braingle.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
        }
        if ((char *)sqlite3_column_text(stmt, 3) != nil)
        {
            braingle.difficulty = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
        }
        if ((char *)sqlite3_column_text(stmt, 5) != nil)
        {
            braingle.popularity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
        }
        braingle.visited = sqlite3_column_int(stmt, 8);
        [Detail addObject:braingle];
    }
    sqlite3_finalize(stmt);
    return Detail;
}

- (BOOL)addBraingleItem:(Braingle *)braingle forCategory: (NSString *) strCategoryType
{
    NSString *values=@"";
    NSNumber *t_visited = [[NSNumber alloc] initWithBool:NO];
    values=@"";
    values =[values stringByAppendingString:[NSString stringWithFormat:@"%i, ", braingle.id]];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", strCategoryType]];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", braingle.date]];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", braingle.title]];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", braingle.difficulty]];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", braingle.popularity]];
    values =[values stringByAppendingString:[NSString stringWithFormat:@"%@", t_visited]];
    
    NSString *query=[NSString stringWithFormat:@"INSERT INTO braingle_table(id,category,date,title,difficulty,popularity,visited) VALUES (%@)",values];
    
    char *errMsg = NULL;
    int result = sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg);
    
    if (result != SQLITE_OK)
    {
        NSLog(@"SQL insert item: %@/n", query);
        NSLog(@"Error : %@/n", [NSString stringWithUTF8String:errMsg]);
    }
    
    return YES;
}


- (BOOL)addBraingleData:(NSMutableArray *)listArray forCategory: (NSString *) strCategoryType
{
    NSNumber *t_id;
    NSString *t_date;
    NSString *t_title;
    NSString *t_popularity;
    NSString *t_difficulty;
    NSString *values=@"";
    
    NSNumber* t_visited = [[NSNumber alloc] initWithBool:NO];
    int count = [listArray count];
    for (int i = 0; i < count; i++)
    {
        values=@"";
        t_id  = [[NSNumber alloc] initWithInt:[[[listArray objectAtIndex:i] valueForKey:@"id"] intValue]];
        t_date = [[listArray objectAtIndex:i] valueForKey:@"date"];
        t_title = [[listArray objectAtIndex:i] valueForKey:@"title"];
        t_title = [t_title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        t_popularity = [[listArray objectAtIndex:i] valueForKey:@"popularity"];
        t_popularity = [t_popularity stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        t_difficulty = [[listArray objectAtIndex:i] valueForKey:@"difficulty"];
        t_difficulty = [t_difficulty stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        values =[values stringByAppendingString:[NSString stringWithFormat:@"%@, ", t_id]];
        values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", strCategoryType]];
        values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", t_date]];
        values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", t_title]];
        values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", t_difficulty]];
        values =[values stringByAppendingString:[NSString stringWithFormat:@"'%@', ", t_popularity]];
        values =[values stringByAppendingString:[NSString stringWithFormat:@"%@", t_visited]];
        
        NSString *query=[NSString stringWithFormat:@"INSERT INTO braingle_table(id,category,date,title,difficulty,popularity,visited) VALUES (%@)",values];
        
        char *errMsg = NULL;
        int result = sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg);
        
        if (result != SQLITE_OK)
        {
            NSLog(@"SQL insert: %@/n", query);
            NSLog(@"Error : %@/n", [NSString stringWithUTF8String:errMsg]);
        }
    }
    
    return YES;
}

@end
