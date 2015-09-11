//
//  AppDelegate.m
//  TopRegions
//
//  Created by Martin Mandl on 05.12.13.
//  Copyright (c) 2014 m2m server software gmbh. All rights reserved.
//

#import "AppDelegate.h"
#import "FlickrHelper.h"
//#import "DocumentHelper.h"
#import "Photo+Flickr.h"
//#import "PhotoDatabaseAvailability.h"
NSString * const historyKey = @"ShutterbugHistoryKey";

@implementation AppDelegate

#define FOREGROUND_FLICKR_FETCH_INTERVAL (15 * 60)

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    //    [DocumentHelper useDocumentWithOperation:^(UIManagedDocument *document, BOOL success) {
    //        if (success) {
    //            NSDictionary *userInfo = document.managedObjectContext ? @{ PhotoDatabaseAvailabilityContext : document.managedObjectContext } : nil;
    //            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoDatabaseAvailabilityNotification
    //                                                                object:self
    //                                                              userInfo:userInfo];
    //        }
    //    }];
    
    [self startFlickrFetch];
    [NSTimer scheduledTimerWithTimeInterval:FOREGROUND_FLICKR_FETCH_INTERVAL
                                     target:self
                                   selector:@selector(startFlickrFetch:)
                                   userInfo:nil
                                    repeats:YES];
    return YES;
}

- (void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [FlickrHelper loadRecentPhotosOnCompletion:^(NSArray *photos, NSError *error) {
        if (error) {
            NSLog(@"Flickr background fetch failed: %@", error.localizedDescription);
            completionHandler(UIBackgroundFetchResultFailed);
        } else {
            //            [self useDocumentWithFlickrPhotos:photos];
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }];
}

- (void)application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    [FlickrHelper handleEventsForBackgroundURLSession:identifier
                                    completionHandler:completionHandler];
}

//- (void)useDocumentWithFlickrPhotos:(NSArray *)photos
//{
//    [DocumentHelper useDocumentWithOperation:^(UIManagedDocument *document, BOOL success) {
//        if (success) {
//            [Photo loadPhotosFromFlickrArray:photos
//                    intoManagedObjectContext:document.managedObjectContext];
//            [document saveToURL:document.fileURL
//               forSaveOperation:UIDocumentSaveForOverwriting
//              completionHandler:nil];
//        }
//    }];
//}

- (void)startFlickrFetch
{
    [FlickrHelper startBackgroundDownloadRecentPhotosOnCompletion:^(NSArray *photos, void (^whenDone)()) {
        //        [self useDocumentWithFlickrPhotos:photos];
        if (whenDone) whenDone();
    }];
}

- (void)startFlickrFetch:(NSTimer *)timer
{
    [self startFlickrFetch];
}

@end
