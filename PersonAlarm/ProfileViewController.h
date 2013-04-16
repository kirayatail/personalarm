//
//  ProfileViewController.h
//  PersonAlarm
//
//  Created by William Gabrielsson on 2013-04-15.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileViewController;
@protocol ProfileViewControllerDelegate
-(void) profileViewController:(ProfileViewController*)pvc
                  donePressed:(BOOL) didPressDone
                     userName:(NSString*)name
                     password:(NSString*)password
                        email:(NSString*)email;
@end


@interface ProfileViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,retain)  id<ProfileViewControllerDelegate> delegate;

-(void) showAlertWithMessage:(NSString*) message;
@end
