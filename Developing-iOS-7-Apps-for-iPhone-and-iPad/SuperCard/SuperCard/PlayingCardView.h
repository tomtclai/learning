//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Tom Lai on 8/13/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView


@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;


@end
