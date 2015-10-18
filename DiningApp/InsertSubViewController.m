//
//  InsertSubViewController.m
//  WellDine
//
//  Created by Felix Xiao on 12/31/12.
//  Copyright (c) 2012 Felix Xiao. All rights reserved.
//

#import "InsertSubViewController.h"
#import "CRTableViewCell.h"
#import "PrettyKit.h"

@interface InsertSubViewController ()

@end

@implementation InsertSubViewController

@synthesize dataSource,imageSource,identifier,subTableView,rows,delegate,returnedArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //current identifiers
    //venue form: "linkchain", "venuecategory", "payment", "venuefeatures"
    if ([identifier isEqualToString:@"venuefeatures"]) {
        dataSource = [[NSArray alloc] initWithObjects:
                  @"Good For Kids",
                  @"Good For Groups",
                  @"Reservations",
                  @"Waiter Services",
                  @"Free Wifi",
                  @"Outdoor Seating",
                  @"Coat Check",
                  @"Good For Dancing",
                  @"Catering Available",
                  @"Wheelchair Accessible",
                  @"Bathrooms Available",
                  @"Child Playground",
                  @"Free Water",
                  @"Free Drink Refills",
                  @"Tip Expected",
                  @"Under Renovation",
                  @"Sports Venue",
                  @"Outside Food Welcome",
                  nil];
        imageSource = [[NSArray alloc] initWithObjects:
                  @"goodforkids.png",
                  @"goodforgroups.png",
                  @"reservations.png",
                  @"waiters.png",
                  @"wifi.png",
                  @"outdoorseating.png",
                  @"coatcheck.png",
                  @"goodfordancing.png",
                  @"catering.png",
                  @"wheelchair.png",
                  @"bathrooms.png",
                  @"playground.png",
                  @"freewater.png",
                  @"freerefills.png",
                  @"tipexpected.png",
                  @"renovation.png",
                  @"sports.png",
                  @"outsidefoodwelcome.png",
                  nil];
    } else if ([identifier isEqualToString:@"payment"]) {
        dataSource = [[NSArray alloc] initWithObjects:
                      @"Cash",
                      @"Check",
                      @"Visa",
                      @"Mastercard",
                      @"Discover",
                      @"American Express",
                      @"Other",
                      nil];
        imageSource = [[NSArray alloc] initWithObjects:
                       @"",
                       nil];
    } else if ([identifier isEqualToString:@"venuecategory"]) {
        dataSource = [[NSArray alloc] initWithObjects:
                      @"American",
                      @"Bakery",
                      @"Buffet",
                      @"Burgers",
                      @"Cafe",
                      @"Cajun",
                      @"Chicken",
                      @"Chinese",
                      @"Coffee",
                      @"Fast Food",
                      @"French",
                      @"German",
                      @"Indian",
                      @"Italian",
                      @"Mediterranean",
                      @"Mexican",
                      @"Mongolian",
                      @"Pasta",
                      @"Pizza",
                      @"Salads",
                      @"Sandwiches",
                      @"Southern",
                      @"Steaks",
                      @"Sushi",
                      @"Vegetarian",
                      nil];
        imageSource = [[NSArray alloc] initWithObjects:
                       @"",
                       nil];
    }

    selectedMarks = [NSMutableArray new];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.subTableView.backgroundView = nil;
    self.subTableView.backgroundColor = [UIColor clearColor];
    self.subTableView.separatorColor = [UIColor clearColor];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButton;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)changed:(id)sender
{
    UIDatePicker *picker = sender;
    NSLog(@"picker value changed");
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"Hmm"];
    NSLog(@"date is %@",[outputFormatter stringFromDate:picker.date]);

}

