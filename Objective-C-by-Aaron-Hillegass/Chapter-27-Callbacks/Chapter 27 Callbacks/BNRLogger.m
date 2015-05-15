//
//  BNRLogger.m
//  Chapter 27 Callbacks
//
//  Created by Tsz Chun Lai on 1/19/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRLogger.h"

@implementation BNRLogger
-(NSString *)lastTimeString
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSLog(@"created dateFormatter");
    }
    return [dateFormatter stringFromDate:self.lastTime];
}

-(void)updateLastTime:(NSTimer *)t
{
    NSDate *now = [NSDate date];
//    [self setLastTime:now];
    [self willChangeValueForKey:@"lastTime"];
    _lastTime = now;
    [self didChangeValueForKey:@"lastTime"];
    NSLog(@"Just set time to %@", self.lastTimeString);
}
// Called each time a chunk of data arrives
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"receive %lu bytes", [data length]);
    
    // Create a mutable data if it does not already exist
    if (!_incomingData)
    {
        _incomingData = [[NSMutableData alloc] init];
    }
    
    [_incomingData appendData:data];
}

// Called when the last chunk has been processed
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Got it all");
    NSString *string = [[NSString alloc] initWithData:_incomingData
                                             encoding:NSUTF8StringEncoding];
    _incomingData = nil;
    NSLog(@"string has %lu characters", [string length]);
//    NSLog(@"THe whole string is %@", string);
}

// Called if the fetch fails
- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *)error
{
    NSLog(@"connection failed : %@", [error localizedDescription]);
    _incomingData = nil;
}

- (void)zoneChange:(NSNotification*) note
{
    NSLog(@"The system time zone has changed");
}

+ (NSSet *)keyPathsForValuesAffectingLastTimeString
{
    return [NSSet setWithObject:@"lastTime"];
}
@end
