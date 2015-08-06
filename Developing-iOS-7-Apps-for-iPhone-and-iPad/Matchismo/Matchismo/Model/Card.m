//
//  Card.m
//  
//
//  Created by Tom Lai on 8/5/15.
//
//

#import "Card.h"


@implementation Card

@synthesize contents = _contents, matched = _matched;

// ObjC generate these for you but you don't see them
//-(NSString *)contents
//{
//    return _contents;
//}
//
//-(void)setContents:(NSString *)contents
//{
//    _contents = contents;
//}


- (int)match:(NSArray *)cards
{
    int score = 0;
    for (Card *card in cards)
    {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
