//
//  ModelController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ModelController.h"
#import "AlarmViewController.h"
#import "SettingsTableViewController.h"

@interface ModelController ()

@property (strong, nonatomic) NSArray *pageData;

@end

@implementation ModelController

@synthesize pageData = _pageData;

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setUpViewControllers];
    }
    return self;
}

- (void) setUpViewControllers
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    // Add new view controllers here. Order is important. Remember to set the title and identifier in the storyboard. It must match the string set here.
    [viewControllers addObject:@"AlarmViewController"];
    [viewControllers addObject:@"SettingsViewController"];
    
    self.pageData = [viewControllers copy];
}

- (UIViewController *) viewControllerAtIndex:(NSUInteger)index
                                  storyboard:(UIStoryboard *) storyboard
{
   // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count]) ||
        (![[self.pageData objectAtIndex:index] isKindOfClass:[NSString class]]))
        {
            return nil;
        }
    return [storyboard instantiateViewControllerWithIdentifier:[self.pageData objectAtIndex:index]];
}

- (NSUInteger) indexOfViewController:(UIViewController *)viewController
{
    // The title must be set in the storyboard. It must be the same as the identifier.
    return [self.pageData indexOfObject:viewController.title];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
