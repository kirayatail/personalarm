//
//  ProfileViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-13.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize delegate = _delegate;


- (IBAction)donePressed:(id)sender {
    // Update information in the database
    
    [self.delegate profileViewController:self didPressDone:YES];
}

- (IBAction)cancelPressed:(id)sender {
    [self.delegate profileViewController:self didPressCancel:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
