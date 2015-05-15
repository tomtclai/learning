//
//  BNRStockHolding.h
//  Stocks
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRStockHolding : NSObject
{
    float _purchaseSharePrice;
    float _currentSharePrice;
    int _numberOfShares;
}
@property (nonatomic) NSString* symbol;
- (float)purchaseSharePrice;
- (float)currentSharePrice;
- (int)numberOfShares;
- (void)setPurchaseSharePrice:(float)p;
- (void)setCurrentSharePrice:(float)c;
- (void)setNumberOfShares:(int)n;
- (float)costInDollars;
- (float)valueInDollars;


@end
