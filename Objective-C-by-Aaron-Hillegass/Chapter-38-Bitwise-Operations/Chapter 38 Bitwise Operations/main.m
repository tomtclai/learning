//
//  main.m
//  Chapter 38 Bitwise Operations
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError *e;
        NSDataDetector *d =
        [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber|
         NSTextCheckingTypeDate
                                        error:&e];
        
        if ([d checkingTypes] & NSTextCheckingTypePhoneNumber)
        {
            NSLog(@"This one is looking for phone numbers");
        }
//     
//        enum {
//            UIDataDetectorTypePhoneNumber = 1<<0,
//            UIDataDetectorTypeLink = 1<<1,
//            UIDataDetectorTypeAddress = 1<<2,
//            UIDataDetectorTypeNone = 0,
//            UIDataDetectorTypeAll = NSUIntegerMax
//        };
        long long unsigned int l =  0;
        l = ~l;
        printf("%llu\n",l);
    }
    return 0;
}
