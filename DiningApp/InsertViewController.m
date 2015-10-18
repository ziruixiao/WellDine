//
//  InsertViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/28/2012
//

#import "InsertViewController.h"
#import "BaseObject.h"
#import "AppDelegate.h"
#import "PrettyKit.h"
#import "TDBadgedCell.h"

@interface InsertViewController ()
@end

@implementation InsertViewController

//synthesize properties
@synthesize customPresets,insertTableView,product,contentView,bestNightsArray;

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
    self.bestNightsArray = [[NSMutableArray alloc] init];
    
    

}


- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self.insertTableView addGestureRecognizer:tap];
    
    self.insertTableView.backgroundView = nil;
    self.insertTableView.backgroundColor = [UIColor clearColor];
    
	NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"HS_InsertPage" ofType: @"plist"];
    NSArray* controlData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    self.horizontalSelect = [[KLHorizontalSelect alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-44)];
    [self.horizontalSelect setTableData:controlData];
    [self.horizontalSelect setDelegate:self];
    
    //SET INITIAL ROW SELECTED USING CUSTOMPRESETS
    [self.horizontalSelect setCurrentIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.horizontalSelect.arrow show:YES];
    [self.contentView addSubview:self.horizontalSelect];
    
    self.product = [[NSMutableDictionary alloc] init];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitInsert)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelInsert)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    _dropDownSelection = [[VPPDropDown alloc] initSelectionWithTitle:@"Attire"
                                                           tableView:self.insertTableView
                                                           indexPath:[NSIndexPath indexPathForRow:0 inSection:4]
                                                            delegate:self
                                                       selectedIndex:0
                                                       elementTitles:@"None Selected", @"Casual", @"Business Casual", @"Casual Elegant", @"Formal", @"Jacket Required", nil];
    int openrows = 0;
    
    if (_dropDownSelection.expanded==YES) { openrows+=6; }
    
    _dropDownSelection2 = [[VPPDropDown alloc] initSelectionWithTitle:@"Ambience"
                                                            tableView:self.insertTableView
                                                            indexPath:[NSIndexPath indexPathForRow:0 inSection:5]
                                                             delegate:self
                                                        selectedIndex:0
                                                        elementTitles:@"None Selected", @"Casual", @"Classy", @"Romantic", @"Trendy", @"Calming", nil];
    if (_dropDownSelection2.expanded==YES) { openrows+=6; }
    
    _dropDownSelection3 = [[VPPDropDown alloc] initSelectionWithTitle:@"Music"
                                                            tableView:self.insertTableView
                                                            indexPath:[NSIndexPath indexPathForRow:0 inSection:6]
                                                             delegate:self
                                                        selectedIndex:1
                                                        elementTitles:@"None Selected", @"None", @"Live Music", @"Recorded Music", nil];
    
    _dropDownSelection4 = [[VPPDropDown alloc] initSelectionWithTitle:@"Alcohol"
                                                            tableView:self.insertTableView
                                                            indexPath:[NSIndexPath indexPathForRow:0 inSection:7]
                                                             delegate:self
                                                        selectedIndex:1
                                                        elementTitles:@"None Selected", @"None", @"Full Bar", @"Beer Only", @"Beer & Wine", @"BYOB", nil];
    
    _dropDownSelection5 = [[VPPDropDown alloc] initSelectionWithTitle:@"Smoking"
                                                            tableView:self.insertTableView
                                                            indexPath:[NSIndexPath indexPathForRow:0 inSection:8]
                                                             delegate:self
                                                        selectedIndex:1
                                                        elementTitles:@"None Selected", @"Not Allowed", @"Limited", @"Allowed", nil];
}

////////////////REVERSE GEOCODE CURRENT LOCATION//////////////
- (IBAction)useCurrentLocation:(id)sender
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    [locationManager stopUpdatingLocation];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"USStateAbbreviations" ofType:@"plist"];
    NSDictionary *dictionary= [[NSDictionary alloc] initWithContentsOfFile:path];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    __block NSString *address = @"";
    __block NSString *city = @"";
    __block NSString *state = @"";
    __block NSString *zipCode = @"";
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            address = [address stringByAppendingString:[placemark subThoroughfare]];
            address = [address stringByAppendingFormat:@" %@",[placemark thoroughfare]];
            city = [city stringByAppendingString:[placemark locality]];
            state = [state stringByAppendingFormat:@"%@",[dictionary objectForKey:[[placemark administrativeArea] uppercaseString]]];
            zipCode = [zipCode stringByAppendingString:[placemark postalCode]];
        }
        [(UITextField*)[self.insertTableView viewWithTag:1001] setText:address];
        [(UITextField*)[self.insertTableView viewWithTag:1002] setText:city];
        [(UITextField*)[self.insertTableView viewWithTag:1003] setText:state];
        [(UITextField*)[self.insertTableView viewWithTag:1004] setText:zipCode];
    }];
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

- (void)reverseGeocoder:(CLGeocoder*)geocoder didFailWithError:(NSError*)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}
//////////////////////////////////////////////////////////////

