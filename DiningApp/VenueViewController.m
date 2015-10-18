//
//  VenueViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/19/2012
//

/* TO DO LIST
 1. In venueData, add an object "open" or "closed" for the key "status" in configureView based on the venue's hours.
 2. In venueData, add an object with an integer for the minutes away the venue is from the user's current location based on the "location" object.
 3. In venueData, add an object with an integer for the percent of "ups"/("ups"+"downs") based on the keys "ups" and "downs".
 4. In venueData, add an object that goes through reviews and takes an average of all the indexes.
 5. Add @property (nonatomic,retain) NSMutableDictionary *venueFeatures; This will be created using fetch from the "features" table in the database based on the "venueID".
 6. In venueFeatures, add an object "yes" or "no" for the keys "dineinnow", "takeoutnow", and "deliverynow" based on keys "dineintimes", "takeouttimes", and "deliverytimes".
 7. Check comments in configureView.
 8. Use the following keys to create these featureScrollView images:
    -"category" in venueData:
        *fastfood, burger, pizza, italian, deli, buffet, chinese, mexican, chicken, seafood, japanese, sushi, mongolian, cafe, ice cream, cakes, bakery, etc
        *use icons of well known food and flags of the world
    -"tender": search for card names, visa, mastercard, discover
    -"goodforkids": family icon
    -"attire": based on pre-provided choices, casual (t-shirt), business casual, formal, etc.
    -"goodforgroups": icon with a lot of people
    -"reservations": icon with a clock or timer and a table
    -"waiters": icon with a waiter
    -"wifi": wifi icon
    -"outdoorseating": something with outside
    -"noiselevel": speaker icon with sound waves, more or less
    -"ambience": kiss for romantic, tree for nature, etc.
    -"tvs": tv icon
    -"bestnights": exclamation point if tonight is listed under best nights
    -"happyhour": drink with flames if now is happy hour
    -"smoking": cigarette or cigarette with x on it
    -"coatcheck": a coat?
    -"goodfordancing": people dancing
    -"catering": boxes
    -"wheelchair": wheelchair logo
    -"bathrooms": restroom sign (man and woman)
    -"seniordiscount": something with old people
    -"childdiscount": something with kids
    -"playground": a playplace
    -"drivethroughtimes": if drive through is available, window with hand coming out
    -"waittime": clock with time, or timer?, or something with speed
    -"freewater": water cup, cup that says H2O on it
    -"freefood": food icon
    -"freerefills": something being poured into a cup
    -"tipexpected": waiter and money
    -"renovation": construction thing
    -"sports": sports balls
    -"outsidefoodwelcome": bag of food with OK next to it
 9. For badge cell with all features, count the number of items -1 in venueFeatures and set that as the badge text.
 10. Show email address, show phone number, add slide to call, add slide for directions, show facebook link, show twitter link.
 11. Run through array of items and use keys for nutrition and allergies and counters to show how many options there are for gluten-free, vegetarian, etc. show this in feature scrollview with peanut and x on it, broccoli, etc.
     set the key for the venue as this: all ints
        -"lowfat" level 2, fat is below a certain line
        -"lowcarb" same with these
        -"lowcalorie" same with these
        -"lowsodium" same with these
        -"lowcholesterol" same with these
        -"lowsugar" same with these
        -"nofat" level 1, none at all
        -"nocarb" same with these
        -"nocalorie" same with these
        -"nosodium"
        -"nocholesterol"
        -"nosugar"
        -"highprotein"
        -"highfiber"
        -"highiron"
        -"highcalcium"
        -"glutenfree"
        -"peanutfree"
        -"milkfree"
        -"eggfree"
        -"nutfree"
        -"soyfree"iron
        -"vegetarian"
        -"vegan"
        -"kosher"
        -"porkfree"
        -"organic"
        -"localingredients"
    /ADD THESE TO MENULISTVIEWCONTROLLER's MENUS:OBJECTATINDEX: DICTIONARIES TOO
 */

#import "VenueViewController.h"
#import "MenuListViewController.h"

@interface VenueViewController ()
@end

@implementation VenueViewController

