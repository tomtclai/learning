//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by Tsz Chun Lai on 3/23/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"
@implementation BNRDrawViewController 

- (void)loadView
{
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

@end
