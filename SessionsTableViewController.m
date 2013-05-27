//
//  SessionsTableViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-05-16.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "SessionsTableViewController.h"
#import "ParseController.h"
#import "LocationController.h"

@interface SessionsTableViewController ()
@property (nonatomic, strong) NSMutableArray* activeSessions;
@property (nonatomic, strong) NSMutableArray* pendingSessions;
@property (nonatomic, strong) NSMutableArray* acceptedSessions;
@property (nonatomic, strong) ParseController* controller;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sessionButton;

@end

@implementation SessionsTableViewController
@synthesize activeSessions = _activeSessions;
@synthesize pendingSessions = _pendingSessions;
@synthesize controller = _controller;
@synthesize acceptedSessions = _acceptedSessions;

#define BUTTON_START @"Start Sessions"
#define BUTTON_STOP @"Stop Sessions"

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [[ParseController alloc]init];
    self.delegate = self.controller;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"switch-background.png"]];
    self.tableView.backgroundView = nil;
    [self updateSessionButton];
}
- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    [super viewWillAppear:animated];
    
    dispatch_queue_t queue = dispatch_queue_create("FetchSessionsQueue", NULL);
    
    dispatch_async(queue, ^(void){
        [self updateSessionTable];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
    [self.acceptedSessions removeAllObjects];
    //Remove badges
//    self.tabBarItem.badgeValue = nil;
    self.parentViewController.tabBarItem.badgeValue = nil;
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"show session map"]){
        [segue.destinationViewController setSessions:self.acceptedSessions];
    }
}

-(NSMutableArray*) activeSessions
{
    if(_activeSessions == nil){
        _activeSessions = [[NSMutableArray alloc]init];
    }
    return _activeSessions;
}

-(NSMutableArray*) acceptedSessions
{
    if(_acceptedSessions == nil){
        _acceptedSessions = [[NSMutableArray alloc]init];
    }
    return _acceptedSessions;
}


- (IBAction)donePressed:(UIBarButtonItem *)sender {
    if([sender.title isEqualToString:BUTTON_START]){
        [self startSessions];
    } else if([sender.title isEqualToString:BUTTON_STOP]){
        [self stopSessions];
    }
}

-(void) startSessions
{
    self.sessionButton.title = @"Stop Session";
    [self.delegate sessionsTableViewControllerCreateSessions:self success:^{
       //Success
        LocationController* locationController = [LocationController sharedLocationController];
        if(locationController.isBroadcasting){
            //DO naaasing
        } else{
            [locationController startBroadcast];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:PA_NSUDEFAULTS_ACTIVESESSION];
        [defaults synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateSessionButton];
            [self.tableView reloadData];
        });

     
        
    }failure:^(WebServiceResponse response){
        //Handle error
    }];
}

-(void) stopSessions
{
    [self.delegate sessionsTableViewControllerDeleteSessions:self success:^{
        [self.activeSessions removeAllObjects];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:PA_NSUDEFAULTS_ACTIVESESSION];
        [defaults synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateSessionButton];
            [self.tableView reloadData];
        });
        LocationController* controller = [LocationController sharedLocationController];
        if(controller.isBroadcasting){
            [controller stopBroadcast];
        }
    }failure:^(WebServiceResponse response){
        
    }];
}

//Called when a Session is started or stopped 
-(void) updateSessionButton
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL userHasActiveSession = [defaults boolForKey:PA_NSUDEFAULTS_ACTIVESESSION];
    if(userHasActiveSession){
        [self.sessionButton setTitle:BUTTON_STOP];
    } else  {
        [self.sessionButton setTitle:BUTTON_START];
    }
}



-(void) updateSessionTable
{
    [self.delegate sessionsTableViewControllerActiveSessions:self success:^(NSArray* result){
        if([result count] > 0 ){
            self.activeSessions = [result mutableCopy];
        } else
     {
         [self.activeSessions removeAllObjects];
         //No one is following. 
     }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }failure:^(WebServiceResponse response){
        //Handle error
    }];
    
    [self.delegate sessionsTableViewControllerPendingSessions:self success:^(NSArray* result){
        if ([result count] > 0)
        {
            self.pendingSessions = [result mutableCopy];
        } else
        {
            [self.pendingSessions removeAllObjects]; 
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
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
        [session fetchIfNeeded];
        PFUser* follower = [session objectForKey:SESSION_RECEIVER];
        [follower fetchIfNeeded];
    
        
        [cell.textLabel setText:follower.username];
    } else if (indexPath.section == SECTION_SESSION_REQUESTS) {
        PFObject* session = [self.pendingSessions objectAtIndex:indexPath.row];
        [session fetchIfNeeded];
        PFUser* sender = [session objectForKey:SESSION_SENDER];
        
        [sender fetchIfNeeded];
        
        [cell.textLabel setText:sender.username];
        
        BOOL accepted = [[session objectForKey:SESSION_ACCEPTED] boolValue];
        if (accepted)
        {
             // Set checkmark if the session is accepted
            [self.acceptedSessions addObject:session];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
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


@end
