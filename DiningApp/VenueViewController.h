//
//  VenueViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/19/2012
//

#import "BaseViewController.h"
#import "KLHorizontalSelect.h"
#import "StyledPullableView.h"

@interface VenueViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,KLHorizontalSelectDelegate,PullableViewDelegate> {
    StyledPullableView *pullDownView;
    UILabel *pullUpLabel;
}

//properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *venueData;
@property (nonatomic,strong) NSMutableArray *reviews;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *menus;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) KLHorizontalSelect* horizontalSelect;
//methods

@end
