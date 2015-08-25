//
//  SetCardView.h
//  SuperCard
//
//  Created by Tom Lai on 8/21/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardButton.h"
@interface SetCardButton : UIButton
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;
@property (nonatomic) BOOL chosen;
@end
