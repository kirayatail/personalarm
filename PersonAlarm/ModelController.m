//
//  ModelController.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-04-11.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ModelController.h"
#import "User.h"
#import "AlarmAppDelegate.h"

@interface ModelController()
@property (nonatomic, strong) NSMutableDictionary* model; //Temp model, for testing purposes, contains the users
@property (nonatomic, strong) NSMutableDictionary* friends; //Temp model, for testing purposes, contains the friends
@end
@implementation ModelController
@synthesize model = _model;
@synthesize friends = _friends;


-(id) init
{
//    if (self = [super init]){
////        NSManagedObjectContext* context = [(AlarmAppDelegate*)([[UIApplication sharedApplication] delegate]) managedObjectContext];
//        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
//       
//        User* user1 = [[User alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
//        user1.email = @"Hans";
//        User* user2 = [[User alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
//        user2.name = @"Greta";
//        User* user3 = [[User alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
//        user3.name = @"Axel";
//        [self.model setObject:user1 forKey:user1.name];
//        [self.model setObject:user2 forKey:user2.name];
//        [self.model setObject:user3 forKey:user3.name];
//    }
//    
//    return self;
    return self = [super init];
}

-(NSMutableDictionary*) model{
    if(_model == nil) {
        _model = [[NSMutableDictionary alloc]init];
    }
    return _model;
}


-(NSMutableDictionary*) friends{
    if(_model == nil) {
        _model = [[NSMutableDictionary alloc]init];
    }
    return _model;
}

-(User*) friendsViewController:(FriendsViewController *)friendsviewController
     getUserwithIdentification:(NSString *)identification
{
    return [self.model objectForKey:identification];
}

-(BOOL) friendsViewController:(FriendsViewController *)friendsViewController
                    addFriend:(NSString *)theFriend
{
    User* user = [self.model objectForKey:theFriend];
    if(user == nil) {
        return NO; //Error
    } else {
        [self.friends setObject:user forKey:(user.objectID)];
        return YES;
    }
}
-(BOOL) friendsViewController:(FriendsViewController *)friendsViewController
                 deleteFriend:(NSString *)theFriend
{
    [self.friends removeObjectForKey:theFriend];
    return YES;
}
-(NSArray*) friendsForUser
{
    return [self.friends allValues];
}
@end
