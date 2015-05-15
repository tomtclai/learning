//
//  main.m
//  Chapter 17 Creating Arrays
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSDate *now = [NSDate date];
        NSDate *tomorrow = [now dateByAddingTimeInterval: 24.0 * 60.0 * 60.0];
        NSDate *yesterday = [now dateByAddingTimeInterval: -24.0* 60.0* 60.0];
//        //creat an array containing all three
//        NSArray *dateList = @[now, tomorrow, yesterday];
//        //Print a couple of dates
//        NSLog(@"The first date is %@", dateList[0]);
//        NSLog(@"The first date is %@", dateList[2]);
//        //How many dates are in the array?
//        NSLog(@"There are %lu dates", [dateList count]);
//        //Iterate over the array
//
//        for (NSDate *d in dateList)
//        {
//            NSLog(@"Here is a date: %@", d);
//        }
        
        //Create an empty mutable array
        NSMutableArray* dateList = [NSMutableArray array];
        
        //Add two dates
        [dateList addObject:now];
        [dateList addObject:tomorrow];
        
        //add yesterday at the beggining of the list
        [dateList insertObject:yesterday atIndex:0];
        
        //iterate over the array
        for (NSDate *d in dateList)
        {
            NSLog(@"Here is a date %@", d);
        }
    }
    return 0;
}
