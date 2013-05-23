//
//  UserAnnotation.m
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-23.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

-(CLLocationCoordinate2D) coordinate
{
   return [self.dataSource userAnnotationDataSource:self getPositionForUser:self.user];
}

-(NSString*) title
{
    [self.user fetchIfNeeded];
    return self.user.username;
}

@end
