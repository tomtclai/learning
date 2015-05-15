//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Tsz Chun Lai on 2/7/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRImageStore.h"
@interface BNRItem : NSObject

+ (id)randomItem;

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber;

- (id)initWithItemName:(NSString *)name
          serialNumber:(NSString *)sNumber;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, readonly) NSString* itemKey;
@end
