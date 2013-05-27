//
//  ParseController.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmViewController.h"
#import "AddFriendViewController.h"
#import "FriendsViewController.h"
#import "SessionsTableViewController.h"
#import "UserAnnotation.h"
#import <Parse/Parse.h>
@interface ParseController : NSObject<AlarmViewControllerDelegate, AddFriendViewControllerDelegate, FriendsViewControllerDelegate, SessionsTableViewControllerDelegate>

+ (void) updateCurrentPosition:(CLLocation *)currentPosition;
-(void) activateAlarm;

@end
