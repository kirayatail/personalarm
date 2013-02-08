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
        NSUserDefaults *numbers = [NSUserDefaults standardUserDefaults];
        _phonenumber = [numbers objectForKey:@"Number"];
        
    }
    
    return self;
}

-(void) setPhonenumber:(NSString *)phonenumber {
    NSUserDefaults *numbers = [NSUserDefaults standardUserDefaults];
    
    //If the phonenumber is new, set it to userdefault
    if (self.phonenumber != phonenumber){
        [numbers setObject:phonenumber forKey:@"Number"];
    } 
}



@end
