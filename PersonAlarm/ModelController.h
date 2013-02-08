//
//  ModelController.h
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelController : NSObject<UIPageViewControllerDataSource>

- (UIViewController *) viewControllerAtIndex:(NSUInteger)index
                                  storyboard:(UIStoryboard *) storyboard;

- (NSUInteger) indexOfViewController:(UIViewController *) viewController;

@end
