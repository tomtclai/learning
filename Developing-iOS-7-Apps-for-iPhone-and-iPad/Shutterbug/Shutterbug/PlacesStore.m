//
//  PlacesStore.m
//  Shutterbug
//
//  Created by Tom Lai on 8/31/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "PlacesStore.h"

@interface PlacesStore ()
@property (nonatomic) NSMutableArray *privateCities;

@end
@implementation PlacesStore
- (NSArray *)allCities
{
    return [self.privateCities copy]
}
@end