- (void)horizontalSelect:(id)horizontalSelect didSelectCell:(KLHorizontalSelectCell*)cell
{
    [self loadNewForm];
}

- (IBAction)cancelInsert
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitInsert
{
    //INITIALIZE self.product and CLEAR IT OF ALL KEYS/OBJECTS
    NSString *insertResponse = @"";
    NSString *insertTable = @"";
    NSString *insertDB = @"welldine";
    bool clearToInsert = NO;
    if (self.horizontalSelect.currentIndex.row==0) {
        insertResponse = [self insertVenue];
        if ([insertResponse isEqualToString:@"success"]) {
            clearToInsert = YES;
            insertTable = @"venues";
        } else {
            //show alert with insertResponse as the error
        }
    } else if (self.horizontalSelect.currentIndex.row==1) {
        insertResponse = [self insertMenu];
        if ([insertResponse isEqualToString:@"success"]) {
            clearToInsert = YES;
            insertTable = @"menus";
        } else {
            //show alert with insertResponse as the error
        }
    } else if (self.horizontalSelect.currentIndex.row==2) {
        insertResponse = [self insertItem];
        if ([insertResponse isEqualToString:@"success"]) {
            clearToInsert = YES;
            insertTable = @"items";
        } else {
            //show alert with insertResponse as the error
        }
    } else if (self.horizontalSelect.currentIndex.row==3) {
        insertResponse = [self insertReview];
        if ([insertResponse isEqualToString:@"success"]) {
            clearToInsert = YES;
            insertTable = @"reviews";
        } else {
            //show alert with insertResponse as the error
        }
    } else if (self.horizontalSelect.currentIndex.row==4) {
        insertResponse = [self insertPhoto];
        if ([insertResponse isEqualToString:@"success"]) {
            clearToInsert = YES;
            insertTable = @"photos";
        } else {
            //show alert with insertResponse as the error
        }
    }
    
    if (clearToInsert==YES) {
        BaseObject *myObject = [[BaseObject alloc] init];
        [myObject insert:self.product intoDB:insertDB andTable:insertTable];
        //show alert saying thanks!
    }
}

//USE TAGS TO RETRIEVE VALUES, ADD KEY AND OBJECT TO SELF PRODUCT NSMUTABLEDICTIONARY
/*
 1. CHECK FOR ESSENTIAL VALUES
 bool problem = NO;
 NSString *problemString = @"";
 for (UIView *subview in self.insertTableView.subviews) {
    switch ((int)subview.tag) {
        case 4:
            //this is essential
            if (subview.text==nil) { 
                if (![problemString isEqualToString:@""]) {
                    problemString = [problemString stringByAppendingString:@","];
                }
                problemString = [problemString stringByAppendingString:@"venue name"];
            }
            break;
        default:
            //nothing
            break;
    }
 }
 
 if (problem==YES) {
    return [NSString stringWithFormat:@"Please provide a value for thesse fields: %@.",problemString];
 }
 
 2. ADD VALUES
 for (UIView *subview in self.insertTableView.subviews) {
    switch ((int)subview.tag) {
        case 0:
            //go through all casese this time
            [self.product setObject:subview.text forKey:@"key"];
            break;
        default:
            //nothing
            break;
    }
 } 
 */

- (NSString*)insertVenue
{
    //2 baseobjects, one for venues and one for features
    
    //VENUES///////////////////
    //FROM VIEWCONTROLLER
    //name (REQ)
    //tags
    //address (REQ)
    //physical
    //phone
    //weburl
    //parking
    //location (REQ)
    //dollars (REQ)
    //category (REQ)
    
    //MANUAL SETUP
    //userID, current logged in user
    //additional tags
    
    
    //SETUP in PHP
    //venueID (auto increment)
    //menuID (always -1)
    //reviewID (always -1)
    //photoID (always -1)
    //itemID (always -1)
    //ups (default 0)
    //downs (default 0)
    //timestamp (default time())
    //lastupdated (default time())
    
    
    //FEATURES/////////////
    //FROM VIEWCONTROLLER
    //dineintimes (REQ)
    //takeouttimes (REQ)
    //deliverytimes (REQ)
    //studentdiscount (default = "no")
    //tender (options)
    //alcohol (options, default = "no")
    //goodforkids (default = -1)
    //attire (options)
    //goodforgroups (default = -1)
    //reservations (default = -1)
    //waiters (default = -1)
    //wifi (default = -1)
    //outdoorseating (default = -1)
    //noise level (1-10)
    //ambience (options)
    //tvs (number)
    //music (options)
    //bestnights (options)
    //happyhour (tenatitive string)
    //smoking (options)
    //coatcheck (default = -1)
    //goodfordancing (default = -1)
    //catering (default = -1)
    //wheelchair (default = -1)
    //bathrooms (default = -1)
    //seniordiscount (default = "no")
    //childdiscount (default = "no")
    //playground (default = -1)
    //drivethroughtimes (REQ)
    //capacity (number, default = -1)
    //waittime (number, default = -1)
    //freewater (default = -1)
    //freefood (string, default = "no")
    //freerefills (default = -1)
    //tipexpected (default = -1)
    //renovation (default = 0)
    //sports (default = -1)
    //outsidefoodwelcome (default = 0)
    //emailaddress
    //facebook
    //twitter
    
    //SETUP IN PHP
    //venueID (auto increment)
    
    return @"success";
}

