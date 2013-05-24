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
    
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self initMap];
}

-(void) initMap
{
    dispatch_queue_t addObjects = dispatch_queue_create("AddSessions", NULL); 
    dispatch_async(addObjects, ^{
        for(PFObject* object in self.sessions){
            UserAnnotation* annotation = [[UserAnnotation alloc]initWithSession:object];
            [self.annotations addObject:annotation];
        }
        if([self.annotations count] >0){
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self.mapView addAnnotations:self.annotations];
            });

        }
    });
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
