//
//  main.m
//  DiningApp
//
//  Created by Felix Xiao on 12/8/12.
//  Copyright (c) 2012 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "BaseObject.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        /*
        NSDate *now = [NSDate date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:now];
        
        NSLog(@"%i",[weekdayComponents weekday]); //saturday = 7, friday = 6, so on...
        
        
        NSLog(@"now: %@", now); // now: 2011-02-28 09:57:49 +0000
        
        NSString *strDate = [[NSString alloc] initWithFormat:@"%@",now];
        NSArray *arr = [strDate componentsSeparatedByString:@" "];
        NSString *str;
        str = [arr objectAtIndex:0];
        NSLog(@"strdate: %@",str); // strdate: 2011-02-28
        
        NSArray *arr_my = [str componentsSeparatedByString:@"-"];
        
        NSInteger date = [[arr_my objectAtIndex:2] intValue];
        NSInteger month = [[arr_my objectAtIndex:1] intValue];
        NSInteger year = [[arr_my objectAtIndex:0] intValue];
        
        NSLog(@"year = %d", year); // year = 2011
        NSLog(@"month = %d", month); // month = 2
        NSLog(@"date = %d", date); // date = 2
        */
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
