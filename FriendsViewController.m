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
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"switch-background.png"]];
    self.tableView.backgroundView = nil;
    
}
- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self refreshTableView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];

    [self refreshTableView];
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
    //Remove badges
    self.parentViewController.tabBarItem.badgeValue = nil;
}

-(void) refreshTableView
{
    dispatch_queue_t queue = dispatch_queue_create("FetchFriendsQueue", NULL);
    dispatch_async(queue, ^(void){
        [self updatePendingFriends];
        [self updateFriends];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
        
    });
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
//            //Update tableView
            dispatch_async(dispatch_get_main_queue(), ^{
                [fvc.tableView reloadData];
            });
//            [fvc.tableView reloadData];
        } else {
            //There is no pending Friends on remote server
            //Delete the local list of Friend requests
            if([fvc.friendRequests count] > 0){
                [fvc.friendRequests removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [fvc.tableView reloadData];
                });
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [fvc.tableView reloadData];
            });

        } else{
            if([fvc.friends count] >0){
                [fvc.friends removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [fvc.tableView reloadData];
                });} else{
                    //DO nasing
                }

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
    if(section ==SECTION_FRIEND) {
        return [self.friends count];
    } else if (section == SECTION_PENDING_FRIEND) {
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
        __block FriendsViewController* fvc = self;
        [self.delegate friendsViewController:self acceptFriendRequest:friendRequest success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                    [fvc refreshTableView];
            });
            
            
   
        } failure:^(WebServiceResponse response) {
            //TODO: Handle error
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
        [friendRequest fetchIfNeeded];
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
        tempLabel.text=@"Friends";
    } else {
        tempLabel.text=@"Pending friends";
    }
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}


@end
