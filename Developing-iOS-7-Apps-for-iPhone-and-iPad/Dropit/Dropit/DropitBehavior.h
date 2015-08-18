//
//  DropitBehavior.h
//  Dropit
//
//  Created by Tom Lai on 8/17/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

- (void)addItem: (id <UIDynamicItem>) item;
- (void)removeItem: (id <UIDynamicItem>) item;
@end
