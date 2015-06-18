//
//  BNRItem.h
//  Homepwner
//
//  Created by Tom Lai on 6/17/15.
//  Copyright © 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSManagedObject

@property (nullable, nonatomic, retain) NSString *itemName;
@property (nullable, nonatomic, retain) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSString *itemKey;
@property (nullable, nonatomic, retain) UIImage *thumbnail;
@property (nullable, nonatomic, retain) NSData *thumbnailData;
@property (nullable, nonatomic, retain) NSManagedObject *assetType;
@property (nonatomic) double orderingValue;
// Insert code here to declare functionality of your managed object subclass
- (void)setThumbnailFromImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END

#import "BNRItem+CoreDataProperties.h"
