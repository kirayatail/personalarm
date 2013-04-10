//
//  AddFriendViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-22.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation AddFriendViewController
@synthesize emailTextField = _emailTextField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPressed:(id)sender {
    
}
@end
