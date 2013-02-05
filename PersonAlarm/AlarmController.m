/*
//  AlarmController.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

 This class acts as an interface between the view controllers and the alarm methods. 
 
*/

#import "AlarmController.h"
#import "TelephoneAlarm.h"
@interface AlarmController() <NSObject>
@property (nonatomic, strong) TelephoneAlarm* phoneAlarm;

@end

@implementation AlarmController
@synthesize phoneAlarm = _phoneAlarm;

-(id)init {
    if ((self = [super init])) {
        self.phoneAlarm = [[TelephoneAlarm alloc] init];
    }
    
    return self;
}

-(void)triggerAlarm {
    [self.phoneAlarm trigger];
}

-(void)stop {
    // Stops any running alarm and disables triggering of the next alarm
}

@end
