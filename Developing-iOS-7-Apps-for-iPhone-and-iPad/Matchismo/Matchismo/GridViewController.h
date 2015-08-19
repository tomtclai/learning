//
//  GridViewController.h
//  Matchismo
//
//  Created by Tom Lai on 8/18/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridViewController : UIViewController
// required input
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) CGFloat elementAspectRatio;
@property (nonatomic) NSUInteger minNumOfButtons;
@end
