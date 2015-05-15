//
//  main.m
//  DateMonger
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+BNRDateConvenience.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDate * test = [[NSDate alloc] init];
        test = [test bnr_midnightOfDateWithDay:3
                                         month:3
                                          year:2014];
        
        NSLog(@"%@", test);
    }
    return 0;
}
