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
@property (nonatomic, strong) NSMutableArray* friendRequests;
@property (nonatomic, strong) NSMutableArray* friends;

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
    [self updateFriends];
}

-(NSMutableArray*) friends
{
    if(_friends == nil){
        _friends = [[NSMutableArray alloc]init];
    }
    return _friends;
}

-(NSMutableArray*) friendRequests
{
    if(_friendRequests == nil) {
        _friendRequests = [[NSMutableArray alloc]init];
    }
    return _friendRequests;
}

-(void) updatePendingFriends
{
    __block FriendsViewController* fvc = self;
    [self.delegate friendsViewControllerGetFriendRequests:self success:^(NSArray* friendRequests){
        if([friendRequests count] > 0){
            fvc.friendRequests = [friendRequests mutableCopy];
            //Update tableView
            [fvc.tableView reloadData];
        } else {
            //There is no pending Friends on remote server
            //Delete the local list of Friend requests
            if([fvc.friendRequests count] > 0){
                [fvc.friendRequests removeAllObjects];
                //Update tableView
                [fvc.tableView reloadData];
            } else {
                //FriendRequests is already emtpy, do nothing..
            }
        }
    }failure:^(WebServiceResponse response){
        
    }];
}
-(void) updateFriends {
    __block FriendsViewController* fvc = self;
    [self.delegate friendsViewControllerGetFriends:self success:^(NSArray* friends){
        if([friends count]> 0){
            fvc.friends = [[NSMutableArray alloc] init];
            fvc.friends = [friends mutableCopy];
            //Update tableView
            [fvc.tableView reloadData];
        }
    }failure:^(WebServiceResponse response) {
        // Handle error
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
#pragma mark UITableViewDelegate methods
#define SECTION_FRIEND 0
#define SECTION_PENDING_FRIEND 1
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0) {
        return [self.friends count];
    } else if (section == 1) {
        return [self.friendRequests count];
    } else {
        return 0;
    }

}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == SECTION_FRIEND) {
        return @"Friends";
    } else if(section == SECTION_PENDING_FRIEND){
        return @"Pending";
    }
    return @"Error";
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==  SECTION_FRIEND)
    {
        //TODO: Handle event
    } else if(indexPath.section == SECTION_PENDING_FRIEND){
        PFObject *friendRequest = [self.friendRequests objectAtIndex:indexPath.row];
        [self.delegate friendsViewController:self acceptFriendRequest:friendRequest success:^{
                [self updateFriends];
        } failure:^(WebServiceResponse response) {
            // Handle error
        }];
    }
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendCell";
    NSString* cellText = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == SECTION_FRIEND) {
        PFUser *friend = [self.friends objectAtIndex:indexPath.row];
        [friend fetchIfNeeded];
        cellText = friend.username;
    } else if(indexPath.section == SECTION_PENDING_FRIEND) {
        PFObject* friendRequest = [self.friendRequests objectAtIndex:indexPath.row];
        PFUser* friend = [friendRequest objectForKey:FRIEND_REQUEST_SENDER];
        [friend fetchIfNeeded];
        cellText = friend.username;
    }  
    [cell.textLabel setText:cellText];
    return cell;
}

//Functionality for deleting a tableView
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(indexPath.section == SECTION_FRIEND){
            //Delete friend
            PFUser* friendToBeDeleted = [self.friends objectAtIndex:indexPath.row];
            [self.delegate friendsViewController:self deleteFriend:friendToBeDeleted  success:^{
                
            }failure:^(WebServiceResponse response){
                //Handle failure
            }];
            
            if([self.friends count] > 0){
                [self.friends removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
            
        } else if(indexPath.section == SECTION_PENDING_FRIEND){
            //Decline Friend Request
           
            PFObject* friendRequest = [self.friendRequests objectAtIndex:indexPath.row];
            [self.delegate friendsViewController:self declineFriendRequest:friendRequest success:^{
                [self.friendRequests removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            } failure:^(WebServiceResponse response){
                //Handle failure
            }];

        }
    }
}
-(NSString*) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SECTION_FRIEND){
        return @"Delete";
    } else {
        return @"Decline";
    }
}




@end
