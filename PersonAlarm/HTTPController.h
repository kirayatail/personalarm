//
//  HTTPController.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-02-15.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConstants.h"
#import <RestKit/RestKit.h>
#import "User.h"
#import "AlarmViewController.h"
#import "AddFriendViewController.h"
#import "FriendsViewController.h"
//A singleton class that handles the network communication
//@interface HTTPController : RKObjectManager<AlarmViewControllerDelegate, AddFriendViewControllerDelegate, FriendsViewControllerDelegate>
@interface HTTPController : RKObjectManager
+(HTTPController*) sharedInstance; 







@end
