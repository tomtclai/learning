//
//  BNRPopoverBackgroundView.m
//  Homepwner
//
//  Created by Tom Lai on 5/14/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRPopoverBackgroundView.h"

@implementation BNRPopoverBackgroundView
@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;

#define kArrowBase 30.0f
#define kArrowHeight 20.0f
#define kBorderInset 8.0f
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (CGFloat)arrowBase
{
    return kArrowBase;
}

+ (CGFloat)arrowHeight
{
    return kArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(kBorderInset, kBorderInset, kBorderInset,       kBorderInset);
}

@end
