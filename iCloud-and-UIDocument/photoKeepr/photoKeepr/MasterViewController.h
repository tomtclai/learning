//
//  MasterViewController.h
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DetailViewController.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, DetailViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

