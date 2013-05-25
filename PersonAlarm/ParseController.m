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
        
        //Send push notification
        PFUser* user =[PFUser currentUser];
        [user fetchIfNeeded];
        NSString* sender = user.username;
        NSString* message = [sender stringByAppendingString:@" has sent you a friend request!"];
        [self sendPushNotificationToUser:receiver withMessage:message];
        success();
    }
}

#pragma mark FriendsViewController delegate
-(void) friendsViewControllerGetFriendRequests:(FriendsViewController *)friendsViewController success:(GetFriendRequestsSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    //Query FriendRequest where reciever == currentUser && not accepted
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_FRIEND_REQUEST];
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

-(void) friendsViewController:(FriendsViewController *)friendsViewController declineFriendRequest:(PFObject *)friendRequest success:(FriendsViewControllerSuccessBlock)success failure:(FriendsViewControllerFailureBlock)faiure
{
    //To decline a Friend Request, simply remove the Friend Request
    [friendRequest deleteInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if(error){
            NSLog(@"Error in ParseCTRLR decline: %@", error.localizedDescription);
        } else {
            success();
        }
    }];
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
    
    //Check if any one-sided Friendships exists
    [self cleanUpFriends];
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
//Check and delete relations to Friend who have ended their Friendship with current user
-(void) cleanUpFriends
{
    //Check if currentUser is listed as receiver in any FriendshipsDeleted object
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_FRIENDSHIPS_DELETED];
    [query includeKey:FRIENDSHIPS_DELETED_RECEIVER];
    [query includeKey:FRIENDSHIPS_DELETED_SENDER];
    [query whereKey:FRIENDSHIPS_DELETED_RECEIVER equalTo:currentUser];
    NSArray* result = [query findObjects];
    if([result count] >0){
        for(int i=0; i<[result count]; i++){
            PFObject* deletedFriendShip = [result objectAtIndex:i];
            PFUser* friendToBeDeleted = [deletedFriendShip objectForKey:FRIENDSHIPS_DELETED_SENDER];
            PFRelation* friends = [currentUser relationforKey:RELATIONS_FRIEND];
            [friendToBeDeleted fetchIfNeeded];
            [friends removeObject:friendToBeDeleted];
        } 
        [currentUser saveInBackground];

    }
    
    
}



-(void) friendsViewController:(FriendsViewController *)friendsViewController deleteFriend:(PFUser *)friend success:(FriendsViewControllerSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    PFUser* currentUser = [PFUser currentUser];
    PFRelation* friends = [currentUser relationforKey:RELATIONS_FRIEND];
    [friends removeObject:friend];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if(error)
        {
            NSLog(@"Error in ParseCTRLR %@", error.localizedDescription);
            //Handle error
        } else if(success) {
            //Let the friend know that a two-sided friendship no longer exists.
            PFObject* notificationForFriend = [PFObject objectWithClassName:PARSECLASS_FRIENDSHIPS_DELETED];
            
            [currentUser fetchIfNeeded];
            
            [notificationForFriend setObject:currentUser forKey:FRIENDSHIPS_DELETED_SENDER];
            [notificationForFriend setObject:friend forKey:FRIENDSHIPS_DELETED_RECEIVER];
            [notificationForFriend saveInBackground];
            success();
        }
            
    }];
   
    
    
}


#pragma mark SessionsTableViewController

//Retrieve accepted Sessions where 'current user' is the sender. 
-(void) sessionsTableViewControllerActiveSessions:(SessionsTableViewController *)sessionsTVC success:(SessionsSuccess)result failure:(ActiveSessionsFailure)response
{
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_SESSION];
    [query includeKey:SESSION_SENDER];
    [query whereKey:SESSION_SENDER equalTo:currentUser];
    [query whereKey:SESSION_ACCEPTED equalTo:[NSNumber numberWithBool:YES]];
    NSArray* activeSessions = [query findObjects];
    result(activeSessions);
}



-(void) sessionsTableViewControllerPendingSessions:(SessionsTableViewController *)sessionsTVC success:(SessionsSuccess)result failure:(ActiveSessionsFailure)response
{
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_SESSION];
    [query includeKey:SESSION_RECEIVER];
    [query whereKey:SESSION_RECEIVER equalTo:currentUser];
    NSArray* pendingSessions = [query findObjects];
    result(pendingSessions);
}


-(void) sessionsTableViewControllerCreateSessions:(SessionsTableViewController *)sessionsTVC success:(CreateSessionsSuccess)result failure:(ActiveSessionsFailure)response
{
    PFUser* currentUser = [PFUser currentUser];
    [currentUser fetchIfNeeded];
    
    PFRelation* friendsRelation = [currentUser relationforKey:RELATIONS_FRIEND];
    PFQuery* queryFriends = [friendsRelation query];
    [queryFriends findObjectsInBackgroundWithBlock:^(NSArray* friends, NSError* error){
        if(error){
            NSLog(@"Error #3 in friendsViewControllerGetFriends: %@", error.localizedDescription);
            //Handle error
        } else {
            for(int i=0; i<[friends count]; i++){
                PFUser* theFriend = [friends objectAtIndex:i];
                PFObject* session = [PFObject objectWithClassName:PARSECLASS_SESSION];
                [session setObject:theFriend forKey:SESSION_RECEIVER];
                [session setObject:currentUser forKey:SESSION_SENDER];
                [session setObject:[NSNumber numberWithBool:NO] forKey:SESSION_ACCEPTED];
                [session saveInBackground];
                NSString* message = [currentUser.username stringByAppendingString:@" wants to start a session with you"];
                [self sendPushNotificationToUser:theFriend withMessage:message];
            }
        }
    }];
    result();
}

-(void) sessionsTableViewControllerDeleteSessions:(SessionsTableViewController *)stvc success:(DeleteSessionsSuccess)success failure:(DeleteSessionsFailure)response
{
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_SESSION];
    [query includeKey:SESSION_SENDER];
    [query whereKey:SESSION_SENDER equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray* result, NSError* error){
        if(error){
            NSLog(@"Error in deleteSessions: %@", error.localizedDescription);
        } else {
            for(PFObject* session in result){
                [session deleteInBackground];
            }
            success();
        }
    }];

    
    
}


#pragma mark Push Notification


-(void) sendPushNotificationToUser:(PFUser*) user withMessage:(NSString*) message
{
    [user fetchIfNeeded];
    PFPush *push = [[PFPush alloc] init];
    NSString* userPrefix = @"User_";
    NSString* objectID = user.objectId;
    NSString* uniqueChannelName = [userPrefix stringByAppendingString:objectID];
    [push setChannel:uniqueChannelName];
    [push setMessage:message];
    [push sendPushInBackground];
}
#pragma mark UpdateCurrentPosition
+ (void) updateCurrentPosition:(CLLocation *)currentPosition
{
    // Get all sessions where current user is the sender
    PFQuery* query = [PFQuery queryWithClassName:PARSECLASS_SESSION];
    [query includeKey:SESSION_SENDER];
    [query whereKey:SESSION_SENDER equalTo:[PFUser currentUser]];
    NSArray* result = [query findObjects];
    
    // Update session objects with the current position
    for (PFObject* session in result)
    {
        double latitude = currentPosition.coordinate.latitude;
        double longitude = currentPosition.coordinate.longitude;
        
        [session setObject:[NSNumber numberWithDouble:latitude] forKey:SESSION_SENDER_LOCATION_LATITUD];
        [session setObject:[NSNumber numberWithDouble:longitude] forKey:SESSION_SENDER_LOCATION_LONGITUD];
        
        [session saveInBackground];
    }
}




@end
