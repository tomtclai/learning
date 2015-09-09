//
//  FlickrCDTVC.h
//  Shutterbug
//
//  Created by Tom Lai on 9/9/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface FlickrCDTVC : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
