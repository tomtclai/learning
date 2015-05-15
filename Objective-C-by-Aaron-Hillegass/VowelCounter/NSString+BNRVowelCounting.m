//
//  NSString+BNRVowelCounting.m
//  VowelCounter
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "NSString+BNRVowelCounting.h"

@implementation NSString (BNRVowelCounting)

-(int)bnr_vowelCount
{
    NSCharacterSet *charSet =
    [NSCharacterSet characterSetWithCharactersInString:@"aeiouAEIOUY"];
    
    NSUInteger count = [self length];
    
    int sum = 0;
    for (int i = 0 ; i < count; i ++)
    {
        unichar c = [self characterAtIndex:i];
        if ([charSet characterIsMember:c]) sum++;
    }
    return sum;
}

@end
