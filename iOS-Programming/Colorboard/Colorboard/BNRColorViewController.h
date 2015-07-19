//
//  BNRColorViewController.h
//  Colorboard
//
//  Created by Tom Lai on 6/27/15.
//  Copyright © 2015 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRColorDescription.h"
@import UIKit;

@interface BNRColorViewController : UIViewController <UIViewControllerRestoration>

@property (nonatomic) BOOL existingColor;
@property (nonatomic) BNRColorDescription *colorDescription;

@end
