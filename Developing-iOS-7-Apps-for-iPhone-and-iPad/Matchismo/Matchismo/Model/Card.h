//
//  Card.h
//  
//
//  Created by Tom Lai on 8/5/15.
//
//

@import Foundation;

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;
@property (nonatomic) NSUInteger numberOfMatchingCards;

// return 0 if not a match
-(int)match:(NSArray *)cards;
@end
