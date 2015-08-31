//
//  City.m
//  
//
//  Created by Tom Lai on 8/31/15.
//
//

#import "City.h"

@implementation City
- (NSString*) description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@", self.name, self.restOfAddress, self.countryName, self.flickrPlaceId];
}
@end
