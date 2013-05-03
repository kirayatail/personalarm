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
@interface AlarmViewController ()

@property (nonatomic, strong) AlarmController *alarmController;
@property (nonatomic, strong) HTTPController* httpController;
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
    self.httpController = [[HTTPController alloc]init];
    self.delegate = self.httpController;
 
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"profile"]) {
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
    if([self userInfoIsEmpty:name email:email password:password]) {
        [pvc showAlertWithMessage:@"The message"];
    } else {
        [self.delegate alarmViewController:self createUserWithName:@"INSERT_NAME" success:^{
            //TODO: HANDLE SUCCESS
        }failure:^(WebServiceResponse response){
            //TODO: HANDLE ERROR
        }];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:name forKey:@"username"];
        [prefs synchronize];
        [prefs setObject:email forKey:@"email"];
        [prefs synchronize];
        [prefs setObject:password forKey:@"password"];
        [prefs synchronize];
        [prefs setBool:YES forKey:@"profile"];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
