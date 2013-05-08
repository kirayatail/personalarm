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
@class AlarmViewController;
@protocol AlarmViewControllerDelegate
typedef void (^AlarmViewControllerSuccessBlock)(User* user);
typedef void (^AlarmViewControllerFailureBlock)(WebServiceResponse);

-(void) alarmViewController:(AlarmViewController*) aVC
        createUserWithName:(NSString*)userName
                      email:(NSString*)email
                    success:(AlarmViewControllerSuccessBlock)success
                    failure:(AlarmViewControllerFailureBlock)failure;

@end
@interface AlarmViewController : UIViewController<ProfileViewControllerDelegate>
@property (nonatomic, retain) id<AlarmViewControllerDelegate> delegate;


@end
