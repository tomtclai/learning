//
//  BNRForeignStockHolding.h
//  Stocks
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//
#import "BNRStockHolding.h"
#import <Foundation/Foundation.h>

@interface BNRForeignStockHolding : BNRStockHolding

@property (nonatomic) float conversionRate;

@end
