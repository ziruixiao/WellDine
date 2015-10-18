//
//  InsertSubViewController.h
//  WellDine
//
//  Created by Felix Xiao on 12/31/12.
//  Copyright (c) 2012 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InsertSubViewControllerDelegate
- (void)passBack:(NSMutableArray*)collectedData;

@end

@interface InsertSubViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataSource;
    NSMutableArray *selectedMarks;
}
@property (nonatomic,strong) NSString *identifier;
@property (nonatomic) NSArray *dataSource;
@property (nonatomic) NSArray *imageSource;
@property (nonatomic,strong) NSMutableArray *returnedArray;
@property (strong, nonatomic) IBOutlet UITableView *subTableView;
@property int rows;
@property (nonatomic, weak) id <InsertSubViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@end
