//
//  PlacesStore.h
//  Shutterbug
//
//  Created by Tom Lai on 8/31/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlacesStore : NSObject
@property NSArray* allCities;
+ (instancetype)sharedStore;
- (void)removeValue:(nonnull NSString *)value
             forKey:(nonnull NSString *)key
         fromEntity:(nonnull NSString *)entity;
- (void)addValue:(nonnull NSString *)value
          forKey:(nonnull NSString *)key
        toEntity:(nonnull NSString *)entity;
@end
