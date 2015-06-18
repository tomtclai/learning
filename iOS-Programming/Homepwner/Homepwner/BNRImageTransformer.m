//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by Tom Lai on 6/17/15.
//  Copyright © 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRImageTransformer.h"
#import <UIKit/UIKit.h>
@implementation BNRImageTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

// Called when the thumbnail variable(value) is saved to the file system.
// Expects an object that can be saved to core data
- (id)transformedValue:(nullable id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

// Called when thumbnail data is loaded from the file system.
// Will create the UIImage from NSData(value)
- (id)reverseTransformedValue:(nullable id)value
{
    return [UIImage imageWithData:value];
}

@end
