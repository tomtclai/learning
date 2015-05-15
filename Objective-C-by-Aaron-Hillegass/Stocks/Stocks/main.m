//
//  main.m
//  Stocks
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRForeignStockHolding.h"
#import "BNRPortfolio.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BNRStockHolding* a = [[BNRStockHolding alloc] init];
        [a setNumberOfShares:40];
        [a setPurchaseSharePrice:4.50];
        [a setCurrentSharePrice:2.30];
        [a setSymbol:@"NYSE"];
        BNRStockHolding* b = [[BNRStockHolding alloc] init];
        [b setNumberOfShares:90];
        [b setPurchaseSharePrice:12.19];
        [b setCurrentSharePrice:10.56];
        [b setSymbol:@"APPL"];
        BNRStockHolding* c = [[BNRStockHolding alloc] init];
        [c setNumberOfShares:210];
        [c setPurchaseSharePrice:45.10];
        [c setCurrentSharePrice:49.51];
        [c setSymbol:@"MSFT"];
        BNRForeignStockHolding* d = [[BNRForeignStockHolding alloc] init];
        [d setNumberOfShares:210];
        [d setPurchaseSharePrice:4.10];
        [d setCurrentSharePrice:4.51];
        d.conversionRate=0.16;
        [d setSymbol:@"BABA"];
        NSArray *StockArray = @[a,b,c,d];
        
        BNRPortfolio *myPortfolio = [[BNRPortfolio alloc] init];
        [myPortfolio setStocks:StockArray];
//        [myPortfolio removeStock:d];
        for (BNRStockHolding *c in [myPortfolio stocks]){
            NSLog(@"%@, %f",[c symbol], [c valueInDollars]);
        }
        
        NSArray *printthis = [myPortfolio topThreeHoldings];
        NSLog(@"%@",printthis);
        
        printthis = [myPortfolio sortedBySymbol];
        NSLog(@"%@",printthis);
    }
    return 0;
}