//synthesize properties
@synthesize venueData,menus,reviews,photos,items;

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"HS_VenuePage" ofType: @"plist"];
    NSArray* controlData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    self.horizontalSelect = [[KLHorizontalSelect alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-44)];
    [self.horizontalSelect setTableData:controlData];
    [self.horizontalSelect setDelegate:self];
    
    //SET INITIAL ROW SELECTED USING CUSTOMPRESETS
    [self.horizontalSelect setCurrentIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.horizontalSelect.arrow show:YES];
    [self.view addSubview:self.horizontalSelect];
    
    [self configureView];
    
    CGRect currentScreen = [[UIScreen mainScreen] bounds];
    
    if (currentScreen.size.height==568.000000) {
        pullDownView = [[StyledPullableView alloc] initWithFrame:CGRectMake(0, 0, 240, 320)];
        pullDownView.openedCenter = CGPointMake(120,260);
        pullDownView.closedCenter = CGPointMake(-80,260);
        pullDownView.handleView.frame = CGRectMake(0, 0, 240, 320);
        
    } else {
        pullDownView = [[StyledPullableView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
        pullDownView.openedCenter = CGPointMake(120,225);
        pullDownView.closedCenter = CGPointMake(-80,225);
        pullDownView.handleView.frame = CGRectMake(0, 0, 240, 240);
    }
    
    
    
    pullDownView.center = pullDownView.closedCenter;
    pullDownView.handleView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:pullDownView];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(loadInsert)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self launchLoadData];
}

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened {
    if (opened) {
        //do something
    } else {
        //do something
    }
}

- (void)loadData
{
    self.loaded = NO;
    @autoreleasepool {
    
        [self configureView];
        //start requests before
        NSMutableDictionary *menuDict = [[NSMutableDictionary alloc] init];
        [menuDict setObject:@"menus" forKey:@"table"];
        [menuDict setObject:@" WHERE " forKey:[NSString stringWithFormat:@"venueID=%i",[[self.venueData objectForKey:@"venueID"] intValue]]];
        [menuDict setObject:@" ORDER BY " forKey:@"name ASC"];
        BaseObject *newObject = [[BaseObject alloc] init];
        [newObject fetch:menuDict];
        
        
        //set up reviews for this specific venue
        NSMutableDictionary *reviewDict = [[NSMutableDictionary alloc] init];
        [reviewDict setObject:@"reviews" forKey:@"table"];
        [reviewDict setObject:@" WHERE " forKey:[NSString stringWithFormat:@"venueID=%i",[[self.venueData objectForKey:@"venueID"] intValue]]];
        [reviewDict setObject:@" ORDER BY " forKey:@"reviewID DESC"];
        BaseObject *newObject2 = [[BaseObject alloc] init];
        [newObject2 fetch:reviewDict];
        
        
        //set up photos for this specific venue
        NSMutableDictionary *photoDict = [[NSMutableDictionary alloc] init];
        [photoDict setObject:@"photos" forKey:@"table"];
        [photoDict setObject:@" WHERE " forKey:[NSString stringWithFormat:@"venueID=%i",[[self.venueData objectForKey:@"venueID"]intValue]]];
        [photoDict setObject:@" ORDER BY " forKey:@"photoID DESC"];
        BaseObject *newObject3 = [[BaseObject alloc] init];
        [newObject3 fetch:photoDict];
        
        
        //set up items for this specific venue
        NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
        [itemDict setObject:@"items" forKey:@"table"];
        [itemDict setObject:@" WHERE " forKey:[NSString stringWithFormat:@"venueID=%i",[[self.venueData objectForKey:@"venueID"] intValue]]];
        [itemDict setObject:@" ORDER BY " forKey:@"name ASC"];
        BaseObject *newObject4 = [[BaseObject alloc] init];
        [newObject4 fetch:itemDict];
        
        [self loadDataFromURL:nil];
        
        //set self arrays after
        
        self.menus = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)newObject.array2];
        self.reviews = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)newObject2.array2];
        self.photos = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)newObject3.array2];
        self.items = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)newObject4.array2];
        self.loaded = YES;
        [self.tableView reloadData];
    }
}

