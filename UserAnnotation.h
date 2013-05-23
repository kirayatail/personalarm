//
//  UserAnnotation.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-05-23.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
@class UserAnnotation;
@protocol UserAnnotationDataSource <NSObject>

-(CLLocationCoordinate2D) userAnnotationDataSource:(UserAnnotation*)userAnnotation getPositionForUser:(PFUser*)user;

@end
@interface UserAnnotation : NSObject<MKAnnotation>
@property (nonatomic, strong) PFUser* user;
@property (nonatomic, retain) id<UserAnnotationDataSource> dataSource;

@end
