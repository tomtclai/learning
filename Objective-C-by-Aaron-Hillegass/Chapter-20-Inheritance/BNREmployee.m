//
//  BNREmployee.m
//  Chapter 20 Inheritance
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNREmployee.h"

@implementation BNREmployee

- (double)yearsOfEmployment
{
    //Do I have a non-nil hireDate?
    if (self.hireDate)
    {
        //NSTimeInterval is the same as double
        NSDate * now = [NSDate date];
        NSTimeInterval secs = [now timeIntervalSinceDate:self.hireDate];
        
        double SECONDS_PER_YEAR = 31557600;
        return secs / SECONDS_PER_YEAR;
    }
    else
        return 0;
}

- (float)bodyMassIndex
{
    float normalBMI = [super bodyMassIndex];
    return normalBMI * 0.9;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Employee %d>", self.employeeID];
}

@end
