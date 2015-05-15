//
//  BNRPerson.h
//  Chapter 19 Properties
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRPerson : NSObject

//BNRPerson has two properties
@property (nonatomic) float heightInMeters;
@property (nonatomic) int weightInKilos;

//BNRPerson has amethod that calculates the BMI
- (float)bodyMassIndex;

@end
