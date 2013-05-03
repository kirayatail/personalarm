//
//  FriendsViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-19.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkConstants.h"
#import "User.h"
@class FriendsViewController;
@protocol FriendsViewControllerDelegate<NSObject>

typedef void (^GetFriendsSuccessBlock)(NSArray* friends);
typedef void (^FriendsViewControllerSuccessBlock)(void);
typedef void (^FriendsViewControllerFailureBlock)(WebServiceResponse);

-(void) friendsViewControllerGetFriends:(FriendsViewController*) friendsViewController
                        success:(GetFriendsSuccessBlock)success
                        failure:(FriendsViewControllerFailureBlock)failure;


-(void) friendsViewController:(FriendsViewController*) friendsViewController
                 deleteFriend:(NSString*)friendID
                      success:(FriendsViewControllerSuccessBlock)success
                      failure:(FriendsViewControllerFailureBlock)failure;



-(void) friendsViewControllerGetFriendRequests:(FriendsViewController*) friendsViewController
                                         success:(FriendsViewControllerSuccessBlock) success
                                         failure:(FriendsViewControllerFailureBlock) failure;

-(void) friendsViewController:(FriendsViewController*) friendsViewController
       respondToFriendRequest:(NSString*) friendRequestID
                       accept:(BOOL)value;

@end


@interface FriendsViewController : UITableViewController


@end
