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
#pragma mark - UISplitViewControllerDelegate
- (void)splitViewController:(nonnull UISplitViewController *)svc
     willHideViewController:(nonnull UIViewController *)aViewController
          withBarButtonItem:(nonnull UIBarButtonItem *)barButtonItem
       forPopoverController:(nonnull UIPopoverController *)pc
{
    // if this bar button item does not have a title. it will not appear at all
    barButtonItem.title = @"Courses";
    
    // Take this bar button item and put it on the left side of the nav item
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(nonnull UISplitViewController *)svc willShowViewController:(nonnull UIViewController *)aViewController invalidatingBarButtonItem:(nonnull UIBarButtonItem *)barButtonItem
{
    // Remove the bar button item from the naviation item
    // Double check that it is the correct button
    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}
#pragma mark dealloc
-(void) dealloc{
    
}

@end
