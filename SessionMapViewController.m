//
//  SessionMapViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-05-16.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "SessionMapViewController.h"
#import <MapKit/MapKit.h>
#import "UserAnnotation.h"
#import "ParseController.h"

@interface SessionMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray* annotations;
@property (nonatomic, strong) ParseController* pc;
@end

@implementation SessionMapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    self.tabBarController.navigationItem.hidesBackButton = NO;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.pc = [[ParseController alloc]init];
    [self initMap];
    
    
}

-(void) initMap
{
    for(PFObject* object in self.sessions){
        UserAnnotation* annotation = [[UserAnnotation alloc]initWithSession:object];
        annotation.dataSource = self.pc;
        [self.annotations addObject:annotation];
    }

    if([self.annotations count] >0){
        [self.mapView addAnnotations:self.annotations];
    }

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                                      selector: @selector(updateMap) userInfo: nil repeats: YES];


    
}

-(void)updateMap
{
    if([self.mapView.annotations count] >0){
        [self.mapView removeAnnotations:self.annotations];
        [self.mapView addAnnotations:self.annotations];
    }
  
    [self.mapView setCenterCoordinate:self.mapView.region.center animated:NO];
}

-(NSMutableArray*) annotations
{
    if(_annotations == nil){
        _annotations = [[NSMutableArray alloc]init];
    }
    return _annotations;
}




- (IBAction)returnToSessions:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
