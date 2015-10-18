//
//  MenuListViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/24/2012
//

/* TO DO LIST
 1. use key "mainImage" to determine what picture to show in the imageview for each menu
 2. set objects for keys "cheapItem" and "expensiveItem"
 3. set object for "averageItemReview"
 4. run through items and add to counters in menu:objectAtIndex:
 */

#import "MenuListViewController.h"
#import "ItemListViewController.h"

@interface MenuListViewController ()
@end

@implementation MenuListViewController

//synthesize properties
@synthesize menuCount,menus,menuPhotos,menuReviews,menuItems,featureScrollExpanded,currentOpenSection;

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    NSLog(@"menus present: %i",[self.menus count]);
    //[self launchLoadData];
}

- (void)loadData
{
    self.loaded = NO;
    @autoreleasepool {
    
        NSMutableDictionary *tempDict1 = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *tempDict2 = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *tempDict3 = [[NSMutableDictionary alloc] init];
        BaseObject *newObject1 = [[BaseObject alloc] init];
        BaseObject *newObject2 = [[BaseObject alloc] init];
        BaseObject *newObject3 = [[BaseObject alloc] init];
        self.menuPhotos = [[NSMutableArray alloc] initWithCapacity:[self.menus count]];
        self.menuReviews = [[NSMutableArray alloc] initWithCapacity:[self.menus count]];
        self.menuItems = [[NSMutableArray alloc] initWithCapacity:[self.menus count]];
        
        //for (NSMutableDictionary *menuDict in self.menus) {
            
            [tempDict1 removeAllObjects];
            [tempDict2 removeAllObjects];
            [tempDict3 removeAllObjects];
            
            [tempDict1 setObject:@"photos" forKey:@"table"];
            [tempDict1 setObject:@" WHERE " forKey:[NSString stringWithFormat:@"menuID=%i",[[[self.menus objectAtIndex:0] objectForKey:@"menuID"] intValue]]];
            [tempDict1 setObject:@" ORDER BY " forKey:@"photoID DESC"];
            [newObject1 fetch:tempDict1];
            
            [tempDict2 setObject:@"reviews" forKey:@"table"];
            [tempDict2 setObject:@" WHERE " forKey:[NSString stringWithFormat:@"menuID=%i",[[[self.menus objectAtIndex:0] objectForKey:@"menuID"] intValue]]];
            [tempDict2 setObject:@" ORDER BY " forKey:@"reviewID DESC"];
            [newObject2 fetch:tempDict2];
            
            [tempDict3 setObject:@"items" forKey:@"table"];
            [tempDict3 setObject:@" WHERE " forKey:[NSString stringWithFormat:@"menuID=%i",[[[self.menus objectAtIndex:0] objectForKey:@"menuID"] intValue]]];
            [tempDict3 setObject:@" ORDER BY " forKey:@"name ASC"];
            [newObject3 fetch:tempDict3];
            
        //}
        [self loadDataFromURL:nil];
        NSLog(@"past this block");
        [self.menuPhotos addObject:(NSMutableArray*)newObject1.array2];
        [self.menuReviews addObject:(NSMutableArray*)newObject2.array2];
        [self.menuItems addObject:(NSMutableArray*)newObject3.array2];
        
        self.loaded = YES;
        [self.tableView reloadData];
    }
}



