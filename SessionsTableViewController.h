//
//  SessionsTableViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-05-16.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionMapViewController.h"
#import "NetworkConstants.h"
@class SessionsTableViewController;
typedef void (^SessionsSuccess)(NSArray* users);
typedef void (^CreateSessionsSuccess)(void);
typedef void (^ActiveSessionsFailure)(WebServiceResponse response);
@protocol SessionsTableViewControllerDelegate <NSObject>

-(void) sessionsTableViewControllerActiveSessions:(SessionsTableViewController*) sessionsTVC success:(SessionsSuccess) result failure:(ActiveSessionsFailure) response;

-(void) sessionsTableViewControllerCreateSessions:(SessionsTableViewController*) sessionsTVC success:(CreateSessionsSuccess) result failure:(ActiveSessionsFailure) response;

-(void) sessionsTableViewControllerPendingSessions:(SessionsTableViewController*) sessionsTVC success:(SessionsSuccess) result failure:(ActiveSessionsFailure) response;



@end

@interface SessionsTableViewController : UITableViewController
@property (nonatomic, retain) id<SessionsTableViewControllerDelegate> delegate;


@end
