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

@end

@implementation TopRegionsTableViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.fetchLimit = 50;
    request.fetchBatchSize = 20;
    request.sortDescriptors  = @[
                                 [NSSortDescriptor sortDescriptorWithKey:@"photographerCount"
                                                               ascending:NO
                                                                selector:@selector(localizedStandardCompare:)],
                                 [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                               ascending:YES
                                                                selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"mostViewPlaces"];
    Region *city = [self.fetchedResultsController objectAtIndexPath:indexPath];
    tableViewCell.textLabel.text = city.name;
    return tableViewCell;
}

@end
