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

@implementation HTTPController

//OBS! Code does not work for now...

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

-(User *) userWithID:(NSString *)phoneNumber
{
    __block User *user = nil;
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
//    [mapping addAttributeMappingsFromArray:@[@"title", @"author", @"body"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"firstName"    :   @"firstname",
     @"lastName"     :   @"lastname",
     @"phoneNumber"  :   @"phone"
     }];
        
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/:phone" keyPath:@"user" statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://obscure-beach-9317.herokuapp.com/users/23.json"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        user = [result firstObject];
//        NSLog(@"Mapped the article: %@", user.firstName);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    [operation start];
    
    return user;     
}

-(BOOL)alarmViewController:(AlarmViewController *)alarmViewController addUserWithName:(NSString *)userName password:(NSString *)password email:(NSString *)email
{
    //TODO: Insert code here
    return NO;
}




@end
