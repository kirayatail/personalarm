//
//  AddFriendViewController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-03-22.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "AddFriendViewController.h"
#import "HTTPController.h"

@interface AddFriendViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchField;
@property (weak, nonatomic) IBOutlet UIButton *resultButton;
@property (nonatomic, strong) PFUser* theFriend;


@end

@implementation AddFriendViewController
@synthesize searchField = _searchField;
@synthesize  delegate = _delegate;
@synthesize theFriend  = _theFriend;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchField.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.resultButton.hidden = YES;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    
    
    
    self.resultButton.hidden = NO;
    __block AddFriendViewController* afvc = self;
    [self.delegate addFriendViewController:self getUser:searchBar.text success:^(NSArray* users){
        PFUser* user = [users objectAtIndex:0];
        NSLog(@"Length: %d", [users count]);
        afvc.theFriend = user;
        dispatch_async(dispatch_get_main_queue(), ^{
            [afvc updateButton];
        });
               
        
    }failure:^(WebServiceResponse response){
        //TODO: HANDLE ERROR
    }];
  
}
 -(void) updateButton
        {
            [self.resultButton setTitle:self.theFriend.username forState:UIControlStateNormal];
        }
    
- (IBAction)addFriend:(id)sender {
    [self.delegate addFriendViewController:self sendFriendRequestToUser:self.theFriend success:^{
            //TODO: HANDLE SUCCESS
    }
    failure:^(WebServiceResponse response){
            //TODO: HANDLE ERROR
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
