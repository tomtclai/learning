//
//  BNRWebViewController.h
//  Nerdfeed
//
//  Created by Tom Lai on 6/14/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@interface BNRWebViewController : UIViewController
@property (nonatomic) NSURL *URL;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UIToolbar *toolBar;
@property(nonatomic,strong) UIBarButtonItem *backButton;
@property(nonatomic,strong) UIBarButtonItem *forwardButton;

@end
