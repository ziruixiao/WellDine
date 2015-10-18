//
//  FirstViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/23/2012
//

#import <UIKit/UIKit.h>
#import "NSString+MD5.h"
#import "AppDelegate.h"
#import "KLHorizontalSelect.h"

@interface FirstViewController : UIViewController <UITextFieldDelegate,KLHorizontalSelectDelegate> {
    CGFloat animatedDistance;
}

@property (nonatomic,strong) KLHorizontalSelect* horizontalSelect;

//properties
@property (strong,nonatomic) IBOutlet UIButton *backButton;
@property (strong,nonatomic) IBOutlet UIButton *registerButton;
@property (strong,nonatomic) IBOutlet UIButton *loginButton;
@property (strong,nonatomic) IBOutlet UIButton *forgotButton;
@property (strong,nonatomic) IBOutlet UITextField *emailTextField;
@property (strong,nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong,nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong,nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong,nonatomic) IBOutlet UIButton *submitLoginButton;
@property (strong,nonatomic) IBOutlet UIButton *submitRegisterButton;
@property (strong,nonatomic) IBOutlet UIButton *submitForgotButton;
@property (strong,nonatomic) IBOutlet UILabel *forgotLabel;
@property (strong, nonatomic) UIImageView *infoImageView;

//methods
- (IBAction)showRegister;
- (IBAction)showLogin;
- (IBAction)forgotPassword;
- (IBAction)goBack;
- (IBAction)submitRegister;
- (IBAction)submitLogin;
- (IBAction)submitForgot;
- (IBAction)noThanks;
- (void)showAlert:(NSString*)title andMessage:(NSString*)message andDismiss:(NSString*)dismiss;

@end
