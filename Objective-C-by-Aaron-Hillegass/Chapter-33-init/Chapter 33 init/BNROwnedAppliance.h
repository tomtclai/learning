//
//  BNROwnedAppliance.h
//  Chapter 33 init
//
//  Created by Tsz Chun Lai on 1/24/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRAppliance.h"

@interface BNROwnedAppliance : BNRAppliance
@property (readonly) NSSet *ownerNames;

// The designated initializer
- (instancetype)initWithProductName:(NSString *)pn
                     firstOwnerName:(NSString *)n;
- (void)addOwnerName:(NSString *)n;
- (void)removeOwnerName:(NSString *)n;
@end
