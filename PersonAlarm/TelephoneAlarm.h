//
//  TelephoneAlarm.h
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmController.h"
#import "TelephoneDatasource.h"

@interface TelephoneAlarm : NSObject<AlarmMethod>
@property (nonatomic, strong) TelephoneDatasource * datasource;

@end
