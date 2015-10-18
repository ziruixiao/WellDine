//
//  SearchViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import "SearchViewController.h"
#import "VenueViewController.h"

@interface SearchViewController ()
@end

@implementation SearchViewController

//synthesize properties
@synthesize searchResults;
@synthesize searchBar;
@synthesize searchText;

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
    searchBar.delegate = (id)self;
    self.loaded = NO;
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
}

///////////////SEARCH FOR VENUE///////////////
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    if (theSearchBar.text.length != 0) {
        self.searchText = theSearchBar.text;
        [self launchLoadData];
    }
    [theSearchBar resignFirstResponder];
}

- (void)loadData
{
    self.loaded = NO;
    @autoreleasepool {
    
        NSMutableDictionary *testDict = [[NSMutableDictionary alloc] init];
        [testDict setObject:@"venues" forKey:@"table"];
        
        NSArray* keywords = [self.searchText componentsSeparatedByString: @" "];
        for (NSString *keyword in keywords) {
            [testDict setObject:@" WHERE " forKey:[NSString stringWithFormat:@"tags LIKE '%%%@%%'",keyword]];
        }
        
        [testDict setObject:@" LIMIT " forKey:@"10"];
        [testDict setObject:@" ORDER BY " forKey:@"name ASC"];
        
        BaseObject *newObject = [[BaseObject alloc] init];
        [newObject fetch:testDict];
        
        [self loadDataFromURL:nil];
        self.searchResults = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)newObject.array2];
        
        self.loaded = YES;
        
        //SETUP ALL REMAINING OBJECTS AND KEYS IN NSMUTABLEDICTIONARY
        [self.tableView reloadData];
    }
}
//////////////////////////////////////////////

///////////////LOAD TABLE VIEW///////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of rows in the section.
    if (self.loaded) return [self.searchResults count];
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"phone"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowVenue"]) {
        VenueViewController *venueViewController = [segue destinationViewController];
        venueViewController.venueData = [self.searchResults objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}
/////////////////////////////////////////////


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
