//
//  SessionMapViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-05-16.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "SessionMapViewController.h"
#import <MapKit/MapKit.h>

@interface SessionMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SessionMapViewController

@synthesize mapView = _mapView;

- (IBAction)returnToSessions:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tabBarController.navigationItem.hidesBackButton = NO;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
