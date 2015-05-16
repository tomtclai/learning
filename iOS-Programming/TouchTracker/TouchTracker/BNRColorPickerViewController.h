//
//  BNRColorPickerViewController.h
//  TouchTracker
//
//  Created by Tsz Chun Lai on 3/27/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BNRAppDelegate.h"
@class BNRDrawView;
@interface BNRColorPickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak) BNRDrawView *parentView;
- (void)removeAnimate;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end