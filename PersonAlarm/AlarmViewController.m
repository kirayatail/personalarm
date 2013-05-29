//
//  AlarmViewController.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-01.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmController.h"
#import "HTTPController.h"
#import "ProfileViewController.h"
#import "ParseController.h"

@interface AlarmViewController ()

@property (nonatomic, strong) AlarmController *alarmController;
@property (strong, nonatomic) IBOutlet UIButton *alarmSwitch;

@property (nonatomic, strong) HTTPController* httpController;
@property (nonatomic, strong) ParseController* parseController;
@property BOOL alarmIsActive;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation AlarmViewController

@synthesize httpController = _httpController;
@synthesize alarmController = _alarmController;
@synthesize delegate = _delegate;
@synthesize alarmSwitch = _alarmSwitch;
@synthesize alarmIsActive = _alarmIsActive;

- (void)viewDidLoad
{
    self.alarmIsActive = NO;
    /* Set up background image */
     
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch-background.png"]];
    
    backgroundImage.frame = self.view.bounds;
    backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.messageLabel.hidden = YES;
    /* ---------------------- */
    
    /* Set up alarm switch */
    
//    UIImage* switchOnImage = [UIImage imageNamed:@"Switch-on.png"];
//    [self.alarmSwitch setBackgroundImage:switchOnImage forState:UIControlStateNormal];
//   
//    self.alarmSwitch.imageView.bounds = CGRectMake(0, 0, 70, 70);
//    self.alarmSwitch.contentVerticalAlignment = UIViewContentModeScaleAspectFit;
//    self.alarmSwitch.imageView.frame = CGRectMake(0, 0, 70, 70);
//    
//    if (self.alarmIsActive) {
//        UIImage* switchOnImage = [UIImage imageNamed:@"Switch-on.png"];
//        [self.alarmSwitch setBackgroundImage:switchOnImage forState:UIControlStateNormal];
//        
//    } else {
//        UIImage* switchOffImage = [UIImage imageNamed:@"Switch-off.png"];
//        [self.alarmSwitch setBackgroundImage:switchOffImage forState:UIControlStateNormal];
//    }
    
    
    /* ------------------- */
    
    [super viewDidLoad];
    self.parseController = [[ParseController alloc]init];
    self.delegate = self.parseController;  
}


- (IBAction)alarmDidActivate:(UIButton *)sender {
    
    ParseController* pc = [[ParseController alloc]init];
    [pc activateAlarm];
    sender.enabled = NO;
    self.messageLabel.hidden = NO;
//    if (!self.alarmIsActive) {
//        UIImage* switchOnImage = [UIImage imageNamed:@"Switch-on.png"];
//        [sender setBackgroundImage:switchOnImage forState:UIControlStateNormal];
//        self.alarmIsActive = YES;
//    } else {
//        UIImage* switchOffImage = [UIImage imageNamed:@"Switch-off.png"];
//        [sender setBackgroundImage:switchOffImage forState:UIControlStateNormal];
//        self.alarmIsActive = NO;
//    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    PFUser*currentUser = [PFUser currentUser];
    if(currentUser){

    } else{
        //        [self showProfileView];
        
        
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        /* --------- Set appearance of login view --------- */
        
        // Create image
        UIImage *image = [UIImage imageNamed:@"logo.png"];
        
        // Create logo
        UIView *loginLogo = [[UIImageView alloc] initWithImage:image];
        UIView *signupLogo = [[UIImageView alloc] initWithImage:image];

        
        // Set the logo
        [logInViewController.logInView setLogo:loginLogo];
        [signUpViewController.signUpView setLogo:signupLogo];
        
        // Set background image for login and signup views
        UIImageView* loginBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch-background.png"]];
        UIImageView* signupBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch-background.png"]];

        
        [logInViewController.logInView insertSubview:loginBackground atIndex:0];
        [signUpViewController.signUpView insertSubview:signupBackground atIndex:0];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
    }
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    //Register the user to push notifications
    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
    NSString* userPrefix = @"User_";
    NSString* objectID = [PFUser currentUser].objectId;
    NSString* uniqueChannelName = [userPrefix stringByAppendingString:objectID];
    [currentInstallation addUniqueObject:uniqueChannelName forKey:@"channels"];
    [currentInstallation saveInBackground];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
   
    //Register the user to push notifications
    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
    NSString* userPrefix = @"User_";
    NSString* objectID = [PFUser currentUser].objectId;
    NSString* uniqueChannelName = [userPrefix stringByAppendingString:objectID];
    [currentInstallation addUniqueObject:uniqueChannelName forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Show Profile"])
    {
        [segue.destinationViewController setDelegate:self];
    }
}
#pragma mark Profile

-(void) showProfileView
{
    [self performSegueWithIdentifier:@"Show Profile" sender:self];
}

-(void)profileViewController:(ProfileViewController *)pvc donePressed:(BOOL)didPressDone userName:(NSString *)name password:(NSString *)password email:(NSString *)email
{
    [self.delegate alarmViewController:self createUserWithName:name
                                 email:email
                              password:password
                               success:^{

                                   //Set the private channel for incoming notifications to the user for incoming notifications
                                    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
                                    [currentInstallation addUniqueObject:[PFUser currentUser].objectId forKey:@"channels"];
                                
                                   [self dismissViewControllerAnimated:YES completion:^{
                                       
                                   }];
                                   
                               }failure:^(WebServiceResponse response){
                                   
                               }];
}
-(BOOL) userInfoIsEmpty:(NSString*) name email:(NSString*) email password:(NSString*)password
{
    if([email isEqualToString:@""] || [name isEqualToString:@""] || [password isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}

#pragma mark Helper methods

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
