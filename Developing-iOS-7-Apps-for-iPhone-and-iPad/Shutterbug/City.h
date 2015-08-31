//
//  City.h
//  
//
//  Created by Tom Lai on 8/31/15.
//
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* flickrPlaceId;
@property (nonatomic, strong) NSString* countryName;
@property (nonatomic, strong) NSString* restOfAddress;
- (NSString*) description;
@end
