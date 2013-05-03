//
//  User.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-04-25.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * rememberToken;
@property (nonatomic, retain) NSString * serverID;
@property (nonatomic, retain) NSSet *hasFriend;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasFriendObject:(Friend *)value;
- (void)removeHasFriendObject:(Friend *)value;
- (void)addHasFriend:(NSSet *)values;
- (void)removeHasFriend:(NSSet *)values;

@end
