//
//  ProfileViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@end

@implementation ProfileViewController

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"SectionData"
                                                          ofType: @"plist"];
    // Build the array from the plist
    NSArray* controlData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.horizontalSelect = [[KLHorizontalSelect alloc] initWithFrame: self.view.bounds];
    [self.horizontalSelect setTableData: controlData];
    
    //Customize the initially selected index - Note section is redundant but should always be 0
    [self.horizontalSelect setCurrentIndex:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    //Add the view as a subview
    [self.view addSubview: self.horizontalSelect];

}

- (void)horizontalSelect:(id)horizontalSelect didSelectCell:(KLHorizontalSelectCell *)cell {
    NSLog(@"Selected Cell: %@", cell.label.text);
}

///////////////LOAD TABLE VIEW///////////////
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
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
    // Dispose of any resources that can be recreated.
}

@end
