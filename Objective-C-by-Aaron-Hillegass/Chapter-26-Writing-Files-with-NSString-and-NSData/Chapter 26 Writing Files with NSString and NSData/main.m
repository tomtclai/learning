//
//  main.m
//  Chapter 26 Writing Files with NSString and NSData
//
//  Created by Tsz Chun Lai on 1/19/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableString *str = [[NSMutableString alloc] init];
        for (int i = 0; i < 10; i++)
            [str appendString:@"Aaron is cool!\n"];
        // Declare a pointer to an NSError object, but do not instantiate it.
        // The NSError instnace will only be created if there is an error.
        NSError *error;
        // Pass the NSError pointer by reference to the NSString method
        BOOL success = [str writeToFile:@"/tmp/cool.txt"
                             atomically:YES
                               encoding:NSUTF8StringEncoding
                                  error:&error];
        // Test the returned BOOL, and query the NSError if the write failed
        if (success)
            NSLog(@"done writing /tmp/cool.txt");
        else
            NSLog(@"writing /tmp/cool.txt failed: %@",
                  [error localizedDescription]);
        NSString *readin;
        readin = [[NSString alloc] initWithContentsOfFile:@"/etc/resolv.conf"
                                              encoding:NSASCIIStringEncoding
                                                 error:&error];
        if (!readin)
            NSLog(@"read failed: %@", [error localizedDescription]);
        else
            NSLog(@"resolve.conf looks like this: %@", readin);
    }
    return 0;
}