- (IBAction)done:(id)sender
{
    returnedArray = [[NSMutableArray alloc] init];
    if ([identifier isEqualToString:@"dinein"]||[identifier isEqualToString:@"delivery"]||[identifier isEqualToString:@"takeout"]||[identifier isEqualToString:@"drivethru"]||[identifier isEqualToString:@"happyhour"]) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"Hmm"];
        if (rows==1) { //open 24/7
            for (int x = 0; x < 7; x++) {
                [returnedArray addObject:@"000,2400"];
            }
            
        } else if (rows==2) { //same daily
            UIDatePicker *row1Opens = (UIDatePicker*)[self.view viewWithTag:1071];
            UIDatePicker *row1Closes = (UIDatePicker*)[self.view viewWithTag:-1071];
            for (int x = 0; x < 7; x++) { //adds this value 7 times: M,Tu,W,Th,F,Sa,Su
                [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row1Opens.date],[outputFormatter stringFromDate:row1Closes.date]]];
            }
        } else if (rows==4) { //same weekdays
            UIDatePicker *row1Opens = (UIDatePicker*)[self.view viewWithTag:1071];
            UIDatePicker *row1Closes = (UIDatePicker*)[self.view viewWithTag:-1071];
            for (int x = 0; x < 5; x++) { //adds this value 5 times: M,Tu,W,Th,F
                [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row1Opens.date],[outputFormatter stringFromDate:row1Closes.date]]];
            }
            //add this once for Sa
            UIDatePicker *row2Opens = (UIDatePicker*)[self.view viewWithTag:1072];
            UIDatePicker *row2Closes = (UIDatePicker*)[self.view viewWithTag:-1072];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row2Opens.date],[outputFormatter stringFromDate:row2Closes.date]]];
            //add this once for Su
            UIDatePicker *row3Opens = (UIDatePicker*)[self.view viewWithTag:1073];
            UIDatePicker *row3Closes = (UIDatePicker*)[self.view viewWithTag:-1073];
                [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row3Opens.date],[outputFormatter stringFromDate:row3Closes.date]]];
            
        } else { //add for each day
            //add this once for M
            UIDatePicker *row1Opens = (UIDatePicker*)[self.view viewWithTag:1071];
            UIDatePicker *row1Closes = (UIDatePicker*)[self.view viewWithTag:-1071];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row1Opens.date],[outputFormatter stringFromDate:row1Closes.date]]];
            //add this once for Sa
            UIDatePicker *row2Opens = (UIDatePicker*)[self.view viewWithTag:1072];
            UIDatePicker *row2Closes = (UIDatePicker*)[self.view viewWithTag:-1072];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row2Opens.date],[outputFormatter stringFromDate:row2Closes.date]]];
            //add this once for Sa
            UIDatePicker *row3Opens = (UIDatePicker*)[self.view viewWithTag:1073];
            UIDatePicker *row3Closes = (UIDatePicker*)[self.view viewWithTag:-1073];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row3Opens.date],[outputFormatter stringFromDate:row3Closes.date]]];
            //add this once for Sa
            UIDatePicker *row4Opens = (UIDatePicker*)[self.view viewWithTag:1074];
            UIDatePicker *row4Closes = (UIDatePicker*)[self.view viewWithTag:-1074];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row4Opens.date],[outputFormatter stringFromDate:row4Closes.date]]];
            //add this once for Sa
            UIDatePicker *row5Opens = (UIDatePicker*)[self.view viewWithTag:1075];
            UIDatePicker *row5Closes = (UIDatePicker*)[self.view viewWithTag:-1075];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row5Opens.date],[outputFormatter stringFromDate:row5Closes.date]]];
            //add this once for Sa
            UIDatePicker *row6Opens = (UIDatePicker*)[self.view viewWithTag:1076];
            UIDatePicker *row6Closes = (UIDatePicker*)[self.view viewWithTag:-1076];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row6Opens.date],[outputFormatter stringFromDate:row6Closes.date]]];
            //add this once for Su
            UIDatePicker *row7Opens = (UIDatePicker*)[self.view viewWithTag:1077];
            UIDatePicker *row7Closes = (UIDatePicker*)[self.view viewWithTag:-1077];
            [returnedArray addObject:[NSString stringWithFormat:@"%@,%@",[outputFormatter stringFromDate:row7Opens.date],[outputFormatter stringFromDate:row7Closes.date]]];
        }
        NSLog(@"%@", returnedArray);
        [delegate passBack:returnedArray];
    } else {
        NSLog(@"%@", selectedMarks);
        [delegate passBack:selectedMarks];
    }
        
    [[self navigationController] popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([identifier isEqualToString:@"dinein"]||[identifier isEqualToString:@"delivery"]||[identifier isEqualToString:@"takeout"]||[identifier isEqualToString:@"drivethru"]||[identifier isEqualToString:@"happyhour"]) {
        if (rows==0) {return 8; }
        return rows;
    }

    return [dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([identifier isEqualToString:@"dinein"]||[identifier isEqualToString:@"delivery"]||[identifier isEqualToString:@"takeout"]||[identifier isEqualToString:@"drivethru"]||[identifier isEqualToString:@"happyhour"]) {
        if (indexPath.row==0) { return 120; }
        return 250;
    }
    return 44;
}

- (IBAction)switchAction:(id)sender
{
    UISwitch *theSwitch = sender;
    if (theSwitch.tag==1050) { //24/7
        if (theSwitch.on==YES) {
            rows = 1;
        } else {
            rows = 8;
        }
    }
    
    if (theSwitch.tag==1051) { //same on weekdays
        if (rows!=1&&rows!=2) {
        if (theSwitch.on==YES) {
            rows = 4;
        } else {
            rows = 8;
        }
        }
    }
    
    if (theSwitch.tag==1052) { //same every day
        if (rows!=1) {
            if (theSwitch.on==YES) {
                rows = 2;
            } else {
                rows = 8;
            }
        }
    }
    
    [self.subTableView reloadData];
    
}

- (IBAction)updateDaily:(id)sender
{
    NSLog(@"daily value changed");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
    
    if ([identifier isEqualToString:@"dinein"]||[identifier isEqualToString:@"delivery"]||[identifier isEqualToString:@"takeout"]||[identifier isEqualToString:@"drivethru"]||[identifier isEqualToString:@"happyhour"]) {
        
        static NSString *CellIdentifier = @"InsertSubCell";
        PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; cell.tableViewBackgroundColor = [UIColor clearColor]; cell.backgroundColor = [UIColor clearColor]; cell.customBackgroundColor = [UIColor clearColor]; cell.textLabel.textColor = [UIColor blackColor]; cell.accessoryType = UITableViewCellAccessoryNone; cell.selectionStyle = UITableViewCellSelectionStyleNone; cell.borderColor = [UIColor clearColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for (id view in [cell subviews]) {
            if ([view isKindOfClass:[UIDatePicker class]]||[view isKindOfClass:[UISegmentedControl class]]||[view isKindOfClass:[UILabel class]]||[view isKindOfClass:[UISwitch class]]) {
                [view removeFromSuperview];
            }
        }
        
        UILabel *hoursTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,0,150,50)];
        hoursTitle.textColor = [UIColor whiteColor];
        hoursTitle.backgroundColor = [UIColor clearColor];
        hoursTitle.font = [UIFont boldSystemFontOfSize:24];
        
        UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,45,160,15)];
        openLabel.backgroundColor = [UIColor clearColor];
        openLabel.textColor = [UIColor greenColor];
        openLabel.textAlignment = NSTextAlignmentCenter;
        openLabel.font = [UIFont boldSystemFontOfSize:14];
        openLabel.text = @"Opens";
        UILabel *closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160,45,160,15)];
        closeLabel.backgroundColor = [UIColor clearColor];
        closeLabel.textColor = [UIColor redColor];
        closeLabel.textAlignment = NSTextAlignmentCenter;
        closeLabel.font = [UIFont boldSystemFontOfSize:14];
        closeLabel.text = @"Closes";
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.frame = CGRectMake(-10,65,175,175);
        datePicker.minuteInterval = 15;
        
        UIDatePicker *datePicker2 = [[UIDatePicker alloc] init];
        datePicker2.datePickerMode = UIDatePickerModeTime;
        datePicker2.frame = CGRectMake(155,65,175,175);
        datePicker2.minuteInterval = 15;
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"Manual", @"24 Hours", @"Closed", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        
        segmentedControl.frame = CGRectMake(160,10,160,30);
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; [segmentedControl setWidth:50 forSegmentAtIndex:0]; [segmentedControl setWidth:55 forSegmentAtIndex:1]; [segmentedControl setWidth:45 forSegmentAtIndex:2];[segmentedControl addTarget:self action:@selector(updateDaily:) forControlEvents:UIControlEventValueChanged];
        
        switch (indexPath.row) {
            case 0: {
                UISwitch *open247 = [[UISwitch alloc] initWithFrame:CGRectMake(231,10,79,27)];
                [open247 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                open247.tag = 1050;
                if (rows==1) { open247.on = YES; }
                [cell addSubview:open247];
                
                UILabel *open247Label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,220,27)];
                open247Label.textColor = [UIColor whiteColor];
                open247Label.backgroundColor = [UIColor clearColor];
                open247Label.font = [UIFont boldSystemFontOfSize:14];
                open247Label.text = @"Open 24 hours every day:";
                [cell addSubview:open247Label];
                
                UISwitch *sameweekdays = [[UISwitch alloc] initWithFrame:CGRectMake(231,47,79,27)];
                [sameweekdays addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                sameweekdays.tag = 1051;
                if (rows==4) { sameweekdays.on = YES; }
                [cell addSubview:sameweekdays];
                
                UILabel *sameweekdaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,47,220,27)];
                sameweekdaysLabel.textColor = [UIColor whiteColor];
                sameweekdaysLabel.backgroundColor = [UIColor clearColor];
                sameweekdaysLabel.font = [UIFont boldSystemFontOfSize:14];
                sameweekdaysLabel.text = @"Same hours on weekdays:";
                [cell addSubview:sameweekdaysLabel];
                
                UISwitch *sameeveryday = [[UISwitch alloc] initWithFrame:CGRectMake(231,84,79,27)];
                [sameeveryday  addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                sameeveryday.tag = 1052;
                if (rows==2) { sameeveryday.on = YES; }
                [cell addSubview:sameeveryday];
                
                UILabel *sameeverydayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,84,220,27)];
                sameeverydayLabel.textColor = [UIColor whiteColor];
                sameeverydayLabel.backgroundColor = [UIColor clearColor];
                sameeverydayLabel.font = [UIFont boldSystemFontOfSize:14];
                sameeverydayLabel.text = @"Same hours every day:";
                [cell addSubview:sameeverydayLabel];
                
                break;
            }
            case 1: {
                if (rows==2) { //same everyday
                    hoursTitle.text = @"Daily";
                } else if (rows==4) { //same on weekdays
                    hoursTitle.text = @"Weekdays";
                } else if (rows==8||rows==0) {
                    hoursTitle.text = @"Mondays";
                }
                [cell addSubview:hoursTitle];
                [cell addSubview:segmentedControl];
                [cell addSubview:openLabel];
                [cell addSubview:closeLabel];
                datePicker.tag = 1071;
                datePicker2.tag = -1071;
                [cell addSubview:datePicker];
                [cell addSubview:datePicker2];
                break;
            }
            case 2: {
                if (rows==4) { //same on weekdays
                    hoursTitle.text = @"Saturdays";
                } else if (rows==8||rows==0) {
                    hoursTitle.text = @"Tuesdays";
                }
                [cell addSubview:hoursTitle];
                [cell addSubview:segmentedControl];
                [cell addSubview:openLabel];
                [cell addSubview:closeLabel];
                datePicker.tag = 1072;
                datePicker2.tag = -1072;
                [cell addSubview:datePicker];
                [cell addSubview:datePicker2];
                break;
            }
            case 3: {
                if (rows==4) { //same on weekdays
                    hoursTitle.text = @"Sundays";
                } else if (rows==8||rows==0) {
                    hoursTitle.text = @"Wednesdays";
                }
                [cell addSubview:hoursTitle];
                [cell addSubview:segmentedControl];
                [cell addSubview:openLabel];
                [cell addSubview:closeLabel];
                datePicker.tag = 1073;
                datePicker2.tag = -1073;
                [cell addSubview:datePicker];
                [cell addSubview:datePicker2];
                break;
            }
            case 4: {
                if (rows==8||rows==0) {
                    hoursTitle.text = @"Thursdays";
                }
                [cell addSubview:hoursTitle];
                [cell addSubview:segmentedControl];
                [cell addSubview:openLabel];
                [cell addSubview:closeLabel];
                datePicker.tag = 1074;
                datePicker2.tag = -1074;
                [cell addSubview:datePicker];
                [cell addSubview:datePicker2];
                break;
            }
            case 5: {
                if (rows==8||rows==0) {
                    hoursTitle.text = @"Fridays";
                }
                [cell addSubview:hoursTitle];
                [cell addSubview:segmentedControl];
                [cell addSubview:openLabel];
                [cell addSubview:closeLabel];
                datePicker.tag = 1075;
                datePicker2.tag = -1075;
                [cell addSubview:datePicker];
                [cell addSubview:datePicker2];
                break;
            }
            case 6: {
                if (rows==8||rows==0) {
                    hoursTitle.text = @"Saturdays";
                }
                [cell addSubview:hoursTitle];
                [cell addSubview:segmentedControl];
                [cell addSubview:openLabel];
                [cell addSubview:closeLabel];
                datePicker.tag = 1076;
                datePicker2.tag = -1076;
                [cell addSubview:datePicker];
                [cell addSubview:datePicker2];
                break;
            }
            case 7: {
                if (rows==8||rows==0) {
                    hoursTitle.text = @"Sundays";
                }
                [cell addSubview:hoursTitle];
                [cell addSubview:segmentedControl];
                [cell addSubview:openLabel];
                [cell addSubview:closeLabel];
                datePicker.tag = 1077;
                datePicker2.tag = -1077;
                [cell addSubview:datePicker];
                [cell addSubview:datePicker2];
                break;
            }
            default: {
                break;
            }   
        }
        
        
        
        [cell prepareForTableView:tableView indexPath:indexPath];
        return cell;
    } else {
        // init the CRTableViewCell
        CRTableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
    
        if (cell == nil) {
            cell = [[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRTableViewCellIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        // Check if the cell is currently selected (marked)
        NSString *text = [dataSource objectAtIndex:[indexPath row]];
        cell.isSelected = [selectedMarks containsObject:text] ? YES : NO;
        cell.textLabel.text = text;
        cell.layer.borderWidth = 0;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270,2,40,40)];
        iconImageView.image = [UIImage imageNamed:[imageSource objectAtIndex:[indexPath row]]];
        iconImageView.tag = -234;
        for (UIImageView *imageView in cell.subviews) {
            if (imageView.tag=-234&&imageView.frame.origin.x==270)
            { [imageView removeFromSuperview]; }
        }
        [cell addSubview:iconImageView];
        cell.textLabel.textColor = [UIColor whiteColor];
    
        return cell;
    }
    return nil;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [dataSource objectAtIndex:[indexPath row]];
    
    if ([selectedMarks containsObject:text])// Is selected?
        [selectedMarks removeObject:text];
    else
        [selectedMarks addObject:text];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
