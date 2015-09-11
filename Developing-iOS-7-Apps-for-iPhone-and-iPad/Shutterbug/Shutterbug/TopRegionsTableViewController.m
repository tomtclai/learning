//
//  TopRegionsTableViewController.m
//  
//
//  Created by Tom Lai on 9/4/15.
//
//

#import "TopRegionsTableViewController.h"
#import "Region+Create.h"
@interface TopRegionsTableViewController ()
@property (strong, nonatomic) NSTimer* databaseResetTimer;
@end

@implementation TopRegionsTableViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.fetchLimit = 5;
//    request.fetchBatchSize = 20;
    request.sortDescriptors  = @[
                                 [NSSortDescriptor sortDescriptorWithKey:@"photographerCount"
                                                               ascending:NO],
                                 [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                               ascending:YES
                                                                selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    self.databaseResetTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                               target:self
                                                             selector:@selector(resetDatabase:)
                                                             userInfo:nil
                                                              repeats:YES];

}

- (void)resetDatabase:(NSTimer *)timer {
//    long rowCount = [self.tableView numberOfRowsInSection:0];
//    long lastIndex = rowCount - 1;
//    if (rowCount > SHOW_TOP_X) {
//
//        for (long i = lastIndex; i > SHOW_TOP_X; i--)
//        {
//            NSLog(@"%lu",i);
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            NSManagedObject* objectToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
//            [self.managedObjectContext deleteObject:objectToDelete];
//        }
//    }
//    
//    NSError* error = nil;
//    [self.fetchedResultsController performFetch:&error];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"mostViewPlaces"];
    Region *city = [self.fetchedResultsController objectAtIndexPath:indexPath];
    tableViewCell.textLabel.text = [NSString stringWithFormat:@"%@", city.name];
    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Photographers", city.photographerCount];
    return tableViewCell;
}



@end
