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

@interface SettingsTableViewController : UITableViewController<MessageSettingsViewControllerDelegate,
    CallSettingsViewControllerDelegate, UITableViewDataSource>

@end
