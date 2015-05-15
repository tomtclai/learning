//
//  BNRAppliance.h
//  Chapter 33 init
//
//  Created by Tsz Chun Lai on 1/24/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRAppliance : NSObject

@property (nonatomic, copy) NSString *productName;
@property (nonatomic) int voltage;

// The designated initializer
- (instancetype) initWithProductName:(NSString *)pn;

@end
