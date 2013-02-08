//
//  MessageSettingsViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "MessageSettingsViewController.h"

@interface MessageSettingsViewController ()

@end

@implementation MessageSettingsViewController

@synthesize delegate = _delegate;

- (IBAction)donePressed:(id)sender
{
    [self.delegate messageSettingsViewController:self didPressDone:YES];
}
- (IBAction)cancelPressed:(id)sender
{
    [self.delegate messageSettingsViewController:self didPressCancel:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
