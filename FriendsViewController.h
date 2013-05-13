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
#import <Parse/Parse.h>
@class FriendsViewController;
@protocol FriendsViewControllerDelegate<NSObject>

typedef void (^GetFriendsSuccessBlock)(NSArray* friends);
typedef void (^GetFriendRequestsSuccessBlock)(NSArray* friendRequests);
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
                                         success:(GetFriendRequestsSuccessBlock) success
                                         failure:(FriendsViewControllerFailureBlock) failure;

-(void) friendsViewController:(FriendsViewController*) friendsViewController
                acceptFriendRequest:(PFObject*)friendRequest
                            success:(FriendsViewControllerSuccessBlock)success
                            failure:(FriendsViewControllerFailureBlock)faiure;

-(void) friendsViewController:(FriendsViewController *)friendsViewController declineFriendRequest:(PFObject *)friendRequest success:(FriendsViewControllerSuccessBlock)success failure:(FriendsViewControllerFailureBlock)faiure;

@end


@interface FriendsViewController : UITableViewController


@end
