//
//  SettingsViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "TelephoneDatasource.h"

@interface SettingsTableViewController ()


@property (nonatomic, strong) TelephoneDatasource *datasource;

@end

@implementation SettingsTableViewController

@synthesize datasource = _datasource;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Message Settings"])
    {
        [segue.destinationViewController setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"Show Call Settings"]) {
        [segue.destinationViewController setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"Show Profile Settings"]) {
        [segue.destinationViewController setDelegate:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark MessageSettingsViewController delegate methods

- (void) messageSettingsViewController:(MessageSettingsViewController *) messageSettingsViewController didPressDone:(BOOL) pressed
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) messageSettingsViewController:(MessageSettingsViewController *) messageSettingsViewController didPressCancel:(BOOL) pressed
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark CallSettingsViewController delegate methods

- (void) callSettingsViewController:(CallSettingsViewController *) callSettingsViewController didPressDone:(BOOL) pressed enteredNumber:(NSString *)phoneNumber
{
    self.datasource = [[TelephoneDatasource alloc]init];
    self.datasource.phonenumber = phoneNumber;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) callSettingsViewController:(CallSettingsViewController *) callSettingsViewController didPressCancel:(BOOL) pressed
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark ProfileViewController delegate methods

- (void) profileViewController:(ProfileViewController *) profileViewController didPressDone:(BOOL) pressed
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) profileViewController:(ProfileViewController *) profileViewController didPressCancel:(BOOL) pressed
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



@end
