//
//  CallSettingsViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "CallSettingsViewController.h"
#import "TelephoneDatasource.h"

@interface CallSettingsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CallSettingsViewController

@synthesize delegate = _delegate;
@synthesize textField = _textField;

- (IBAction)cancelPressed:(id)sender
{
    [self.delegate callSettingsViewController:self didPressCancel:YES];
}

- (IBAction)donePressed:(id)sender
{
    [self.delegate callSettingsViewController:self didPressDone:YES enteredNumber:self.textField.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // self.textField.text =
}


@end
