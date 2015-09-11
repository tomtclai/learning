//
//  ImageViewController.m
//  imaginarium
//
//  Created by Tom Lai on 8/27/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "ImageViewController.h"
#import "URLViewController.h"
@interface ImageViewController () <UIScrollViewDelegate,UISplitViewControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) UIPopoverController *urlPopoverController;
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
    if (self.splitViewController)
        [self.spinner startAnimating];
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;
    if (self.imageURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        [self.spinner startAnimating];
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
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
    [self configureZoomScale];
    [self.spinner stopAnimating];
}

- (void)configureZoomScale
{
    if (self.imageView.bounds.size.width != 0 && self.imageView.bounds.size.height != 0)
    {
        CGFloat x = self.scrollView.bounds.size.width / self.imageView.bounds.size.width;
        CGFloat y = self.scrollView.bounds.size.height / self.imageView.bounds.size.height;
        
        CGFloat minZoomScale = MIN(x,y);
        CGFloat maxZoomScale = MAX(x,y);
        CGFloat defaultZoomScale = maxZoomScale;
        
        self.scrollView.minimumZoomScale = minZoomScale;
        self.scrollView.maximumZoomScale = maxZoomScale;
        self.scrollView.zoomScale = defaultZoomScale;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    if (!self.splitViewController)
        [self.spinner startAnimating];
}

#pragma mark - UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
        self.navigationItem.leftBarButtonItem.title = self.navigationController.title;
    }
    if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[URLViewController class]]) {
        URLViewController *urlvc = (URLViewController *)segue.destinationViewController;
        // if we are segueing to a popover, the segue itself will be a UIStoryboardPopoverSegue
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
            self.urlPopoverController = popoverSegue.popoverController;
            urlvc.url = self.imageURL;
        }
    }
}

// don't show the URL if it's already showing or we don't have a URL to show

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Show URL"]) {
        return self.urlPopoverController ? NO : (self.imageURL ? YES : NO);
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

@end
