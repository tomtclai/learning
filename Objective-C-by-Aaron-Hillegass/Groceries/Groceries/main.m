//
//  main.m
//  Groceries
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *grocery = [NSMutableArray array];
        [grocery addObject:@"Loaf Of bread"];
        [grocery addObject:@"Container of milk"];
        [grocery addObject:@"Stick of butter"];
        NSLog(@"My grocery list is:");
        for (NSString* d in grocery)
        {
            NSLog(@"%@",d);
        }
    }
    return 0;
}
