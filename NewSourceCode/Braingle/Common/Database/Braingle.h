//
//  Braingle.h
//  Braingle
//
//  Created by LAWRENCE SHANNON on 4/18/13.
//
//

#import <Foundation/Foundation.h>

@interface Braingle : NSObject

@property int id;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * difficulty;
@property (nonatomic, retain) NSString * html;
@property (nonatomic, retain) NSString * popularity;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property int visited;

@end