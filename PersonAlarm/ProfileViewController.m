//
//  ProfileViewController.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-04-15.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ProfileViewController
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)donePressed:(id)sender {
    
    NSString * name = [self.nameTextField text];
    NSString * email = [self.emailTextField text];
    NSString * pwd = [self.passwordTextField text];    
    [self.delegate profileViewController:self donePressed:YES userName:name password:pwd email:email];
}

-(void) showAlertWithMessage:(NSString *)message
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
//Hides the keyboard
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark UITextFieldDelegate methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}






@end