/////////////LOAD THE VENUE ARRAYS/////////////
- (void)configureView
{
    //set up menus for this specific venue
    
    
    //process venueData
    //UNCOMMENT self.title = [self.venueData objectForKey:@"name"];
    self.title = @"Piazza Italia";
    if (self.venueData) {
        /*KEYS TO SET
         FROM venueData
         1. status ("open" or "closed")
         2. minutes (int, distance away from current location)
         3. dollars (double, cost of a typical meal) STRAIGHT FROM KEY
         4. percent (based on keys "ups" and "downs")
         5. stars (based on array of reviews created when venue page is loaded, average of review scores, key is "stars")
         
         
         FROM venueFeatures
         6. dineinnow ("yes" or "no")
         7. deliverynow ("yes" or "no")
         8. takeoutnow ("yes" or "no")
         
         9. studentdiscount ("no" or discount details) STRAIGHT FROM KEY
         10. tender ("cashonly",or list of tenders) STRAIGHT FROM KEY
         11. alcohol ("no",details about offerings or BYOB ) STRAIGHT FROM KEY
         
         FROM other places
         6. photos (count of array photos), show number with camera sign if more than one
         7. menus (count of array menus), show number with menu logo if more than one
         8. items (count of array items), show number with food if more than one and text, item details available
         */
        [self.venueData setObject:@"open" forKey:@"status"];
        [self.venueData setObject:@"4.3" forKey:@"stars"];
        [self.venueData setObject:@"yes" forKey:@"alcohol"];
        [self.venueData setObject:@"yes" forKey:@"deliverynow"];
        [self.venueData setObject:@"yes" forKey:@"dineinnow"];
        [self.venueData setObject:@"yes" forKey:@"takeoutnow"];
        [self.venueData setObject:@"21" forKey:@"minutes"];
        [self.venueData setObject:@"27" forKey:@"dollars"];
        [self.venueData setObject:@"87" forKey:@"percent"];
        
        //[self loadFeatureScrollView];
    }
}
/*
- (void)loadFeatureScrollView
{
    for (UIView *subView in self.featureScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    FEATURES TO CHECK FOR:
     1. Open/Closed (key="status")
     2. Cost of Meal (key="dollars") money1.png ($0-$9), money2.png ($10-$19), money3.png ($20-29), money4.png ($30-39), money5.png ($40+)
     3. Average Review (key="stars") stars1.png (0-1.25), stars2.png (1.76-2.25), stars3.png (2.76-3.25), stars4.png (3.76-4.25), stars5.png (4.76-5)
     4. Dine-In Available (key="dineinnow")
     5. Delivery Available (key="deliverynow")
     6. TakeOut Available (key="takeoutnow")
     7. Student Discount (key="studentdiscount")
     8. Payment Method (key="tender")
     9. Alcohol Provided (key="alcohol")
     
    int numImages = 0;
    UIImage *featureImage = [UIImage imageNamed:@""];
    CGRect frame = CGRectMake(5,0,40,40);
    NSString *expandedLabelText = @"";
    UIImageView *featureImageView = [[UIImageView alloc] initWithImage:featureImage];
    if ([[self.venueData objectForKey:@"status"] isEqualToString:@"open"]) {
        featureImage = [UIImage imageNamed:@"open.png"];
        expandedLabelText = @"Currently Open";
    } else if ([[self.venueData objectForKey:@"status"] isEqualToString:@"closed"]) {
        featureImage = [UIImage imageNamed:@"closed.png"];
        expandedLabelText = @"Currently Closed";
    }
    featureImageView.frame = frame;
    featureImageView.image = featureImage;
    [self.featureScrollView addSubview:featureImageView];
    if (self.featureScrollExpanded==NO) {
        frame.origin.x+=45;
    } else {
        //load label
        UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
        featureLabel.textColor = [UIColor whiteColor];
        featureLabel.backgroundColor = [UIColor clearColor];
        featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        featureLabel.text = expandedLabelText;
        [self.featureScrollView addSubview:featureLabel];
        if (numImages%4==3) {
            frame.origin.y = 0;
            frame.origin.x+=155;
        } else {
            frame.origin.y+=40;
        }
    }
    numImages++;
    

    UIImageView *featureImageView2 = [[UIImageView alloc] initWithImage:featureImage];
    if ([[self.venueData objectForKey:@"dollars"] intValue]<10) {
        featureImage = [UIImage imageNamed:@"money1.png"];
        expandedLabelText = @"$0-9 Per Meal";
    } else if ([[self.venueData objectForKey:@"dollars"] intValue]<20) {
        featureImage = [UIImage imageNamed:@"money2.png"];
        expandedLabelText = @"$10-19 Per Meal";
    } else if ([[self.venueData objectForKey:@"dollars"] intValue]<30) {
        featureImage = [UIImage imageNamed:@"money3.png"];
        expandedLabelText = @"$20-29 Per Meal";
    } else if ([[self.venueData objectForKey:@"dollars"] intValue]<40) {
        featureImage = [UIImage imageNamed:@"money4.png"];
        expandedLabelText = @"$30-39 Per Meal";
    } else if ([[self.venueData objectForKey:@"dollars"] intValue]>=40) {
        featureImage = [UIImage imageNamed:@"money5.png"];
        expandedLabelText = @"$40+ Per Meal";
    }
    featureImageView2.frame = frame;
    featureImageView2.image = featureImage;
    [self.featureScrollView addSubview:featureImageView2];
    if (self.featureScrollExpanded==NO) {
        frame.origin.x+=45;
    } else {
        UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
        featureLabel.textColor = [UIColor whiteColor];
        featureLabel.backgroundColor = [UIColor clearColor];
        featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        featureLabel.text = expandedLabelText;
        [self.featureScrollView addSubview:featureLabel];
        if (numImages%4==3) {
            frame.origin.y = 0;
            frame.origin.x+=155;
        } else {
            frame.origin.y+=40;
        }
    }
    numImages++;
    
    UIImageView *featureImageView3 = [[UIImageView alloc] initWithImage:featureImage];
    
    if ([[self.venueData objectForKey:@"stars"] floatValue]==-1.00) { //not reviewed yet
        //do nothing at all
    } else {
        if ([[self.venueData objectForKey:@"stars"] floatValue]<1.25) {
            featureImage = [UIImage imageNamed:@"stars1.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]<1.76) {
            featureImage = [UIImage imageNamed:@"stars1_5.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]<2.25) {
            featureImage = [UIImage imageNamed:@"stars2.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]<2.76) {
            featureImage = [UIImage imageNamed:@"stars2_5.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]<3.25) {
            featureImage = [UIImage imageNamed:@"stars3.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]<3.76) {
            featureImage = [UIImage imageNamed:@"stars3_5.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]<4.25) {
            featureImage = [UIImage imageNamed:@"stars4.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]<4.76) {
            featureImage = [UIImage imageNamed:@"stars4_5.png"];
        } else if ([[self.venueData objectForKey:@"stars"] floatValue]>=4.76) {
            featureImage = [UIImage imageNamed:@"stars5.png"];
        }
        expandedLabelText = [NSString stringWithFormat:@"%@ Star Review",[self.venueData objectForKey:@"stars"]];
        featureImageView3.frame = frame;
        featureImageView3.image = featureImage;
        [self.featureScrollView addSubview:featureImageView3];
        if (self.featureScrollExpanded==NO) {
            frame.origin.x+=45;
        } else {
            UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
            featureLabel.textColor = [UIColor whiteColor];
            featureLabel.backgroundColor = [UIColor clearColor];
            featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            featureLabel.text = expandedLabelText;
            [self.featureScrollView addSubview:featureLabel];
            if (numImages%4==3) {
                frame.origin.y = 0;
                frame.origin.x+=155;
            } else {
                frame.origin.y+=40;
            }
        }
        numImages++;
    }
    
    
    
    
    if ([[self.venueData objectForKey:@"dineinnow"] isEqualToString:@"yes"]) {
        UIImageView *featureImageView4 = [[UIImageView alloc] initWithImage:featureImage];
        featureImage = [UIImage imageNamed:@"plate.png"];
        expandedLabelText = @"Dine-In Available";
        featureImageView4.frame = frame;
        featureImageView4.image = featureImage;
        [self.featureScrollView addSubview:featureImageView4];
        if (self.featureScrollExpanded==NO) {
            frame.origin.x+=45;
        } else {
            UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
            featureLabel.textColor = [UIColor whiteColor];
            featureLabel.backgroundColor = [UIColor clearColor];
            featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            featureLabel.text = expandedLabelText;
            [self.featureScrollView addSubview:featureLabel];
            if (numImages%4==3) {
                frame.origin.y = 0;
                frame.origin.x+=155;
            } else {
                frame.origin.y+=40;
            }
        }
        numImages++;
    }
    
    if ([[self.venueData objectForKey:@"deliverynow"] isEqualToString:@"yes"]) {
        UIImageView *featureImageView5 = [[UIImageView alloc] initWithImage:featureImage];
        featureImage = [UIImage imageNamed:@"car.png"];
        expandedLabelText = @"Delivery Available";
        featureImageView5.frame = frame;
        featureImageView5.image = featureImage;
        [self.featureScrollView addSubview:featureImageView5];
        if (self.featureScrollExpanded==NO) {
            frame.origin.x+=45;
        } else {
            UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
            featureLabel.textColor = [UIColor whiteColor];
            featureLabel.backgroundColor = [UIColor clearColor];
            featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            featureLabel.text = expandedLabelText;
            [self.featureScrollView addSubview:featureLabel];
            if (numImages%4==3) {
                frame.origin.y = 0;
                frame.origin.x+=155;
            } else {
                frame.origin.y+=40;
            }
        }
        numImages++;
    }
    
    if ([[self.venueData objectForKey:@"takeoutnow"] isEqualToString:@"yes"]) {
        UIImageView *featureImageView6 = [[UIImageView alloc] initWithImage:featureImage];
        featureImage = [UIImage imageNamed:@"basket.png"];
        expandedLabelText = @"Take-Out Available";
        featureImageView6.frame = frame;
        featureImageView6.image = featureImage;
        [self.featureScrollView addSubview:featureImageView6];
        if (self.featureScrollExpanded==NO) {
            frame.origin.x+=45;
        } else {
            UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
            featureLabel.textColor = [UIColor whiteColor];
            featureLabel.backgroundColor = [UIColor clearColor];
            featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            featureLabel.text = expandedLabelText;
            [self.featureScrollView addSubview:featureLabel];
            if (numImages%4==3) {
                frame.origin.y = 0;
                frame.origin.x+=155;
            } else {
                frame.origin.y+=40;
            }
        }
        numImages++;
    }
    
    if ([[self.venueData objectForKey:@"studentdiscount"] isEqualToString:@"yes"]) {
        UIImageView *featureImageView7 = [[UIImageView alloc] initWithImage:featureImage];
        featureImage = [UIImage imageNamed:@"student.png"];
        expandedLabelText = @"Student Discount";
        featureImageView7.frame = frame;
        featureImageView7.image = featureImage;
        [self.featureScrollView addSubview:featureImageView7];
        if (self.featureScrollExpanded==NO) {
            frame.origin.x+=45;
        } else {
            UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
            featureLabel.textColor = [UIColor whiteColor];
            featureLabel.backgroundColor = [UIColor clearColor];
            featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            featureLabel.text = expandedLabelText;
            [self.featureScrollView addSubview:featureLabel];
            if (numImages%4==3) {
                frame.origin.y = 0;
                frame.origin.x+=155;
            } else {
                frame.origin.y+=40;
            }
        }
        numImages++;
    }
    
    UIImageView *featureImageView8 = [[UIImageView alloc] initWithImage:featureImage];
    featureImage = [UIImage imageNamed:@"cash.png"];
    expandedLabelText = @"Cash Accepted";
    featureImageView8.frame = frame;
    featureImageView8.image = featureImage;
    [self.featureScrollView addSubview:featureImageView8];
    if (self.featureScrollExpanded==NO) {
        frame.origin.x+=45;
    } else {
        UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
        featureLabel.textColor = [UIColor whiteColor];
        featureLabel.backgroundColor = [UIColor clearColor];
        featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        featureLabel.text = expandedLabelText;
        [self.featureScrollView addSubview:featureLabel];
        if (numImages%4==3) {
            frame.origin.y = 0;
            frame.origin.x+=155;
        } else {
            frame.origin.y+=40;
        }
    }
    numImages++;
    
    if (![[self.venueData objectForKey:@"tender"] isEqualToString:@"cashonly"]) {
        UIImageView *featureImageView9 = [[UIImageView alloc] initWithImage:featureImage];
        featureImage = [UIImage imageNamed:@"creditcard.png"];
        expandedLabelText = @"Credit Cards";
        featureImageView9.frame = frame;
        featureImageView9.image = featureImage;
        [self.featureScrollView addSubview:featureImageView9];
        if (self.featureScrollExpanded==NO) {
            frame.origin.x+=45;
        } else {
            UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
            featureLabel.textColor = [UIColor whiteColor];
            featureLabel.backgroundColor = [UIColor clearColor];
            featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            featureLabel.text = expandedLabelText;
            [self.featureScrollView addSubview:featureLabel];
            if (numImages%4==3) {
                frame.origin.y = 0;
                frame.origin.x+=155;
            } else {
                frame.origin.y+=40;
            }
        }
        numImages++;
    }
    
    if ([[self.venueData objectForKey:@"alcohol"] isEqualToString:@"yes"]) {
        UIImageView *featureImageView10 = [[UIImageView alloc] initWithImage:featureImage];
        featureImage = [UIImage imageNamed:@"drink.png"];
        expandedLabelText = @"Alcohol For Sale";
        featureImageView10.frame = frame;
        featureImageView10.image = featureImage;
        [self.featureScrollView addSubview:featureImageView10];
        if (self.featureScrollExpanded==NO) {
            frame.origin.x+=45;
        } else {
            UILabel *featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 45,frame.origin.y+10,110,20)];
            featureLabel.textColor = [UIColor whiteColor];
            featureLabel.backgroundColor = [UIColor clearColor];
            featureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            featureLabel.text = expandedLabelText;
            [self.featureScrollView addSubview:featureLabel];
            if (numImages%4==3) {
                frame.origin.y = 0;
                frame.origin.x+=155;
            } else {
                frame.origin.y+=40;
            }
        }
        numImages++;
    }
    
    CGFloat scrollViewWidth = 0.0f;
    
    for (UIView* view in self.featureScrollView.subviews)
    {
        scrollViewWidth += view.frame.size.width;
    }
    
    if (self.featureScrollExpanded==NO) {
        [self.featureScrollView setContentSize:(CGSizeMake(scrollViewWidth+45,40))];
    } else {
        [self.featureScrollView setContentSize:(CGSizeMake((((numImages-1)/4)+1)*160,160))];
    }
    

}
*///LOADFEATURESCROLLVIEW
///////////////////////////////////////////////

