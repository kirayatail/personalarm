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
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.dataSource = self;
}

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
/*
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"messageCell";
  / if(indexPath.row == 1) {
        CellIdentifier = @"messageCell";
    } else if(indexPath.row) {
        CellIdentifier = @"callCell";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Show Message Settings" sender:self];
    } else if(indexPath.row == 1) {
        [self performSegueWithIdentifier:@"Show Call Settings" sender:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

@end
