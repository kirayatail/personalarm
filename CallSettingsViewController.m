//
//  CallSettingsViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "CallSettingsViewController.h"
#import "TelephoneDatasource.h"

@interface CallSettingsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) TelephoneDatasource *datasource;


@end

@implementation CallSettingsViewController

@synthesize delegate = _delegate;
@synthesize textField = _textField;
@synthesize datasource = _datasource;

- (IBAction)cancelPressed:(id)sender
{
    [self.delegate callSettingsViewController:self didPressCancel:YES];
}

- (IBAction)donePressed:(id)sender
{
    BOOL valid = [TelephoneDatasource phoneNumberIsValid:self.textField.text];
    
    if(valid) {
        [self.delegate callSettingsViewController:self didPressDone:YES enteredNumber:self.textField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid phone number" message:@"Please enter a valid phone number" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datasource = [[TelephoneDatasource alloc]init];
    [self.textField setText:self.datasource.phonenumber];
}

- (IBAction)addContactPressed:(id)sender {
    ABPeoplePickerNavigationController* peoplePickerNavigationController = [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerNavigationController.peoplePickerDelegate = self;
    [self presentViewController:peoplePickerNavigationController animated:YES completion:^{
        
    }];
    
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    //Extract the phone number from the person user selected, and put it on the textfield
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        //TODO: Notify user that the contact is invalid?
        phone = @"No phone number";
    }   
    self.textField.text = phone;
    CFRelease(phoneNumbers);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    return NO;
    
}



-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    return NO;
}
-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
