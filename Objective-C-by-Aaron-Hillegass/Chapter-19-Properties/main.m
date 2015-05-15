//
//  main.m
//  Chapter 19 Properties
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Create an instance of BNRPerson
        BNRPerson *mikey = [[BNRPerson alloc] init];
        
        //give the instance variables interesting values
        mikey.weightInKilos = 96;
        mikey.heightInMeters = 1.8;
        
        //log the instance variables
        float height = mikey.heightInMeters;
        int weight = mikey.weightInKilos;
        NSLog(@"mike is %.2f meter tall and weighs %d kilograms",
              height, weight);
        
        //log some values
        float bmi = [mikey bodyMassIndex];
        NSLog(@"mikey has a BMI of %f", bmi);
    }
    return 0;
}
