//
//  FriendsViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-19.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "FriendsViewController.h"
#import "User.h"
#import "HTTPController.h"
#import "Friend.h"
@interface FriendsViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) id <FriendsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) HTTPController* httpController;  // TODO: Singelton?

@end

@implementation FriendsViewController
@synthesize fetchedResultsController = _fetchedResultsController;




- (void)viewDidLoad
{
    [super viewDidLoad];
    _httpController = [HTTPController sharedInstance];
    [self setUpFetchedResultsController];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void) setUpFetchedResultsController
{
    /*
    //TODO: Implement getters for NSManagedObjectContext* context from App Delegate
     //TODO: Get Friends from Core Data
    AlarmAppDelegate *appDelegate =  (AlarmAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pending == %@", [NSNumber numberWithBool:YES]];
//    request.predicate = predicate;
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Friend"];
    NSSortDescriptor* description = [NSSortDescriptor sortDescriptorWithKey:@"pending" ascending:YES];
    NSError* error;
    [request setSortDescriptors:[NSArray arrayWithObject:description]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController performFetch:&error];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Show AFVC"]) {
        [segue.destinationViewController setDelegate:self.httpController];
    }
}
#pragma mark UITableViewDelegate method
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==1) {
        return [[self.fetchedResultsController fetchedObjects]count];
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
        NSArray* array = [self.fetchedResultsController fetchedObjects];
        Friend* friend = [array objectAtIndex:indexPath.row];
        cellText = friend.email;
    } 
    [cell.textLabel setText:cellText];

    
    return cell;
}



@end
