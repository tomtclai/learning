//
//  BNRCoursesViewController.h
//  Nerdfeed
//
//  Created by Tom Lai on 6/14/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BNRWebViewController;

@interface BNRCoursesViewController : UITableViewController
@property (nonatomic) BNRWebViewController *webViewController;

@end