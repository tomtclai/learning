//
//  FlickerPhotosTableViewController.m
//  Shutterbug
//
//  Created by Tom Lai on 8/28/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "FlickrPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "AppDelegate.h"
#import "ShutterbugDatabaseAvailability.h"
#import "Photo.h"
@interface FlickrPhotosTableViewController ()

@end

@implementation FlickrPhotosTableViewController
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ShutterbugDataBaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[ShutterbugDataBaseAvailabilityContext];
                                                      
                                                      
                                                      NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
                                                      
                                                      NSFetchedResultsController * controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                                                                    managedObjectContext:self.managedObjectContext
                                                                                                                                      sectionNameKeyPath:nil
                                                                                                                                               cacheName:@"Photo"];
                                                      self.fetchedResultsController = controller;
                                                      self.debug = YES;

                                                  }];
}
//- (void)setPhotos:(NSArray *)photos
//{
//    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
//    NSError *error ;
//    _photos = [self.managedObjectContext executeFetchRequest:request
//                                                       error:&error];
//    [self.tableView reloadData];
//}

#pragma mark - UITableViewDelegate

// for ipad
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareForImageViewController:detail toDisplayPhoto:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    return cell;
}
- (void)prepareForImageViewController:(ImageViewController *)ivc toDisplayPhoto:(Photo *)photo
{
    ivc.imageURL = [[NSURL alloc] initWithString:photo.imageURL];
    ivc.title = photo.title;
    [self saveToHistory:photo];
}

// For iphone
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    [self prepareForImageViewController:segue.destinationViewController
                                         toDisplayPhoto:[self.fetchedResultsController objectAtIndexPath:indexPath]];
                }
            }
        }
    } else {
        NSLog(@"sender isn't UITableViewCell");
    }
}

- (void)saveToHistory:(Photo*) photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:[defaults arrayForKey:historyKey]];
    [mutableArray insertObject:photo atIndex:0];
    [defaults setObject:mutableArray forKey:historyKey];
}
@end
