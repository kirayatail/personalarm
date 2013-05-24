//
//  AlarmAppDelegate.m
//  PersonAlarm
//
//  Created by Max Witt on 2013-02-01.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "AlarmAppDelegate.h"
#import <Parse/Parse.h>
#import "NetworkConstants.h"
#import "LocationController.h"


@implementation AlarmAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Register for Parse
    [Parse setApplicationId:@"nJBlt4J0vsGWzNbDmOAaRluQi8bN0SB4M73asOCH" clientKey:@"fsCqbOS73hOBz3ZqdFVCNCRnPguWpqL6RXbdQQ7E"];
    //Register for Push Notifications 
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    
    NSUserDefaults *numbers = [NSUserDefaults standardUserDefaults];
    BOOL userHasActiveSession = [numbers boolForKey:PA_NSUDEFAULTS_ACTIVESESSION];
    if(userHasActiveSession){
        //Start updating the location
        LocationController* controller = [LocationController sharedLocationController];
        [controller startBroadcast];
    }
    return YES;
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    if([PFUser currentUser]){
        //Register the user to push notifications
        NSString* userPrefix = @"User_";
        PFUser* user = [PFUser currentUser];
        [user fetchIfNeeded];
        NSString* objectID = user.objectId;
        NSString* uniqueChannelName = [userPrefix stringByAppendingString:objectID];
        [currentInstallation addUniqueObject:uniqueChannelName forKey:@"channels"];
        [currentInstallation saveInBackground];
    }
}


-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //Receieve and handle push notification when the application is running (and in background?)
    //TODO: Sessions and shit. FAAAAAAK THIIIZ
    UITabBarController* rootVC =(UITabBarController*) self.window.rootViewController;
    NSArray* viewControllers = rootVC.viewControllers;
    UIViewController* friendsVC = [viewControllers objectAtIndex:2];
    friendsVC.tabBarItem.badgeValue = @"1";
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
