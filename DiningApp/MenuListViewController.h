//
//  MenuListViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/24/2012
//

#import "BaseTableViewController.h"

@interface MenuListViewController : BaseTableViewController

//properties
@property int menuCount;
@property BOOL featureScrollExpanded;
@property int currentOpenSection;
@property (nonatomic,strong) NSMutableArray *menus;
@property (nonatomic,strong) NSMutableArray *menuPhotos;
@property (nonatomic,strong) NSMutableArray *menuReviews;
@property (nonatomic,strong) NSMutableArray *menuItems;
//methods

@end
