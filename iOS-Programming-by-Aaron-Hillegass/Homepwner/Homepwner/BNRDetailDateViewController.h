//
//  BNRDetailDateViewController.h
//  Homepwner
//
//  Created by Tsz Chun Lai on 3/20/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;
@interface BNRDetailDateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) BNRItem *item;
@end
