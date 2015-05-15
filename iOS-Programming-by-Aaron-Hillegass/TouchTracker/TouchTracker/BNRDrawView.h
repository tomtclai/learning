//
//  BNRDrawView.h
//  TouchTracker
//
//  Created by Tsz Chun Lai on 3/23/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BNRLine.h"
#import "BNRColorPickerViewController.h"
@interface BNRDrawView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, strong) NSMutableDictionary *circlesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedCircles;
@property (nonatomic, weak) BNRLine *selectedLine;
@property (nonatomic, strong) BNRColorPickerViewController* cpvc;
@property (nonatomic, strong) UIColor *fixedColor;
@end
