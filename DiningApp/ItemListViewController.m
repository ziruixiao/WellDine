//
//  ItemListViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/26/2012
//

#import "ItemListViewController.h"
#import "ItemDetailViewController.h"

@interface ItemListViewController ()
@end

@implementation ItemListViewController

//synthesize properties
@synthesize items,itemphotos,itemreviews,sortingHeaders,sortingCondition,nameTableView,detailTableView,detailScrollView,itemSearchBar,headerUIView,headerScrollView;

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
    self.detailTableView.delegate = self;
    self.nameTableView.delegate = self;
    self.headerScrollView.delegate = self;
    self.detailScrollView.delegate = self;
    int detailTableWidth = 515;
    self.detailScrollView.contentSize = CGSizeMake(detailTableWidth,self.detailScrollView.frame.size.height);
    self.headerScrollView.contentSize = CGSizeMake(detailTableWidth,self.headerScrollView.frame.size.height);
    self.headerUIView.frame = CGRectMake(0,0,detailTableWidth,44);
    self.headerScrollView.showsHorizontalScrollIndicator = NO;
    self.detailScrollView.scrollEnabled = YES;
    self.detailScrollView.showsHorizontalScrollIndicator = YES;
    self.headerScrollView.scrollEnabled = YES;
    self.headerScrollView.showsHorizontalScrollIndicator = YES;
    //self.detailTableView.contentSize = CGSizeMake(detailTableWidth,[self.items count]*44);
    self.detailTableView.backgroundColor = [UIColor yellowColor];
    self.detailTableView.scrollEnabled = YES;
    self.detailTableView.showsHorizontalScrollIndicator = NO;
    self.detailTableView.contentSize = CGSizeMake(177,[self.items count]*44);
    self.detailTableView.showsVerticalScrollIndicator = YES;
    self.detailTableView.bounces = NO;
    self.detailTableView.alwaysBounceHorizontal = NO;
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    [self loadDetailHeaders];

}

- (void)loadDetailHeaders
{
    //1. stars (button)
    //2. pictures with number (button)
    //3. price
    //4. description?
    //5. calories
    //6. fat
    //7. carbs
    //"tap for full facts"
    //
    //UNIVERSAL ATTRIBUTES
    int headerOffSet = 0;
    
    //COLUMN 1: STARS
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0+headerOffSet,2,40,40)];
    headerImage.image = [UIImage imageNamed:@"singlestar.png"];
    [self.headerUIView addSubview:headerImage];
    headerOffSet+=45;
    
    //COLUMN 2: PRICE
    UIImageView *headerImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0+headerOffSet,2,40,40)];
    headerImage2.image = [UIImage imageNamed:@"singlemoney.png"];
    [self.headerUIView addSubview:headerImage2];
    headerOffSet+=45;
    
    //COLUMN 3: PICTURES
    UIImageView *headerImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(0+headerOffSet,2,40,40)];
    headerImage3.image = [UIImage imageNamed:@"camera.png"];
    [self.headerUIView addSubview:headerImage3];
    headerOffSet+=45;
    
    //COLUMN 4: CALORIES
    UILabel *headerLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,40,44)];
    headerLabel2.font = [UIFont boldSystemFontOfSize:14];
    headerLabel2.textAlignment = NSTextAlignmentCenter;
    headerLabel2.backgroundColor = [UIColor clearColor];
    headerLabel2.text = @"Cal";
    [self.headerUIView addSubview:headerLabel2];
    headerOffSet+=45;
    
    //COLUMN 5: FATS
    UILabel *headerLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,40,44)];
    headerLabel3.font = [UIFont boldSystemFontOfSize:14];
    headerLabel3.textAlignment = NSTextAlignmentCenter;
    headerLabel3.backgroundColor = [UIColor clearColor];
    headerLabel3.text = @"Fat";
    [self.headerUIView addSubview:headerLabel3];
    headerOffSet+=45;
     
    //COLUMN 6: CARBS
    UILabel *headerLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,40,44)];
    headerLabel4.font = [UIFont boldSystemFontOfSize:14];
    headerLabel4.textAlignment = NSTextAlignmentCenter;
    headerLabel4.backgroundColor = [UIColor clearColor];
    headerLabel4.text = @"Carb";
    [self.headerUIView addSubview:headerLabel4];
    headerOffSet+=45;
    
    //COLUMN 7: DESCRIPTION
    UIImageView *headerImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(0+headerOffSet,2,40,40)];
    headerImage4.image = [UIImage imageNamed:@"description.png"];
    [self.headerUIView addSubview:headerImage4];
    headerOffSet+=245;
    
}
- (void)sortItems:(NSString*)newCondition
{
    if (self.sortingCondition==newCondition) {
        NSLog(@"sort by %@ reveresed",newCondition);
    }
    else {
        self.sortingCondition = newCondition;
        NSLog(@"new sort by %@ default order",newCondition);
    }
}

