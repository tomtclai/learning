//
//  main.m
//  strings
//
//  Created by Tsz Chun Lai on 10/28/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *lament = @"Why me!?";
        NSString *slogan = @"I \u2661 NY";
         NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [NSString stringWithFormat:@"The date is %@", now];
        NSLog(@"%@",lament);
        NSLog(@"%@",slogan);
        NSLog(@"%@",dateString);
        NSLog(@"%lu" , (unsigned long)[dateString length]);
        if ([slogan isEqualToString:lament])
        {
            NSLog(@"%@ and %@ are equal", slogan, lament);
        }
        NSString *angry = @"That makes me so mad";
        NSLog(@"%@",[angry uppercaseString]);
    }
    return 0;
}
