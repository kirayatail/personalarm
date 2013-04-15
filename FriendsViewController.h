//
//  FriendsViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-19.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@class FriendsViewController;
@protocol FriendsViewControllerDelegate<NSObject>

-(User*) friendsViewController:(FriendsViewController*)friendsviewController
     getUserwithIdentification:(NSString*) identification;

-(BOOL) friendsViewController:(FriendsViewController*)friendsViewController
                    addFriend:(User*) theFriend;

-(BOOL) friendsViewController:(FriendsViewController*)friendsViewController
                 deleteFriend:(User*) theFriend;

-(NSArray*) friendsForUser;

@end


@interface FriendsViewController : UITableViewController


@end
