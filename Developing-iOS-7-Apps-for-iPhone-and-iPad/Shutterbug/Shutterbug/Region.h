//
//  Region.h
//  Shutterbug
//
//  Created by Tom Lai on 9/9/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * photographerCount;
@property (nonatomic, retain) NSString * flickrPlaceID;
@property (nonatomic, retain) NSSet *hasPhotosTakenBy;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addHasPhotosTakenByObject:(Photographer *)value;
- (void)removeHasPhotosTakenByObject:(Photographer *)value;
- (void)addHasPhotosTakenBy:(NSSet *)values;
- (void)removeHasPhotosTakenBy:(NSSet *)values;

@end
