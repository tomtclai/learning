//
//  BNREmployee.h
//  Chapter 20 Inheritance
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRPerson.h"
@class BNRAsset;

@interface BNREmployee : BNRPerson
@property (nonatomic) unsigned int employeeID;
@property (nonatomic) NSDate *hireDate;
@property (nonatomic, copy) NSArray *assets;
- (double)yearsOfEmployment;
- (void)addAsset:(BNRAsset *)a;
- (void)removeAsset:(BNRAsset *)a;
- (unsigned int)valueOfAssets;

@end
