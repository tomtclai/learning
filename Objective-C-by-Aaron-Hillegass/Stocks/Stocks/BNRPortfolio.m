//
//  BNRPortfolio.m
//  Stocks
//
//  Created by Tsz Chun Lai on 1/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//
#import "BNRStockHolding.h"
#import "BNRPortfolio.h"
@interface BNRPortfolio()
{
    NSMutableArray *_stocks;
}
@end
@implementation BNRPortfolio

// Accessors for stocks properties
- (void)setStocks:(BNRStockHolding *)a
{
    _stocks = [a mutableCopy];
}

- (NSArray *)stocks
{
    return [_stocks copy];
}

- (void)addStock:(BNRStockHolding *)a
{
    //is stocks nil?
    if (!_stocks) {
        //create the array
        _stocks = [[NSMutableArray alloc] init];
    }
    [_stocks addObject:a];
}

- (void)removeStock:(BNRStockHolding *)a
{
    //is stocks filled?
    if (_stocks) {
        //remove the stock
        
        for (int i = 0 ; i < _stocks.count; i++)
        {
            if ( a == _stocks[i])
            {
                [_stocks removeObjectAtIndex:i];
                break;
            }
        }
    }
}
- (float)totalValue
{
    unsigned int sum = 0;
    for (BNRStockHolding *BNRsth in _stocks)
    {
        sum += [BNRsth valueInDollars];
    }
    return sum;
}

- (NSArray *)topThreeHoldings
{
    NSMutableArray *result = [_stocks mutableCopy];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"valueInDollars"
                                                 ascending:NO];
    [result sortUsingDescriptors:@[sort]];
    NSRange range = NSMakeRange(0, 3);
    NSIndexSet *topThree = [NSIndexSet indexSetWithIndexesInRange:range];
    return [result objectsAtIndexes:topThree];
}

- (NSArray *)sortedBySymbol
{
    NSMutableArray *result = [_stocks mutableCopy];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"symbol"
                                                           ascending:YES];
    [result sortUsingDescriptors:@[sort]];
    return result;
}
@end
