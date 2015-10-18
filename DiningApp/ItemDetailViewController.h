//
//  ItemDetailViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/26/2012
//

#import "BaseTableViewController.h"

@interface ItemDetailViewController : BaseTableViewController

//properties
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *reviews;
@property (nonatomic,strong) NSMutableDictionary *itemData;

@property (strong, nonatomic) IBOutlet UIScrollView *featureScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *reviewScrollView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionCellTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceCellTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *venueCellTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameCellTextLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *reviewFirstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *nutritionCell;
@property (strong, nonatomic) IBOutlet TDBadgedCell *viewAllPhotosCell;
@property (strong, nonatomic) IBOutlet TDBadgedCell *viewAllReviewsCell;


@end
