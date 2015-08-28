//
//  ViewController.m
//  imaginarium
//
//  Created by Tom Lai on 8/27/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
        ImageViewController *ivc = segue.destinationViewController;
        ivc.imageURL = [NSURL URLWithString:segue.identifier];
        ivc.title = segue.identifier;
    }
}


@end
