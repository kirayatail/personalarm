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

#define SETTINGS_SECTION 0
#define GENERAL_SECTION 1
#define MESSAGE_SETTINGS 0
#define CALL_SETTINGS 1
#define PROFILE_SETTINGS 0
#define FRIEND_SETTINGS 1

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
    self.tableView.dataSource = self;
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

#pragma mark -

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == MESSAGE_SETTINGS && indexPath.section == SETTINGS_SECTION) {
        [self performSegueWithIdentifier:@"Show Message Settings" sender:self];
    } else if(indexPath.row == CALL_SETTINGS && indexPath.section == SETTINGS_SECTION) {
        [self performSegueWithIdentifier:@"Show Call Settings" sender:self];
    } else if (indexPath.row == PROFILE_SETTINGS && indexPath.section == GENERAL_SECTION) {
        [self performSegueWithIdentifier:@"Show Profile Settings" sender:self];
    } else if (indexPath.row == FRIEND_SETTINGS && indexPath.section == GENERAL_SECTION) {
        // Add the view controller and segue for friend settings!!
        [self performSegueWithIdentifier:@"Show Friend Settings" sender:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return 2;
}

@end
