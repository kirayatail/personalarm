//
//  HTTPController.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-02-15.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "HTTPController.h"
#import "User.h"
#import <RestKit/CoreData.h>
#import "AlarmAppDelegate.h"
#import "Friend.h"

@interface HTTPController()
@property (nonatomic, strong) NSString* base_url;
@property (nonatomic, strong) NSString* deviceToken;
@end
@implementation HTTPController
@synthesize base_url = _base_url;
@synthesize deviceToken = _deviceToken;

-(NSString*)base_url
{
    if(_base_url == nil) {
        _base_url = @"http://lit-oasis-4007.herokuapp.com";
    }
    return _base_url;
}
-(NSString*) deviceToken
{
    if(_deviceToken == nil) {
//        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//       _deviceToken = [prefs objectForKey:@"deviceToken"];
        _deviceToken = @"2332nfsdfdsj8";
    }
    return _deviceToken;
}
static HTTPController * _instance;
+(HTTPController*) sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}



#pragma mark AlarmViewControllerDelegate methods

//  Add user (POST)
//  base/users?name=...&devToken=...&email=...
-(void) alarmViewController:(AlarmViewController *)aVC createUserWithName:(NSString *)userName email:(NSString *)email success:(AlarmViewControllerSuccessBlock)success failure:(AlarmViewControllerFailureBlock)failure
{
    NSString* URLpath = [self.base_url stringByAppendingString:@"/users?name=\""];
//    NSString* URLpath = @"users?name=\"";
    NSString* URLpath1 = [URLpath stringByAppendingString:userName];
    NSString* URLpath2 =[URLpath1 stringByAppendingString:@"\"&devToken=\""];
    NSString* URLpath3 = [URLpath2 stringByAppendingString:self.deviceToken];
    NSString* URLpath4 = [URLpath3 stringByAppendingString:@"\"&email=\""];
    NSString* URLpath5 = [URLpath4 stringByAppendingString:email];
    NSString* URLpath6 = [URLpath5 stringByAppendingString:@"\""];
    NSLog(@"URLPATH: %@", URLpath6);

//    URLpath += userName + devTokenStatic + self.deviceToken + @"&email=" + email;
    
    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[User class]];
    //    [responseMapping addAttributeMappingsFromArray:@[@"firstName", @"lastName", @"phoneNumber"]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"name"        :   @"name",
     @"email"       :   @"email",
     @"deviceToken" :   @"devToken"
     }];
    
    NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor* userDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
//    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:self.base_url]];
    RKObjectManager* manager = [RKObjectManager sharedManager];
    [manager addResponseDescriptor:userDescriptor];
    [manager postObject:nil path:URLpath6 parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingresult)
    {
        User* user = [mappingresult firstObject];
        NSLog(@"name: %@", user.name);
    } failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
}


#pragma mark AddFriendViewControllerDelegate methods
//Search for a user from the web service
-(void) addFriendViewController:(AddFriendViewController *)aFVC getUser:(NSString *)user success:(AddFriendViewControllerUserSearchSuccess)success failure:(AddFriendViewControllerFailureBlock)failure
{    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
    //    [mapping addAttributeMappingsFromArray:@[@"title", @"author", @"body"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"name"            :   @"name",
     @"deviceToken"     :   @"devToken",
     @"email"           :   @"email",
     @"serverID"        :   @"id"
     }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); 
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/:phone" keyPath:@"user" statusCodes:statusCodes];
    NSString* requestURL = [self.base_url stringByAppendingString:user];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        User* user;
        user = [result firstObject];
        success(user);
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        failure(WEBSERVICE_FAILUE_CONNECTION_ERROR);
    }];
    [operation start];
    

    
}

