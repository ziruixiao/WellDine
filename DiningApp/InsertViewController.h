//
//  InsertViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/28/2012
//
#import "KLHorizontalSelect.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "InsertSubViewController.h"
#import "VPPDropDown.h"
#import "VPPDropDownDelegate.h"

@interface InsertViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,KLHorizontalSelectDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UITextViewDelegate,VPPDropDownDelegate,UIActionSheetDelegate,InsertSubViewControllerDelegate>
{
    CGFloat animatedDistance;
    CLLocationManager *locationManager;
    CLPlacemark * myPlacemark;
    @private
    VPPDropDown *_dropDownSelection;
    VPPDropDown *_dropDownSelection2;
    VPPDropDown *_dropDownSelection3;
    VPPDropDown *_dropDownSelection4;
    VPPDropDown *_dropDownSelection5;
    NSIndexPath *_ipToDeselect;
}
//properties
@property (nonatomic,strong) KLHorizontalSelect* horizontalSelect;
@property (nonatomic,strong) NSMutableDictionary *customPresets;
@property (strong,nonatomic) IBOutlet UIView *contentView;
@property (strong,nonatomic) IBOutlet UITableView *insertTableView;
@property (strong,nonatomic) NSMutableDictionary *product;
@property (strong,nonatomic) NSMutableArray *bestNightsArray;

//methods
- (IBAction)cancelInsert;
- (IBAction)submitInsert;
- (void)loadNewForm;

- (NSString*)insertVenue;
- (NSString*)insertMenu;
- (NSString*)insertItem;
- (NSString*)insertReview;
- (NSString*)insertPhoto;
@end
