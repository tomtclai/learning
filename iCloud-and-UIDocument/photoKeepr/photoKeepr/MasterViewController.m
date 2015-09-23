//
//  MasterViewController.m
//  photoKeepr
//
//  Created by Tom Lai on 9/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PTKDocument.h"
#import "NSDate+FormattedStrings.h"
#import "PTKEntry.h"
#import "PTKMetadata.h"
#import "PTKEntryCell.h"

@interface MasterViewController ()
@property (nonatomic, strong) NSURL * localRoot;
@property (nonatomic, strong) PTKDocument * selDocument;
@end

@implementation MasterViewController

NSMutableArray<PTKEntry *> * objects;
#pragma mark Helpers
- (BOOL)iCloudOn {
    return NO;
}

// lazy load
- (NSURL *)localRoot {
    if (_localRoot != nil) {
        return _localRoot;
    }
    
    NSArray * paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    _localRoot = [paths firstObject];
    
    return _localRoot;
}

// pass in a filename and get the full path to the file.
- (NSURL *)getDocURL: (NSString *)filename {
    if ([self iCloudOn]) {
        // TODO
        return nil;
    } else {
        return [self.localRoot URLByAppendingPathComponent:filename];
    }
}

// loops through the list of PTKEntry instances in _objects and checks to see if the name matches any of them. If it does, there’s a conflict, otherwise it’s OK.
- (BOOL)docNameExistsInObjects:(NSString *)docName {
    BOOL nameExists = NO;
    for (PTKEntry * entry in objects) {
        if ([[entry.fileURL lastPathComponent] isEqualToString:docName])  {
            nameExists = YES;
            break;
        }
    }
    return nameExists;
}

//  find a non-taken name for a file
- (NSString *)getDocFilename:(NSString *)prefix uniqueInObjects:(BOOL)uniqueInObjects {
    NSInteger docCount = 0;
    NSString* newDocName = nil;
    
    // document list should be up-to-date
    BOOL done = NO;
    BOOL first = YES;
    while (!done) {
        if (first) {
            first = NO;
            newDocName = [NSString stringWithFormat:@"%@.%@", prefix, PTK_EXTENSION];
        } else {
            newDocName = [NSString stringWithFormat:@"%@ %ld.%@", prefix, (long)docCount, PTK_EXTENSION];
        }
        
        // Look for an existing doc with the same name
        BOOL nameExists;
        if (uniqueInObjects) {
            nameExists = [self docNameExistsInObjects:newDocName];
        } else {
            // TODO
            return nil;
        }
        
        if (!nameExists) {
            break;
        } else {
            docCount++;
        }
    }
    return newDocName;
}

#pragma mark Entry management methods
- (NSInteger)indexOfEntryWithFileURL:(NSURL *)fileURL {
    __block NSInteger retval = -1;
#warning signed integer conversion
    [objects enumerateObjectsUsingBlock:^(PTKEntry *  _Nonnull entry, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([entry.fileURL isEqual:fileURL]) {
            retval = idx;
            *stop = YES;
        }
    }];
    return retval;
}

- (void)addOrUpdateEntryWithURL:(NSURL *)fileURL metadata:(PTKMetadata *)metadata state:(UIDocumentState)state version:(NSFileVersion *)version {
    long int index = [self indexOfEntryWithFileURL:fileURL];
    if (index == -1) {
        // add entry
        PTKEntry * entry = [[PTKEntry alloc] initWithFileURL:fileURL
                                                    metadata:metadata
                                                       state:state
                                                     version:version];
        [objects addObject:entry];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(objects.count - 1) inSection:0];
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
    } else {
        // update entry
        PTKEntry *entry = objects[index];
        entry.metadata = metadata;
        entry.state = state;
        entry.version = version;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)removeEntryWithURL:(NSURL *)fileURL {
    long int index = [self indexOfEntryWithFileURL:fileURL];
    [objects removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

- (BOOL)renameEntry:(PTKEntry *)entry to:(NSString *)filename {
    // return if not actually renaming
    if ([entry.description isEqualToString:filename]) {
        return YES;
    }
    // Check if can rename
    NSString * newDocFilename = [NSString stringWithFormat:@"%@.%@", filename, PTK_EXTENSION];
    if ([self docNameExistsInObjects:newDocFilename]) {
        NSString *message = [NSString stringWithFormat:@"\"%@\" is already taken. Please choose a different name", filename];
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [self showViewController:alertViewController sender:self];

        return NO;
    }
    
    NSURL * newDocURL = [self getDocURL:newDocFilename];
    NSLog(@"Moving %@ to %@", entry.fileURL, newDocURL);
    
    // Simple renaming to start
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSError * error;
    BOOL success = [fileManager moveItemAtURL:entry.fileURL toURL:newDocURL error:&error];
    if (!success) {
        NSLog(@"Failed to move file %@", error.localizedDescription);
        return NO;
    }
    
    // Fix up entry
    entry.fileURL = newDocURL;
    long int index = [self indexOfEntryWithFileURL:entry.fileURL];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    
    return YES;
}

#pragma mark File management
- (void)loadDocAtURL:(NSURL *)fileURL {
    // Open doc to read metadata
    PTKDocument *doc = [[PTKDocument alloc] initWithFileURL:fileURL];
    [doc openWithCompletionHandler:^(BOOL success) {
        // Check status
        if (!success) {
            NSLog(@"Failed to open %@", fileURL);
            return ;
        }
        
        // Load metatdata in the background
        PTKMetadata *metadata = doc.metadata;
        NSURL *fileURL = doc.fileURL;
        UIDocumentState state = doc.documentState;
        NSFileVersion * version = [NSFileVersion currentVersionOfItemAtURL:fileURL];
        NSLog(@"Loaded File URL: %@", [doc.fileURL lastPathComponent]);
        
        // Close doc
        [doc closeWithCompletionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"Fail to close %@", fileURL);
                // Continue anyway
            }
            
            // Add to the list of files on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addOrUpdateEntryWithURL:fileURL metadata:metadata state:state version:version];
            });
        }];
    }];
}
- (void)deleteEntry:(PTKEntry *)entry {
    // Will cause problems with iCloud but works file for local docs
    NSFileManager* fileManager = [NSFileManager new];
    [fileManager removeItemAtURL:entry.fileURL error:nil];
    
    // Fixup view
    [self removeEntryWithURL:entry.fileURL];
}


