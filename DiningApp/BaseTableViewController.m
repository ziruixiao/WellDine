//
//  BaseTableViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import "BaseTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FirstViewController.h"
#import "InsertViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface BaseTableViewController ()
@end

@implementation BaseTableViewController

//synthesize properties
@synthesize loaded,appDelegate,username;
@synthesize textPull,textRelease,textLoading,refreshHeaderView,refreshLabel,refreshArrow,refreshSpinner;

- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
    [self loadKeychain];
}

- (void)loadKeychain
{
    self.appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if ([[self.appDelegate.loginDetails objectForKey:(__bridge id)kSecAttrAccount] isEqualToString:@""] &&
        [[self.appDelegate.loginDetails objectForKey:(__bridge id)kSecValueData] isEqualToString:@""]) {
        //first launch ever of application, not logged in
        NSString* blank = @" ";
        [self.appDelegate.loginDetails setObject:blank forKey:(__bridge id)kSecAttrAccount];
        [self.appDelegate.loginDetails setObject:blank forKey:(__bridge id)kSecValueData];
        
        //show modal login/register page because of first launch
        UIStoryboard *storyboard = self.storyboard;
        FirstViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        svc.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:svc animated:YES completion:nil];
        
        //set default username as guest
        self.username = @"Guest";
    } else if ([[self.appDelegate.loginDetails objectForKey:(__bridge id)kSecAttrAccount] isEqualToString:@" "] &&
               [[self.appDelegate.loginDetails objectForKey:(__bridge id)kSecValueData] isEqualToString:@" "]) {
        //not first launch, not logged in
        //set default username as guest
        self.username = @"Guest";
    } else {
        //currently logged in
        //set username as keychain item
        self.username = [self.appDelegate.loginDetails objectForKey:(__bridge id)kSecAttrAccount];
    }
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(loadInsert)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self setupStrings];
    [self addPullToRefreshHeader];
}

- (void)loadInsert
{
    //additional presets that are customized to show up by default, such as for a page with a venue loaded, preload the venue name, etc, the method below returns a dictionary.
    InsertViewController *insertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InsertPage"];
    UINavigationController *insertNC = [[UINavigationController alloc] initWithRootViewController:insertVC];
    insertVC.customPresets = [self insertPresets];
    insertVC.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
    [self presentViewController:insertNC animated:YES completion:NULL];
    
}

- (NSMutableDictionary*)insertPresets
{
    return nil;
    //override this function in every view controller that should be customized
}

- (void)launchLoadData
{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)loadData
{
    //initialize in other files
}

- (void)loadDataFromURL:(NSString*)url
{
    [NSThread detachNewThreadSelector: @selector(searchStart) toTarget:self withObject:nil];
    [NSThread sleepForTimeInterval:3];
    [NSThread detachNewThreadSelector: @selector(searchDone) toTarget:self withObject:nil];
}

- (void)searchStart
{
    //what happens when search starts
}

- (void)searchDone
{
    //what happens after the search is done
}


///////////////PULL TO REFRESH///////////////
- (void)setupStrings
{
    textPull = @"Pull down to refresh";
    textRelease = @"Release to refresh";
    textLoading = @"Loading...";
}

- (void)addPullToRefreshHeader
{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0-REFRESH_HEADER_HEIGHT,320,REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT-27)/2),(floorf(REFRESH_HEADER_HEIGHT-44)/2),27,44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT-20)/2),floorf((REFRESH_HEADER_HEIGHT-20)/2),20,20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading) {
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI,0,0,1);
            } else {
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI*2,0,0,1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        [self startLoading];
    }
}

- (void)startLoading
{
    isLoading = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT,0,0,0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    [self refresh];
}

- (void)stopLoading
{
    isLoading = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI*2,0,0,1);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(stopLoadingComplete)];
    }];
}

- (void)stopLoadingComplete
{
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh
{
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}
/////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
