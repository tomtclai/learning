//
//  URLViewController.m
//  Photomania
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "URLViewController.h"

@interface URLViewController ()
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;

@end

@implementation URLViewController

- (void)setUrl:(NSURL *)url
{
    _url = url;
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI
{
    self.urlTextView.text = [self.url absoluteString];
}
@end
