//
//  UserAnnotation.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-23.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "UserAnnotation.h"
#import "NetworkConstants.h"

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
    CLLocationCoordinate2D theCoordinate;
    [self.session refresh];
    theCoordinate.longitude = [[self.session objectForKey:SESSION_SENDER_LOCATION_LONGITUD]doubleValue];
    theCoordinate.latitude = [[self.session objectForKey:SESSION_SENDER_LOCATION_LATITUD]doubleValue];
    return theCoordinate;
}

-(NSString*) title
{
    PFUser* user = [self.session objectForKey:SESSION_SENDER];
    [user fetchIfNeeded];
    return user.username;
}


@end
