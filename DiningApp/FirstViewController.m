//
//  FirstViewController.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/23/2012
//

#import "FirstViewController.h"

@interface FirstViewController ()
@end


@implementation FirstViewController

//synthesize properties
@synthesize backButton, registerButton, loginButton, forgotButton;
@synthesize emailTextField, usernameTextField, passwordTextField, confirmTextField;
@synthesize submitRegisterButton, submitLoginButton, submitForgotButton, forgotLabel;
@synthesize infoImageView;

//methods
- (void)viewDidAppear:(BOOL)animated //WHAT HAPPENS BEFORE VIEW IS SHOWN
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"SectionData"
                                                          ofType: @"plist"];
    // Build the array from the plist
    NSArray* controlData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.horizontalSelect = [[KLHorizontalSelect alloc] initWithFrame: self.view.bounds];
    [self.horizontalSelect setTableData: controlData];
    
    //Customize the initially selected index - Note section is redundant but should always be 0
    [self.horizontalSelect setCurrentIndex:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    //Add the view as a subview
    [self.view addSubview: self.horizontalSelect];
    
}

- (void)horizontalSelect:(id)horizontalSelect didSelectCell:(KLHorizontalSelectCell *)cell {
    NSLog(@"Selected Cell: %@", cell.label.text);
}


//////////////SHOW AND HIDE IBOUTLETS///////////////
- (IBAction)showRegister
{
    self.registerButton.hidden = YES;
    self.loginButton.hidden = YES;
    self.forgotButton.hidden = YES;
    self.submitLoginButton.hidden = YES;
    self.submitForgotButton.hidden = YES;
    self.forgotLabel.hidden = YES;
    
    self.backButton.hidden = NO;
    self.emailTextField.hidden = NO;
    self.usernameTextField.hidden = NO;
    self.passwordTextField.hidden = NO;
    self.confirmTextField.hidden = NO;
    self.submitRegisterButton.hidden = NO;
}

- (IBAction)showLogin
{
    self.registerButton.hidden = YES;
    self.loginButton.hidden = YES;
    self.submitRegisterButton.hidden = YES;
    self.submitForgotButton.hidden = YES;
    self.forgotLabel.hidden = YES;
    
    self.backButton.hidden = NO;
    self.forgotButton.hidden = NO;
    self.usernameTextField.hidden = NO;
    self.passwordTextField.hidden = NO;
    self.submitLoginButton.hidden = NO;
}

- (IBAction)goBack
{
    self.backButton.hidden = YES;
    self.forgotButton.hidden = YES;
    self.emailTextField.hidden = YES;
    self.usernameTextField.hidden = YES;
    self.passwordTextField.hidden = YES;
    self.confirmTextField.hidden = YES;
    self.submitRegisterButton.hidden = YES;
    self.submitLoginButton.hidden = YES;
    self.submitForgotButton.hidden = YES;
    self.forgotLabel.hidden = YES;
    
    self.loginButton.hidden = NO;
    self.registerButton.hidden = NO;
}

- (IBAction)forgotPassword
{
    self.loginButton.hidden = YES;
    self.registerButton.hidden = YES;
    self.forgotButton.hidden = YES;
    self.usernameTextField.hidden = YES;
    self.passwordTextField.hidden = YES;
    self.confirmTextField.hidden = YES;
    self.submitRegisterButton.hidden = YES;
    self.submitLoginButton.hidden = YES;
    
    self.backButton.hidden = NO;
    self.emailTextField.hidden = NO;
    self.submitForgotButton.hidden = NO;
    self.forgotLabel.hidden = NO;
}

- (IBAction)submitForgot
{
    
}

- (IBAction)noThanks
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
////////////////////////////////////////////////////


//////////////REGISTER AND LOGIN///////////////
- (IBAction)submitRegister
{
    NSString *submitEmail = self.emailTextField.text;
    NSString *submitUsername = self.usernameTextField.text;
    NSString *submitPassword = self.passwordTextField.text;
    NSString *submitConfirm = self.confirmTextField.text;
    
    if ([submitEmail isEqualToString:@""] || [submitUsername isEqualToString:@""] || [submitPassword isEqualToString:@""] || [submitConfirm isEqualToString:@""]) { //make sure they're filled
        [self showAlert:@"Error" andMessage:@"Please fill in all fields and submit again." andDismiss:@"Return"];
    } else { //continue with login
        if ([submitUsername rangeOfString:@" "].location == NSNotFound &&
            [submitPassword rangeOfString:@" "].location == NSNotFound &&
            [submitConfirm rangeOfString:@" "].location == NSNotFound &&
            [submitUsername length] < 31 && [submitUsername length] > 4 &&
            [submitPassword length] < 31 && [submitPassword length] > 4) { //check length, spaces
            if ([submitPassword isEqualToString:submitConfirm]) { //if passwords match
                NSString *submitPassword_md5; //create MD5 hash version of password
                submitPassword_md5 = [submitPassword MD5];
                
                //POST THIS HERE USING ASIHTTPFORMREQUEST
                
                //UPON SUCCESS
                /*
                 [self.appDelegate.loginDetails setObject:submitUsername forKey:(id)kSecAttrAccount];
                 [self.appDelegate.loginDetails setObject:submitPassword_md5 forKey:(id)kSecValueData];
                 */
                    
                //DISMISS MODALVIEWCONTROLLER
    
            } else { //shows alert for passwords that don't match
                [self showAlert:@"Error" andMessage:@"Your passwords do not match." andDismiss:@"Return"];
            }
        } else { //shows alert for invalid username and password
            [self showAlert:@"Error" andMessage:@"Your username and password must be between 5 and 30 characters and not contain any spaces." andDismiss:@"Return"];
        }
    }
}

- (IBAction)submitLogin
{
    NSString *submitUsername = [self.usernameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *submitPassword = [self.passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
     
    if ([submitUsername isEqualToString:@""] || [submitPassword isEqualToString:@""]) { //check for field content
        [self showAlert:@"Error" andMessage:@"Please fill in all fields and submit again." andDismiss:@"Return"];
    } else { //contiue with login
        NSString *submitPassword_md5;
        submitPassword_md5 = [submitPassword MD5];
         
        //POST THIS HERE USING ASIHTTPFORMREQUEST
         
        //UPON SUCCESS
        /*
         [self.appDelegate.loginDetails setObject:submitUsername forKey:(id)kSecAttrAccount];
         [self.appDelegate.loginDetails setObject:submitPassword_md5 forKey:(id)kSecValueData];
         */
         
        //DISMISS MODALVIEWCONTROLLER
    }
}
///////////////////////////////////////////////

//////////STANDARD METHODS FOR VC TEXT & ALERT DELEGATES//////////
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)showAlert:(NSString*)title andMessage:(NSString*)message andDismiss:(NSString*)dismiss
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:dismiss otherButtonTitles:nil, nil];
    [alert show];
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    [theTextField resignFirstResponder];
    //UNLESS THE TEXTFIELD IS THE LAST ONE BEFORE SUBMITTING IS POSSIBLE
    //THEN CALL ANOTHER METHOD INSTEAD OF JUST RESIGNFIRSTRESPONDER
    return YES;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITextField *textField in self.view.subviews) {
        [textField resignFirstResponder];
    }
}
//////////////////////////////////////////////////////////////////


@end
