//
//  HomeViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import "HomeViewController.h"
#import "VenueViewController.h"
#import "MenuListViewController.h"
#import "ItemListViewController.h"

@interface HomeViewController ()
@end

@implementation HomeViewController

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
}

///////////////TEMPORARY, DELETE LATER///////////////
- (IBAction)showVenue:(int)venueIdentifier
{
    [NSThread detachNewThreadSelector:@selector(loadVenue) toTarget:self withObject:nil];
}

- (void)loadVenue
{
    self.loaded = NO;
    @autoreleasepool {
    
        NSMutableDictionary *testDict = [[NSMutableDictionary alloc] init];
        [testDict setObject:@"venues" forKey:@"table"];
        
        [testDict setObject:@" WHERE " forKey:@"venueID=1"];
        
        [testDict setObject:@" LIMIT " forKey:@"10"];
        [testDict setObject:@" ORDER BY " forKey:@"name ASC"];
        
        BaseObject *newObject = [[BaseObject alloc] init];
        [newObject fetch:testDict];
        
        [self loadDataFromURL:nil];
        
        //actions here
        VenueViewController *venueVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VenuePage"];
        venueVC.venueData = [newObject.array2 objectAtIndex:0];
        [self.navigationController pushViewController:venueVC animated:YES];
    
    }
}

- (IBAction)showMenuList:(int)menuListIdentifier
{
    [NSThread detachNewThreadSelector:@selector(loadMenuList) toTarget:self withObject:nil];
}

- (void)loadMenuList
{
    self.loaded = NO;
    @autoreleasepool {
    
        NSMutableDictionary *testDict = [[NSMutableDictionary alloc] init];
        [testDict setObject:@"menus" forKey:@"table"];
        
        [testDict setObject:@" WHERE " forKey:@"venueID=1"];
        
        [testDict setObject:@" LIMIT " forKey:@"10"];
        [testDict setObject:@" ORDER BY " forKey:@"name ASC"];
        
        BaseObject *newObject = [[BaseObject alloc] init];
        [newObject fetch:testDict];
        
        [self loadDataFromURL:nil];
        
        //actions here
        MenuListViewController *menuListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuListPage"];
        menuListVC.menuCount = [newObject.array2 count];
        menuListVC.menus = [NSMutableArray arrayWithArray:(NSMutableArray*)newObject.array2];
        [self.navigationController pushViewController:menuListVC animated:YES];
    
    }
}

- (IBAction)showItemList:(int)itemListIentifier
{
    [NSThread detachNewThreadSelector:@selector(loadItemList) toTarget:self withObject:nil];
}

- (void)loadItemList
{
    self.loaded = NO;
    @autoreleasepool {
    
        NSMutableDictionary *testDict = [[NSMutableDictionary alloc] init];
        [testDict setObject:@"items" forKey:@"table"];
        [testDict setObject:@" WHERE " forKey:@"menuID=1"];
        [testDict setObject:@" ORDER BY " forKey:@"name ASC"];
        BaseObject *newObject = [[BaseObject alloc] init];
        [newObject fetch:testDict];
        
        NSMutableDictionary *testDict2 = [[NSMutableDictionary alloc] init];
        [testDict2 setObject:@"reviews" forKey:@"table"];
        [testDict2 setObject:@" WHERE " forKey:@"menuID=1"];
        [testDict2 setObject:@" ORDER BY " forKey:@"reviewID DESC"];
        BaseObject *newObject2 = [[BaseObject alloc] init];
        [newObject2 fetch:testDict2];
        
        NSMutableDictionary *testDict3 = [[NSMutableDictionary alloc] init];
        [testDict3 setObject:@"photos" forKey:@"table"];
        [testDict3 setObject:@" WHERE " forKey:@"menuID=1"];
        [testDict3 setObject:@" ORDER BY " forKey:@"reviewID DESC"];
        BaseObject *newObject3 = [[BaseObject alloc] init];
        [newObject3 fetch:testDict3];
        
        [self loadDataFromURL:nil];
        
        //actions here
        ItemListViewController *itemListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemListPage"];
        itemListVC.items = [NSMutableArray arrayWithArray:(NSMutableArray*)newObject.array2];
        itemListVC.itemreviews = [NSMutableArray arrayWithArray:(NSMutableArray*)newObject2.array2];
        itemListVC.itemphotos = [NSMutableArray arrayWithArray:(NSMutableArray*)newObject3.array2];
        [self.navigationController pushViewController:itemListVC animated:YES];
    }
}
/////////////////////////////////////////////////////

///////////////LOAD TABLE VIEW///////////////
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    switch (indexPath.section) {
        default:
            break;
    }
    
    [cell prepareForTableView:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        cell.cornerRadius = 20;
    }
    else {
        cell.cornerRadius = 10;
    }
    return cell;
}
 */
/////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
