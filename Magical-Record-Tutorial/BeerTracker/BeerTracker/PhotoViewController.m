//  PhotoViewController.m
//  BeerTracker
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.


#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.imageView.image = self.image;
}

@end
