//
//  main.m
//  Chapter 28 Blocks
//
//  Created by Tsz Chun Lai on 1/19/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        double (^divBlock)(double,double);
        divBlock = ^(double dividend, double divisor){
            double qoutient = dividend/ divisor;
            return qoutient;
        };
        


    }
    
    return 0;
}
