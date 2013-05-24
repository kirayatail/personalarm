//
//  LocationController.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-05-24.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "LocationController.h"
#import "ParseController.h"
@interface LocationController () <CLLocationManagerDelegate>

@property(nonatomic) BOOL isBroadcasting;
@property(nonatomic, retain) CLLocationManager *clm;

@end


@implementation LocationController

@synthesize isBroadcasting = _isBroadcasting;
@synthesize clm = _clm;

-(id)init{
    if(self = [super init]){
        self.clm = [[CLLocationManager alloc] init];
        [self.clm setDelegate:self];
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
    self.isBroadcasting = YES;
    [self.clm startUpdatingLocation];
}

-(void)stopBroadcast{
    self.isBroadcasting = NO;
    [self.clm stopUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* currentPosition = [locations lastObject];
    if(self.isBroadcasting){
        [ParseController updateCurrentPosition:currentPosition];
    }
}

@end
