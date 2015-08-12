//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Tom Lai on 8/12/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"
@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSString *shading in [SetCard validShadings]) {
                for (NSString *color in [SetCard validColors]) {
                    for (int number = 1; number <= [SetCard maxNumber]; number++) {
                        SetCard *card = [[SetCard alloc]init];
                        card.shape = shape;
                        card.shading = shading;
                        card.color = color;
                        card.number = number;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end
