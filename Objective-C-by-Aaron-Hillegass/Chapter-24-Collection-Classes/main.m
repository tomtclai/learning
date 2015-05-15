//
//  main.m
//  Chapter 20 Inheritance
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNREmployee.h"
#import "BNRAsset.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Create an array of BNREMployee objects
        NSMutableArray *employees = [[NSMutableArray alloc] init];
        
        //Create a dictionary of executives
        NSMutableDictionary *executives = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < 10; i++){
            // Create an instance of BNREmployee
            BNREmployee *mikey = [[BNREmployee alloc] init];
            
            // Give the instance vairables interesting values
            mikey.weightInKilos = 90+1;
            mikey.heightInMeters = 1.8 - i/10.0;
            mikey.employeeID = i;
            if (i==0) [executives setObject:mikey forKey:@"CEO"];
            if (i==1) [executives setObject:mikey forKey:@"CTO"];
            // Put the employee in the employees array
            [employees addObject:mikey];
        }
        
        NSMutableArray *allAssests = [[NSMutableArray alloc] init];
        //Print out the entire dictionary
        NSLog(@"executives: %@", executives);
        
        //Print out the CEO's Information
        NSLog(@"CEO: %@", executives[@"CEO"]);
        executives = nil;
        // Create 10 assets
        for (int i = 0; i < 10; i++) {
            // Create an asset
            BNRAsset *asset = [[BNRAsset alloc] init];
            
            // Give it an interesting label
            NSString *currentLabel = [NSString stringWithFormat:@"Laptop %d",i];
            asset.label = currentLabel;
            asset.resaleValue = 1+i * 17;
            
            // Get a random number between 0 and 9 inclusive
            NSUInteger randomIndex = random() % [employees count];
//            NSUInteger randomIndex = i;
            // Find that employee
            BNREmployee *randomEmployee = [employees objectAtIndex:randomIndex];
            
            // Assign the asset to the employee
            [randomEmployee addAsset:asset];
            [allAssests addObject:asset];
            // Remove the asset to the employee
//            [randomEmployee removeAsset:asset];
        }
        NSSortDescriptor *voa = [NSSortDescriptor
                                 sortDescriptorWithKey:@"valueOfAssets"
                                 ascending:YES];
        NSSortDescriptor *eid = [NSSortDescriptor
                                 sortDescriptorWithKey:@"employeeID"
                                 ascending:YES];
        [employees sortUsingDescriptors:@[voa, eid]];
        
        NSLog(@"Employees: %@", employees);

        NSLog(@"Giving up ownership of one employee");
        
        [employees removeObjectAtIndex:5];
        NSLog(@"allAssets: %@", allAssests);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"holder.valueOfAssets > 70"];
        NSArray *toBeReclaimed = [allAssests
                                  filteredArrayUsingPredicate:predicate];
        NSLog(@"toBeReclaimed %@", toBeReclaimed);
        toBeReclaimed = nil;
        
        NSLog(@"Giving up ownership of arrays");
        allAssests = nil;
        employees = nil;
    }
    return 0;
}
