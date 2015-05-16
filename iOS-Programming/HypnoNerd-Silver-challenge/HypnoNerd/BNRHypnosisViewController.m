//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by Tsz Chun Lai on 2/21/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@implementation BNRHypnosisViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"BNRHypnosisViewController loaded its view");
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = @"Hypnotize";
        
        // Create a UIImage from a file
        // This will use Hypno@2x.png on retina display devices
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // Put that inmage on the tab bar item
        self.tabBarItem.image = i;
    }
    return self;
}

- (void)loadView
{
    // Create a view
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] init];
    
    self.redGreenBlue = [[UISegmentedControl alloc]
                         initWithItems:[NSArray arrayWithObjects:
                                        @"R",@"G", @"B", nil]];
    [self.redGreenBlue addTarget:backgroundView action:@selector(segmentControlOption)
           forControlEvents:UIControlEventValueChanged];
    
    // Set it as *the* view of this view controller
    self.view = backgroundView;
}
@end
