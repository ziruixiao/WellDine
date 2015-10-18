//
//  BaseViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PrettyKit.h"
#import "TDBadgedCell.h"

@interface BaseViewController : UIViewController

//properties
@property BOOL loaded;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) NSString *username;

//methods
- (void)loadKeychain;
- (void)launchLoadData;
- (void)loadData;
- (void)loadDataFromURL:(NSString*)url;
- (void)searchStart;
- (void)searchDone;

@end
