//
//  main.m
//  RandomPossessions
//
//  Created by Tsz Chun Lai on 2/7/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Create a mutable array object, store its address in items variable
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
//        // Send the message addObject: to the NSMutableArray pointed to
//        // by the variable items, passing a string each time.
//        [items addObject:@"One"];
//        [items addObject:@"Two"];
//        [items addObject:@"Three"];
//        
//        // Send another message, insertObject: atIndex:, to that same array object
//        [items insertObject:@"Zero" atIndex:0];
//        
//        // For every item in the array as determined by sending count to items
//        for (int i = 0 ; i < [items count]; i++) {
//            // We get the ith object from the array and pass it as an argument to
//            //NSLog, which implicitly sends the description message to that object
//            NSLog(@"%@", [items objectAtIndex:i]);
//        }
//        
        
//        BNRItem *p = [[BNRItem alloc] init];
//        
//        [p setItemName:@"Red Sofa"];
//        [p setSerialNumber:@"A1B2C"];
//        [p setValueInDollars:100];
//        
//        NSLog(@"%@ %@ %@ %d", [p itemName], [p dateCreated], [p serialNumber], [p valueInDollars]);
//        
//        for (int i = 0 ; i < 10; i ++)
//        {
//            BNRContainer *p = [BNRContainer randomItem];
//            [p addObject:[BNRItem randomItem]];
//            [p addObject:[BNRContainer randomItem]];
//            [p addObject:[BNRContainer randomItem]];
//            [items addObject:p];
//        }

        BNRItem *backpack = [[BNRItem alloc] init];
        [backpack setItemName:@"Backpack"];
//        [items addObject:backpack];
        
        BNRItem *calculator = [[BNRItem alloc] init];
        [calculator setItemName:@"calculator"];
//        [items addObject:calculator];

        [backpack setContainedItem:calculator];
        
        backpack = nil;
        
        NSLog(@"Container: %@", [calculator container]);
        for (BNRItem *item in items)
        {
            NSLog(@"%@", item);
        }
        
        items = nil;
    }
    return 0;
}
