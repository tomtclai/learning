//
//  AppDelegate.m
//  Hypnosister
//
//  Created by Tsz Chun Lai on 2/15/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRHypnosisView.h"
@interface AppDelegate () <UIScrollViewDelegate>
@property (strong, nonatomic) BNRHypnosisView *hypnosisView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
//    BNRHypnosisView *firstView = [[BNRHypnosisView alloc] initWithFrame:firstFrame];
//
//    [self.window addSubview:firstView];
    
    // Create a CGRects for frames
    CGRect initRect = self.window.bounds;
    
    //Create a screen sized scroll view and add it to the window
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:initRect];
    
    scrollView.delegate = self;
    [self.window addSubview:scrollView];
    initRect.size.height*=2;
    initRect.size.width*=2;
    self.hypnosisView = [[BNRHypnosisView alloc] initWithFrame:initRect];
    [scrollView addSubview: self.hypnosisView];
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 2.0;
//    //add a second screensized hyponosis view just off screen to the right
//    screenRect.origin.x += screenRect.size.width;
//    BNRHypnosisView *anotherView = [[BNRHypnosisView alloc] initWithFrame:screenRect];
//    [scrollView addSubview:anotherView];
    
    //Tell the scroll view how big its content area is
    
    ViewController* qvc = [[ViewController alloc] init];
    scrollView.contentSize = initRect.size;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[self window]setRootViewController:qvc];
    qvc.view = scrollView;

    return YES;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"viewForZoomingInScrollView called");
    return self.hypnosisView;
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView
                        withView:(UIView *)view
                         atScale:(CGFloat)scale
{
    NSLog(@"scrollViewDidEndZooming called");
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

@end
