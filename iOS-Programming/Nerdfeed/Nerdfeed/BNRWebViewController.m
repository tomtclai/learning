//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by Tom Lai on 6/14/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"

@implementation BNRWebViewController 

#pragma webview
- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    UIToolbar *toolBar = [[UIToolbar alloc] init];

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"back";
    backButton.action = @selector(goBack);
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]init];
    forwardButton.title = @"forward";
    forwardButton.action = @selector(goForward);
    
    [toolBar setItems:[[NSArray alloc] initWithObjects:backButton, forwardButton, nil]];
    
    webView.scalesPageToFit = YES;


    self.view = webView;
    //    self.webView = webView; why doesn't this work?
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
//        [self.webView loadRequest:req]; why doesn't this work?
    }
}

@end
