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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];

    imageView.contentMode = UIViewContentModeCenter;
    
    // Tell scrollview the size of content contained within
    CGPoint center= CGPointMake(600/2.0,600/2.0);
    [imageView setCenter:center];
    
    [scrollView addSubview: imageView];
    
    // Specifying the zoom factor and the delegate object are the min requirements
    // to support zoomming in using the pinch gestures
    scrollView.contentSize = imageView.frame.size;
    scrollView.minimumZoomScale=1.0;
    scrollView.maximumZoomScale=2.0;
    scrollView.delegate=self;
    
    self.imageView = imageView;
    self.scrollView = scrollView;
    self.view = scrollView;
    
}
#pragma mark - view will appaer
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark - scrollview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
