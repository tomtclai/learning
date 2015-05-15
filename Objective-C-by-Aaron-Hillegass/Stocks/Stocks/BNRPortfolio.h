//
//  BNRPortfolio.h
//  Stocks
//
//  Created by Tsz Chun Lai on 1/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRStockHolding;
@class BNRPortfolio;

@interface BNRPortfolio : NSObject

@property (nonatomic, copy) NSArray *stocks;
- (void)addStock:(BNRStockHolding *)a;
- (float)totalValue;
- (void)removeStock:(BNRStockHolding *)a;
- (NSArray *)topThreeHoldings;
- (NSArray *)sortedBySymbol;
@end