///////////////LOAD TABLE VIEW///////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return @" Venue Information";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    return 30;
    else
        return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @" Venue Information";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        return label;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 4;
    }
    if (section == 2) {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section==0 && indexPath.row==0) return 66;
    if (indexPath.section==0 && indexPath.row==1) return 22;
    return 44;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"PrettyCell";
    static NSString *GridCellIdentifier = @"GridCell";
    PrettyGridTableViewCell *gridCell;
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.tableViewBackgroundColor = [UIColor clearColor];
    
    static NSString *BadgeCellIdentifier = @"BadgeCell";
    TDBadgedCell *badgeCell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BadgeCellIdentifier];
    badgeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	badgeCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    badgeCell.showShadow = YES;
    
    switch (indexPath.section) {
        case 0: {
             gridCell = [tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
            if (gridCell == nil) {
                gridCell = [[PrettyGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GridCellIdentifier];
                gridCell.tableViewBackgroundColor = tableView.backgroundColor;
                gridCell.actionBlock = ^(NSIndexPath *indexPath, int selectedIndex) {
                    if (selectedIndex == 0) {
                        //LOAD MAP VIEW
                        
                    } else if (selectedIndex == 1) {
                        MenuListViewController *menuListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuListPage"];
                        NSLog(@"menus sent: %i",[self.menus count]);
                        menuListVC.menuCount = [self.menus count];
                        menuListVC.menus = self.menus;
                        [self.navigationController pushViewController:menuListVC animated:YES];
                    } else if (selectedIndex == 2) {
                        //LOAD REVIEW LIST VIEW
                    }
                    //[gridCell deselectAnimated:YES];
                    
                };
            }
            [gridCell prepareForTableView:tableView indexPath:indexPath];
            gridCell.numberOfElements = 3;
            switch (indexPath.row) {
                case 0:
                    gridCell.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:55];
                    gridCell.textLabel.textColor = [UIColor blackColor];
                    [gridCell setText:[self.venueData objectForKey:@"minutes"] atIndex:0];
                    [gridCell setText:[self.venueData objectForKey:@"dollars"] atIndex:1];
                    [gridCell setText:[self.venueData objectForKey:@"percent"] atIndex:2];
                    gridCell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"quickBG.png"]];
                    return gridCell;
                case 1:
                    gridCell.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15];
                    gridCell.textLabel.textColor = [UIColor whiteColor];
                    [gridCell setText:@"min away" atIndex:0];
                    [gridCell setText:@"$ per meal" atIndex:1];
                    [gridCell setText:@"% liked" atIndex:2];
                    gridCell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"quickBG2.png"]];
                    return gridCell;
                default:
                    break;
            }
            break;
        }
        case 1: {
            cell.imageView.image = nil;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.textColor = [UIColor blackColor];
                    //UNCOMMENT cell.textLabel.text = [self.venueData objectForKey:@"name"];
                    cell.textLabel.text = @"Piazza Italia";
                    cell.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:17];
                    cell.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:255.0/255.0 blue:220.0/255.0 alpha:1.0];
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    return cell;
                case 1:
                    
                    //UNCOMMENT cell.textLabel.text = [self.venueData objectForKey:@"address"];
                    cell.textLabel.text = @"905 W Main St \r Durham, NC 27701";
                    cell.textLabel.numberOfLines = 2;
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    return cell;
                case 2:
                    //UNCOMMENT cell.textLabel.text = [self.venueData objectForKey:@"physical"];
                    cell.textLabel.text = @"Suite 18A, SW corner of Main & Gregson, adjacent to parking lot.";
                    cell.textLabel.numberOfLines = 2;
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    return cell;
                case 3:
                    //UNCOMMENT cell.textLabel.text = [self.venueData objectForKey:@"parking"];
                    cell.textLabel.text = @"Gated lot, 1 block East of corner, get ticket stamped by waiter.";
                    cell.textLabel.numberOfLines = 3;
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    return cell;
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0:
                    badgeCell.textLabel.text = @"Features";
                    badgeCell.imageView.image = [UIImage imageNamed:@"checkmark.png"];
                    badgeCell.badgeString = @"2";
                    badgeCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
                    badgeCell.badge.radius = 9;
                    return badgeCell;
                case 1:
                    badgeCell.textLabel.text = @"Reviews";
                    badgeCell.imageView.image = [UIImage imageNamed:@"heart.png"];
                    badgeCell.badgeString = [NSString stringWithFormat:@"%i",[self.reviews count]];
                    badgeCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
                    badgeCell.badge.radius = 9;
                    return badgeCell;
                case 2:
                    badgeCell.textLabel.text = @"Menus";
                    badgeCell.imageView.image = [UIImage imageNamed:@"menu.png"];
                    badgeCell.badgeString = [NSString stringWithFormat:@"%i",[self.menus count]];
                    badgeCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
                    badgeCell.badge.radius = 9;
                    return badgeCell;
                case 3:
                    badgeCell.textLabel.text = @"Items";
                    badgeCell.imageView.image = [UIImage imageNamed:@"food.png"];
                    badgeCell.badgeString = [NSString stringWithFormat:@"%i",[self.items count]];
                    badgeCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
                    badgeCell.badge.radius = 9;
                    return badgeCell;
                case 4:
                    badgeCell.textLabel.text = @"Photos";
                    badgeCell.imageView.image = [UIImage imageNamed:@"camera.png"];
                    badgeCell.badgeString = [NSString stringWithFormat:@"%i",[self.photos count]];
                    badgeCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
                    badgeCell.badge.radius = 9;
                    return badgeCell;
                default:
                    break;
            }
            break;
        }
        default: {
            break;
        }
    }
    
    // Configure the cell...
    
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.text = @"Text";
    if (indexPath.section == 0) {
        cell.cornerRadius = 20;
    }
    else {
        cell.cornerRadius = 10;
    }
    
    return cell;
     
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    break;
                case 2:
                    break;
                case 3:
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    break;
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
            break;
        default:
            break;
    }
}
/////////////////////////////////////////////


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
