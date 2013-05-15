//
//  Friend.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-04-25.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * pending;
@property (nonatomic, retain) User *isFriendOf;

@end
