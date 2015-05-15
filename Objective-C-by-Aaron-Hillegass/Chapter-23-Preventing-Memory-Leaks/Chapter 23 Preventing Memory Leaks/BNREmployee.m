//
//  BNREmployee.m
//  Chapter 20 Inheritance
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNREmployee.h"
#import "BNRAsset.h"
// A class Extension
@interface BNREmployee()
{
    NSMutableArray *_assets;
}
@property (nonatomic) unsigned int officeAlarmCode;
@end

@implementation BNREmployee
//Accessors for assets properties
- (void)setAsset:(BNRAsset *)a
{
    _assets = [a mutableCopy];
}

- (NSArray *)assets
{
    return [_assets copy];
}

- (void)addAsset:(BNRAsset *)a
{
    //Is assets nil?
    if (!_assets) {
        //create the array
        _assets = [[NSMutableArray alloc] init];
        a.holder = self;
    }
    [_assets addObject:a];
}
- (void)removeAsset:(BNRAsset *)a
{
    if(_assets)
    {
        for (int i = 0 ; i < [_assets count]; i++)
        {
            if (_assets[i] == a)
            {
                [_assets removeObjectAtIndex:i];
                break;
            }
        }
    }
}

- (unsigned int)valueOfAssets
{
    unsigned int sum = 0;
    for (BNRAsset *a in _assets){
        sum += [a resaleValue];
    }
    return sum;
}

- (double)yearsOfEmployment
{
    //Do I have a non-nil hireDate?
    if (self.hireDate)
    {
        //NSTimeInterval is the same as double
        NSDate * now = [NSDate date];
        NSTimeInterval secs = [now timeIntervalSinceDate:self.hireDate];
        
        double SECONDS_PER_YEAR = 31557600;
        return secs / SECONDS_PER_YEAR;
    }
    else
        return 0;
}

- (float)bodyMassIndex
{
    float normalBMI = [super bodyMassIndex];
    return normalBMI * 0.9;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Employee %u: %u in assets>",
            self.employeeID, self.valueOfAssets];
}

- (void) dealloc
{
    NSLog(@"deallocating %@", self);
}

@end
