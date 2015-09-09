//
//  AppDelegate.m
//  Shutterbug
//
//  Created by Tom Lai on 8/28/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "AppDelegate.h"
#import "ShutterbugDatabaseAvailability.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "Region+Create.h"
NSString * const historyKey = @"ShutterbugHistoryKey";
// https://stackoverflow.com/questions/26974975/where-to-use-and-initialize-uimanageddocument
// If you want to hear from Paul, he talks about it in Lecture 12 (Fall 2013-14) at 14 minutes and 25 seconds (UIManagedContext) and at 14:50 he starts talking about the two ways to get the UIManagedContext -- being UIManagedDocument or the "Use Core Data" checkbox.
//Create a UImanagedDocument and ask for its managedObjectContext
@interface AppDelegate () <NSURLSessionDownloadDelegate>
@property (copy, nonatomic) void (^flickerDownloadBackgroundURLSessionCompletionHandler)();
@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSURLSession *flickrDownloadSession;
@property (strong, nonatomic) NSTimer *flickrForeFroundFetchTimer;

@end


// name of the Flickr fetching background download session
#define FLICKR_FETCH @"Flickr Just Uploaded Fetch"

// how often (in seconds) we fetch new photos if we are in the foreground
#define FOREGROUND_FLICKR_FETCH_INTERVAL (20*60)

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
            for (NSURLSessionDownloadTask * task in downloadTasks){
                [task resume];
            }
        }
    }];
}

- (NSArray *)flickrPhotosAtURL:(NSURL *)url
{
    NSData *flickrJSONData = [NSData dataWithContentsOfURL:url];
    NSDictionary *flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJSONData
                                                                       options:0
                                                                         error:NULL];
    return [flickrPropertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}


- (NSArray *)flickrPlacesAtURL:(NSURL *)url
{
    NSData *flickrJSONData = [NSData dataWithContentsOfURL:url];
    NSDictionary *flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJSONData
                                                                       options:0
                                                                         error:NULL];
    return [flickrPropertyList valueForKeyPath:FLICKR_RESULTS_PLACES];
}
#pragma mark getters & setters
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

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    [NSTimer scheduledTimerWithTimeInterval:20*60
                                     target:self
                                   selector:@selector(startFlickrFetch:) userInfo:nil
                                    repeats:YES];
    
    NSDictionary *userInfo = self.managedObjectContext? @{ShutterbugDataBaseAvailabilityContext : self.managedObjectContext} : nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ShutterbugDataBaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - NSURLSessionDownloadDelegate
// required by the protocol
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if ([downloadTask.taskDescription isEqualToString:FLICKR_FETCH]) {
        NSManagedObjectContext *context = [self createManagedObjectContext];
        if (context) {
            NSArray *photos = [self flickrPhotosAtURL:location];
            [context performBlock:^{
                [Photo loadPhotosFromFlickrArray:photos intoManagedObjectContext:context];
            }];
            
            NSArray *places = [self flickrPlacesAtURL:location];
            [context performBlock:^{
                [Region loadRegionFromFlickrArray:places intoManagedObjectContext:context];
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
        [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
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
