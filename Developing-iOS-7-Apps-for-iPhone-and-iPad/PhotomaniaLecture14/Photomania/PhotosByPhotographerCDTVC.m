//
//  PhotosByPhotographerCDTVC.m
//  Photomania
//
//  Created by Tom Lai on 9/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "PhotosByPhotographerCDTVC.h"

@interface PhotosByPhotographerCDTVC ()

@end

@implementation PhotosByPhotographerCDTVC

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    [self setupFetchedResultsController];
}
- (void)setupFetchedResultsController
{
    NSManagedObjectContext *context = self.photographer.managedObjectContext;
    
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
