//
//  ParseController.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ParseController.h"

@implementation ParseController

-(void) alarmViewController:(AlarmViewController *)aVC createUserWithName:(NSString *)userName email:(NSString *)email password:(NSString*)password success:(CreateUserBlock)success failure:(AlarmViewControllerFailureBlock)failure
{
    PFUser* user = [PFUser user];
    user.username= userName;
    user.password =password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeded, NSError* error) {
        if(!error){
            success();
        } else{
            NSString* errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error with signup: %@", errorString);
        }
    }];
}
-(void) alarmViewControllerLogin:(AlarmViewController *)afc success:(LoginSuccess)success failure:(AlarmViewControllerFailureBlock)failure
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userName =[prefs objectForKey:@"name"];
    NSString* password = [prefs objectForKey:@"password"];
    [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser* user, NSError* error){
        if(user){
            success();
        } else{
            //Error
            NSString* errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error with login: %@", errorString);
        }
    }];
}


@end
