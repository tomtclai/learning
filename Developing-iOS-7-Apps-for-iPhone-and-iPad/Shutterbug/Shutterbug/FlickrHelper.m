//  FlickrHelper.m
//  TopRegions
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

#import "FlickrHelper.h"
@interface FlickrHelper () <NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSession *downloadSession;
@property (copy, nonatomic) void (^recentPhotosCompletionHandler)(NSArray *photos, void(^whenDone)());
@property (copy, nonatomic) void (^downloadBackgroundURLSessionCompletionHandler)();
@end
@implementation FlickrHelper
#define FLICKR_FETCH @"Flickr Download Session"
#define FLICKR_FETCH_RECENT_PHOTOS @"Flickr Download Task to Download Recent Photos"
+ (FlickrHelper *)sharedFlickrHelper;
{
    static dispatch_once_t pred = 0;
    __strong static FlickrHelper *_sharedFlickrHelper = nil;
    dispatch_once(&pred, ^{
        _sharedFlickrHelper = [[self alloc] init];
    });
    return _sharedFlickrHelper;
}
+ (void)loadTopPlacesOnCompletion:(void (^)(NSArray * photos, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[FlickrHelper URLforTopPlaces]
                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    NSArray *places;
                                                    if (!error) {
                                                        places = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location]
                                                                                                 options:0
                                                                                                   error:&error];
                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        completionHandler(places, error);
                                                    });
                                                }];
    [task resume];
}

+ (void)loadRecentPhotosOnCompletion:(void (^)(NSArray *, NSError *))completionHandler
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[FlickrHelper URLforRecentGeoreferencedPhotos]
                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    NSArray *photos;
                                                    if (!error) {
                                                        photos = [[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location]
                                                                                                 options:0
                                                                                                    error:&error] valueForKeyPath:FLICKR_RESULTS_PHOTOS];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completionHandler(photos, error);
                                                        });
                                                    }
                                                }];
    [task resume];
}

+ (void)loadPhotosInPlace:(NSDictionary *)place maxResults:(NSUInteger)results onCompletion:(void (^)(NSArray *, NSError *))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[FlickrHelper URLforPhotosInPlace:[place valueForKeyPath:FLICKR_PLACE_ID] maxResults:(int)results]
                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    NSArray *photos;
                                                    if (!error) {
                                                        photos = [[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location]
                                                                                                  options:0
                                                                                                    error:&error] valueForKeyPath:FLICKR_RESULTS_PHOTOS];
                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        completionHandler(photos, error);
                                                    });
                                                }];
    [task resume];
}


+ (void)startBackgroundDownloadRecentPhotosOnCompletion:(void (^)(NSArray *, void (^)()))completionHandler
{
    FlickrHelper *fh = [FlickrHelper sharedFlickrHelper];
    [fh.downloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if ([downloadTasks count]) {
            NSURLSessionDownloadTask *task = [fh.downloadSession downloadTaskWithURL: [FlickrFetcher URLforRecentGeoreferencedPhotos]];
            task.taskDescription = FLICKR_FETCH_RECENT_PHOTOS;
            fh.recentPhotosCompletionHandler = completionHandler;
            [task resume];
        } else {
            for (NSURLSessionDownloadTask *task in downloadTasks) [task resume];
        }
    }];
}

+ (void)handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:FLICKR_FETCH]) {
        FlickrHelper *fh = [FlickrHelper sharedFlickrHelper];
        fh.downloadBackgroundURLSessionCompletionHandler = completionHandler;
    }
}

- (NSURLSession *)downloadSession
{
    if (!_downloadSession) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:FLICKR_FETCH]
                                                             delegate:self
                                                        delegateQueue:nil];
        });
    }
    return _downloadSession;
}

+ (NSString *)titleOfPlace:(NSDictionary *)place
{
    return [[[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] firstObject];
}

+ (NSString *)subtitleOfPlace:(NSDictionary *)place
{
    NSArray *nameParts = [[place valueForKeyPath:FLICKR_PLACE_NAME]
                          componentsSeparatedByString:@", "];
    
    NSRange range;
    range.location = 1;
    range.length = [nameParts count] - 2;
    return [[nameParts subarrayWithRange:range] componentsJoinedByString:@", "];
}

+ (NSString *)countryOfPlace:(NSDictionary *) place
{
    return [[[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
}

+ (NSArray *)sortPlaces:(NSArray *)places
{
    return [places sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *name1 = [obj1 valueForKeyPath:FLICKR_PLACE_NAME];
        NSString *name2 = [obj2 valueForKeyPath:FLICKR_PLACE_NAME];
        return [name1 localizedCompare:name2];
    }];
}

+ (NSDictionary *)placesByCountries:(NSArray<NSDictionary*> *)places
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (NSDictionary *place in places) {
        NSString *countryName = [FlickrHelper countryOfPlace:place];
        
        NSMutableArray *placesInACountry = result[countryName];
        
        if (!placesInACountry) {
            placesInACountry = [NSMutableArray array];
        }
        
        [placesInACountry addObject:place];
    }
    return result;
}

+ (NSArray *)countriesFromPlacesByCountrySorted:(NSDictionary *)placesByCountry
{
    NSArray<NSString*> *countries = [placesByCountry allKeys];
    countries = [countries sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    return countries;
}

#define FLICKR_UNKNOWN_PHOTO_TITLE @"Unknown"

+ (NSString *)titleOfPhoto:(NSDictionary *)photo
{
    NSString *title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    if ([title length]) return title;
    
    title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([title length]) return title;
    
    return  FLICKR_UNKNOWN_PHOTO_TITLE;
}

+ (NSString *)subtitleOfPhoto:(NSDictionary *)photo
{
    NSString *title = [FlickrHelper titleOfPhoto:photo];
    if ([title isEqualToString:FLICKR_UNKNOWN_PHOTO_TITLE]) return @"";
    
    NSString *subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([title isEqualToString:subtitle]) return @"";
    
    return subtitle;
}

+ (NSURL *)URLforPhoto:(NSDictionary *)photo
{
    return [FlickrHelper URLforPhoto:photo format:FlickrPhotoFormatLarge];
}

+ (NSString *)IDforPhoto:(NSDictionary *)photo
{
    return [photo valueForKeyPath:FLICKR_PHOTO_ID];
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    if ([downloadTask.taskDescription isEqualToString:FLICKR_FETCH_RECENT_PHOTOS]) {
        NSDictionary *flickrPropertyList;
        NSData *flickrJSONData = [NSData dataWithContentsOfURL:location];
        if (flickrJSONData) {
            flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJSONData
                                                                 options:0
                                                                   error:NULL];
            NSArray *photos = [flickrPropertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            
            self.recentPhotosCompletionHandler(photos, ^{
                [self downloadTasksMightBeComplete];
            });
        }
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (error && (session == self.downloadSession)) {
        NSLog(@"Flickr background downlod session failed: %@", error.localizedDescription);
        [self downloadTasksMightBeComplete];
    }
}

- (void)downloadTasksMightBeComplete
{
    if (self.downloadBackgroundURLSessionCompletionHandler) {
        [self.downloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            if (![downloadTasks count]) {
                void (^completionHandler)() = self.downloadBackgroundURLSessionCompletionHandler;
                self.downloadBackgroundURLSessionCompletionHandler = nil;
                if (completionHandler) {
                    completionHandler();
                }
            }
        }];
    }
}
@end
