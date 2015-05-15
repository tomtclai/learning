//
//  main.m
//  Chapter 27 Callbacks
//
//  Created by Tsz Chun Lai on 1/19/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRLogger.h"
#import "BNRObserver.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BNRLogger *logger = [[BNRLogger alloc] init];
        
        //Object that might need to trigger callbacks in several other objects
        //use notifications.
        //Notification centers do not own their observers.
        
//        
//        [[NSNotificationCenter defaultCenter]
//         addObserver:logger
//         selector:@selector(zoneChange:)
//         name:NSSystemTimeZoneDidChangeNotification
//         object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserverForName:NSSystemTimeZoneDidChangeNotification
         object:nil
         queue:nil
         usingBlock:^void (NSNotification* s)
             {
                 NSLog(@"The system time zone has changed");
                 return;
             }
         ];
        
        NSURL* url = [NSURL URLWithString:
                      @"http://www.gutenberg.org/cache/epub/205/pg205.txt"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        //Object that have more complicated lives use helper objects,
        //and the most common tpye of helper object is the delegate
        //Objects do not own their delegates or data sources except NSURLConnection
        __unused NSURLConnection *fetchConn =
        [[NSURLConnection alloc] initWithRequest:request
                                        delegate:logger
                                startImmediately:YES];
        
        
        //Object that do just one time use target action
        //Objects do not own their targets except NSTimer
        __unused NSTimer *timer =
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:logger
                                       selector:@selector(updateLastTime:)
                                       userInfo:nil
                                        repeats:YES];
        
        __unused BNRObserver *observer = [[BNRObserver alloc] init];
        
        // I want to know the new value and the old value whenever lastTime is changed
        [logger addObserver:observer
                 forKeyPath:@"lastTimeString"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:nil];
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
