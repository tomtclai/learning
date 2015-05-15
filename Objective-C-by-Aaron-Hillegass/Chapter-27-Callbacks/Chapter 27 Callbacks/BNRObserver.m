//
//  BNRObserver.m
//  Chapter 27 Callbacks
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRObserver.h"

@implementation BNRObserver

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    NSString *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
    NSLog(@"Observed: %@ of %@ was changed from %@ to %@",
          keyPath, object, oldValue, newValue);
}

@end
