//
//  BaseObject.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/8/2012
//

/*
 TO DO LIST
 1. When creating a BaseObject, create the tags string, including what the user specifies as tags, automatically add strings associated with the insert separated by each space.
 2. When creating a BaseObject as a venue, allow the user to use their current location to mark the spot of the restaurant, or use a map API to record the absolute location (possibly in longitude and latitude) based on an address lookup. Do not allow the object to be created until a location is determined. Post in the venues table with the key "location".
 3. When creating a BaseObject as a venue, include the amount of money a typical meal at the venue costs as a required value. Post in the venues table with the key "dollars".
 4. When creating a BaseObject as a venue, include the category of the venue. There must be at least one, separate additional ones with a comma. Post in the venues table with the key "category"
 */

#import "BaseObject.h"
#import "ASIFormDataRequest.h"

@interface BaseObject ()
- (void)fetchFailed:(ASIHTTPRequest*)myRequest;
- (void)fetchFinished:(ASIHTTPRequest*)myRequest;
- (void)insertFailed:(ASIHTTPRequest*)myRequest;
- (void)insertFinished:(ASIHTTPRequest*)myRequest;
@end

@implementation BaseObject

//synthesize properties
@synthesize request,insertDictionary,array2;

//methods

/////FETCH INFORMATION FROM MYSQL DATABASE/////
- (void)fetch:(NSMutableDictionary*)filters
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [request cancel];
    NSString *stringURLofRequest = @"http://www.zeropennies.com/dining/fetch.php";
	[self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:stringURLofRequest]]];
	
    //authentications
    [request addRequestHeader:@"Referrer" value:@"iOSApp"];
    [request setPostValue:@"felix_xiao" forKey:@"authenticate"];
    
    //specifications
    [request setPostValue:@"zerope5_dining" forKey:@"database"];
    
    /*/////MYSQL QUERY NOTES/////
     NSMutableDictionary: keys = query strings ("id=5","name='Felix'"), objects = types (" WHERE "," ORDER BY "," LIMIT ")
     */
    
    //build query
    NSString *query = @"SELECT * FROM ";
    query = [query stringByAppendingFormat:@"%@",[filters objectForKey:@"table"]];
    
    //add WHERE conditions to query
    int counter = 0;
    for (id key in filters) {
        if ([[filters objectForKey:key] isEqualToString:@" WHERE "]) {
            if (counter == 0) {
                query = [query stringByAppendingFormat:@" WHERE %@",key];
            }
            else {
                query = [query stringByAppendingFormat:@" AND %@",key];
            }
            counter++;
        }
    }
    
    //add ORDER BY conditions to query
    counter = 0;
    for (id key in filters) {
        if ([[filters objectForKey:key] isEqualToString:@" ORDER BY "]) {
            if (counter == 0) {
                query = [query stringByAppendingFormat:@" ORDER BY %@",key];
            }
            else {
                query = [query stringByAppendingFormat:@", %@",key];
            }
            counter++;
        }
    }
    
    //add LIMIT condition to query
    for (id key in filters) {
        if ([[filters objectForKey:key] isEqualToString:@" LIMIT "]) {
            query = [query stringByAppendingFormat:@" LIMIT %@",key];
        }
    }
    
    NSLog(@"Post URL: %@",stringURLofRequest);
    NSLog(@"MySQL query: %@",query);
    [request setPostValue:query forKey:@"fetch_query"];
    
    request.timeOutSeconds = 5;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    request.shouldContinueWhenAppEntersBackground = YES;
#endif
	request.delegate = self;
	[request setDidFailSelector:@selector(fetchFailed:)];
	[request setDidFinishSelector:@selector(fetchFinished:)];
	
	[request startAsynchronous];
    NSLog(@"fetch requests sent");
}

- (void)fetchFinished:(ASIHTTPRequest*)myRequest
{
    NSLog(@"fetch was finished");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    data = [[NSMutableData alloc] init];
    [data appendData:[myRequest responseData]];
    NSLog(@"before array creation in fetch finished");
    array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"after json array");
    self.array2 = [[NSArray alloc] initWithArray:array];
    NSLog(@"Number of results: %i",[self.array2 count]);
}

- (void)fetchFailed:(ASIHTTPRequest*)myRequest
{
    NSLog(@"Problem with fetch request: %@",[myRequest responseString]);
}
///////////////////////////////////////////////


/////INSERT INFORMATION INTO MYSQL DATABASE/////
- (void)insert:(NSMutableDictionary*)dictionary intoDB:(NSString*)DBName andTable:(NSString*)tableName
{
    //[request cancel];
    //NSString *stringURLofRequest = @"http://www.zeropennies.com/dining/insert.php";
	//[self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:stringURLofRequest]]];
	
    //authentications
    //[request addRequestHeader:@"Referrer" value:@"iOSApp"];
    //[request setPostValue:@"felix_xiao" forKey:@"authenticate"];
    
    //specifications
    //[request setPostValue:DBName forKey:@"database"];
	//[request setPostValue:tableName forKey:@"table"];
    
    //fields
    for (id key in [dictionary allKeys]) {
        //[request setPostValue:[dictionary objectForKey:key] forKey:key];
        NSLog(@"%@: %@",key,[dictionary objectForKey:key]);
    }
    
    //request.timeOutSeconds = 5;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    //request.shouldContinueWhenAppEntersBackground = YES;
#endif
    //request.delegate = self;
	//[request setDidFailSelector:@selector(insertFailed:)];
	//[request setDidFinishSelector:@selector(insertFinished:)];
	//[request startAsynchronous];
}

- (void)insertFinished:(ASIHTTPRequest*)myRequest
{
    NSLog(@"Successful insert request: %@",[myRequest responseString]);
}

- (void)insertFailed:(ASIHTTPRequest*)myRequest
{
    NSLog(@"Problem with insert request: %@",[myRequest responseString]);
}
////////////////////////////////////////////////

@end
