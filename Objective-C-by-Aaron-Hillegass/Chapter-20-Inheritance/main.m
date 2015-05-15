//
//  main.m
//  Chapter 20 Inheritance
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNREmployee.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Create an instance of BNREmployee
        BNREmployee *mikey = [[BNREmployee alloc] init];
        
        //give the instance variables interesting values
        mikey.weightInKilos = 96;
        mikey.heightInMeters = 1.8;
        mikey.employeeID = 12;
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M, d, y 'at' hh:mm"];
        NSDate *result = [formatter dateFromString:@"July, 18, 2014 at 08:00"];
        
        mikey.hireDate = result;
        
        //log the instance variables
        float height = mikey.heightInMeters;
        int weight = mikey.weightInKilos;
        NSLog(@"mike is %.2f meter tall and weighs %d kilograms",
              height, weight);
        NSLog(@"%@ hired on %@", mikey, mikey.hireDate);
        
        //log some values
        float bmi = [mikey bodyMassIndex];
        double years = [mikey yearsOfEmployment];
        NSLog(@"BMI of %f, has worked with us for %.2f years", bmi, years);
    }
    return 0;
}