///////////////LOAD TABLE VIEW///////////////
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if ([scrollView isEqual:self.nameTableView]) {
 	    self.detailScrollView.contentOffset = CGPointMake(0,self.nameTableView.contentOffset.y);
    } else if ([scrollView isEqual:self.detailTableView]) {
	    self.nameTableView.contentOffset = CGPointMake(0,self.detailTableView.contentOffset.y);
    } else if ([scrollView isEqual:self.detailScrollView]) {
        self.headerScrollView.contentOffset = CGPointMake(self.detailScrollView.contentOffset.x,0);
    } else if ([scrollView isEqual:self.headerScrollView]) {
        self.detailScrollView.contentOffset = CGPointMake(self.headerScrollView.contentOffset.x,0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if ([self.sortingHeaders count]>0)
        return [self.sortingHeaders count];
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of items counted: %i",[self.items count]);
    return [self.items count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView==self.nameTableView) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"name"];
        if ([self.items count]==0) cell.textLabel.text = @"Sample Item";
        return cell;
    }
    
    if (tableView==self.detailTableView) {
        //add labels to the cell
        int headerOffSet = 0;
        //COLUMN 1: STARS
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0+headerOffSet,12,40,16)]; //half sized
        float reviewTotal = 0.00;
        float reviewCount = 0.00;
        for (NSMutableDictionary *reviewDict in self.itemreviews) {
            [reviewDict setObject:[NSString stringWithFormat:@"%f",2.3] forKey:@"score"]; //REMOVE IN FUTURE WHEN FETCH,INSERT,AND DATABASE ARE UPDATED
            if ([[reviewDict objectForKey:@"itemID"] intValue]==(indexPath.row+1)) { //+1 is critical because 1st index is 0
                reviewTotal += [[reviewDict objectForKey:@"score"] floatValue];
                reviewCount += 1.00;
            }
        }
        float reviewAverage = -1.00;
        if (reviewCount>0) {
            reviewAverage = reviewTotal/reviewCount;
        }
        
        if (reviewAverage==-1.0) { //not reviewed yet
            //do nothing at all
            headerImage.image = [UIImage imageNamed:@"starsunknownwide.png"];
        } else {
            if (reviewAverage<1.25) {
                headerImage.image = [UIImage imageNamed:@"stars1wide.png"];
            } else if (reviewAverage<1.76) {
                headerImage.image = [UIImage imageNamed:@"stars1_5wide.png"];
            } else if (reviewAverage<2.25) {
                headerImage.image = [UIImage imageNamed:@"stars2wide.png"];
            } else if (reviewAverage<2.76) {
                headerImage.image = [UIImage imageNamed:@"stars2_5wide.png"];
            } else if (reviewAverage<3.25) {
                headerImage.image = [UIImage imageNamed:@"stars3wide.png"];
            } else if (reviewAverage<3.76) {
                headerImage.image = [UIImage imageNamed:@"stars3_5wide.png"];
            } else if (reviewAverage<4.25) {
                headerImage.image = [UIImage imageNamed:@"stars4wide.png"];
            } else if (reviewAverage<4.76) {
                headerImage.image = [UIImage imageNamed:@"stars4_5wide.png"];
            } else if (reviewAverage>=4.76) {
                headerImage.image = [UIImage imageNamed:@"stars5wide.png"];
            }
        }
        [cell addSubview:headerImage];
        
        UILabel *reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,40,14)];
        reviewLabel.font = [UIFont systemFontOfSize:10];
        reviewLabel.textAlignment = NSTextAlignmentCenter;
        reviewLabel.backgroundColor = [UIColor clearColor];
        if (reviewAverage==-1.0) {
            reviewLabel.text = @"";
        } else {
            reviewLabel.text = [NSString stringWithFormat:@"%i",(int)reviewCount];
            
        }
        [cell addSubview:reviewLabel];
        
        UILabel *reviewLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,26,40,14)];
        reviewLabel2.font = [UIFont boldSystemFontOfSize:10];
        reviewLabel2.textAlignment = NSTextAlignmentCenter;
        reviewLabel2.backgroundColor = [UIColor clearColor];
        if (reviewAverage==-1.0) {
            reviewLabel2.text = @"";
        } else {
            reviewLabel2.text = [NSString stringWithFormat:@"(%0.2f)",reviewAverage];
            
        }
        [cell addSubview:reviewLabel2];
        
        
        headerOffSet+=45;
        
        
        //COLUMN 2: PRICE
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,2,40,40)];
        priceLabel.font = [UIFont boldSystemFontOfSize:12];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.backgroundColor = [UIColor clearColor];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        priceLabel.text = [NSString stringWithFormat:@"%0.2f",[[[self.items objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
        [cell addSubview:priceLabel];
        headerOffSet+=45;
        
        //COLUMN 3: PICTURES
        UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,2,40,40)];
        photoLabel.font = [UIFont systemFontOfSize:12];
        photoLabel.textAlignment = NSTextAlignmentCenter;
        photoLabel.backgroundColor = [UIColor clearColor];
        int photoCount = 0;
        
        for (NSMutableDictionary *photoDict in self.itemphotos) {
            if ([[photoDict objectForKey:@"itemID"] intValue]==(indexPath.row+1)) { //+1 is critical because 1st index is 0
                photoCount++;
            }
        }
        photoLabel.text = [NSString stringWithFormat:@"%i",photoCount];
        [cell addSubview:photoLabel];
        headerOffSet+=45;
        
        //COLUMN 4: CALORIES
        UILabel *headerLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,40,44)];
        headerLabel2.font = [UIFont systemFontOfSize:12];
        headerLabel2.textAlignment = NSTextAlignmentCenter;
        headerLabel2.backgroundColor = [UIColor clearColor];
        headerLabel2.text = @"100"; //REMOVE IN FUTURE
        //UNCOMMENT IN FUTURE //headerLabel2.text = [NSString stringWithFormat:@"%i",[[[self.items objectAtIndex:indexPath.row] objectForKey:@"calories"] intValue]];
        [cell addSubview:headerLabel2];
        headerOffSet+=45;
        
        //COLUMN 5: FATS
        UILabel *headerLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,40,44)];
        headerLabel3.font = [UIFont systemFontOfSize:12];
        headerLabel3.textAlignment = NSTextAlignmentCenter;
        headerLabel3.backgroundColor = [UIColor clearColor];
        headerLabel3.text = [NSString stringWithFormat:@"%i",[[[self.items objectAtIndex:indexPath.row] objectForKey:@"fat"] intValue]];
        [cell addSubview:headerLabel3];
        headerOffSet+=45;
        
        //COLUMN 6: CARBS
        UILabel *headerLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,40,44)];
        headerLabel4.font = [UIFont systemFontOfSize:12];
        headerLabel4.textAlignment = NSTextAlignmentCenter;
        headerLabel4.backgroundColor = [UIColor clearColor];
        headerLabel4.text = [NSString stringWithFormat:@"%i",[[[self.items objectAtIndex:indexPath.row] objectForKey:@"carbs"] intValue]];
        [cell addSubview:headerLabel4];
        headerOffSet+=45;
        
        //COLUMN 7: DESCRIPTION
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+headerOffSet,0,240,44)];
        headerLabel.font = [UIFont systemFontOfSize:10];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        headerLabel.numberOfLines = 3;
        headerLabel.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"description"];
        [cell addSubview:headerLabel];
        headerOffSet+=245;
        
        return cell;
    }
    
    /*[cell prepareForTableView:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        cell.cornerRadius = 20;
    }
    else {
        cell.cornerRadius = 10;
    }*/
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowItemPageLeft"]) {
        ItemDetailViewController *itemDetailViewController = [segue destinationViewController];
        NSMutableArray *photosToPush = [[NSMutableArray alloc] init];
        NSMutableArray *reviewsToPush = [[NSMutableArray alloc] init];
        
        for (NSMutableDictionary *photoDict in self.itemphotos) {
            if ([[photoDict objectForKey:@"itemID"] intValue]==([self.nameTableView indexPathForSelectedRow].row+1)) {
                [photosToPush addObject:photoDict];
            }
        }
        
        for (NSMutableDictionary *reviewDict in self.itemreviews) {
            if ([[reviewDict objectForKey:@"itemID"] intValue]==([self.nameTableView indexPathForSelectedRow].row+1)) {
                [reviewsToPush addObject:reviewDict];
            }
        }
        
        itemDetailViewController.photos = photosToPush;
        itemDetailViewController.reviews = reviewsToPush;
        itemDetailViewController.itemData = [self.items objectAtIndex:[self.nameTableView indexPathForSelectedRow].row];
    }
    
    if ([[segue identifier] isEqualToString:@"ShowItemPageRight"]) {
        ItemDetailViewController *itemDetailViewController = [segue destinationViewController];
        NSMutableArray *photosToPush = [[NSMutableArray alloc] init];
        NSMutableArray *reviewsToPush = [[NSMutableArray alloc] init];
        
        for (NSMutableDictionary *photoDict in self.itemphotos) {
            if ([[photoDict objectForKey:@"itemID"] intValue]==([self.detailTableView indexPathForSelectedRow].row+1)) {
                [photosToPush addObject:photoDict];
            }
        }
        
        for (NSMutableDictionary *reviewDict in self.itemreviews) {
            if ([[reviewDict objectForKey:@"itemID"] intValue]==([self.detailTableView indexPathForSelectedRow].row+1)) {
                [reviewsToPush addObject:reviewDict];
            }
        }
        
        itemDetailViewController.photos = photosToPush;
        itemDetailViewController.reviews = reviewsToPush;
        itemDetailViewController.itemData = [self.items objectAtIndex:[self.detailTableView indexPathForSelectedRow].row];
        //send objecets for key venueName
    }

}

/////////////////////////////////////////////


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
