//
//  BaseTableViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import <UIKit/UIKit.h>
#import "BaseObject.h"
#import "AppDelegate.h"
#import "PrettyKit.h"
#import "TDBadgedCell.h"

@interface BaseTableViewController : UITableViewController {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

//properties
@property BOOL loaded;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) NSString *username;

@property (nonatomic,strong) UIView *refreshHeaderView;
@property (nonatomic,strong) UILabel *refreshLabel;
@property (nonatomic,strong) UIImageView *refreshArrow;
@property (nonatomic,strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic,copy) NSString *textPull;
@property (nonatomic,copy) NSString *textRelease;
@property (nonatomic,copy) NSString *textLoading;

//methods
- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

- (void)loadInsert;
- (NSMutableDictionary*)insertPresets;

- (void)launchLoadData;
- (void)loadData;
- (void)loadDataFromURL:(NSString*)url;
- (void)searchStart;
- (void)searchDone;
@end
