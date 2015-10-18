//
//  BaseObject.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/8/2012
//

#import <Foundation/Foundation.h>
@class ASIFormDataRequest;

@interface BaseObject : NSObject {
    ASIFormDataRequest *request;
    NSMutableData *data;
    NSArray *array;
}

//properties
@property (strong,nonatomic) ASIFormDataRequest *request;
@property (strong,nonatomic) NSMutableDictionary *insertDictionary;
@property (strong,nonatomic) NSArray *array2;

//methods
- (void)fetch:(NSMutableDictionary*)filters;
- (void)insert:(NSMutableDictionary*)dictionary intoDB:(NSString*)DBName andTable:(NSString*)tableName;

@end
