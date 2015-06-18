//
//  BNRAssetTypeViewController.h
//  Homepwner
//
//  Created by Tom Lai on 6/17/15.
//  Copyright © 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRDetailViewController;
@import UIKit;
@class BNRItem;
@interface BNRAssetTypeViewController : UITableViewController

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, weak) UIPopoverController *padPopover;
@property (nonatomic, weak) BNRDetailViewController *dvc;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *addButton;
- (void) toggleEditingMode;
- (void) addEntityType;
@end
