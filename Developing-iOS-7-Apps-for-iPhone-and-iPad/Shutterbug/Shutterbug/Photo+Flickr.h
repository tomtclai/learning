//
//  Photo+Flickr.h
//  Shutterbug
//
//  Created by Tom Lai on 9/8/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *)context;
@end
