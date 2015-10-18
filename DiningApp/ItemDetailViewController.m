//
//  ItemDetailViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/26/2012
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()
@end

@implementation ItemDetailViewController

//synthesize properties
@synthesize itemData,photos,reviews,featureScrollView,photoScrollView,reviewScrollView,descriptionCellTextLabel,priceCellTextLabel,venueCellTextLabel,nameCellTextLabel,reviewFirstCell,nutritionCell,viewAllPhotosCell,viewAllReviewsCell;

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    nameCellTextLabel.text = [self.itemData objectForKey:@"name"];
    //UNCOMMENT IN FUTURE //venueCellTextLabel.text = [self.itemData objectForKey:@"venueName"];
    venueCellTextLabel.text = @"Venue Name";
    priceCellTextLabel.text = [NSString stringWithFormat:@"$%0.2f",[[self.itemData objectForKey:@"price"] floatValue]];
    descriptionCellTextLabel.text = [self.itemData objectForKey:@"description"];
    
    [self loadPhotoScrollView];
    viewAllPhotosCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	viewAllPhotosCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    viewAllPhotosCell.textLabel.textAlignment = NSTextAlignmentRight;
    viewAllPhotosCell.textLabel.text = @"View All Photos";
    viewAllPhotosCell.showShadow = YES;
    viewAllPhotosCell.badgeString = [NSString stringWithFormat:@"%i",[self.photos count]];
    viewAllPhotosCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    viewAllPhotosCell.badge.radius = 9;
    
    //reviewFirstCell
    
    [self loadReviewScrollView];
    viewAllReviewsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	viewAllReviewsCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    viewAllReviewsCell.textLabel.textAlignment = NSTextAlignmentRight;
    viewAllReviewsCell.textLabel.text = @"View All Reviews";
    viewAllReviewsCell.showShadow = YES;
    viewAllReviewsCell.badgeString = [NSString stringWithFormat:@"%i",[self.reviews count]];
    viewAllReviewsCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    viewAllReviewsCell.badge.radius = 9;
    
    [self loadFeatureScrollView];
    [self loadNutritionCell];
}

- (void)loadPhotoScrollView
{
    for (int x = 0; x < [self.photos count]; x++) {
        UIImageView *photoContainer = [[UIImageView alloc] init];
        photoContainer.frame = CGRectMake(5+105*x,0,100,100);
        photoContainer.layer.borderColor = [[UIColor blackColor] CGColor];
        photoContainer.layer.borderWidth = 1.0;
        photoContainer.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.healthforceontario.ca/upload/en/jobs/facebook-50x50.png"]]];
        [photoScrollView addSubview:photoContainer];
    }
    [photoScrollView setContentSize:CGSizeMake(5+105*[self.photos count],100)];
}

- (void)loadReviewScrollView
{
    for (int x = 0; x < [self.reviews count]; x++) {
        UILabel *reviewTitle = [[UILabel alloc] init];
        reviewTitle.textAlignment = NSTextAlignmentCenter;
        reviewTitle.frame = CGRectMake(0+300*x,0,300,30);
        reviewTitle.text = [[self.reviews objectAtIndex:0] objectForKey:@"title"];
        [reviewScrollView addSubview:reviewTitle];
        
        UILabel *reviewDescription = [[UILabel alloc] init];
        reviewDescription.textAlignment = NSTextAlignmentCenter;
        reviewDescription.frame = CGRectMake(0+300*x,30,300,70);
        reviewDescription.text = [[self.reviews objectAtIndex:0] objectForKey:@"description"];
        [reviewScrollView addSubview:reviewDescription];
    }
    [reviewScrollView setContentSize:CGSizeMake(300*[self.reviews count],100)];
}

