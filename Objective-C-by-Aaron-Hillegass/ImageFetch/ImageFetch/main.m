//
//  main.m
//  ImageFetch
//
//  Created by Tsz Chun Lai on 1/19/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSURL* url = [NSURL URLWithString:
                      @"https://www.google.com/images/logos/ps_logo2.png"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:NULL
                                                         error:&error];
        if (!data){
            NSLog(@"fetch failed: %@", [error localizedDescription]);
            return 1;
        }
        
        NSLog(@"The file is %lu bytes", (unsigned long) [data length]);
        
        BOOL written = [data writeToFile:@"/tmp/google.png"
                                 options:0
                                   error:&error];
        
        if (!written){
            NSLog(@"write failed: %@", [error localizedDescription]);
            return 1;
        }
        
        NSLog(@"Success");
        
        NSData *readData = [NSData dataWithContentsOfFile:@"/tmp/google.png"];
        NSLog(@"The file read from the disk has %lu bytes",
              (unsigned long) [readData length]);
        
        // The function returns an array of paths
        NSArray *desktops = NSSearchPathForDirectoriesInDomains
        (NSDesktopDirectory, NSUserDomainMask, YES);
        
        // But I know the user has exactly one desktop directory
        NSString *desktopPath = desktops[0];
        
    }
    return 0;
}
