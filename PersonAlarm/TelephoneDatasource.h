//
//  TelephoneDatasource.h
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TelephoneDatasource : NSObject

@property (nonatomic, strong) NSString *phonenumber;

-(id)init;

+(BOOL) phoneNumberIsValid:(NSString *)phoneNumber;
@end
