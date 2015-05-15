//
//  BNRAsset.m
//  Chapter 20 Inheritance
//
//  Created by Tsz Chun Lai on 1/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRAsset.h"

@implementation BNRAsset
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: $%u>",
            self.label, self.resaleValue];
}

-(void)dealloc
{
    NSLog(@"deallocating %@", self);
}
@end
