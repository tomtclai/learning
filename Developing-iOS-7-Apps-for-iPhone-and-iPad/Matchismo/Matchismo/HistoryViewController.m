//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/13/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "HistoryViewController.h"
@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;

@end

@implementation HistoryViewController
//- (instancetype)initWithHistory: (History *)history{
//    self = [super init];
//    if (self) {
//        self.history = history;
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    self.display.attributedText = self.history.attributedLog;
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
