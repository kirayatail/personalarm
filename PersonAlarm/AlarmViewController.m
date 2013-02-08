//
//  AlarmViewController.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-01.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmController.h"

@interface AlarmViewController ()

@property (nonatomic, strong) AlarmController *alarmController;

@end

@implementation AlarmViewController

@synthesize alarmController = _alarmController;

- (IBAction)alarmPressed:(id)sender {
    self.alarmController = [[AlarmController alloc] init];
    [self.alarmController triggerAlarm];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

@end
