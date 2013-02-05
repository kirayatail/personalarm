//
//  ModelController.m
//  PersonAlarm
//
//  Created by Simon Olsson on 2013-02-05.
//  Copyright (c) 2013 Chalmers. All rights reserved.
//

#import "ModelController.h"
#import "AlarmViewController.h"
#import "SettingsViewController.h"

@interface ModelController ()

@property (strong, nonatomic) NSArray *pageData;
@property UIStoryboard *storyboard;

@end

@implementation ModelController

@synthesize pageData = _pageData;
@synthesize storyboard = _storyboard;

- (id) initWithStoryboard:(UIStoryboard *)storyboard
{
    self = [super init];
    if (self)
    {
        self.storyboard = storyboard;
        [self setUpViewControllers];
    }
    return self;
}

- (void) setUpViewControllers
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    AlarmViewController *alarmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlarmViewController"];
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    [viewControllers addObject:alarmViewController];
    [viewControllers addObject:settingsViewController];
    
    self.pageData = [viewControllers copy];

}

- (UIViewController *) viewControllerAtIndex:(NSUInteger)index
                                  storyboard:(UIStoryboard *) storyboard
{
   // Return the data view cobntroller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count]))
        {
            return nil;
        }
    return [self.pageData objectAtIndex:index];
}

- (NSUInteger) indexOfViewController:(UIViewController *)viewController
{
    return [self.pageData indexOfObject:viewController];
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
