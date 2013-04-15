//
//  FriendsViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-19.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "FriendsViewController.h"
#import "User.h"
#import "ModelController.h"
@interface FriendsViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) id <FriendsViewControllerDelegate> delegate;
@property(nonatomic, strong) ModelController* modelController;
@end

@implementation FriendsViewController
 



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modelController = [[ModelController alloc]init];
    self.delegate = self.modelController;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addFriendPressed:(UIBarButtonItem *)sender {
    
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    User* user =  [self.delegate friendsViewController:self getUserwithIdentification:self.searchBar.text];
    NSLog(@"%@", user.name);
    
    
}
#pragma mark UITableViewDelegate methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    static NSString *CellIdentifier = @"friendCell";
    NSString* cellText = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //Only for demo purposes
    if(indexPath.section == 0) {
        cellText = @"Friend 1";
    } else if(indexPath.section == 1) {
        cellText = @"Friend 2";
    }
    [cell.textLabel setText:cellText];

    
    return cell;
}



@end
