//
//  NSDate+BNRDateConvenience.h
//  DateMonger
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BNRDateConvenience)
-(instancetype) bnr_midnightOfDateWithDay:(NSInteger)d
                                    month:(NSInteger)m
                                     year:(NSInteger)y;
@end
