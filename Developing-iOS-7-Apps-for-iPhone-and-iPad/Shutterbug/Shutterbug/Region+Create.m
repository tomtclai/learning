//
//  Region+Create.m
//  Shutterbug
//
//  Created by Tom Lai on 9/8/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "Region+Create.h"

@implementation Region (Create)
+ (Region *)regionWithFlickrInfo:(NSDictionary *)regionDictionary
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *region = nil;
    if (regionDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
        request.predicate = [NSPredicate predicateWithFormat:@"flickrPlaceID = %@", regionDictionary[FLICKR_PLACE_ID]];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1 )) {
            // handle error
        } else if (![matches count]) {
            // no match
            region = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer"
                                                   inManagedObjectContext:context];
            
            region.flickrPlaceID = regionDictionary[FLICKR_PLACE_ID];
            region.name = regionDictionary[FLICKR_PLACE_NAME];
        } else {
            region = [matches lastObject];
        }
    }
    return region;
}

+ (void)loadRegionFromFlickrArray:(NSArray *)regions
         intoManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *regionDict in regions) {
        [self regionWithFlickrInfo:regionDict inManagedObjectContext:context];
    }
}
@end
