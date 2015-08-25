//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Tom Lai on 8/13/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardButton : UIButton
- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerOffset;
- (void)pushContextAndRotateUpsideDown;
- (void)popContext;
@end
