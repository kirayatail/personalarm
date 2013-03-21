//
//  User.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-21.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSString * rememberToken;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * serverID;

@end
