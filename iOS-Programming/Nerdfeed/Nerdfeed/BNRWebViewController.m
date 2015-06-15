//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by Tom Lai on 6/14/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"

@implementation BNRWebViewController 
#pragma mark init
- (instancetype) init
{
    self = [super init];

    return self;
}
- (void)deviceOrientationDidChange: (NSNotification *) nsn
{
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationPortrait ||
        orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight)
    {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        [self.toolBar setFrame:CGRectMake(0, screenHeight-36,
                                          screenWidth, 36)];
    }
}
#pragma mark toolBar
- (void)setUpToolBar
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:
                          CGRectMake(0, screenHeight-36,
                                     screenWidth, 36)];
    self.toolBar = toolBar;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"back";
    backButton.action = @selector(goBack);
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]init];
    forwardButton.title = @"forward";
    forwardButton.action = @selector(goForward);
    
    [toolBar setItems:[[NSArray alloc] initWithObjects:backButton, forwardButton, nil]];
    
    [self.view addSubview:toolBar];
}
#pragma mark webview
- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    self.webView = webView;
    self.view = webView;

    
    webView.scalesPageToFit = YES;
    [self setUpToolBar];
//    [toolBar addConstraints:toolBarConstraints];

}

#pragma mark UIview
- (void)viewDidLoad
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}
- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req]; //why doesn't this work?
    }
}
#pragma mark dealloc
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end
