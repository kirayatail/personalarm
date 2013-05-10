//
//  AddFriendViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-22.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkConstants.h"
#import "User.h"
#import <Parse/Parse.h>
@class AddFriendViewController;

typedef void (^AddFriendViewControllerSuccessBlock)(void);
typedef void (^AddFriendViewControllerUserSearchSuccess)(NSArray* users);
typedef void (^AddFriendViewControllerFailureBlock)(WebServiceResponse);

@protocol AddFriendViewControllerDelegate
-(void) addFriendViewController:(AddFriendViewController*) aFVC
                        getUser:(NSString*)user
                        success: (AddFriendViewControllerUserSearchSuccess)success
                        failure: (AddFriendViewControllerFailureBlock)failure;


-(void) addFriendViewController:(AddFriendViewController*) aFVC
        sendFriendRequestToUser:(PFUser*)theFriend
                        success: (AddFriendViewControllerSuccessBlock)success
                        failure: (AddFriendViewControllerFailureBlock)failure;

@end

@interface AddFriendViewController : UIViewController<UISearchBarDelegate>
@property id<AddFriendViewControllerDelegate> delegate;

@end