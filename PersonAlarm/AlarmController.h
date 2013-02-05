//
//  AlarmController.h
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TelephoneAlarm;

@protocol AlarmMethod <NSObject>
-(void)trigger;
-(void)stop;
@end


@interface AlarmController : NSObject
@property (nonatomic, strong) TelephoneAlarm* phoneAlarm;
-(void)triggerAlarm;

-(void)stop;
@end
