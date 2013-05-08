//
//  FriendsViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-19.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "FriendsViewController.h"
#import "User.h"
#import "ParseController.h"
#import "Friend.h"
@interface FriendsViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) id <FriendsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) ParseController* parseController;
@property (nonatomic, strong) NSMutableArray* pendingFriends;

@end

@implementation FriendsViewController
@synthesize fetchedResultsController = _fetchedResultsController;




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parseController = [[ParseController alloc]init];
    self.delegate = self.parseController;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatePendingFriends];
    
}

-(void) updatePendingFriends
{
    __block FriendsViewController* fvc = self;
    [self.delegate friendsViewControllerGetFriendRequests:self success:^(NSArray* friendRequests){
        fvc.pendingFriends = [[NSMutableArray alloc]init];
        fvc.pendingFriends = [friendRequests copy];
        [fvc.tableView reloadData];
    }failure:^(WebServiceResponse response){
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Show AFVC"]) {
        [segue.destinationViewController setDelegate:self.parseController];
    }
}
#pragma mark UITableViewDelegate method
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0) {
//        return [[self.fetchedResultsController fetchedObjects]count];
        return 0;
    } else if (section == 1) {
        return [self.pendingFriends count];
    } else {
        return 0;
    }

}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0) {
        return @"Friends";
    } else if(section == 1){
        return @"Pending";
    }
    return @"Error";
}




-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This code is for testing purposes, needs to be implemented
    //TODO: Get friend objects from FetchedResultsController
    static NSString *CellIdentifier = @"friendCell";
    NSString* cellText = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section == 1) {
        PFUser* friend = [self.pendingFriends objectAtIndex:indexPath.row];
        cellText = friend.username;
    }  
    [cell.textLabel setText:cellText];

    
    return cell;
}



@end
