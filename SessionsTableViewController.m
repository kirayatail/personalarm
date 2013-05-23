//
//  SessionsTableViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-05-16.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "SessionsTableViewController.h"
#import "ParseController.h"

@interface SessionsTableViewController ()
@property (nonatomic, strong) NSMutableArray* activeSessions;
@property (nonatomic, strong) NSMutableArray* pendingSessions;
@property (nonatomic, strong) ParseController* controller;
@property (nonatomic, strong) CLLocationManager* clm;
@end

@implementation SessionsTableViewController
@synthesize activeSessions = _activeSessions;
@synthesize pendingSessions = _pendingSessions;
@synthesize controller = _controller;
@synthesize clm = _clm;

-(CLLocationManager *) clm
{
    if (_clm == nil)
    {
        _clm = [[CLLocationManager alloc] init];
    }
    return _clm;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [[ParseController alloc]init];
    self.delegate = self.controller;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"switch-background.png"]];
    self.tableView.backgroundView = nil;
}

-(NSMutableArray*) activeSessions
{
    if(_activeSessions == nil){
        _activeSessions = [[NSMutableArray alloc]init];
    }
    return _activeSessions;
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    [super viewWillAppear:animated];
    
    dispatch_queue_t queue = dispatch_queue_create("FetchSessionsQueue", NULL);
   
    dispatch_async(queue, ^(void){
        [self updateSessionTable];
        [self.tableView reloadData];
    });
}
- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self startSessions];
}

-(void) startSessions
{
    [self.delegate sessionsTableViewControllerCreateSessions:self success:^{
        self.clm.delegate = self;
        [self.clm startUpdatingLocation];
        
    }failure:^(WebServiceResponse response){
        
    }];
}

-(void) setUpLocationManager
{
    self.clm.distanceFilter = 50;
    self.clm.delegate = self;
    [self.clm startUpdatingLocation];
}


-(void) updateSessionTable
{
    [self.delegate sessionsTableViewControllerActiveSessions:self success:^(NSArray* result){
        if([result count] > 0 ){
            self.activeSessions = [result mutableCopy];
        } else
     {
         //No one is following. 
     }
        
    }failure:^(WebServiceResponse response){
        //Handle error
    }];
    
    [self.delegate sessionsTableViewControllerPendingSessions:self success:^(NSArray* result){
        if ([result count] > 0)
        {
            self.pendingSessions = [result mutableCopy];
        } else
        {
            // No pending sessions
        }
    } failure:^(WebServiceResponse response){
        // Handle error
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

#define SECTION_FOLLOWING_YOU 0
#define SECTION_SESSION_REQUESTS 1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == SECTION_FOLLOWING_YOU) {
        return [self.activeSessions count];
    } else if (section == SECTION_SESSION_REQUESTS) {
        return [self.pendingSessions count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == SECTION_FOLLOWING_YOU) {
        PFObject* session = [self.activeSessions objectAtIndex:indexPath.row];
        PFUser* follower = [session objectForKey:SESSION_RECEIVER];
        
        [follower fetchIfNeeded];
        
        [cell.textLabel setText:follower.username];
    } else if (indexPath.section == SECTION_SESSION_REQUESTS) {
        PFObject* session = [self.pendingSessions objectAtIndex:indexPath.row];
        PFUser* sender = [session objectForKey:SESSION_SENDER];
        
        [sender fetchIfNeeded];
        
        [cell.textLabel setText:sender.username];
        
        BOOL accepted = [[session objectForKey:SESSION_ACCEPTED] boolValue];
        if (accepted)
        {
             // Set checkmark if the session is accepted
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == SECTION_FOLLOWING_YOU) {
        return @"Following you";
    } else if(section == SECTION_SESSION_REQUESTS){
        return @"Session requests";
    }
    return @"Error";
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    tempLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    if (section == 0) {
        tempLabel.text=@"Following you";
    } else {
        tempLabel.text=@"Session requests";
    }
     
    [tempView addSubview:tempLabel];
    
    return tempView;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_FOLLOWING_YOU)
    {
        // DOO NASING FORE NAUW
    } else if (indexPath.section == SECTION_SESSION_REQUESTS) {
        // Set the session as accepted
        
        PFObject* session = [self.pendingSessions objectAtIndex:indexPath.row];
        
        [session setObject:[NSNumber numberWithBool:YES] forKey:SESSION_ACCEPTED];
        
        [session saveInBackground];
    }
}

#pragma mark CLLocationManagerDelegate methods

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* currentPosition = [locations lastObject];
    
    [ParseController updateCurrentPosition:currentPosition];
}

@end
