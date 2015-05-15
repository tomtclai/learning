//
//  main.m
//  Chapter 33 init
//
//  Created by Tsz Chun Lai on 1/24/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRAppliance.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        BNRAppliance *a = [[BNRAppliance alloc] init];
        NSLog(@"a is %@", a);
        [a setValue:@"Washing Machine" forKey:@"productName"];
        [a setValue:[NSNumber numberWithInt:240] forKey:@"Voltage"];
        NSLog(@"a is %@", a);
        
        NSLog(@"The product name is %@", [a valueForKey:@"productName"]);
    }
    return 0;
}
