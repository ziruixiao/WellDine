//
//  ProfileViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import "BaseViewController.h"
#import "KLHorizontalSelect.h"

@interface ProfileViewController : BaseViewController <KLHorizontalSelectDelegate>
@property (nonatomic,strong) KLHorizontalSelect* horizontalSelect;
@end
