//
//  ParseController.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ParseController.h"

@implementation ParseController

-(void) alarmViewController:(AlarmViewController *)aVC createUserWithName:(NSString *)userName email:(NSString *)email password:(NSString*)password success:(CreateUserBlock)success failure:(AlarmViewControllerFailureBlock)failure
{
    PFUser* user = [PFUser user];
    user.username= userName;
    user.password =password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeded, NSError* error) {
        if(!error){
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

    //Check if a relation already exists
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query includeKey:@"Sender"];
    [query includeKey:@"Reciever"];
    [query whereKey:@"Reciever" equalTo:receiver];
    [query whereKey:@"Sender" equalTo:currentUser];
    
    if ([[query findObjects] count] == 0) {
        PFObject* friendRequest = [PFObject objectWithClassName:@"FriendRequest"];
        [friendRequest setObject:[PFUser objectWithoutDataWithClassName:@"_User" objectId:currentUser.objectId] forKey:@"Sender"];
        [friendRequest setObject:[PFUser objectWithoutDataWithClassName:@"_User" objectId:receiver.objectId] forKey:@"Reciever"];
        [friendRequest saveInBackground];
        success();
    }
}

#pragma mark FriendsViewController delegate
-(void) friendsViewControllerGetFriendRequests:(FriendsViewController *)friendsViewController success:(GetFriendRequestsSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query includeKey:@"Sender"];
    [query includeKey:@"Reciever"];
   [query whereKey:@"Reciever" equalTo:currentUser];
    dispatch_queue_t myQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(myQueue, ^{
        NSArray* pendingFriends =[query findObjects];
        
        NSMutableArray* tempArray = [[NSMutableArray alloc]init];
        for(int i=0; i<[pendingFriends count]; i++){
            PFObject* theObj = [pendingFriends objectAtIndex:i];
            PFUser* user = [theObj objectForKey:@"Sender"];
            [tempArray addObject:user];
        }
         success(tempArray);
    });
}




@end
