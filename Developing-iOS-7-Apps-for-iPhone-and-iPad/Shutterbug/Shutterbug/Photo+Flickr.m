//
//  Photo+Flickr.m
//  Shutterbug
//
//  Created by Tom Lai on 9/8/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"
#import "Region+Create.h"
@implementation Photo (Flickr)
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique =%@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        //handle error
    } else if (![matches count]) {
        // no match
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        
        photo.unique = unique;
        photo.title = photoDictionary[FLICKR_PHOTO_TITLE];
        photo.subtitle = photoDictionary[FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString
                          ];
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        
        photo.whoTook = [Photographer photographerWithName:photographerName
                                    inManagedObjectContext:context];
        
        
        //how to go from place id to dictionary?
        NSString* placeID = photoDictionary[FLICKR_PHOTO_PLACE_ID];
        NSURL* urlForPlace = [FlickrFetcher URLforInformationAboutPlace:placeID];
        dispatch_queue_t fetchQ = dispatch_queue_create("Flickr wqewqe fetcher", NULL);
        dispatch_async(fetchQ, ^{
            NSData *flickrJSONData = [NSData dataWithContentsOfURL:urlForPlace];
            NSDictionary *flickrJSONDictionary = [NSJSONSerialization JSONObjectWithData:flickrJSONData
                                                                                 options:0
                                                                                   error:NULL];
            dispatch_async(dispatch_get_main_queue(), ^{
            NSString* nameOfRegion = [FlickrFetcher extractRegionNameFromPlaceInformation:flickrJSONDictionary];
                Region *region = [Region regionWithFlickrPlaceID:placeID
                                                        name:nameOfRegion
                                      inManagedObjectContext:context];

                [region addHasPhotosTakenByObject:photo.whoTook];
                region.photographerCount = @(region.photographerCount.intValue + 1);
                photo.whoTook.numberOfPhotos = @(photo.whoTook.numberOfPhotos.intValue + 1);
            });

        });
    } else {
        photo =  [matches firstObject];
//        Region * region = [Region regionWithFlickrInfo: inManagedObjectContext:context];
    }
    return photo;
}
+ (void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *photo in photos) {
        [self photoWithFlickrInfo:photo inManagedObjectContext:context];// there is a better way to do this
    }
}

@end
