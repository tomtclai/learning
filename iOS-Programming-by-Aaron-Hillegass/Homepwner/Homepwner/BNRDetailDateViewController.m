//
//  BNRDetailDateViewController.m
//  Homepwner
//
//  Created by Tsz Chun Lai on 3/20/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRDetailDateViewController.h"
#import "BNRItem.h"
@interface BNRDetailDateViewController ()

@end

@implementation BNRDetailDateViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.datePicker.date = self.item.dateCreated;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    // Save changes to item
    self.item.dateCreated = self.datePicker.date;
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
