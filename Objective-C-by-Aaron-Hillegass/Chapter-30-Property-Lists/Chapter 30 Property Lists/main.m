//
//  main.m
//  Chapter 30 Property Lists
//
//  Created by Tsz Chun Lai on 1/21/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
void example();
void challenge();
NSString* path = @"/tmp/stocks.plist";
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        challenge();
    }
    return 0;
}

void example(){
    NSMutableArray *stocks = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *stock;
    
    stock = [NSMutableDictionary dictionary];
    [stock setObject:@"APPL"
              forKey:@"symbol"];
    [stock setObject:[NSNumber numberWithInt:200]
              forKey:@"shares"];
    [stocks addObject:stock];
    
    stock = [NSMutableDictionary dictionary];
    [stock setObject:@"GOOG"
              forKey:@"symbol"];
    [stock setObject:[NSNumber numberWithInt:160]
              forKey:@"shares"];
    
    [stocks addObject:stock];
    
    [stocks writeToFile:path
             atomically:YES];
    
    NSArray *stockList = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *d in stockList){
        NSLog(@"I have %@ shares of %@",
              [d objectForKey:@"shares"],
              [d objectForKey:@"symbol"]);
    }
}

void challenge()
{
    NSMutableArray *all8Types = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *stock;

    stock = [NSMutableDictionary dictionary];
    [stock setObject:@"APPL"
              forKey:@"symbol"];
    [stock setObject:[NSNumber numberWithInt:200]
              forKey:@"shares"];
    [all8Types addObject:stock];
    
    NSData* somedata= [NSMutableData dataWithContentsOfFile:path];
//    [somedata writeToFile:path
//               atomically:YES];
    [all8Types addObject:somedata];
    
    NSString* somestring = @"Hello";
//    [somestring writeToFile:path
//                 atomically:YES
//                   encoding:NSUTF8StringEncoding
//                      error:nil];
    [all8Types addObject:somestring];
    
    NSDate* somedate = [NSDate date];
//    somedata = [NSKeyedArchiver archivedDataWithRootObject:somedate];
//    [somedata writeToFile:path
//               atomically:YES];
    [all8Types addObject:somedate];
    
    NSNumber* someNumber = [NSNumber numberWithInt:142354];
//    somedata = [NSKeyedArchiver archivedDataWithRootObject:someNumber];
//    [somedata writeToFile:path
//               atomically:YES];
    [all8Types addObject:someNumber];
    
    someNumber = [NSNumber numberWithFloat:123.231];
//    somedata = [NSKeyedArchiver archivedDataWithRootObject:someNumber];
//    [somedata writeToFile:path
//               atomically:YES];
    [all8Types addObject:someNumber];
    
    NSNumber* someBoolean= [NSNumber numberWithBool:YES];
//    somedata = [NSKeyedArchiver archivedDataWithRootObject:someBoolean];
//    [somedata writeToFile:path
//               atomically:YES];
    
    [all8Types addObject:someBoolean];
    
    [all8Types writeToFile:path atomically:YES];
}