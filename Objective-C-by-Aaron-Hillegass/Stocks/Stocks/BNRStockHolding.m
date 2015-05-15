//
//  BNRStockHolding.m
//  Stocks
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRStockHolding.h"

@implementation BNRStockHolding
- (float)purchaseSharePrice
{
    return _purchaseSharePrice;
}
- (float)currentSharePrice
{
    return _currentSharePrice;
}
- (int)numberOfShares;
{
    return _numberOfShares;
}
- (void)setPurchaseSharePrice:(float)p
{
    _purchaseSharePrice = p;
}
- (void)setCurrentSharePrice:(float)c
{
    _currentSharePrice = c;
}
- (void)setNumberOfShares:(int)n
{
    _numberOfShares = n;
}
- (float)costInDollars;
{
    return [self purchaseSharePrice] * [self numberOfShares];
}
- (float)valueInDollars
{
    return [self currentSharePrice] * [self numberOfShares];
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, %f",
            self.symbol,self.valueInDollars];
}
@end
