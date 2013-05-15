//
//  AlarmViewController.h
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-01.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "NetworkConstants.h"
#import "User.h"
#import <Parse/Parse.h>

@class AlarmViewController;

@protocol AlarmViewControllerDelegate

typedef void (^AlarmViewControllerSuccessBlock)(User* user);
typedef void (^LoginSuccess)(void);
typedef void (^CreateUserBlock)(void);

typedef void (^AlarmViewControllerFailureBlock)(WebServiceResponse);

-(void) alarmViewController:(AlarmViewController*) aVC
        createUserWithName:(NSString*)userName
                      email:(NSString*)email
                  password :(NSString*)password
                    success:(CreateUserBlock)success
                    failure:(AlarmViewControllerFailureBlock)failure;

-(void) alarmViewControllerLogin:(AlarmViewController*)afc success:(LoginSuccess) success failure:(AlarmViewControllerFailureBlock) failure;

@end
@interface AlarmViewController : UIViewController<ProfileViewControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (nonatomic, retain) id<AlarmViewControllerDelegate> delegate;


@end
