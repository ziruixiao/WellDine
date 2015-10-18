//
//  ItemListViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/26/2012
//

#import "BaseViewController.h"

@interface ItemListViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

//properties
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSMutableArray *itemphotos;
@property (nonatomic,strong) NSMutableArray *itemreviews;
@property (nonatomic,strong) NSMutableDictionary *sortingHeaders;
@property (nonatomic,strong) NSString *sortingCondition;
@property (strong, nonatomic) IBOutlet UITableView *nameTableView;
@property (strong, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *itemSearchBar;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (strong, nonatomic) IBOutlet UIView *headerUIView;
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;

//methods
- (void)sortItems:(NSString*)newCondition;
//possible //- (void)groupItems;

@end
