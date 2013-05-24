//
//  UserAnnotation.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-23.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "UserAnnotation.h"
#import "NetworkConstants.h"
@interface UserAnnotation()
@property(nonatomic, strong) NSDate* oldTime;
@end

@implementation UserAnnotation


-(id) initWithSession:(PFObject *)session
{
    self = [super init];
    if(self) {
        self.session = session;
    }
    return self;
}

-(CLLocationCoordinate2D) coordinate
{
    [self updateCoordinate];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.longitude = [[self.session objectForKey:SESSION_SENDER_LOCATION_LONGITUD]doubleValue];
    theCoordinate.latitude = [[self.session objectForKey:SESSION_SENDER_LOCATION_LATITUD]doubleValue];
    return theCoordinate;
}

-(void) updateCoordinate
{
    if(self.oldTime == nil){
        self.oldTime = [NSDate date];
    } else {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:self.oldTime
                                                     toDate:[NSDate date]
                                                    options:0];
        double seconds = components.second;
        if(seconds > 20 ){ //Update every 20 seconds
            [self.session refreshInBackgroundWithBlock:^(PFObject* object, NSError* error){
                if(error){
                    NSLog(@"UserAnnotation: %@", error.localizedDescription);
                } else {
                    self.session = object;
                }
            }];
            self.oldTime = [NSDate date];
        }
        
    }

   

}

-(NSString*) title
{
    PFUser* user = [self.session objectForKey:SESSION_SENDER];
    [user fetchIfNeeded];
    return user.username;
}


@end
