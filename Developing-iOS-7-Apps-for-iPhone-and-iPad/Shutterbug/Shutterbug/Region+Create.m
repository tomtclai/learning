//
//  Region+Create.m
//  Shutterbug
//
//  Created by Tom Lai on 9/8/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "Region+Create.h"

@implementation Region (Create)
+ (Region *)regionWIthName:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *region = nil;
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1 )) {
            // handle error
        } else if (![matches count]) {
            region = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer"
                                                   inManagedObjectContext:context];
            
            region.name = name;
        } else {
            region = [matches lastObject];
        }
    }
    return region;
}
@end
