//
//  ProfileViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-13.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ProfileViewController.h"
#import "HTTPController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end

@implementation ProfileViewController

@synthesize delegate = _delegate;
@synthesize firstNameTextField = _firstNameTextField;
@synthesize lastNameTextField = _lastNameTextField;
@synthesize phoneNumberTextField = _phoneNumberTextField;


- (IBAction)donePressed:(id)sender {
    // Post new profile information to the database
    HTTPController *httpController = [[HTTPController alloc] init];
    [httpController addUserWithFirstName:self.firstNameTextField.text
                                lastName:self.lastNameTextField.text
                             phoneNumber:self.phoneNumberTextField.text];
    
    [self.delegate profileViewController:self didPressDone:YES];
}

- (IBAction)cancelPressed:(id)sender {
    [self.delegate profileViewController:self didPressCancel:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
