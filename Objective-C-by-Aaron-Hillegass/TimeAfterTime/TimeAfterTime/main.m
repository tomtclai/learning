//
//  main.m
//  TimeAfterTime
//
//  Created by Tsz Chun Lai on 10/26/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

void challenge()
{
    NSHost *instanceOfNSHost = [NSHost currentHost];
    NSString *instanceOfNSString = [instanceOfNSHost localizedName];
    NSLog(@"%@",instanceOfNSString);
}
void challenge2()
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1994];
    [comps setMonth:9];
    [comps setDay:25];
    [comps setHour:21];
    [comps setMinute:30];
    
    NSCalendar *g = [[NSCalendar alloc]
                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dob = [g dateFromComponents:comps];
    NSLog(@"%@", dob);
    NSDate *now = [[NSDate alloc] init];
    double seconds = [now timeIntervalSinceDate:dob];
    NSLog(@"Tom is %f seconds old", seconds);
}
int main(int argc, const char * argv[])
{
    @autoreleasepool {
        //In the square brackets:
        //  NSDate is pointer to the object or class that has the method
        //  date is the name of the method
        //NSDate *now = [NSDate date];
        //always nest alloc and init
            //alloc method returns a pointer to a new instance that needs to be
            //initialized. An uninitialized instance is not ready to receive
            //messages
            //makes no difference for this particular class because date method
            //initilizes
        NSDate *now = [[NSDate alloc] init];

        NSLog(@"This NSDate object lives at %p", now);
        NSLog(@"The date is %@", now);
        //second gets output from timeIntervalSince1970 of the object now
        double seconds = [now timeIntervalSince1970];
        //nested message sends
        seconds = [[NSDate date] timeIntervalSince1970];
        NSLog(@"It has been %f seconds since the start of 1970.", seconds);
        NSDate *later = [now dateByAddingTimeInterval:10000];
        NSLog(@"In 100,000 seconds it will be %@", later);
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSLog(@"My calendar is %@", [cal calendarIdentifier]);
        unsigned long day = [cal ordinalityOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitMonth
                                          forDate:now];
        NSLog(@"This is day %lu of the month", day);
        challenge2();
        
        return 0;
    }
}
