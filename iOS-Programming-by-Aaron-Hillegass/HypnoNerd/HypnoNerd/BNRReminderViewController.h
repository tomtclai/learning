//
//  BNRReminder.h
//  HypnoNerd
//
//  Created by Tsz Chun Lai on 2/21/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BNRReminderViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
