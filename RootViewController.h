//
//  RootViewController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
