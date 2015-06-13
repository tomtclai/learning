//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Tom Lai on 6/12/15.
//  Copyright © 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRImageViewController.h"
@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

#pragma mark - load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}
#pragma mark - view will appaer
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // We must cast the view to UIImageView to send it setImage:
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}
@end
