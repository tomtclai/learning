//
//  City.h
//  
//
//  Created by Tom Lai on 8/31/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * restOfAddress;
@property (nonatomic, retain) NSString * flickrPlaceId;
@property (nonatomic, retain) Country *country;

@end
