//
//  NSDate+BNRDateConvenience.m
//  DateMonger
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "NSDate+BNRDateConvenience.h"

@implementation NSDate (BNRDateConvenience)
-(instancetype) bnr_midnightOfDateWithDay:(NSInteger)d
                                    month:(NSInteger)m
                                     year:(NSInteger)y
{
    NSDateComponents * dateComp = [[NSDateComponents alloc] init];
    [dateComp setDay:d];
    [dateComp setMonth:m];
    [dateComp setYear:y];
    [dateComp setHour:0];
    [dateComp setMinute:0];
    [dateComp setSecond:0];
    NSCalendar *greg = [[NSCalendar alloc]
                        initWithCalendarIdentifier:
                        NSCalendarIdentifierGregorian];
    
    NSDate * result =[greg dateFromComponents:dateComp];
    return result;
}
@end