- (NSString*)insertMenu
{
    return @"success";
}

- (NSString*)insertItem
{
    return @"success";
}

- (NSString*)insertReview
{
    return @"success";
}

- (NSString*)insertPhoto
{
    return @"success";
}

- (void)loadNewForm
{
    for (UIView *view in self.insertTableView.subviews) {
        [view removeFromSuperview];
    }
    [self.insertTableView reloadData];
}

- (IBAction)sliderAction:(id)sender
{
    UISlider *slider = (UISlider*)[self.insertTableView viewWithTag:-1007];
    [(UITextField*)[self.insertTableView viewWithTag:1007] setText:[NSString stringWithFormat:@"%i",(int)roundl(slider.value)]];
    
    UISlider *slider2 = (UISlider*)[self.insertTableView viewWithTag:-1014];
    [(UITextField*)[self.insertTableView viewWithTag:1014] setText:[NSString stringWithFormat:@"%i",(int)roundl(slider2.value)]];
    
    UISlider *slider3 = (UISlider*)[self.insertTableView viewWithTag:-1015];
    [(UITextField*)[self.insertTableView viewWithTag:1015] setText:[NSString stringWithFormat:@"%i",(int)roundl(slider3.value)]];
    
    UISlider *slider4 = (UISlider*)[self.insertTableView viewWithTag:-1008];
    [(UITextField*)[self.insertTableView viewWithTag:1008] setText:[NSString stringWithFormat:@"%i",(int)roundl(slider4.value)]];
    
    UISlider *slider5 = (UISlider*)[self.insertTableView viewWithTag:-1013];
    [(UITextField*)[self.insertTableView viewWithTag:1013] setText:[NSString stringWithFormat:@"%i",(int)roundl(slider5.value)]];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:18];
    
    if (tableView==self.insertTableView) {
        switch (self.horizontalSelect.currentIndex.row) {
            case 0:
                switch (section) { //add cases for the number of sections
                    case 0: //name,link to venue chain
                        label.text=@"     Add Venue";
                        break;
                    case 1: //use current location, street address, city state zipcode, physical, parking
                        label.text=@"     Location";
                        break;
                    case 2: //dine-in, delivery, takeout, drive through
                        label.text=@"     Hours";
                        break;
                    case 3: //category, cost of meal, tender catalog, feature catalog
                        label.text=@"     Basic Features";
                        break;
                    case 4: //attire, ambience, noise level, tvs, music, best nights, alcohol, happy hour, smoking
                        label.text=@"     Additional Features";
                        break;
                    case 10: //phone, url, email, facebook, twitter
                        label.text=@"     Contact Information";
                        break;
                    case 11: //free food, student discount, senior discount, children discount
                        label.text=@"     Discounts & Deals";
                        break;
                    default:
                        break;
                }
                break;
            case 1:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            case 2:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            case 3:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            case 4:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    return label;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.horizontalSelect.currentIndex.row==0&&(section==9||section==5||section==6||section==7||section==8)) {
        return 0.1;
    }
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView==self.insertTableView) {
        switch (self.horizontalSelect.currentIndex.row) {
            case 0:
                return 12;
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                break;
            default:
                break;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:section];
    
    if (tableView==self.insertTableView) {
        switch (self.horizontalSelect.currentIndex.row) {
            case 0:
                switch (section) { //add cases for the number of sections
                    case 0: //name,link to venue chain
                        return 2;
                    case 1: //use current location, street address, city state zipcode, physical, parking
                        return 5;
                    case 2: //dine-in, delivery, takeout, drive through
                        return 4;
                    case 3: //category, cost of meal, wait time, tender catalog, feature catalog
                        return 5;
                    case 4:
                        return 1+rows;
                    case 5:
                        return 1+rows;
                    case 6:
                        return 1+rows;
                    case 7:
                        return 1+rows;
                    case 8:
                        return 1+rows;
                    case 9: //attire, ambience, capacity, noise level, tvs, music, best nights, alcohol, happy hour, smoking
                        return 5;
                    case 10: //phone, url, email, facebook, twitter
                        return 5;
                    case 11: //free food, student discount, senior discount, children discount
                        return 4;
                    default:
                        break;
                }
                break;
            case 1:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            case 2:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            case 3:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            case 4:
                switch (section) { //add cases for the number of sections
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.horizontalSelect.currentIndex.row==0&&tableView==self.insertTableView) {
        if ((indexPath.section==1&&(indexPath.row==3||indexPath.row==4))||(indexPath.section==11)) {
            return 110;
        }
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        return [VPPDropDown tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    static NSString *CellIdentifier = @"InsertCell";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; cell.tableViewBackgroundColor = [UIColor clearColor]; cell.backgroundColor = [UIColor clearColor]; cell.customBackgroundColor = [UIColor clearColor]; cell.textLabel.textColor = [UIColor blackColor]; cell.accessoryType = UITableViewCellAccessoryNone; cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    for (id view in [cell subviews]) //remove everything from tableview
    {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIButton class]]  || [view isKindOfClass:[UISwitch class]] || [view isKindOfClass:[UISlider class]] || [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UISegmentedControl class]]) {
            [view removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITextField *fullTextFieldEdge = [[UITextField alloc] initWithFrame:CGRectMake(25,9,270,30)]; fullTextFieldEdge.borderStyle = UITextBorderStyleRoundedRect; fullTextFieldEdge.textAlignment = NSTextAlignmentCenter; fullTextFieldEdge.delegate = self;
    UITextField *fullTextField = [[UITextField alloc] initWithFrame:CGRectMake(25,7,270,30)]; fullTextField.borderStyle = UITextBorderStyleRoundedRect; fullTextField.textAlignment = NSTextAlignmentCenter; fullTextField.delegate = self;
    UITextField *fullTextFieldEdgeReq = [[UITextField alloc] initWithFrame:CGRectMake(25,7,270,30)]; fullTextFieldEdgeReq.borderStyle = UITextBorderStyleRoundedRect; fullTextFieldEdgeReq.layer.cornerRadius=8.0f; fullTextFieldEdgeReq.layer.masksToBounds=YES; fullTextFieldEdgeReq.layer.borderColor=[[UIColor redColor]CGColor]; fullTextFieldEdgeReq.layer.borderWidth= 2.0f; fullTextFieldEdgeReq.textAlignment = NSTextAlignmentCenter; fullTextFieldEdgeReq.delegate = self;
    UITextField *fullTextFieldReq = [[UITextField alloc] initWithFrame:CGRectMake(25,7,270,30)]; fullTextFieldReq.borderStyle = UITextBorderStyleRoundedRect; fullTextFieldReq.layer.cornerRadius=8.0f; fullTextFieldReq.layer.masksToBounds=YES; fullTextFieldReq.layer.borderColor=[[UIColor redColor]CGColor]; fullTextFieldReq.layer.borderWidth= 2.0f; fullTextFieldReq.textAlignment = NSTextAlignmentCenter; fullTextFieldReq.delegate = self;
    
    UILabel *leftLabelEdge = [[UILabel alloc] initWithFrame:CGRectMake(20,4,100,42)]; leftLabelEdge.textColor = [UIColor blackColor]; leftLabelEdge.backgroundColor = [UIColor clearColor]; leftLabelEdge.font = [UIFont boldSystemFontOfSize:17];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,2,100,42)]; leftLabel.textColor = [UIColor blackColor]; leftLabel.backgroundColor = [UIColor clearColor]; leftLabel.font = [UIFont boldSystemFontOfSize:17];
    UILabel *middleLabelEdge = [[UILabel alloc] initWithFrame:CGRectMake(125,4,160,42)]; middleLabelEdge.textColor = [UIColor blackColor]; middleLabelEdge.backgroundColor = [UIColor clearColor]; middleLabelEdge.font = [UIFont systemFontOfSize:14];
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125,2,160,42)]; middleLabel.textColor = [UIColor blackColor]; middleLabel.backgroundColor = [UIColor clearColor]; middleLabel.font = [UIFont systemFontOfSize:14];
    UILabel *smallMiddleLabelEdge = [[UILabel alloc] initWithFrame:CGRectMake(125,4,100,42)]; smallMiddleLabelEdge.textColor = [UIColor blackColor]; smallMiddleLabelEdge.backgroundColor = [UIColor clearColor]; smallMiddleLabelEdge.font = [UIFont systemFontOfSize:14];
    UILabel *smallMiddleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125,2,100,42)]; smallMiddleLabel.textColor = [UIColor blackColor]; smallMiddleLabel.backgroundColor = [UIColor clearColor]; smallMiddleLabel.font = [UIFont systemFontOfSize:14];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(125,2,170,42)]; rightLabel.textColor = [UIColor blackColor];rightLabel.numberOfLines = 2; rightLabel.font = [UIFont systemFontOfSize:14]; rightLabel.backgroundColor = [UIColor clearColor];
    UILabel *rightLabelDetail = [[UILabel alloc] initWithFrame:CGRectMake(0,2,285,42)]; rightLabelDetail.font = [UIFont boldSystemFontOfSize:12]; rightLabelDetail.backgroundColor = [UIColor clearColor]; rightLabelDetail.textAlignment = NSTextAlignmentRight; rightLabelDetail.textColor = [UIColor blackColor];
    
    UISlider *sliderEdge = [[UISlider alloc] initWithFrame:CGRectMake(125,4,100,40)]; sliderEdge.backgroundColor = [UIColor clearColor]; [sliderEdge addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];sliderEdge.continuous = YES;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(125,2,100,40)]; slider.backgroundColor = [UIColor clearColor];[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged]; slider.continuous = YES;

    NSArray *itemArray = [NSArray arrayWithObjects: @"Su", @"M", @"Tu", @"W", @"Th", @"F", @"Sa", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(130, 7, 160, 30); segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; [segmentedControl setWidth:23 forSegmentAtIndex:0]; [segmentedControl setWidth:23 forSegmentAtIndex:1]; [segmentedControl setWidth:23 forSegmentAtIndex:2]; [segmentedControl setWidth:23 forSegmentAtIndex:3]; [segmentedControl setWidth:23 forSegmentAtIndex:4]; [segmentedControl setWidth:23 forSegmentAtIndex:5]; [segmentedControl setWidth:23 forSegmentAtIndex:6]; [segmentedControl addTarget:self action:@selector(updateBestNights:) forControlEvents:UIControlEventValueChanged];
    UILabel *nightsEmptyLabel = [[UILabel alloc] init]; nightsEmptyLabel.backgroundColor = [UIColor greenColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(25,2,270,100)]; textView.delegate = self; textView.layer.cornerRadius=8.0f; textView.layer.borderColor=[[UIColor grayColor]CGColor]; textView.layer.borderWidth= 0.5f; textView.font = fullTextField.font;
    UILabel *textViewLabel  = [[UILabel alloc] initWithFrame:CGRectMake(30,2,260,50)]; textViewLabel.textColor = [UIColor lightGrayColor]; textViewLabel.backgroundColor = [UIColor clearColor]; textViewLabel.font = fullTextField.font; textViewLabel.numberOfLines = 2;
    
    cell.cornerRadius = 10;
    int rows = indexPath.row - [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:indexPath.section];

    if (self.horizontalSelect.currentIndex.row==0) {
        switch (indexPath.section) {
            case 0: {
                switch (indexPath.row) {
                    case 0: {
                        fullTextFieldEdgeReq.placeholder = @"Venue Name"; fullTextFieldEdgeReq.tag = 1000; [cell addSubview:fullTextFieldEdgeReq];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 1: {
                        rightLabelDetail.text = @"Link to restaurant chain"; rightLabelDetail.tag=-1000; [cell addSubview:rightLabelDetail];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                }
            }
            case 1: {
                switch (indexPath.row) {
                    case 0: { 
                        UIButton *useCurrentLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [useCurrentLocation addTarget:self action:@selector(useCurrentLocation:) forControlEvents:UIControlEventTouchUpInside]; useCurrentLocation.frame = CGRectMake(60,8,200,32); [useCurrentLocation setBackgroundImage:[UIImage imageNamed:@"currentLocation.png"] forState:UIControlStateNormal]; [cell addSubview:useCurrentLocation];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 1: {
                        fullTextFieldReq.placeholder = @"Address";
                        fullTextFieldReq.tag = 1001;
                        [cell addSubview:fullTextFieldReq];
                        [cell prepareForTableView:tableView indexPath:indexPath];
                        return cell;
                    }
                    case 2: {
                        UITextField *cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(25,7,140,30)]; cityTextField.layer.cornerRadius=8.0f; cityTextField.layer.masksToBounds=YES; cityTextField.layer.borderColor=[[UIColor redColor]CGColor]; cityTextField.layer.borderWidth= 2.0f; cityTextField.placeholder = @"City"; cityTextField.tag = 1002; cityTextField.delegate = self; cityTextField.borderStyle = UITextBorderStyleRoundedRect; cityTextField.textAlignment = NSTextAlignmentCenter; [cell addSubview:cityTextField];
                        UITextField *stateTextField = [[UITextField alloc] initWithFrame:CGRectMake(170,7,55,30)]; stateTextField.layer.cornerRadius=8.0f; stateTextField.layer.masksToBounds=YES; stateTextField.layer.borderColor=[[UIColor redColor]CGColor]; stateTextField.layer.borderWidth= 2.0f; stateTextField.placeholder = @"State"; stateTextField.tag = 1003; stateTextField.delegate = self; stateTextField.borderStyle = UITextBorderStyleRoundedRect; stateTextField.textAlignment = NSTextAlignmentCenter; [cell addSubview:stateTextField]; 
                        UITextField *zipCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(230,7,65,30)]; zipCodeTextField.layer.cornerRadius=8.0f; zipCodeTextField.layer.masksToBounds=YES; zipCodeTextField.layer.borderColor=[[UIColor redColor]CGColor]; zipCodeTextField.layer.borderWidth= 2.0f; zipCodeTextField.placeholder = @"Zip";  zipCodeTextField.tag = 1004; zipCodeTextField.delegate = self;zipCodeTextField.borderStyle = UITextBorderStyleRoundedRect; zipCodeTextField.textAlignment = NSTextAlignmentCenter; [cell addSubview:zipCodeTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 3: {
                        textView.tag = 1005; [cell addSubview:textView];
                        if ([textView.text isEqualToString:@""]) { textViewLabel.text = @"Location Description (ex. across from mall, next to donut shop.)"; textViewLabel.tag = -1005; [cell addSubview:textViewLabel]; }
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 4: {  
                        textView.tag = 1006; [cell addSubview:textView];
                        if ([textView.text isEqualToString:@""]) { textViewLabel.text = @"Parking Instructions (ex. private lot, parking garage.)"; textViewLabel.tag = -1006; [cell addSubview:textViewLabel]; }
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                }
            }
            case 2: {
                switch (indexPath.row) {
                    case 0: {
                        leftLabelEdge.text = @"Dine In"; [cell addSubview:leftLabelEdge];
                        middleLabelEdge.text = @"Not Set Up"; middleLabelEdge.tag = 1036; [cell addSubview:middleLabelEdge];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 1: {
                        leftLabel.text = @"Delivery"; [cell addSubview:leftLabel];
                        middleLabel.text = @"Not Set Up"; middleLabel.tag = 1037; [cell addSubview:middleLabel];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 2: {
                        leftLabel.text = @"Take Out"; [cell addSubview:leftLabel];
                        middleLabel.text = @"Not Set Up"; middleLabel.tag = 1038; [cell addSubview:middleLabel];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 3: {
                        leftLabel.text = @"Drive Thru"; [cell addSubview:leftLabel];
                        middleLabel.text = @"Not Set Up"; middleLabel.tag = 1039; [cell addSubview:middleLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                }
            } 
            case 3: {
                switch (indexPath.row) {
                    case 0: {
                        leftLabelEdge.text = @"Category"; [cell addSubview:leftLabelEdge];
                        middleLabelEdge.text = @"None selected"; [cell addSubview:middleLabelEdge];
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue; cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 1: {
                        leftLabel.text = @"$ Per Meal"; [cell addSubview:leftLabel];
                        slider.minimumValue = 1; slider.maximumValue = 99.99; slider.tag = -1007; [cell addSubview:slider];
                        UITextField *dollarsTextField = [[UITextField alloc] initWithFrame:CGRectMake(230,7,65,30)];dollarsTextField.layer.cornerRadius=8.0f; dollarsTextField.layer.masksToBounds=YES; dollarsTextField.layer.borderColor=[[UIColor redColor]CGColor]; dollarsTextField.layer.borderWidth= 2.0f; dollarsTextField.placeholder = @"$"; dollarsTextField.delegate = self; dollarsTextField.borderStyle = UITextBorderStyleRoundedRect; dollarsTextField.textAlignment = NSTextAlignmentCenter; dollarsTextField.tag = 1007; [cell addSubview:dollarsTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 2: {
                        leftLabel.text = @"Wait Time"; [cell addSubview:leftLabel];
                        slider.minimumValue = 0; slider.maximumValue = 180; slider.tag = -1008; [cell addSubview:slider];
                        UITextField *waitTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(230,7,65,30)];waitTimeTextField.placeholder = @"min"; waitTimeTextField.delegate = self; waitTimeTextField.borderStyle = UITextBorderStyleRoundedRect; waitTimeTextField.textAlignment = NSTextAlignmentCenter; waitTimeTextField.tag = 1008; [cell addSubview:waitTimeTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 3: {
                        leftLabel.text = @"Payment"; [cell addSubview:leftLabel];
                        middleLabel.text = @"0 selected"; middleLabel.tag = 1009; [cell addSubview:middleLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue; cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 4: {
                        leftLabel.text = @"Features"; [cell addSubview:leftLabel];
                        middleLabel.text = @"0 selected"; middleLabel.tag = 1010; [cell addSubview:middleLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue; cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                }
            }
            case 4: { [cell prepareForTableView:tableView indexPath:indexPath]; return cell; }
            case 5: { [cell prepareForTableView:tableView indexPath:indexPath]; return cell; }
            case 6: {  [cell prepareForTableView:tableView indexPath:indexPath]; return cell;}
            case 7: {  [cell prepareForTableView:tableView indexPath:indexPath]; return cell; }
            case 8: {  [cell prepareForTableView:tableView indexPath:indexPath]; return cell;}
            case 9: {
                switch (rows) {
                    case 0: {
                        leftLabel.text = @"Capacity"; [cell addSubview:leftLabel];
                        slider.minimumValue = 5; slider.maximumValue = 1000; slider.tag = -1013; [cell addSubview:slider];
                        UITextField *capacityTextField = [[UITextField alloc] initWithFrame:CGRectMake(230,7,65,30)]; capacityTextField.placeholder = @"#"; capacityTextField.delegate = self; capacityTextField.borderStyle = UITextBorderStyleRoundedRect; capacityTextField.textAlignment = NSTextAlignmentCenter; capacityTextField.tag = 1013; [cell addSubview:capacityTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 1: {
                        leftLabel.text = @"Best Nights"; [cell addSubview:leftLabel];
                        segmentedControl.tag = 1017; [cell addSubview:segmentedControl];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 2: {
                        leftLabel.text = @"Noise Level"; [cell addSubview:leftLabel];
                        slider.minimumValue = 1; slider.maximumValue = 10; slider.tag = -1014; [cell addSubview:slider];
                        UITextField *noiseTextField = [[UITextField alloc] initWithFrame:CGRectMake(230,7,65,30)]; noiseTextField.placeholder = @"1-10"; noiseTextField.delegate = self; noiseTextField.borderStyle = UITextBorderStyleRoundedRect; noiseTextField.textAlignment = NSTextAlignmentCenter; noiseTextField.tag = 1014; [cell addSubview:noiseTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 3: {
                        leftLabel.text = @"Happy Hour"; [cell addSubview:leftLabel];
                        middleLabel.text = @"Not Set Up"; middleLabel.tag = 1040; [cell addSubview:middleLabel];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; cell.selectionStyle = UITableViewCellSelectionStyleBlue; 
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 4: {
                        leftLabel.text = @"TVs"; [cell addSubview:leftLabel];
                        slider.minimumValue = 0; slider.maximumValue = 100; slider.tag = -1015; [cell addSubview:slider];
                        UITextField *tvsTextField = [[UITextField alloc] initWithFrame:CGRectMake(230,7,65,30)]; tvsTextField.placeholder = @"#"; tvsTextField.delegate = self; tvsTextField.borderStyle = UITextBorderStyleRoundedRect; tvsTextField.textAlignment = NSTextAlignmentCenter; tvsTextField.tag = 1015; [cell addSubview:tvsTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                }
            }
            case 10: {
                switch (indexPath.row) {
                    case 0: {
                        fullTextFieldEdge.keyboardType = UIKeyboardTypePhonePad; fullTextFieldEdge.placeholder = @"Phone Number"; fullTextFieldEdge.tag = 1027; [cell addSubview:fullTextFieldEdge];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 1: {
                        fullTextField.keyboardType = UIKeyboardTypeURL; fullTextField.placeholder = @"Website"; fullTextField.tag = 1028; [cell addSubview:fullTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 2: {
                        fullTextField.keyboardType = UIKeyboardTypeEmailAddress; fullTextField.placeholder = @"Email Address"; fullTextField.tag = 1029; [cell addSubview:fullTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 3: {
                        fullTextField.keyboardType = UIKeyboardTypeURL; fullTextField.placeholder = @"Facebook"; fullTextField.tag = 1030; [cell addSubview:fullTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                    case 4: {
                        fullTextField.keyboardType = UIKeyboardTypeURL; fullTextField.placeholder = @"Twitter"; fullTextField.tag = 1031; [cell addSubview:fullTextField];
                        [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                    }
                }
            }
            case 11: {
                switch (indexPath.row) {
                    case 0: {
                    textView.frame = CGRectMake(25,5,270,100); textView.tag = 1032; [cell addSubview:textView];
                    if ([textView.text isEqualToString:@""]) { textViewLabel.frame = CGRectMake(30,5,260,50); textViewLabel.text = @"Free Food (ex. breadsticks and salad with meal)"; textViewLabel.tag = -1032; [cell addSubview:textViewLabel]; }
                    [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                }
                    case 1: { 
                    textView.tag = 1033; [cell addSubview:textView];
                    if ([textView.text isEqualToString:@""]) { textViewLabel.tag = -1033; textViewLabel.text = @"Student Discount (ex. 10% off with Duke ID)"; [cell addSubview:textViewLabel]; }
                    [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                }
                    case 2: { 
                    textView.tag = 1034; [cell addSubview:textView];
                    if ([textView.text isEqualToString:@""]) { textViewLabel.text = @"Senior Discount (ex. 10% off for ages 65+)"; textViewLabel.tag = -1034; [cell addSubview:textViewLabel]; }
                    [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                }
                    case 3: {
                    textView.tag = 1035; [cell addSubview:textView];
                    if ([textView.text isEqualToString:@""]) { textViewLabel.text = @"Child Discount (ex. free kids entree with adult entree)"; textViewLabel.tag = -1035; [cell addSubview:textViewLabel]; }
                    [cell prepareForTableView:tableView indexPath:indexPath]; return cell;
                }
                }
            }
            default:
                break;
        }
    }
    else if (self.horizontalSelect.currentIndex.row==1) { /////MENU FORM/////MENU FORM/////MENU FORM/////
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        return cell;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    } else if (self.horizontalSelect.currentIndex.row==2) { /////ITEM FORM/////ITEM FORM/////ITEM FORM/////
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        return cell;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    } else if (self.horizontalSelect.currentIndex.row==3) { /////REVIEW FORM/////REVIEW FORM/////REVIEW FORM/////
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        return cell;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    } else if (self.horizontalSelect.currentIndex.row==4) { /////PHOTO FORM/////PHOTO FORM/////PHOTO FORM/////
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        return cell;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    
    [cell prepareForTableView:tableView indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row %i",indexPath.row);
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
            [VPPDropDown tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    if (tableView==self.insertTableView) {
        if (self.horizontalSelect.currentIndex.row==0) {
            if (indexPath.section==0&&indexPath.row==1) { //link to venue chain
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Link to Venue Chain";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"linkchain";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==3&&indexPath.row==0) { //category
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Venue Category";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"venuecategory";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==3&&indexPath.row==3) { //payment
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Payment Methods";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"payment";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==3&&indexPath.row==4) { //features
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Venue Features";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"venuefeatures";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==2&&indexPath.row==0) { //dinein
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Setup Dine In";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"dinein";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==2&&indexPath.row==1) { //delivery
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Setup Delivery";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"delivery";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==2&&indexPath.row==2) { //dinein
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Setup Take Out";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"takeout";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==2&&indexPath.row==3) { //dinein
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Setup Drive Thru";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"drivethru";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            } else if (indexPath.section==9&&indexPath.row==3) { //dinein
                InsertSubViewController *insertSubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertSubPage"];
                insertSubViewController.title = @"Setup Happy Hour";
                insertSubViewController.delegate = self;
                insertSubViewController.identifier = @"happyhour";
                [self.navigationController pushViewController:insertSubViewController animated:YES];
            }
        }
    }
}


- (void) dropDown:(VPPDropDown *)dropDown elementSelected:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)indexPath {
        [self.insertTableView deselectRowAtIndexPath:indexPath animated:NO];
    dropDown.expanded  = NO;
    
}
- (UITableViewCell *) dropDown:(VPPDropDown *)dropDown rootCellAtGlobalIndexPath:(NSIndexPath *)globalIndexPath {
    
    return nil;
}
- (UITableViewCell *) dropDown:(VPPDropDown *)dropDown cellForElement:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)globalIndexPath {
    static NSString *cellIdentifier = @"CustomDropDownCell";
    
    UITableViewCell *cell = [self.insertTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"Custom cell";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"row %d",globalIndexPath.row];
    
    return cell;
}


- (CGFloat) dropDown:(VPPDropDown *)dropDown heightForElement:(VPPDropDownElement *)element atIndexPath:(NSIndexPath *)indexPath {
    float height = dropDown.tableView.rowHeight;
    
    return height + indexPath.row * 10;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_ipToDeselect != nil) {
        [self.insertTableView deselectRowAtIndexPath:_ipToDeselect animated:YES];
        _ipToDeselect = nil;
    }
}

- (void)updateBestNights:(id)sender
{
    UISegmentedControl *bestNightsControl = sender;
    NSString *stringToFind;
    NSLog(@"detected with index %i",bestNightsControl.selectedSegmentIndex);
    int highlightTag;
    switch (bestNightsControl.selectedSegmentIndex) {
        case 0:
            stringToFind = @"Su";
            highlightTag = 0;
            break;
        case 1:
            stringToFind = @"M";
            highlightTag = 1;
            break;
        case 2:
            stringToFind = @"Tu";
            highlightTag = 2;
            break;
        case 3:
            stringToFind = @"W";
            highlightTag = 3;
            break;
        case 4:
            stringToFind = @"Th";
            highlightTag = 4;
            break;
        case 5:
            stringToFind = @"F";
            highlightTag = 5;
            break;
        case 6:
            stringToFind = @"Sa";
            highlightTag = 6;
            break;
    }
    if (bestNightsControl.tag==1017) {
        
        if ([self.bestNightsArray containsObject:stringToFind]) {
            NSLog(@"string to delete is %@",stringToFind);
            NSLog(@"tag to delete is %i",(1018+highlightTag));
            [self.bestNightsArray removeObjectIdenticalTo:stringToFind];
            [(UILabel*)[self.insertTableView viewWithTag:(1018+highlightTag)] removeFromSuperview];
        } else {
            NSLog(@"tag added is %i",(1018+highlightTag));
            [self.bestNightsArray addObject:stringToFind];
            NSLog(@"string to add is %@",stringToFind);
            UILabel *highlightLabel = [[UILabel alloc] initWithFrame:CGRectMake(130+(highlightTag*24),35,23,2)];
            highlightLabel.tag = 1018+highlightTag;
            highlightLabel.backgroundColor = [UIColor greenColor];
            [bestNightsControl.superview addSubview:highlightLabel];
        }
        bestNightsControl.selectedSegmentIndex = -1;
    }
}

- (void)passBack:(NSMutableArray*)collectedData
{
    NSLog(@"number selected %i",[collectedData count]);
}

//declare static values for keyboard animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    if (textView.tag==1005) {
        [(UILabel*)[self.insertTableView viewWithTag:-1005] setHidden:YES];
    }
    if (textView.tag==1006&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1006] setHidden:YES];
    }
    if (textView.tag==1032&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1032] setHidden:YES];
    }
    if (textView.tag==1033&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1033] setHidden:YES];
    }
    if (textView.tag==1034&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1034] setHidden:YES];
    }
    if (textView.tag==1035&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1035] setHidden:YES];
    }
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];

}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    if (textView.tag==1005) {
        [(UILabel*)[self.insertTableView viewWithTag:-1005] setHidden:NO];
    }
    if (textView.tag==1006&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1006] setHidden:NO];
    }
    if (textView.tag==1032&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1032] setHidden:NO];
    }
    if (textView.tag==1033&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1033] setHidden:NO];
    }
    if (textView.tag==1034&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1034] setHidden:NO];
    }
    if (textView.tag==1035&&[textView.text isEqualToString:@""]) {
        [(UILabel*)[self.insertTableView viewWithTag:-1035] setHidden:NO];
    }
    NSLog(@"textview text: %@",textView.text);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    NSLog(@"textfield text: %@",textField.text);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
        [theTextField resignFirstResponder];
    
    //AUTO-SUBMIT FORM IF TEXTFIELD IS LAST IN REQUIRED TEXTFIELDS
    return YES;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
