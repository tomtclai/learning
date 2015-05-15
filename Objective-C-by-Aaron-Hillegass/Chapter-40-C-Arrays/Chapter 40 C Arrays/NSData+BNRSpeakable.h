//
//  NSData+BNRSpeakable.h
//  Chapter 40 C Arrays
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (BNRSpeakable)
- (NSString *)encodeAsSpeakableString;
+ (NSData *)dataWithSpeakableString:(NSString *)s
                              error:(NSError **)e;
@end
