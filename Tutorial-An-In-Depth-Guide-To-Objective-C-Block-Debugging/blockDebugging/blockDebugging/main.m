//
//  main.m
//  blockDebugging
//
//  Created by Tom Lai on 9/16/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelperClass.h"
int main(int argc, char **argv)
{
    @autoreleasepool {
        HelperClass *object = [HelperClass new];
        
        NSInteger capturedInteger = 2;
        
        [object doThingWithBlock:^ BOOL (NSString *arg1, NSInteger arg2) {
            NSInteger someInteger = arg2 + capturedInteger;
            
            printf("%p %li\n", arg1, someInteger);
            
            return YES;
        }];
        
        return 0;
    }
}