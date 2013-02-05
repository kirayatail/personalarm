//
//  TelephoneAlarm.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "TelephoneAlarm.h"
#import "TelephoneDatasource.h"
@interface TelephoneAlarm ()
@end

@implementation TelephoneAlarm
@synthesize datasource = _datasource;

-(void)trigger {
    // TODO: check if datasource content is valid
    NSString *number = self.datasource.phonenumber;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:number]]];
}

-(void)stop {
    // Do nothing, this is not a continuous alarm.
}
@end
