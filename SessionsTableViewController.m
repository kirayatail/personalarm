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
@property (nonatomic, strong) ParseController* controller;
@end

@implementation SessionsTableViewController
@synthesize activeSessions = _activeSessions;
@synthesize controller = _controller;

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

 
}
- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self startSessions];
}



-(void) startSessions
{
    [self.delegate sessionsTableViewControllerCreateSessions:self success:^{
    
        
    }failure:^(WebServiceResponse response){
        
    }];
}


-(void) updateSessionTable
{
    [self.delegate sessionsTableViewControllerActiveSessions:self success:^(NSArray* result){
        if([result count] >0 ){
            self.activeSessions = [result mutableCopy];
        } else
     {
         //No one is following. 
     }
        
    }failure:^(WebServiceResponse response){
        //Handle error
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"Friend 1"];
    } else if (indexPath.section == 1) {
        [cell.textLabel setText:@"Pending session"];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0) {
        return @"Following you";
    } else if(section == 1){
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

@end
