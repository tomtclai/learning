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
    return @[@"oval", @"squiggle",@"diamond"];
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
    return @[@"solid",@"striped",@"open"];
}
#pragma mark - instance method
#pragma content
- (NSString *)contents
{
    const NSDictionary *shapes = @{@"oval":@"●",
                                   @"squiggle":@"▲",
                                   @"diamond":@"■"};

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

// override
- (int)match:(NSArray *)theCards
{
    int score = 0;
    int numberOfMatchingCards = 3;
    if ([theCards count] != numberOfMatchingCards) return score; // invalid number of cards
    NSMutableArray *colors = [[NSMutableArray alloc]init];
    NSMutableArray *shapes = [[NSMutableArray alloc]init];
    NSMutableArray *shadings = [[NSMutableArray alloc]init];
    NSMutableArray *numbers = [[NSMutableArray alloc]init];
    
    for (SetCard* i in theCards)
    {
        if (![colors containsObject:i.color])      [colors addObject:i.color];
        if (![shapes containsObject:i.shape])      [shapes addObject:i.shape];
        if (![shadings containsObject:i.shading])  [shadings addObject:i.shading];
        if (![numbers containsObject:@(i.number)]) [numbers addObject:@(i.number)];
    }
    
    if (([colors count] == 1 || [colors count] == numberOfMatchingCards) &&
        ([shapes count] == 1 || [shapes count] == numberOfMatchingCards) &&
        ([shadings count] == 1 || [shadings count] == numberOfMatchingCards) &&
        ([numbers count] == 1 || [numbers count] == numberOfMatchingCards)) {
        score = 4;
    }
    return score;
}

@end
