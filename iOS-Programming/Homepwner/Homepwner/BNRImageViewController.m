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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    scrollView.delegate=self;

    self.imageView = imageView;
    self.scrollView = scrollView;
    self.view = imageView;
}

#pragma mark - view will appaer
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // send imageView setImage:
    self.imageView.image = self.image;
    
    // Tell scrollview the size of content contained within
    self.scrollView.contentSize = self.image.size;
    
    // Specifying the zoom factor and the delegate object are the min requirements
    // to support zoomming in using the pinch gestures
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.delegate=self;
    
    [[self scrollView] setFrame:[self imageView].frame];

    self.scrollView.backgroundColor=[UIColor clearColor];
    self.imageView.backgroundColor=[UIColor greenColor];
    [[self scrollView]addSubview:self.imageView];

}

#pragma mark - UI Scroll View'
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.imageView;
}

#pragma mark double tap
@end