//Send friend request
//base/friendReq?id=...&devToken=...
-(void) addFriendViewController:(AddFriendViewController *)aFVC sendFriendRequestToUser:(NSString *)friendID success:(AddFriendViewControllerSuccessBlock)success failure:(AddFriendViewControllerFailureBlock)failure
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    NSString* devToken = [prefs objectForKey:@"deviceToken"];
    NSString* URLpath = @"/friendReq?id=";
    [URLpath stringByAppendingString:friendID];
    [URLpath stringByAppendingString:@"&devToken="];
    [URLpath stringByAppendingString:devToken];

    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[User class]];
    //    [responseMapping addAttributeMappingsFromArray:@[@"firstName", @"lastName", @"phoneNumber"]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"name"        :   @"name",
     @"email"       :   @"email",
     @"deviceToken" :   @"devToken",
     @"serverID"    :   @"id"
     }];
    
    NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor* userDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"/users" keyPath:@"users" statusCodes:statusCodes];
    
    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:self.base_url]];
    [manager addResponseDescriptor:userDescriptor];
    [manager postObject:nil path:URLpath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingresult)
     {
         User* user = [mappingresult firstObject];
         NSLog(@"name: %@", user.name);
     } failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed with error: %@", [error localizedDescription]);
     }];
}
    



#pragma mark FriendsViewControllerDelegate methods
-(void) friendsViewController:(FriendsViewController *)friendsViewController deleteFriend:(NSString *)friendID success:(FriendsViewControllerSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    //TODO: Connect to web service
}

-(void) friendsViewControllerGetFriends:(FriendsViewController *)friendsViewController success:(GetFriendsSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    //TODO: Connect to web service
}

-(void) friendsViewControllerGetFriendRequests:(FriendsViewController *)friendsViewController success:(FriendsViewControllerSuccessBlock)success failure:(FriendsViewControllerFailureBlock)failure
{
    //TODO: Connect to web service
}

-(void) friendsViewController:(FriendsViewController *)friendsViewController respondToFriendRequest:(NSString *)friendRequestID accept:(BOOL)value
{
    //TODO: Connect to web service
}





#pragma mark Other

-(void) addUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName phoneNumber:(NSString *)phoneNumber
{    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[User class]];
//    [responseMapping addAttributeMappingsFromArray:@[@"firstName", @"lastName", @"phoneNumber"]];
    [responseMapping addAttributeMappingsFromDictionary:@{
        @"firstName"    :   @"firstname",
        @"lastName"     :   @"lastname",
        @"phoneNumber"  :   @"phone"
     }];
    
    NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor* userDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"/users" keyPath:@"users" statusCodes:statusCodes]; //Change pathPattern
    
    RKObjectMapping* requestMapping = [RKObjectMapping requestMapping];
//    [requestMapping addAttributeMappingsFromArray:@[@"firstName", @"lastName", @"phoneNumber"]];
    [requestMapping addAttributeMappingsFromDictionary:@{
        @"firstName"    :   @"firstname",
        @"lastName"     :   @"lastname",
        @"phoneNumber"  :   @"phone"
     }];

    RKRequestDescriptor* requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[User class] rootKeyPath:@"user"];
    
    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://obscure-beach-9317.herokuapp.com"]]; //Insert later
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:userDescriptor];
    
    User* user = [User new]; 
    
//    user.firstName = firstName;
//    user.lastName = lastName;
//    user.phoneNumber = phoneNumber;
    
    [manager postObject:user path:@"/users" parameters:nil success:nil failure:nil];
}

//-(User *) userWithID:(NSString *)phoneNumber
//{
//    __block User *user = nil;
//    
//    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
////    [mapping addAttributeMappingsFromArray:@[@"title", @"author", @"body"]];
//    [mapping addAttributeMappingsFromDictionary:@{
//     @"firstName"    :   @"firstname",
//     @"lastName"     :   @"lastname",
//     @"phoneNumber"  :   @"phone"
//     }];
//        
//    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/:phone" keyPath:@"user" statusCodes:statusCodes];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://obscure-beach-9317.herokuapp.com/users/23.json"]];
//    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
//    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
//        user = [result firstObject];
////        NSLog(@"Mapped the article: %@", user.firstName);
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        NSLog(@"Failed with error: %@", [error localizedDescription]);
//    }];
//    [operation start];
//    
//    return user;     
//}










@end