#pragma mark Refresh Methods
- (void)loadLocal {
    NSArray *localDocuments = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.localRoot
                                                            includingPropertiesForKeys:nil
                                                                               options:0
                                                                                 error:nil];
    NSLog(@"Found %ld local files", localDocuments.count);
    for (int i = 0; i < localDocuments.count ; i++) {
        NSURL * fileURL = [localDocuments objectAtIndex:i];
        
        if ([[fileURL pathExtension] isEqualToString:PTK_EXTENSION]) {
            NSLog(@"Found local file: %@", fileURL);
            [self loadDocAtURL:fileURL];
        }
    }
    // The reason we enable/disable the right bar button item is you shouldn’t be able to create a new file until we have retrieved the list of files. This is because we need the list of files to guarantee a unique name when creating a new file. This doesn’t much matter now since we get the list of files right away, but is good to have in place for when that isn’t the case with iCloud.
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)refresh {
    [objects removeAllObjects];
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (!self.iCloudOn) {
        [self loadLocal];
    }
}

#pragma mark DetailViewControllerDelegate
- (void)detailViewControllerDidClose:(DetailViewController *)detailViewController {
    [self.navigationController popViewControllerAnimated:YES];
    NSFileVersion * version = [NSFileVersion currentVersionOfItemAtURL:detailViewController.doc.fileURL];
    [self addOrUpdateEntryWithURL:detailViewController.doc.fileURL metadata:detailViewController.doc.metadata state:detailViewController.doc.documentState version:version];
    
}
#pragma mark - View Controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    objects = [NSMutableArray new];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    // Get unique filename
    NSURL * fileURL = [self getDocURL:[self getDocFilename:@"Photo" uniqueInObjects:YES]];
    NSLog(@"Want to create file at %@", fileURL);
    
    // Create new doc and save to url
    PTKDocument *doc = [[PTKDocument alloc] initWithFileURL:fileURL];
    [doc saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"Failed to create file at %@", fileURL);
            return;
        }
        
        NSLog(@"File created at %@", fileURL);
        PTKMetadata * metadata = doc.metadata;
        NSURL *fileURL = doc.fileURL;
        UIDocumentState state = doc.documentState;
        NSFileVersion * version = [NSFileVersion currentVersionOfItemAtURL:fileURL];
        
        self.selDocument = doc;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addOrUpdateEntryWithURL:fileURL
                                 metadata:metadata
                                    state:state
                                  version:version];
            [self performSegueWithIdentifier:@"showDetail" sender:self];
        });
    }];
}

#pragma mark - Segues
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKEntry *entry = [objects objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    _selDocument = [[PTKDocument alloc]initWithFileURL:entry.fileURL];
    [_selDocument openWithCompletionHandler:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"showDetail" sender:self];
        });
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        UINavigationController * nc = [segue destinationViewController];
        DetailViewController *dvc = nc.viewControllers.firstObject;
        dvc.delegate = self;
        dvc.doc = _selDocument;
    }
}

#pragma mark - Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [sectionInfo numberOfObjects];
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKEntryCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PTKEntry *entry = [objects objectAtIndex: indexPath.row];
    
    cell.titleTextField.text = entry.description;
    cell.titleTextField.delegate = self;
    
    cell.subtitleLabel.text = entry.version? [entry.version.modificationDate mediumString] : @"";
    cell.photoImageView.image = entry.metadata? entry.metadata.thumbnail : nil;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PTKEntry *entry =[objects objectAtIndex:indexPath.row];
        [self deleteEntry:entry];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
