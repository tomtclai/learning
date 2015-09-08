//
//  Photographer+Create.m
//  Photomania
//
//  Created by Tom Lai on 9/3/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "Photographer+Create.h"
#import "Region+Create.h"
@implementation Photographer (Create)
+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photographer *photographer = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if ([matches count]) {
            photographer = [matches lastObject];
        } else { // count == 0
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer"
                                                         inManagedObjectContext:context];
            photographer.name = name;
            
            
//            [photographer addHasTakenPhotosIn: [Region regionWithName:regionName
//                                               inManagedObjectContext:context]];
        }
    }
    return photographer;
}
@end
