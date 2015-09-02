///Users/tomlai/tomtom/public/Developing-iOS-7-Apps-for-iPhone-and-iPad/Shutterbug/Shutterbug/City.h
//  City.h
//  
//
//  Created by Tom Lai on 8/31/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country;

@interface City : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *restOfAddress;
@property (nonatomic, retain) NSString *flickrPlaceId;
@property (nonatomic, retain) NSString *country;

@end