///////////////LOAD TABLE VIEW///////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return menuCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row==0) return 100;
    if (indexPath.row==1) return 60;
    if (self.featureScrollExpanded == YES && indexPath.row==3) { return 164; }
    return 44;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *InfoCellIdentifier = @"MenusPageInfoCell";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoCellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    static NSString *PhotosCellIdentifier = @"MenusPagePhotosCell";
    PrettyTableViewCell *photosCell = [tableView dequeueReusableCellWithIdentifier:PhotosCellIdentifier];
    if (photosCell == nil) {
        photosCell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PhotosCellIdentifier];
        photosCell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    static NSString *FeaturesCellIdentifier = @"MenusPageFeaturesCell";
    PrettyTableViewCell *featuresCell = [tableView dequeueReusableCellWithIdentifier:FeaturesCellIdentifier];
    if (featuresCell == nil) {
        featuresCell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeaturesCellIdentifier];
        featuresCell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    static NSString *BadgeCellIdentifier = @"BadgeCell";
    TDBadgedCell *badgeCell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BadgeCellIdentifier];
    badgeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	badgeCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    badgeCell.showShadow = YES;
    
    UIImageView *menuInfoImageView;
    UILabel *itemCountLabel;
    UILabel *menuInfoLabel1;
    UILabel *menuInfoLabel2;
    UILabel *menuInfoLabel3;
    
    UIImageView *menuReviewsImageView;
    UILabel *menuReviewsLabel;
    
    UIScrollView *photoScrollView;
    UIScrollView *featureScrollView;
    switch (indexPath.row) {
            
        case 0:{
            //set up imageview in first row for the menu, this can be set by the restaurant owner or chosen in a set of defaults that can be chosen from.
            if ([[self.menus objectAtIndex:indexPath.section] objectForKey:@"MenuImage"]!=nil) {
                //load UIImage MenuImage associated with the menu (100x100) (200x200)
                menuInfoImageView = [[UIImageView alloc] initWithImage:[[self.menus objectAtIndex:indexPath.section] objectForKey:@"MenuImage"]];
            } else { //load default menu image (100x100) (200x200)
                menuInfoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultMenuInfoImage.png"]];
            }
            menuInfoImageView.center = CGPointMake(60,50);
            
            menuInfoImageView.backgroundColor = [UIColor clearColor];
            
            //set up labels in first for the menu from dictionary data in nsmutablearray
            menuInfoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(110,10,200,30)];
            menuInfoLabel1.text = [[self.menus objectAtIndex:indexPath.section] objectForKey:@"name"];
            menuInfoLabel1.textColor = [UIColor blackColor];
            menuInfoLabel1.font = [UIFont boldSystemFontOfSize:20];
            menuInfoLabel1.textAlignment = NSTextAlignmentCenter;
            menuInfoLabel1.backgroundColor = [UIColor clearColor];
            
            menuInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(110,40,200,20)];
            menuInfoLabel2.text = @"Venue Name"; //REMOVE IN FUTURE
            //UNCOMMENT IN FUTURE menuInfoLabel1.text = [[self.menus objectAtIndex:indexPath.row] objectForKey:@"venueName"];
            menuInfoLabel2.font = [UIFont boldSystemFontOfSize:14];
            menuInfoLabel2.textColor = [UIColor blueColor];
            menuInfoLabel2.textAlignment = NSTextAlignmentCenter;
            menuInfoLabel2.backgroundColor = [UIColor clearColor];
            
            //set up itemCountLabel
            itemCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(110,60,200,20)];
            itemCountLabel.text = @"6 items";
            //UNCOMMENT IN FUTURE itemCountLabel.text = [NSString stringWithFormat:@"%i items",[[[self.menus objectAtIndex:indexPath.row] objectForKey:@"count"] intValue]];
            itemCountLabel.font = [UIFont boldSystemFontOfSize:14];
            itemCountLabel.textAlignment = NSTextAlignmentCenter;
            itemCountLabel.backgroundColor = [UIColor clearColor];
            
            menuInfoLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(110,80,200,20)];
            NSString *menuInfoLabel3Text = @"";
            //UNCOMMENT IN FUTURE menuInfoLabel3Text = [menuInfoLabel3Text stringByAppendingFormat:@"$%f - $%f",[[[self.menus objectAtIndex:indexPath.row] objectForKey:@"cheapItem"] floatValue],[[[self.menus objectAtIndex:indexPath.row] objectForKey:@"expensiveItem"] floatValue]];
            menuInfoLabel3.text = [menuInfoLabel3Text stringByAppendingString:@"$3.99 - $9.99"]; //REMOVE IN FUTURE
            menuInfoLabel3.font = [UIFont boldSystemFontOfSize:14];
            menuInfoLabel3.textColor = [UIColor redColor];
            menuInfoLabel3.text = menuInfoLabel3Text;
            menuInfoLabel3.textAlignment = NSTextAlignmentCenter;
            menuInfoLabel3.backgroundColor = [UIColor clearColor];
            
            [cell addSubview:menuInfoImageView];
            [cell addSubview:itemCountLabel];
            [cell addSubview:menuInfoLabel1];
            [cell addSubview:menuInfoLabel2];
            [cell addSubview:menuInfoLabel3];
            return cell;
        }
        case 1:{
            //add scrollview
            photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10,0,270,60)];
            photoScrollView.backgroundColor = [UIColor clearColor];
            photoScrollView.pagingEnabled = NO;
            photoScrollView.showsVerticalScrollIndicator = NO;
            photoScrollView.bounces = YES;
            photoScrollView.alwaysBounceHorizontal = YES;
            photoScrollView.showsHorizontalScrollIndicator = NO;
            photoScrollView.scrollEnabled = YES;
            
            UIImageView *cameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,40,40)];
            cameraImageView.image = [UIImage imageNamed:@"camera.png"];
            [photoScrollView addSubview:cameraImageView];
            
            UILabel *photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,40,40,20)];
            photoCountLabel.text = [NSString stringWithFormat:@"%i",[[self.menuPhotos objectAtIndex:indexPath.section] count]];
            photoCountLabel.backgroundColor = [UIColor clearColor];
            photoCountLabel.font = [UIFont boldSystemFontOfSize:12];
            photoCountLabel.textAlignment = NSTextAlignmentCenter;
            photoCountLabel.textColor = [UIColor blackColor];
            [photoScrollView addSubview:photoCountLabel];
            
            //add photo thumbnails of items inside this
            int photocount = 0; //starting number of photos
            UIImageView *menuImageContainer = [[UIImageView alloc] initWithFrame:CGRectMake(50,5,50,50)];
            menuImageContainer.layer.borderColor = [[UIColor blackColor] CGColor];
            menuImageContainer.layer.borderWidth = 1.0;
            
            //assuming there is an array of arrays (1 for each menu) of dictionaries (1 for each picture), 2nd-level array of dictionaries is passed on to the next view controller
            for (NSMutableDictionary *photoDict in [self.menuPhotos objectAtIndex:indexPath.section]) {
                menuImageContainer.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[photoDict objectForKey:@"photoURL"]]]];
                menuImageContainer.frame = CGRectMake(50+photocount*55,5,50,50);
                [photoScrollView addSubview:menuImageContainer];
                photocount++;
            }
            
            //set scroller size at the end
            [photoScrollView setContentSize:CGSizeMake(50+photocount*55,60)];
            [photosCell addSubview:photoScrollView];
            return photosCell;
        }
        case 2:{
            menuReviewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(110,7,150,30)];
            menuReviewsLabel.text = @"Item Reviews";
            menuReviewsLabel.font = [UIFont boldSystemFontOfSize:14];
            menuReviewsLabel.textColor = [UIColor blackColor];
            menuReviewsLabel.textAlignment = NSTextAlignmentCenter;
            menuReviewsLabel.backgroundColor = [UIColor clearColor];
            [badgeCell addSubview:menuReviewsLabel];
            
            float itemReview = [[[self.menus objectAtIndex:indexPath.section] objectForKey:@"averageItemReview"] floatValue];
            NSString *reviewImageName = @"starsunkownwide.png";
            if (itemReview==-1.00) { //no reviews yet
                //do nothing at all
            } else {
                if (itemReview<1.25) {
                    reviewImageName = @"stars1wide.png";
                } else if (itemReview<1.76) {
                    reviewImageName = @"stars1_5wide.png";
                } else if (itemReview<2.25) {
                    reviewImageName = @"stars2wide.png";
                } else if (itemReview<2.76) {
                    reviewImageName = @"stars2_5wide.png";
                } else if (itemReview<3.25) {
                    reviewImageName = @"stars3wide.png";
                } else if (itemReview<3.76) {
                    reviewImageName = @"stars3_5wide.png";
                } else if (itemReview<4.25) {
                    reviewImageName = @"stars4wide.png";
                } else if (itemReview<4.76) {
                    reviewImageName = @"stars4_5wide.png";
                } else if (itemReview>=4.76) {
                    reviewImageName = @"stars5wide.png";
                }
            }
            menuReviewsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:reviewImageName]];
            menuReviewsImageView.center = CGPointMake(60,22);
            menuReviewsImageView.backgroundColor = [UIColor clearColor];
            [badgeCell addSubview:menuReviewsImageView];
            
            badgeCell.badgeString = [NSString stringWithFormat:@"%i",[[[self.menus objectAtIndex:indexPath.section] objectForKey:@"itemReviewCount"] intValue]];
            badgeCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
            badgeCell.badge.radius = 9;
            return badgeCell;
        }
        case 3:{
            //feature scrollview
            
            /*/things to include
             1. currently available/not available
             2. allergen options (all in table)
             3. nutrition adherences (all in table)
             4. average price on menu (show money signs)
             5. average item review (same as above?)
             6. combo options
             7. specials available
            */
            
            //assuming there is an array of arrays (1 for each menu) of dictionaries (1 for each item), 2nd-level array of dictionaries is passed on to the next view controller
            
            //INT COUNTER VALUES FOR EACH
            //int numGlutenFree = 0;
            //if item is glutenfre, numGlutenFree++, show this when double tapped
            
            //counter for number of photos in scrollview
            
            for (NSMutableDictionary *itemDict in [self.menuItems objectAtIndex:indexPath.section]) {
                //update counters here
            }
            
            //if statement similar to VenueViewController
            
            if (self.featureScrollExpanded == YES && self.currentOpenSection == indexPath.section) { //expanded
                featureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10,0,300,160)];
            } else {
                featureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10,0,300,40)];
            }
            featureScrollView.backgroundColor = [UIColor blackColor];
            
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                  initWithTarget:self
                                                                  action:@selector(changeFeatureScrollView:)];
            [singleTapGestureRecognizer setNumberOfTapsRequired:1];
            [featureScrollView addGestureRecognizer:singleTapGestureRecognizer];
            featureScrollView.tag = indexPath.section + 100; //CRITICAL, USED TO FIND WHICH ONE IS OPEN
            //set content size
            
            
            [featuresCell addSubview:featureScrollView];
            return featuresCell;
        }
        default:{
            break;
        }
    }
    
    [cell prepareForTableView:tableView indexPath:indexPath];
    if (indexPath.row == 0) {
        cell.cornerRadius = 20;
    }
    else {
        cell.cornerRadius = 10;
    }
    return cell;
}

