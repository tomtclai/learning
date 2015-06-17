//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by Tom Lai on 6/14/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"
@interface BNRWebViewController () <UIWebViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic) BOOL firstPageInHistory;
@end
@implementation BNRWebViewController
#pragma mark init
- (instancetype) init
{
    self = [super init];

    return self;
}

#pragma mark toolBar
- (void)setUpToolBar
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    self.toolBar = toolBar;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"back";
    backButton.action = @selector(goBack);
    backButton.enabled = false;
    self.backButton = backButton;
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]init];
    forwardButton.title = @"forward";
    forwardButton.action = @selector(goForward);
    forwardButton.enabled = false;
    self.forwardButton = forwardButton;
    
    [toolBar setItems:[[NSArray alloc] initWithObjects:backButton, forwardButton, nil]];
    
    [self.view addSubview:toolBar];
}


#pragma mark webview
- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    self.webView = webView;
    self.view = webView;
    webView.delegate = self;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    webView.scalesPageToFit = YES;
    [self setUpToolBar];
}
- (void)goBack
{
    [[self webView] goBack];
    [self updateBackForwardEnable];
}
- (void)goForward
{
    [[self webView] goForward];
    [self updateBackForwardEnable];
}
- (void)updateBackForwardEnable
{
    if (self.firstPageInHistory) {
        self.backButton.enabled = false;
        self.forwardButton.enabled = false;
    } else {
        self.backButton.enabled = [[self webView] canGoBack];
        self.forwardButton.enabled = [[self webView] canGoForward];
    }
}
- (void)webViewDidStartLoad:(nonnull UIWebView *)webView
{
    [self updateBackForwardEnable];
    self.firstPageInHistory = NO;
}
#pragma mark UIview
- (void)viewWillDisappear:(BOOL)animated
{
    self.view = nil;
    self.webView =nil;
}
- (void)viewDidLoad
{
    NSDictionary *labels = @{
                            @"toolbar":self.toolBar,
                            @"webview":self.webView
                            };
    NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolbar(36@1000)]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:labels];
    
    NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[toolbar(1000@10)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:labels];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:Vconstraints];
    [self.view addConstraints:Hconstraints];
}
- (void)setURL:(NSURL *)URL
{
    self.firstPageInHistory = YES;
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req]; //why doesn't this work?
    }
}
#pragma mark dealloc
-(void) dealloc{
    
}

@end
