//
//  AppDelegate.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/8/2012
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"
#import "KeychainItemWrapper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate> {
    UIWindow *window;
    CustomTabBarController *myTabBarController;
    KeychainItemWrapper *loginDetails;
}

//properties
@property (nonatomic,strong) IBOutlet UIWindow *window;
@property (nonatomic,strong) IBOutlet CustomTabBarController *myTabBarController;
@property (nonatomic,strong) KeychainItemWrapper *loginDetails;

@end
