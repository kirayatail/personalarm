//
//  MessageSettingsViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-08.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageSettingsViewController;

@protocol MessageSettingsViewControllerDelegate <NSObject>

- (void) messageSettingsViewController:(MessageSettingsViewController *) messageSettingsViewController didPressDone:(BOOL) pressed;

- (void) messageSettingsViewController:(MessageSettingsViewController *) messageSettingsViewController didPressCancel:(BOOL) pressed;

@end

@interface MessageSettingsViewController : UIViewController

@property (nonatomic, assign) id <MessageSettingsViewControllerDelegate> delegate;

@end
