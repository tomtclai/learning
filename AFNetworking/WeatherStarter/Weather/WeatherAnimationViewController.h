//
//  WeatherAnimationViewController.h
//  Weather
//
//  Created by Scott on 26/01/2013.
//  Updated by Joshua Greene 16/12/2013.
//
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+weather.h"

@interface WeatherAnimationViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property(nonatomic, strong) NSDictionary *weatherDictionary;

- (IBAction)updateBackgroundImage:(id)sender;
- (IBAction)deleteBackgroundImage:(id)sender;

- (void)start:(NSString *)type;
- (void)stop;

@end