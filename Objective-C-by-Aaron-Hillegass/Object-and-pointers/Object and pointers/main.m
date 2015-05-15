//
//  main.m
//  Object and pointers
//
//  Created by Tsz Chun Lai on 10/27/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDate *currentTime = [NSDate date];
        NSLog(@"currentTime's value is %p", currentTime);
        sleep(2);
        currentTime = [NSDate date];
        NSLog(@"currentTime's value is %p", currentTime);
    }
    return 0;
}
