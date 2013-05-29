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
@property (nonatomic, strong) NSDate* oldTime;

@end


@implementation LocationController

@synthesize isBroadcasting = _isBroadcasting;
@synthesize clm = _clm;

-(id)init{
    if(self = [super init]){
        self.clm = [[CLLocationManager alloc] init];
        [self.clm setDelegate:self];
        self.clm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //        self.clm.distanceFilter = 30; //30 meters
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
        if(self.oldTime == nil){
            self.oldTime = [NSDate date];
            [ParseController updateCurrentPosition:currentPosition];
        } else {
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                       fromDate:self.oldTime
                                                         toDate:[NSDate date]
                                                        options:0];
            double seconds = components.second;
            if(seconds > 10 ){ //Update every 10 seconds
                [ParseController updateCurrentPosition:currentPosition];
            }
            
        }
    }
}

@end
