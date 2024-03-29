//
//  ImageViewController.m
//  imaginarium
//
//  Created by Tom Lai on 8/27/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 10.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;
    if (self.imageURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task =
        [session downloadTaskWithRequest:request
                       completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                           if (!error) {
                               if ([request.URL isEqual:self.imageURL]) {
                                   UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       self.image = image;
                                   });
                               }
                           }
                       }];
        [task resume];
    }
}

// don't need to synthesize because _image is never used
- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    [self.spinner stopAnimating];
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.spinner startAnimating];
    [self.scrollView addSubview:self.imageView];
}


@end
