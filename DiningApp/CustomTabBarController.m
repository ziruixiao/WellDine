//
//  CustomTabBarController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/13/2012
//

#import "CustomTabBarController.h"
#import "MTPopupWindow.h"

@interface CustomTabBarController ()
@end

@implementation CustomTabBarController

//methods
- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPressRecognizer =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 1;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [button addGestureRecognizer:longPressRecognizer];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        button.center = self.tabBar.center;
    }
    else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

- (void)longPressDetected:(UIGestureRecognizer*)sender
{
    if (sender.state != UIGestureRecognizerStateRecognized)
        return;
    [self setSelectedIndex:2];
    UIViewController *longPressSearchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LongPressPage"];
    [MTPopupWindow showWindowWithView:longPressSearchViewController.view];
}

- (void)buttonEvent
{
    [self setSelectedIndex:2];
    [self defaultSearch];
}

- (void)defaultSearch //USE DEFAULT OPTIONS TO SEARCH, SINGLE TAP ON CENTER BUTTON
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"centerImage.png"] highlightImage:[UIImage imageNamed:@"centerImageSelected.png"]];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
