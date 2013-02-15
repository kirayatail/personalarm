//
//  HTTPController.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-02-15.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "HTTPController.h"
#import "User.h"

@implementation HTTPController

-(void) addUser:(NSString *)firstName surname:(NSString*)surname phoneNumber:(NSString *)phoneNumber
{
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"firstName", @"surname", @"phoneNumber"]];
    NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor* userDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"/users" keyPath:@"users" statusCodes:statusCodes]; //Change pathPattern
    
    RKObjectMapping* requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"firstName", @"surname", @"phoneNumber"]];
    
    RKRequestDescriptor* requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[User class] rootKeyPath:@"user"];
    
    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"URL STRING"]]; //Insert later
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:userDescriptor];
    
    User* user = [User new]; //Check this
    user.firstName = firstName;
    user.surname = surname;
    user.phoneNumber = phoneNumber;
    
    [manager postObject:user path:@"/users" parameters:nil success:nil failure:nil];
    
    
    
}


@end