- (void)loadFeatureScrollView
{
    for (UIView *subView in self.featureScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    //allergy-free logos
    //nutrition-specific logos
    //on-sale logo
}

- (void)loadNutritionCell
{
    //DELETE THIS IN THE FUTURE
    [self.itemData setObject:@"-1" forKey:@"vitaminA"];
    [self.itemData setObject:@"-1" forKey:@"vitaminC"];
    [self.itemData setObject:@"-1" forKey:@"calcium"];
    [self.itemData setObject:@"-1" forKey:@"iron"];
    
    float defaultDailyCalories = 1000.0f;
    
    
    for (UILabel *nutrition in self.nutritionCell.contentView.subviews) {
        switch ((int)nutrition.tag) {
            case 0:
                break;
            case 1:
                nutrition.text = [self.itemData objectForKey:@"servingsize"];
                if ([nutrition.text isEqualToString:@""] || nutrition.text==nil)
                    nutrition.text = @"One Order";
                break;
            case 2:
                if ([[self.itemData objectForKey:@"calories"] intValue]>=0) {
                    nutrition.text = [self.itemData objectForKey:@"calories"];
                    if ([nutrition.text isEqualToString:@""] || nutrition.text==nil)
                        nutrition.text = [NSString stringWithFormat:@"%i",([[self.itemData objectForKey:@"fat"] intValue]*9 + [[self.itemData objectForKey:@"carbs"] intValue]*4 + [[self.itemData objectForKey:@"protein"] intValue]*4)];
                }
                break;
            case 3:
                if ([[self.itemData objectForKey:@"caloriesfat"] intValue]>=0) {
                    nutrition.text = [self.itemData objectForKey:@"caloriesfat"];
                    if ([nutrition.text isEqualToString:@""] || nutrition.text==nil)
                        nutrition.text = [NSString stringWithFormat:@"%i",([[self.itemData objectForKey:@"fat"] intValue]*9)];
                }
                break;
            case 4:
                if ([[self.itemData objectForKey:@"fat"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@g",[self.itemData objectForKey:@"fat"]];
                }
                break;
            case 5:
                if ([[self.itemData objectForKey:@"fat"] intValue]>=0)
                    nutrition.text = [NSString stringWithFormat:@"%i%%",((int)([[self.itemData objectForKey:@"fat"] floatValue]/(defaultDailyCalories/31.0)*100.0))];
                break;
            case 6:
                if ([[self.itemData objectForKey:@"satfat"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@g",[self.itemData objectForKey:@"satfat"]];
                }
                break;
            case 7:
                if ([[self.itemData objectForKey:@"satfat"] intValue]>=0)
                    nutrition.text = [NSString stringWithFormat:@"%i%%",((int)([[self.itemData objectForKey:@"satfat"] floatValue]/(defaultDailyCalories/100.0)*100.0))];
                break;
            case 8:
                if ([[self.itemData objectForKey:@"transfat"] intValue]>=0)
                    nutrition.text = [NSString stringWithFormat:@"%@g",[self.itemData objectForKey:@"transfat"]];
                break;
            case 9:
                if ([[self.itemData objectForKey:@"cholesterol"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@mg",[self.itemData objectForKey:@"cholesterol"]];
                }
                break;
            case 10:
                if ([[self.itemData objectForKey:@"cholesterol"] intValue]>=0)
                    nutrition.text = [NSString stringWithFormat:@"%i%%",((int)([[self.itemData objectForKey:@"cholesterol"] floatValue]/300.0*100.0))];
                break;
            case 11:
                if ([[self.itemData objectForKey:@"sodium"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@mg",[self.itemData objectForKey:@"sodium"]];
                }
                break;
            case 12:
                if ([[self.itemData objectForKey:@"sodium"] intValue]>=0)
                    nutrition.text = [NSString stringWithFormat:@"%i%%",((int)([[self.itemData objectForKey:@"sodium"] floatValue]/2400.0*100.0))];
                break;
            case 13:
                if ([[self.itemData objectForKey:@"carbs"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@g",[self.itemData objectForKey:@"carbs"]];
                }
                break;
            case 14:
                if ([[self.itemData objectForKey:@"carbs"] intValue]>=0)
                    nutrition.text = [NSString stringWithFormat:@"%i%%",((int)([[self.itemData objectForKey:@"carbs"] floatValue]/(defaultDailyCalories/6.67)*100.0))];
                break;
            case 15:
                if ([[self.itemData objectForKey:@"fiber"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@g",[self.itemData objectForKey:@"fiber"]];
                }
                break;
            case 16:
                if ([[self.itemData objectForKey:@"fiber"] intValue]>=0)
                    nutrition.text = [NSString stringWithFormat:@"%i%%",((int)([[self.itemData objectForKey:@"fiber"] floatValue]/(defaultDailyCalories/81.0)*100.0))];
                break;
            case 17:
                if ([[self.itemData objectForKey:@"sugars"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@g",[self.itemData objectForKey:@"sugars"]];
                }
                break;
            case 18:
                if ([[self.itemData objectForKey:@"protein"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@g",[self.itemData objectForKey:@"protein"]];
                }
                break;
            case 19:
                if ([[self.itemData objectForKey:@"vitaminA"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@%%",[self.itemData objectForKey:@"vitaminA"]];
                }
                break;
            case 20:
                if ([[self.itemData objectForKey:@"vitaminC"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@%%",[self.itemData objectForKey:@"vitaminC"]];
                }
                break;
            case 21:
                if ([[self.itemData objectForKey:@"calcium"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@%%",[self.itemData objectForKey:@"calcium"]];
                }
                break;
            case 22:
                if ([[self.itemData objectForKey:@"iron"] intValue]>=0) {
                    nutrition.text = [NSString stringWithFormat:@"%@%%",[self.itemData objectForKey:@"iron"]];
                }
                break;
            default:
                break;
        }
        
    }
    
    for (UILabel *nutrition in self.nutritionCell.subviews) {
        if ((int)nutrition.tag>0&&(int)nutrition.tag<23) {
            if ([nutrition.text isEqualToString:@""] || nutrition.text==nil)
                nutrition.text = @"N/A";
        }
    }
    //dictionary ADD servingsize,calories,caloriesfat,vitaminA,vitaminC,calcium,iron
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
