//
//  BNRPerson.m
//  Chapter 19 Properties
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRPerson.h"

@implementation BNRPerson


- (float)bodyMassIndex
{
    float h = [self heightInMeters];
    return [self weightInKilos] / (h * h);
}

@end
