//
//  LocationController.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-05-24.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "LocationController.h"
@interface LocationController () <CLLocationManagerDelegate>

@property(nonatomic) BOOL isBroadcasting;
@property(nonatomic, retain) CLLocationManager *clm;

@end


@implementation LocationController

@synthesize isBroadcasting = _isBroadcasting;
@synthesize clm = _clm;

-(id)init{
    if(self = [super init]){
        this.clm = [[CLLocationManager alloc] init];
    }
    
    return self;
}

+(id)sharedLocationController {
    static LocationController *sharedLocationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationController = [[self alloc] init];
    });
    return sharedLocationController;
}

-(void)startBroadcast{
    
}

-(void)stopBroadcast{
    
}




@end
