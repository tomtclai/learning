//
//  SetCard.m
//  Matchismo
//
//  Created by Tom Lai on 8/10/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "SetCard.h"

@import UIKit;
@implementation SetCard
#pragma mark class method
+ (NSArray *)validShapes
{
    return @[@"ovals", @"squiggles",@"diamonds"];
}

+ (NSArray *)validColors
{
    return @[@"red",@"purple",@"green"];
}

+ (int)maxNumber
{
    return 3;
}

+ (NSArray *)validShadings
{
    return @[@"solid",@"striped",@"outlined"];
}
#pragma mark - instance method
#pragma content
- (NSString *)contents
{
    const NSDictionary *shapes = @{@"ovals":@"●",
                                   @"squiggles":@"▲",
                                   @"diamonds":@"■"};

    NSMutableString* result = [[NSMutableString alloc]init];
    
    

    [result appendString: shapes[self.shape]];

    return result;
}
#pragma mark setters
- (void)setNumber:(NSUInteger)number
{
    if (number <= 3) _number = number;
}

- (void)setShape:(NSString *)shape
{
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape = shape;
    }
}
- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}
- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}
#pragma mark match
typedef enum matchResult : NSUInteger
{
    allDifferent   = 0b01,
    allSame        = 0b10,
    neither     = 0b11,
} matchResult;

// override
- (int)match:(NSArray *)theCards
{
    int score = 0;
    if ([theCards count] != 3) return score; // invalid number of cards
    NSMutableArray *otherCards = [theCards mutableCopy];
    [otherCards removeObject:self];
    // There are 3 ways to a match
    // 1. All three cards have the same shape & color & number but different shading
    // 2. All three cards have a different shape & color & number but the same shading
    // 3. All three cards have a different shape & color & number & shading
    
    SetCard * cardA = [otherCards firstObject];
    SetCard * cardB = [otherCards lastObject];

    
    NSArray * shadingArrStrings = @[self.shading, cardA.shading, cardB.shading];
    NSArray * colorArrStrings = @[self.color, cardA.color, cardB.color];
    NSArray * numberArrStrings = @[[NSString stringWithFormat:@"%@", @(self.number)],
                                    [NSString stringWithFormat:@"%@", @(cardA.number)],
                                    [NSString stringWithFormat:@"%@", @(cardB.number)]];
    NSArray * shapeArrStrings = @[self.shape, cardA.shape, cardB.shape];
    
    
    matchResult shadingRes = [self matchHelper:shadingArrStrings];
    matchResult colorRes = [self matchHelper:colorArrStrings];
    matchResult numberRes = [self matchHelper:numberArrStrings];
    matchResult shapeRes = [self matchHelper:shapeArrStrings];
    

    // case 1
    if (shapeRes == allSame && colorRes == allSame &&
        numberRes == allSame && shadingRes == allDifferent)
    {
        score = 1;
    // case 2
    } else if (shapeRes == allDifferent && colorRes == allDifferent &&
               numberRes == allDifferent && shadingRes == allSame)
    {
        score = 1;
    // case 3
    } else if (shapeRes == allDifferent && colorRes == allDifferent &&
               numberRes == allDifferent && shadingRes == allDifferent)
    {
        score = 1;
    } else {
        score = 0;
    }
    
    
    return score;
}
- (matchResult)matchHelper:(NSArray *)attrStrings
{
    matchResult res = 0;
    NSString* str1 = attrStrings [0];
    NSString* str2 = attrStrings [1];
    NSString* str3 = attrStrings [2];
    
    if ([str1 isEqualToString: str2]) { // S -> A   B
        res = res | allSame;
    } else {
        res = res | allDifferent;
    }
    if ([str2 isEqualToString: str3]) { // S  A -> B
        res = res | allSame;
    } else {
        res = res | allDifferent;
    }
    if ([str3 isEqualToString: str1]) { // A  B -> S
        res = res | allSame;
    } else {
        res = res | allDifferent;
    }
    return res;
}
@end
