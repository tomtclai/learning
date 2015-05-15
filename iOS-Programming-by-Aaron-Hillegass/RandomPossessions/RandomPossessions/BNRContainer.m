////
////  BNRContainer.m
////  RandomPossessions
////
////  Created by Tsz Chun Lai on 2/14/15.
////  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
////
//
//#import "BNRContainer.h"
//
//@implementation BNRContainer
//- (NSString *)description
//{
//    NSMutableString *descriptionString =
//    [[NSMutableString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@: \n{",
//     [self itemName],
//     [self serialNumber],
//     [super valueInDollars],
//     [super dateCreated]];
//    
//    for (BNRItem* a in items)
//    {
//        [descriptionString appendFormat:@"\n    %@", a];
//    }
//    
//    [descriptionString appendFormat:@"\n}"];
//    
//    return descriptionString;
//}
//
//- (id)initWithItemName:(NSString *)name
//         valueInDollars:(int)value
//           serialNumber:(NSString *)sNumber
//                objects:(BNRItem *)item
//{
//    self = [super initWithItemName:name
//                   valueInDollars:value
//                     serialNumber:sNumber];
//    
//    items = [[NSMutableArray alloc] init];
//    [items addObject:item];
//    
//    return self;
//}
//
//- (void)addObject:(BNRItem *)object
//{
//    if (items== nil)
//        items = [[NSMutableArray alloc] init];
//    [items addObject:object];
//}
//@end
