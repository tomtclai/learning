//
//  BNRPerson.h
//  Chapter 18 Your First Class
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRPerson : NSObject
{
    //BNRPerson has two instance variables
    float _heightInMeters;
    int _weightInKilos;
}

//BNRPerson has methods to read and set its instance variables
- (float)heightInMeters;
- (void)setHeightInMeters:(float)h;
- (int)weightInKilos;
- (void)setWeightInKilos:(int)w;

//BNRPerson has amethod that calculates the BMI
- (float)bodyMassIndex;

@end
