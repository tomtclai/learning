//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Tom Lai on 6/12/15.
//  Copyright © 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRImageViewController.h"
@interface BNRImageViewController () <UIScrollViewDelegate>

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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView addSubview:imageView];
    scrollView.delegate=self;
    self.view = scrollView;
}
#pragma mark - view will appaer
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // We must cast the view to UIImageView to send it setImage:
    UIImageView *imageView = (UIImageView *)self.view.subviews;
    imageView.image = self.image;
}
@end
