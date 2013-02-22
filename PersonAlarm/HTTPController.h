//
//  HTTPController.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-02-15.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface HTTPController : RKObjectManager

-(void) addUserWithFirstName:(NSString*)firstName lastName:(NSString*)lastName phoneNumber:(NSString*)phoneNumber;

//-(User*) getUserWithPhoneNumberAsID:(NSString*) phoneNumber; //Make NSManagedObject of User later..

//-(void) deleteUser:(NSString*) phoneNumberAsID; // Phone number is ID now.



@end
