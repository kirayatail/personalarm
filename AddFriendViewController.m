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
@property (nonatomic, retain) NSString* friendID;


@end

@implementation AddFriendViewController
@synthesize searchField = _searchField;
@synthesize  delegate = _delegate;
@synthesize friendID = _friendID;


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
    __block AddFriendViewController* blockSelf = self;
    self.resultButton.hidden = NO;
    [self.delegate addFriendViewController:self getUser:@"INSERT_USERNAME" success:^(User* user){
        blockSelf.friendID = user.serverID;
    }failure:^(WebServiceResponse response){
        //TODO: HANDLE ERROR
    }];
  
}
- (IBAction)addFriend:(id)sender {
    [self.delegate addFriendViewController:self sendFriendRequestToUser:self.friendID success:^{
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
