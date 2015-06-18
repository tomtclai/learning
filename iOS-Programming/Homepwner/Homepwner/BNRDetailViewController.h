//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Tsz Chun Lai on 3/20/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController
@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock) (void);

- (instancetype)initForNewItem:(BOOL)isNew;
- (void) setTypeLabel;
@end
