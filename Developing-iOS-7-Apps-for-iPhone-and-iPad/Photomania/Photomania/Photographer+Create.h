//
//  Photographer+Create.h
//  Photomania
//
//  Created by Tom Lai on 9/3/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)
+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;
@end
