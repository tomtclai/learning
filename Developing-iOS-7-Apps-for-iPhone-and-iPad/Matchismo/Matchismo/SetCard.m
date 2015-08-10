//
//  SetCard.m
//  Matchismo
//
//  Created by Tom Lai on 8/10/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
+ (NSArray *)validShapes
{
    return @[@"ovals", @"squiggles",@"diamonds"];
}

+ (NSArray *)validColor
{
    return @[@"red",@"purple",@"green"];
}

+ (int)maxNumber
{
    return 3;
}

+ (NSArray *)validShading
{
    return @[@"solid",@"striped",@"outlined"];
}
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    //TODO: here
    return score;
}
@end
