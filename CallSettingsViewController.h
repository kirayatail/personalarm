//
//  CallSettingsViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class CallSettingsViewController;

@protocol CallSettingsViewControllerDelegate <NSObject>

- (void) callSettingsViewController:(CallSettingsViewController *) callSettingsViewController didPressDone:(BOOL) pressed enteredNumber:(NSString *) phoneNumber;

- (void) callSettingsViewController:(CallSettingsViewController *) callSettingsViewController didPressCancel:(BOOL) pressed;

@end

@interface CallSettingsViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, assign) id <CallSettingsViewControllerDelegate> delegate;

@end
