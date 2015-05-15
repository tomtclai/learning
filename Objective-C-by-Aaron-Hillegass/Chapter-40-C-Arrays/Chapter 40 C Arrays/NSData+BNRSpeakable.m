//
//  NSData+BNRSpeakable.m
//  Chapter 40 C Arrays
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "NSData+BNRSpeakable.h"

@implementation NSData (BNRSpeakable)
- (NSString *)encodeAsSpeakableString {
    NSString *data = [[NSString alloc] initWithData:self
                                           encoding:NSASCIIStringEncoding];
    int thisByte;
    NSMutableString* result = [[NSMutableString alloc]init];
    NSString* brandNames[] = {@"Camry", @"Nikon", @"Apple", @"Ford",
        @"Audi", @"Google", @"Nike", @"Amazon", @"Honda", @"Mazda",
        @"Buick", @"Fiat", @"Jeep", @"Lexus", @"Volvo", @"Fuji",
        @"Sony", @"Delta", @"Focus", @"Puma", @"Samsung", @"Tivo",
        @"Halo", @"Sting", @"Shrek", @"Avatar", @"Shell", @"Visa",
        @"Vogue", @"Twitter", @"Lego", @"Pepsi" };
    
    const int first3Bit = 0b11100000;
    const int last5Bit  = 0b00011111;
    
    if ([data length] > 0){
        thisByte = [data characterAtIndex:0];
        [result appendFormat:@"%d", ((thisByte & first3Bit) >> 5) + 2];
        [result appendString:@" "];
        [result appendFormat:@"%@", brandNames[thisByte & last5Bit]];
    }
    for (int i = 1 ; i < [data length]; i++)
    {
        thisByte = [data characterAtIndex:i];
        [result appendString:@" "];
        [result appendFormat:@"%d", ((thisByte & first3Bit) >> 5) + 2];
        [result appendString:@" "];
        [result appendFormat:@"%@", brandNames[thisByte & last5Bit]];
    }
    return result;
}
+ (NSData *)dataWithSpeakableString:(NSString *)s
                              error:(NSError **)e
{
    NSDictionary *theList = @{@"Camry" : @0, @"Nikon" : @1,
                              @"Apple" : @2, @"Ford" : @3,
                              @"Audi" : @4, @"Google" : @5,
                              @"Nike" : @6, @"Amazon" : @7,
                              @"Honda" : @8, @"Mazda" : @9,
                              @"Buick" : @10, @"Fiat" : @11,
                              @"Jeep" : @12, @"Lexus" : @13,
                              @"Volvo" : @14, @"Fuji" : @15,
                              @"Sony" : @16, @"Delta" : @17,
                              @"Focus" : @18, @"Puma" : @19,
                              @"Samsung" : @20, @"Tivo" : @21,
                              @"Halo" : @22, @"Sting" : @23,
                              @"Shrek" : @24, @"Avatar" : @25,
                              @"Shell" : @26, @"Visa" : @27,
                              @"Vogue" : @28, @"Twitter" : @29,
                              @"Lego" : @30,@"Pepsi" : @31, };
    NSMutableString *result = [[NSMutableString alloc] init];
    NSArray *ary = [s componentsSeparatedByString:@" "];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    int thisByte = 0;
    for (int i = 0 ; i < [ary count]; i++)
    {
        bool isNum = i%2 == 0;
        if (isNum) {
            thisByte = [[f numberFromString: ary[i]]intValue];
            thisByte -= 2;
            thisByte <<= 5;
        }
        else {
            NSNumber* theNumber = [theList objectForKey:ary[i]];
            if (theNumber == nil) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Unable to parse"};
                *e = [NSError errorWithDomain:@"SpeakableBytes" code:1 userInfo:userInfo];
                return nil;
            }
            thisByte += [theNumber intValue];
            [result appendFormat:@"%c", thisByte];
        }
    }
    return [result dataUsingEncoding:NSASCIIStringEncoding];
}
@end
