//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Tsz Chun Lai on 2/7/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

@synthesize itemName, serialNumber,valueInDollars, dateCreated;
- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];

    if (self) {
        // Give the instance variables initial values
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];

        dateCreated = [[NSDate alloc] init];

        // Create an NSUUID object - get its string representation
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    // Return the address of the newly initilized object
    return self;
}

- (id)initWithItemName:(NSString *)name
          serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:sNumber];
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     itemName,
     serialNumber,
     valueInDollars,
     dateCreated];

    return descriptionString;
}

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                                              @"Rusty",
                                                              @"Shiny", nil];
    // Create an array of three nouns
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                               @"Spork",
                               @"Mac", nil];

    // Get the index of a random adjective/nount from the lists
    NSInteger adjectiveIndex =  rand() % [randomAdjectiveList count];
    NSInteger nounIndex      =  rand() % [randomNounList count];

    // Note that NSINteger is not an object, but a type definition
    // for "unsiged long"

     NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                             [randomAdjectiveList objectAtIndex:adjectiveIndex],
                             [randomNounList objectAtIndex:nounIndex]];

    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];

    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];

    return newItem;
}

- (void)dealloc
{
    NSLog(@"Destroyed :%@", self);
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated  forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        itemName = [aDecoder decodeObjectForKey:@"itemName"];
        serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];;
    }
    return self;
}
@end
