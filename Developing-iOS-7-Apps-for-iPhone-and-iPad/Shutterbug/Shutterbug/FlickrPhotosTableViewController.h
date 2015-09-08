//
//  FlickerPhotosTableViewController.h
//  Shutterbug
//
//  Created by Tom Lai on 8/28/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface FlickrPhotosTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
