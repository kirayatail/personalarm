//
//  SettingsViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageSettingsViewController.h"
#import "CallSettingsViewController.h"
#import "ProfileViewController.h"

@interface SettingsTableViewController : UITableViewController<MessageSettingsViewControllerDelegate,
    CallSettingsViewControllerDelegate, UITableViewDataSource, ProfileViewControllerDelegate>

@end
