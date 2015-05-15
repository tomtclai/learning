//
//  BNRForeignStockHolding.m
//  Stocks
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRForeignStockHolding.h"

@implementation BNRForeignStockHolding

- (float)valueInDollars
{
    return [super valueInDollars] * _conversionRate;
}

@end
