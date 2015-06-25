//
//  AppDelegate.m
//  Empty Project
//
//  Created by Tsz Chun Lai on 2/15/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BNRHypnosisViewController.h"
#import "BNRReminderViewController.h"
@interface AppDelegate ()
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    return  YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // If state restoration did not occur set up the view controller hierarchy
    if (!self.window.rootViewController)
    {
        BNRHypnosisViewController *hvc = nil;
        BNRReminderViewController *rvc = nil;
        UITabBarController *tabBarController = nil;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Override point for customization after application launch.
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        NSBundle *appBundle = [NSBundle mainBundle];
        
        
        hvc = [[BNRHypnosisViewController alloc] initWithNibName:@"BNRReminderViewController" bundle:appBundle];
        
        
        rvc = [[BNRReminderViewController alloc] init];
        
        tabBarController = [[UITabBarController alloc] init];
        [tabBarController addChildViewController:hvc];
        [tabBarController addChildViewController:rvc];
        // state restoration support
        tabBarController.restorationIdentifier = NSStringFromClass([tabBarController class]);
        tabBarController.restorationClass = [tabBarController class];
        self.window.rootViewController = tabBarController;
        self.window.backgroundColor = [UIColor whiteColor];
        
    }
    [self.window makeKeyAndVisible];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeBadge categories:nil]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - state restoration
- (BOOL)application:(nonnull UIApplication *)application shouldSaveApplicationState:(nonnull NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(nonnull UIApplication *)application shouldRestoreApplicationState:(nonnull NSCoder *)coder
{
    return YES;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)identifierComponents coder:(nonnull NSCoder *)coder
{
    // Create a new tab bar controller
    UIViewController *vc = [[UITabBarController alloc]init];
    
    // The last object in the path array is the restoration
    // identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    // If there is only 1 identifier component, then
    // this is the root view controller
    if ([identifierComponents count] == 1)
    {
        [[UIApplication sharedApplication].delegate window].rootViewController = vc;
    }
    return vc;
}
- (UIViewController *)application:(nonnull UIApplication *)application
viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)
identifierComponents coder:(nonnull NSCoder *)coder
{
    // Create a new tab bar controller
    UIViewController *vc = [[UITabBarController alloc]init];
    
    // The last object in the path array is the restoration
    // identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    // If there is only 1 identifier component, then
    // this is the root view controller
    if ([identifierComponents count] == 1)
    {
        [[UIApplication sharedApplication].delegate window].rootViewController = vc;
    }
    return vc;
}
@end
