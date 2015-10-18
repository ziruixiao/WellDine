//
//  SearchViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import "BaseTableViewController.h"
#import "VenueViewController.h"

@interface SearchViewController : BaseTableViewController

//properties
@property (strong,nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSString *searchText;

//methods

@end
