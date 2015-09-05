//
//  Photo.h
//  Shutterbug
//
//  Created by Tom Lai on 9/5/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) Photographer *whoTook;

@end
