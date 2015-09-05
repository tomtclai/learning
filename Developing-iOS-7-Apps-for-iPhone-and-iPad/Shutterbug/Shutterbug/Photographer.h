//
//  Photographer.h
//  Shutterbug
//
//  Created by Tom Lai on 9/5/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Region;

@interface Photographer : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *hasTakenPhotosIn;
@end

@interface Photographer (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addHasTakenPhotosInObject:(Region *)value;
- (void)removeHasTakenPhotosInObject:(Region *)value;
- (void)addHasTakenPhotosIn:(NSSet *)values;
- (void)removeHasTakenPhotosIn:(NSSet *)values;

@end
