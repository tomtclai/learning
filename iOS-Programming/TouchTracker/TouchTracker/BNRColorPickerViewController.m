//
//  BNRColorPickerViewController.m
//  TouchTracker
//
//  Created by Tsz Chun Lai on 3/27/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRColorPickerViewController.h"
#import "BNRDrawView.h"
@interface BNRColorPickerViewController ()

@end

@implementation BNRColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.colorView.backgroundColor=[UIColor colorWithRed:self.redSlider.value
                                                   green:self.greenSlider.value
                                                    blue:self.blueSlider.value
                                                   alpha:1.0];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.view];
    self.parentView = (BNRDrawView*) aView;
    if (animated&&self.popUpView==nil) {
        [self showAnimate];
    }

    [self viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useThisColor:(id)sender {
    NSLog(@"use this color tapped");
    self.parentView.fixedColor = self.colorView.backgroundColor;
    [self removeAnimate];
}

- (IBAction)useAutoColor:(id)sender {
    NSLog(@"use auto color tapped");
    self.parentView.fixedColor = nil;
    [self removeAnimate];

}
- (IBAction)redSliderChanged:(id)sender {
    CGFloat red, green, blue, alpha;
    [[[self colorView] backgroundColor]getRed:&red
                                        green:&green 
                                         blue:&blue
                                        alpha:&alpha];
    red = self.redSlider.value;
    self.colorView.backgroundColor = [UIColor colorWithRed:red
                                                     green:green
                                                      blue:blue
                                                     alpha:alpha];
//    NSLog(@"%f", *red);
}
- (IBAction)greenSliderChanged:(id)sender {
    CGFloat red, green, blue, alpha;
    [[[self colorView] backgroundColor]getRed:&red
                                        green:&green
                                         blue:&blue
                                        alpha:&alpha];
    green = self.greenSlider.value;
    self.colorView.backgroundColor = [UIColor colorWithRed:red
                                                     green:green
                                                      blue:blue
                                                     alpha:alpha];
}
- (IBAction)blueSliderChanged:(id)sender {
    CGFloat red, green, blue, alpha;
    [[[self colorView] backgroundColor]getRed:&red
                                        green:&green
                                         blue:&blue
                                        alpha:&alpha];
    blue = self.blueSlider.value;
    self.colorView.backgroundColor = [UIColor colorWithRed:red
                                                     green:green
                                                      blue:blue
                                                     alpha:alpha];
}


- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
