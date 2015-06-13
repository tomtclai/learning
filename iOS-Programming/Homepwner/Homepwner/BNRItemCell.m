//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Tom Lai on 5/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRItemCell.h"
#import <UIKit/UIKit.h>

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
