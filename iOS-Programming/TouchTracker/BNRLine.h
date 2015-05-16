//
//  BNRLine.h
//  TouchTracker
//
//  Created by Tsz Chun Lai on 3/23/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BNRLine : NSObject
@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic) CGFloat width;
@property (nonatomic) UIColor* color;
@end