- (void)changeFeatureScrollView:(UIGestureRecognizer*)sender
{
    if (sender.state != UIGestureRecognizerStateRecognized)
        return;
    
    if (self.featureScrollExpanded == YES) {
        self.featureScrollExpanded = NO;
        self.currentOpenSection = -1;
        NSLog(@"decreased");
        [UIView animateWithDuration:0.6 animations:^{
            sender.view.frame = CGRectMake(10,0,300,40);
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.featureScrollExpanded = YES;
        self.currentOpenSection = ((UIScrollView*)sender.view).tag - 100;
        NSLog(@"increased");
        [UIView animateWithDuration:0.6 animations:^{
            sender.view.frame = CGRectMake(10,0,300,160);
        } completion:^(BOOL finished) {
        }];
    }
    [self.tableView reloadData];

}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowItemListPage"]) {
        ItemListViewController *itemListViewController = [segue destinationViewController];
        //these are 3 multi-dimensional arrays. They are arrays (menu lists) of arrays (menus) of dictionaries (photos,reviews,items)
        itemListViewController.itemphotos = [self.menuPhotos objectAtIndex:[self.tableView indexPathForSelectedRow].section];
        itemListViewController.itemreviews = [self.menuReviews objectAtIndex:[self.tableView indexPathForSelectedRow].section];
        itemListViewController.items = [self.menuItems objectAtIndex:[self.tableView indexPathForSelectedRow].section];
        
        //set sorting headers dictionary and sorting condition here in the future based on user options
        //sorting headers dictionary: key=header (ex. Below 9.99, Below 19.99, Below 29.99), object=number of items that match it=number of rows (ex. 4, 3, 2)
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}
/////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
