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

+ (BOOL) phoneNumberIsValid:(NSString *)phoneNumber
{    
    //This is the string that is going to be compared to the input string
    NSString *testString = [NSString string];
    
    NSScanner *scanner = [NSScanner scannerWithString:phoneNumber];
    
    //This is the character set containing all digits. It is used to filter the input string
    NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"+1234567890"];
    
    //This goes through the input string and puts all the
    //characters that are digits into the new string
    [scanner scanCharactersFromSet:skips intoString:&testString];
    
    return ([phoneNumber length] == [testString length]) && ([phoneNumber length] >= 10);
}


@end
