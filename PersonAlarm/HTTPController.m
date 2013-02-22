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
    
    User* user = [User new]; //Check this
    
    user.firstName = firstName;
    user.lastName = lastName;
    user.phoneNumber = phoneNumber;
    
    [manager postObject:user path:@"/users" parameters:nil success:nil failure:nil];
}


@end
