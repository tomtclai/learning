//
//  Region+Create.m
//  Shutterbug
//
//  Created by Tom Lai on 9/8/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "Region+Create.h"
#import "AppDelegate.h"
@implementation Region (Create)
+ (Region *)regionWithFlickrInfo:(NSDictionary *)regionDictionary
    inManagedObjectContext:(NSManagedObjectContext *)context
{

    NSString * flickrPlaceID = regionDictionary[FLICKR_PLACE_ID];
    NSString * name = regionDictionary[FLICKR_PLACE_NAME];
    
    return [Region regionWithFlickrPlaceID:flickrPlaceID
                                      name:name
                    inManagedObjectContext:context];
}

+ (void)loadRegionFromFlickrArray:(NSArray *)flickrDictionaries
         intoManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *regionDict in flickrDictionaries) {
        [self regionWithFlickrInfo:regionDict inManagedObjectContext:context];
    }
}

+ (Region *)regionWithFlickrPlaceID:(NSString*)flickrPlaceID
                               name:(NSString*)name
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *region = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"flickrPlaceID =%@", flickrPlaceID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1 )) {
        // handle error
    } else if (![matches count]) {
        // no match
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region"
                                               inManagedObjectContext:context];
        
        region.flickrPlaceID = flickrPlaceID;
        region.name = name;
    } else {
        region = [matches lastObject];
    }
    

    
    return region;
}
+ (Region*)addPhotographerWithName:(NSString*)photographerName
                  toRegionWithPlaceID:(NSString*)flickrPlaceID
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Region *region = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"flickrPlaceID =%@", flickrPlaceID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if (!matches || error || ([matches count] > 1 )) {
        return region;
    }
    
    region = [matches lastObject];
    
    if (!region.hasPhotosTakenBy) // if set is empty
    {
        region.hasPhotosTakenBy = [NSSet setWithObject:photographerName];//set of strings
        region.photographerCount = @(1);
    }
    else if (![region.hasPhotosTakenBy containsObject:photographerName])
    {
        NSMutableSet *tempSet = [NSMutableSet setWithSet:region.hasPhotosTakenBy];
        [tempSet addObject:photographerName];
        region.hasPhotosTakenBy = tempSet;
        region.photographerCount = @(region.photographerCount.intValue + 1);
    }
    return region;
}
@end
