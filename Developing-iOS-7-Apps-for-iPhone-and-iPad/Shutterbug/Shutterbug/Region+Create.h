//
//  Region+Create.h
//  Shutterbug
//
//  Created by Tom Lai on 9/8/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "Region.h"
#import "FlickrFetcher.h"
@interface Region (Create)
+ (Region *)regionWithFlickrInfo:(NSDictionary *)regionDictionary
          inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Region *)regionWithFlickrPlaceID:(NSString*)flickrPlaceID
                               name:(NSString*)name
             inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Region*)addPhotographerWithName:(NSString*)photographerName
                  toRegionWithPlaceID:(NSString*)flickrPlaceID
    inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadRegionFromFlickrArray:(NSArray *)regions
         intoManagedObjectContext:(NSManagedObjectContext *)context;
@end
