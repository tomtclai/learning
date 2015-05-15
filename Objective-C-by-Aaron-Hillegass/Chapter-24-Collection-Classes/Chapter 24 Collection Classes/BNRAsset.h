//
//  BNRAsset.h
//  Chapter 20 Inheritance
//
//  Created by Tsz Chun Lai on 1/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNREmployee;
@interface BNRAsset : NSObject
@property (nonatomic, copy) NSString *label;
@property (nonatomic) unsigned int resaleValue;
@property (nonatomic, weak) BNREmployee *holder;
@end
