//
//  main.m
//  temp
//
//  Created by Tsz Chun Lai on 1/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSArray *a = [NSArray array];
        NSArray *b = [NSArray arrayWithArray:a];
        //b==a
        NSObject *obj;
        NSArray *c = [NSArray arrayWithObjects:obj, nil];
        
    }
    return 0;
}
