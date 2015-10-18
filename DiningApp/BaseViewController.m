//
//  BaseViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/15/2012
//

#import "BaseViewController.h"
#import "FirstViewController.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

//synthesize properties
@synthesize appDelegate,username,loaded;

//methods
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
