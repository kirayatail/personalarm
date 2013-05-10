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
#import <Parse/Parse.h>
#import "ParseController.h"
@interface AlarmViewController ()

@property (nonatomic, strong) AlarmController *alarmController;
@property (nonatomic, strong) HTTPController* httpController;
@property (nonatomic, strong) ParseController* parseController;
@end

@implementation AlarmViewController
@synthesize httpController = _httpController;
@synthesize alarmController = _alarmController;
@synthesize delegate = _delegate;
- (IBAction)alarmPressed:(id)sender {
    self.alarmController = [[AlarmController alloc] init];
    [self.alarmController triggerAlarm];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parseController = [[ParseController alloc]init];
    self.delegate = self.parseController;
  
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    PFUser*currentUser = [PFUser currentUser];
    if(currentUser){

    } else{
        [self showProfileView];
    }
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

@end
