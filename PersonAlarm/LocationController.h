//
//  LocationController.h
//  PersonAlarm
//
//  Created by Max Witt on 2013-05-24.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationController : NSObject <CLLocationManagerDelegate>

+(id)sharedLocationController;

-(void)startBroadcast;
-(void)stopBroadcast;

-(BOOL)isBroadcasting;


@end
