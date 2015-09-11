//
//  AppDelegate.m
//  Photomania
//
//  Created by Tom Lai on 9/3/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+MOC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "PhotoDatabaseAvailability.h"
@interface AppDelegate () <NSURLSessionDownloadDelegate>

@property (copy, nonatomic) void (^flickerDownloadBackgroundURLSessionCompletionHandler)();
@property (strong, nonatomic) NSURLSession *flickrDownloadSession;
@property (strong, nonatomic) NSTimer *flickrForeGroundFetchTimer;
@property (strong, nonatomic) NSManagedObjectContext *photoDatabaseContext;

@end

// name of the Flickr fetching background download session
#define FLICKR_FETCH @"Flickr Just Uploaded Fetch"

// how often (in seconds) we fetch new photos if we are in the foreground
#define FOREGROUND_FLICKR_FETCH_INTERVAL (20*60)

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.photoDatabaseContext = [self createMainQueueManagedObjectContext]; // in HW, set from UI manage document
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:(NSTimeInterval)FOREGROUND_FLICKR_FETCH_INTERVAL];
    [self startFlickrFetch];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //background fetch
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    // empty implementation to enable the delegate methods
    // need to wait until fetch completes
    self.flickerDownloadBackgroundURLSessionCompletionHandler = completionHandler;
}
- (void)setPhotoDatabaseContext:(NSManagedObjectContext *)photoDatabaseContext
{
    _photoDatabaseContext = photoDatabaseContext;
    //timer
    [NSTimer scheduledTimerWithTimeInterval:20*60
                                     target:self
                                   selector:@selector(startFlickrFetch:) userInfo:nil
                                    repeats:YES];
    NSDictionary *userInfo = self.photoDatabaseContext? @{ PhotoDatabaseAvailabilityContext : self.photoDatabaseContext} :nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)startFlickrFetch: (NSTimer *)timer
{
    [self startFlickrFetch];
}
- (void)startFlickrFetch
{
    [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (![downloadTasks count]) {
            NSURLSessionDownloadTask *task = [self.flickrDownloadSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
            task.taskDescription = FLICKR_FETCH;
            [task resume];
        } else {
            for (NSURLSessionDownloadTask * task in downloadTasks) [task resume];
        }
    }];
}

- (NSURLSession *)flickrDownloadSession
{
    if (!_flickrDownloadSession) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:FLICKR_FETCH];
            urlSessionConfig.allowsCellularAccess = NO;// for example
            _flickrDownloadSession = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                                   delegate:self
                                                              delegateQueue:nil];
        });
    }
    return _flickrDownloadSession;
}

- (NSArray *)flickrPhotosAtURL:(NSURL *)url
{
    NSData *flickrJSONData = [NSData dataWithContentsOfURL:url];
    NSDictionary *flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJSONData
                                                                       options:0
                                                                         error:NULL];
    return [flickrPropertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

#pragma mark - NSURLSessionDownloadDelegate
// required by the protocol
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if ([downloadTask.taskDescription isEqualToString:FLICKR_FETCH]) {
        NSManagedObjectContext *context = self.photoDatabaseContext;
        if (context) {
            NSArray *photos = [self flickrPhotosAtURL:location];
            [context performBlock:^{
                [Photo loadPhotosFromFlickrArray:photos intoManagedObjectContext:context];
                [context save:NULL];// no necessary if using document
            }];
        } else {
            [self flickrDownloadTasksMightBeComplete];
        }
    }
}

// required by the protocol
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void)flickrDownloadTasksMightBeComplete
{
    if (self.flickerDownloadBackgroundURLSessionCompletionHandler) {
        [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray  *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            if (![downloadTasks count]) {
                void (^completionHandler)() = self.flickerDownloadBackgroundURLSessionCompletionHandler;
                self.flickerDownloadBackgroundURLSessionCompletionHandler  = nil;
                if (completionHandler) {
                    completionHandler();
                }
            }
        }];
    }
}
@end
