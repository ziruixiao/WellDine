//
//  CustomTabBarController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/13/2012
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController

//methods
- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;
- (void)defaultSearch;
@end
