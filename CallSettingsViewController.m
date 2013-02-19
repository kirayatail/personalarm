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


@end

@implementation CallSettingsViewController

@synthesize delegate = _delegate;
@synthesize textField = _textField;

- (IBAction)cancelPressed:(id)sender
{
    [self.delegate callSettingsViewController:self didPressCancel:YES];
}

- (IBAction)donePressed:(id)sender
{
    [self.delegate callSettingsViewController:self didPressDone:YES enteredNumber:self.textField.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // self.textField.text =
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
