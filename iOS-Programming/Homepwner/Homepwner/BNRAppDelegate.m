//
//  BNRAppDelegate.m
//  Empty Project
//
//  Created by Tsz Chun Lai on 2/15/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRAppDelegate.h"
#import "BNRItemStore.h"
#import "BNRItemsViewController.h"
@interface BNRAppDelegate ()

@end

@implementation BNRAppDelegate

- (BOOL)application:(nonnull UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    // if state restoration did not occur set up the view controller hierarchy
    if (!self.window.rootViewController) {
        // Create a BNRItemsViewController
        BNRItemsViewController *itemsViewController =
        [[BNRItemsViewController alloc] init];
        
        
        // Create an instance of a UINavigationController
        // its stack contains only itemsViewController
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
        
        // Give the navigation controller a restoration identifier,
        // ususally is class name
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        // Place navigation controller's view in the window hierarchy
        self.window.rootViewController = navController;
        self.window.backgroundColor = [UIColor whiteColor];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%@",NSStringFromSelector(_cmd));
    BOOL success = [[BNRItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems");
    }
    else {
        NSLog(@"Could not save any of the BNRItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSLog(@"%@",NSStringFromSelector(_cmd));
}

#pragma mark - state restoration
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(nonnull NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(nonnull UIApplication *)application shouldRestoreApplicationState:(nonnull NSCoder *)coder
{
    return YES;
}

- (UIViewController *)application:(nonnull UIApplication *)application viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)identifierComponents coder:(nonnull NSCoder *)coder
{
    // Create a new navigation controller
    UIViewController *vc = [[UINavigationController alloc]init];
    
    // The last object in the path array is the restoration
    // identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    // If there is only 1 identifier component, then
    // this is the root view controller
    if ([identifierComponents count] == 1)
    {
        self.window.rootViewController = vc;
    }
    
    return vc;
}
@end
