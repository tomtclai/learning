//
//  BNRAppliance.m
//  Chapter 33 init
//
//  Created by Tsz Chun Lai on 1/24/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRAppliance.h"

@implementation BNRAppliance
-(instancetype) init
{
    return [self initWithProductName:@"Unknown"];
}
-(instancetype) initWithProductName:(NSString *)pn
{
    // Did the NSObject's init method return something non-nil?
    if (self = [super init]) {
        // Set the product name
        _productName = [pn copy];
        // Give voltage a starting value
        _voltage = 120;
    }
    
    // Return a pointer to the new object
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@ : %d volts>",
            self.productName, self.voltage];
}
@end
