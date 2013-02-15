//
//  ProfileViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-13.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileViewController;

@protocol ProfileViewControllerDelegate <NSObject>

- (void) profileViewController:(ProfileViewController *) profileViewController didPressDone:(BOOL) pressed;

- (void) profileViewController:(ProfileViewController *) profileViewController didPressCancel:(BOOL) pressed;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, assign) id <ProfileViewControllerDelegate> delegate;

@end
