//
//  ParseController.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ParseController.h"
#import "NetworkConstants.h"
@implementation ParseController


-(void) alarmViewController:(AlarmViewController *)aVC createUserWithName:(NSString *)userName email:(NSString *)email password:(NSString*)password success:(CreateUserBlock)success failure:(AlarmViewControllerFailureBlock)failure
{
    //Create a temporary user with the given values 
    PFUser* user = [PFUser user];
    user.username= userName;
    user.password =password;
    user.email = email;
    [user signUpInBackgroundWithBlock:^(BOOL succeded, NSError* error) {
        if(!error){
            //User is now stored in [PFUser currentUser]
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

#pragma mark AddFriendViewController delegate
-(void) addFriendViewController:(AddFriendViewController *)aFVC getUser:(NSString *)user success:(AddFriendViewControllerUserSearchSuccess)success failure:(AddFriendViewControllerFailureBlock)failure
{
    PFQuery* query = [PFUser query];
    [query whereKey:@"username" equalTo:user];
    NSArray* users = [query findObjects];
    if(users){
        success(users);
    } else{
        //Handle error
    }
}

-(void) addFriendViewController:(AddFriendViewController *)aFVC sendFriendRequestToUser:(PFUser *)receiver success:(AddFriendViewControllerSuccessBlock)success failure:(AddFriendViewControllerFailureBlock)failure
{
    PFUser* currentUser = [PFUser currentUser];
    
    //Check if the sender already has sent an identical Friend Request
    PFQuery *query1 = [PFQuery queryWithClassName:@"FriendRequest"];
    [query1 includeKey:FRIEND_REQUEST_SENDER];
    [query1 includeKey:FRIEND_REQUEST_RECEIVER];
    [query1 whereKey:FRIEND_REQUEST_RECEIVER equalTo:receiver];
    [query1 whereKey:FRIEND_REQUEST_SENDER equalTo:currentUser];
    
    //Check if the receiver already has sent a FriendRequest to the sender
    //TODO: Should we automatically accept the FriendRequest in this case?
    PFQuery *query2 = [PFQuery queryWithClassName:@"FriendRequest"];
    [query2 includeKey:FRIEND_REQUEST_SENDER];
    [query2 includeKey:FRIEND_REQUEST_RECEIVER];
    [query2 whereKey:FRIEND_REQUEST_RECEIVER equalTo:currentUser];
    [query2 whereKey:FRIEND_REQUEST_SENDER equalTo:receiver];
    
    if (([[query1 findObjects] count] == 0) && ([[query2 findObjects] count] == 0)) {
        PFObject* friendRequest = [PFObject objectWithClassName:PARSECLASS_FRIEND_REQUEST];
        [friendRequest setObject:currentUser forKey:FRIEND_REQUEST_SENDER];
        [friendRequest setObject:receiver forKey:FRIEND_REQUEST_RECEIVER];
        [friendRequest setObject:[NSNumber numberWithBool:NO] forKey:FRIEND_REQUEST_ACCEPTED];
        [friendRequest saveInBackground];
        [self sendPushNotificationToUser:receiver];
        success();
    }
}

#pragma mark FriendsViewController delegate
-(void) friendsViewControllerGetFriendRequests:(FriendsViewController *)friendsViewController success:(GetFriendRequestsSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    //Query FriendRequest where reciever == currentUser && not accepted
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_FRIEND_REQUEST];
    [query includeKey:FRIEND_REQUEST_ACCEPTED];
    [query includeKey:FRIEND_REQUEST_RECEIVER];
    [query whereKey:FRIEND_REQUEST_RECEIVER equalTo:currentUser];
    [query whereKey:FRIEND_REQUEST_ACCEPTED equalTo:[NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray* result, NSError* error){
        if(error){
            NSLog(@"Error getFriendReq's #1 %@", error.localizedDescription);
        } else {
            success(result);
        }
    }];
    
}



- (void) friendsViewController:(FriendsViewController *)friendsViewController acceptFriendRequest:(PFObject *)friendRequest success:(FriendsViewControllerSuccessBlock)success failure:(FriendsViewControllerFailureBlock)faiure
{
    //Add the sender of the Friend Request to receiver's(currentUser) friends
    PFUser* sender = [friendRequest objectForKey:FRIEND_REQUEST_SENDER];
    PFUser* currentUser = [PFUser currentUser];
    PFRelation* friends = [currentUser relationforKey:RELATIONS_FRIEND];
    [friends addObject:sender];
    [currentUser saveInBackground];

    //Let the sender know that the receiver has accepted the FriendRequest
    [friendRequest setObject:[NSNumber numberWithBool:YES] forKey:FRIEND_REQUEST_ACCEPTED];
    [friendRequest saveInBackground];
    
    
}

-(void) friendsViewControllerGetFriends:(FriendsViewController *)friendsViewController success:(GetFriendsSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    //Check if any Friend Requests has been accepted
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_FRIEND_REQUEST];
    [query whereKey:FRIEND_REQUEST_SENDER equalTo:currentUser];
    [query whereKey:FRIEND_REQUEST_ACCEPTED equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray* result, NSError* error){
        if(error){
            NSLog(@"Error in getFriends #1 %@", error.localizedDescription);
        } else {
            for(int i=0; i<[result count]; i++){
                //Retrive the user that accepted the FriendRequest, and add to Friend list
                PFObject* friendRequest = [result objectAtIndex:i];
                PFUser* friend =[friendRequest objectForKey:FRIEND_REQUEST_RECEIVER];
                PFRelation* friends = [currentUser relationforKey:RELATIONS_FRIEND];
                [friends addObject:friend];
                [currentUser saveInBackgroundWithBlock:^(BOOL success, NSError* error){
                    if(success){
                         //The FriendRequest is no lomger needed, delete it
                        [friendRequest deleteInBackground];
                    } else {
                        NSLog(@"Error #2 in friendsViewControllerGetFriends: %@", error.localizedDescription);
                    }
                }];
                
            }
        }
    }];
    //Query for Friends related by currentUser
    PFRelation* friendsRelation = [currentUser relationforKey:RELATIONS_FRIEND];
    PFQuery* queryFriends = [friendsRelation query];
    [queryFriends findObjectsInBackgroundWithBlock:^(NSArray* result, NSError* error){
        if(error){
            NSLog(@"Error #3 in friendsViewControllerGetFriends: %@", error.localizedDescription);
            //Handle error
        } else {
            success(result);
        }
    }];
    
    
}

-(void) friendsViewController:(FriendsViewController *)friendsViewController deleteFriend:(NSString *)friendID success:(FriendsViewControllerSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    //TODO: IMPLEMENT!
}



#pragma mark Push Notification
-(void) sendPushNotificationToUser:(PFUser*) user
{
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:user.objectId];
    [push setMessage:@"Friend request!"];
    [push sendPushInBackground];
    
}
@end
