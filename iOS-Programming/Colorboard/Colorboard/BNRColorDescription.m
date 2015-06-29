//
//  BNRColorDescription.m
//  Colorboard
//
//  Created by Tom Lai on 6/29/15.
//  Copyright © 2015 Tom. All rights reserved.
//

#import "BNRColorDescription.h"

@implementation BNRColorDescription

- (instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0
                                 green:0
                                  blue:1
                                 alpha:1];
        _name = @"Blue";
    }
    return self;
}
@end
