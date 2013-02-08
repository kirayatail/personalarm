//
//  TelephoneDatasource.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "TelephoneDatasource.h"

@interface TelephoneDatasource ()

@end

@implementation TelephoneDatasource

@synthesize phonenumber = _phonenumber;

-(id)init {
    
    // Get phonenumber from userdefault
    if (self = [super init]){
        _phonenumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"Number"];
    }
    return self;
}


-(void) setPhonenumber:(NSString *)phonenumber
{
    NSUserDefaults *numbers = [NSUserDefaults standardUserDefaults];
    
    //If the phonenumber is new, set it to userdefault and save it to instance variable.
    if (phonenumber != self.phonenumber){
        [numbers setObject:phonenumber forKey:@"Number"];
        [numbers synchronize];
        _phonenumber = [numbers objectForKey:@"Number"];
    }
}


@end
