//
//  BNRReminder.m
//  HypnoNerd
//
//  Created by Tsz Chun Lai on 2/21/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRReminderViewController.h"

@implementation BNRReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"BNRReminderViewController loaded its view");
}


- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypnotize me!";
    note.fireDate = date;
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = @"Reminder";
        
        // Create a UIImage from a file
        // This will use Hypno@2x.png on retina display devices
        UIImage *i = [UIImage imageNamed:@"Time.png"];
        
        // Put that inmage on the tab bar item
        self.tabBarItem.image = i;
    }
    return self;
}

@end
