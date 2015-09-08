//
//  AppDelegate.m
//  Shutterbug
//
//  Created by Tom Lai on 8/28/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "AppDelegate.h"
#import "ShutterbugDatabaseAvailability.h"
NSString * const historyKey = @"ShutterbugHistoryKey";
// https://stackoverflow.com/questions/26974975/where-to-use-and-initialize-uimanageddocument
// If you want to hear from Paul, he talks about it in Lecture 12 (Fall 2013-14) at 14 minutes and 25 seconds (UIManagedContext) and at 14:50 he starts talking about the two ways to get the UIManagedContext -- being UIManagedDocument or the "Use Core Data" checkbox.
//Create a UImanagedDocument and ask for its managedObjectContext
@interface AppDelegate ()

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@end

@implementation AppDelegate

- (void)createUIManagedDocument
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"Shutterbug";
    // this creates the UIManagedDocument instance, but does not open nor create the underlying file
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];

    // Open / create the underlying file
    self.document = document;
    if ([[NSFileManager defaultManager]fileExistsAtPath:[url path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) [self documentIsReady];
        }];
    } else {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) [self documentIsReady];
          }];
    }
}

- (void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.managedObjectContext = self.document.managedObjectContext;
        
        NSDictionary *userInfo = self.managedObjectContext? @{ShutterbugDataBaseAvailabilityContext : self.managedObjectContext} : nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:ShutterbugDataBaseAvailabilityNotification
                                                            object:self
                                                          userInfo:userInfo];
        
    }
}

//- (void)contextChanged:(NSNotification *)notification
//{
//    // notifications.userInfo is a dict with these keys
//    // NSinsertedObjectsKey
//    // NSUpdatedObjectsKey
//    // NSDeletedObjectsKey
//}
+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [NSArray array];
    NSDictionary *factorySettings = @{historyKey : array};
    [defaults registerDefaults:factorySettings];
}

- (NSManagedObjectContext *)createManagedObjectContext
{
    if (!self.document)
        [self createUIManagedDocument];
    return self.document.managedObjectContext;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.managedObjectContext = [self createManagedObjectContext];
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

@end
