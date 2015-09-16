//
//  HelperClass.m
//  blockDebugging
//
//  Created by Tom Lai on 9/16/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "HelperClass.h"

@implementation HelperClass
- (void)doThingWithBlock:(BOOL (^) (NSString *arg1, NSInteger arg2))block
{
    block(@"Oh Hai", 22);
}
@end
