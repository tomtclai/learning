//
//  HelperClass.h
//  blockDebugging
//
//  Created by Tom Lai on 9/16/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperClass : NSObject
- (void)doThingWithBlock:(BOOL (^) (NSString *arg1, NSInteger arg2))block;
@end
