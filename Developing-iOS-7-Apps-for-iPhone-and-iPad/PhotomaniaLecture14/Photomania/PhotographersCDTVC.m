//
//  PhotographersCDTVC.m
//  Photomania
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PhotographersCDTVC.h"
#import "Photographer.h"
#import "PhotoDatabaseAvailability.h"
#import "PhotosByPhotographerCDTVC.h"
#import "PhotosByPhotographerMapViewController.h"
@implementation PhotographersCDTVC

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[PhotoDatabaseAvailabilityContext];
                                                  }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];

    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Photographer Cell"];
    
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photographer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", (int)[photographer.photos count]];
    
    return cell;
}
#pragma mark - Navigation
- (void)prepareViewController:(id)vc forSegue: (NSString *)segueIdentifier fromIndexPath:(NSIndexPath *)indexPath
{
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[PhotosByPhotographerCDTVC class]]) {
        if (![segueIdentifier length] || [segueIdentifier isEqualToString:@"Show Photos By Photographer"]) {
            //prepare vc
            PhotosByPhotographerCDTVC * pbpcdtvc = (PhotosByPhotographerCDTVC *)vc;
            pbpcdtvc.photographer = photographer;
        }
    }
    if ([vc isKindOfClass:[PhotosByPhotographerMapViewController class]]) {
        if (![segueIdentifier length] || [segueIdentifier isEqualToString:@"Show Photos By Photographer"]) {
            //prepare vc
            PhotosByPhotographerMapViewController * pbpmvc = (PhotosByPhotographerMapViewController *)vc;
            pbpmvc.photographer = photographer;
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if ([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *) detailvc).viewControllers firstObject];
        [self prepareViewController:detailvc
                           forSegue:nil
                      fromIndexPath:indexPath];
    }
}

@end
