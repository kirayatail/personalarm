//
//  AlarmViewController.h
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-01.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
@class AlarmViewController;
@protocol AlarmViewControllerDelegate
-(BOOL) alarmViewController:(AlarmViewController*)alarmViewController   
            addUserWithName:(NSString*)userName
                   password:(NSString*)password
                      email:(NSString*)email;
@end
@interface AlarmViewController : UIViewController<ProfileViewControllerDelegate>
@property (nonatomic, retain) id<AlarmViewControllerDelegate> delegate;


@end
