//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Tsz Chun Lai on 3/2/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemsViewController() <UIPopoverControllerDelegate, UIDataSourceModelAssociation>
@property (nonatomic, strong) UIPopoverController *imagePopover;
@end

@implementation BNRItemsViewController

#pragma mark - init

// Changing designated initializer to init
// 1. Call the superclass's designated initilizer from yours
- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = NSLocalizedString(@"Homepwner", @"Name of application");
        
        
        // state restoration support
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // Create a new bar button that will send
        // addNewItem: to BNRItemsVIewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        
        // Set this bar button item as the right items in the navigation Item
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(updateTableViewForDynamicTypeSize)
                   name:UIContentSizeCategoryDidChangeNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(localeChanged:)
                   name:NSCurrentLocaleDidChangeNotification
                 object:nil];
    }
    
    return self;
}

// 2. Override the superclass's designated initilizer to call yours
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}


#pragma mark - table view controller
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    if (indexPath.row == items.count) return;
    BNRItem *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Once a UINib has been registered with a table view, the table view can be
    // asked to load the instance of BNRItemCell when given the reuse identifier
    // "BNRItemCell".
    // Get a new or recycled cell
    BNRItemCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell"
     forIndexPath:indexPath];
    NSArray *items = [[BNRItemStore sharedStore] allItems];

    BNRItem *item = items[indexPath.row];

    // Configure the cell with the BNRItem
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    
    
    // Create a number formatter for currency
    static NSNumberFormatter *currencyFormatter = nil;
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
    cell.thumbnailView.image = item.thumbnail;
    
    // by default, cell has a strong reference to actionBlack, actionBlock has a
    // strong reference to cell.
    // the following line breaks the strong reference cycle.
    __weak BNRItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        // temporarily take strong ownership, make sure the cell hangs around until
        // actionBlock is done executing
        BNRItemCell *cell = weakCell;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            // if there is no image, we don't need to display anything
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!img) return;
            
            // Make a rectangle for the frame of the thumbnail relative to our table view
            CGRect rect = [self.view convertRect:cell.thumbnailView.bounds
                                        fromView:cell.thumbnailView];
            
            // Create a new BNRImageViewController and set its image
            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            
            // Present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command ...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        // Also remove that row from the table view with an animation
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[BNRItemStore sharedStore] allItems] count])
        return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}



#pragma mark - view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    // Register this NIB, which contain the cell
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"BNRItemCell"];
    // The table view simply stores the UINib instance in an NSDictionary
    // for the key "BNRItemCell". A UINib contains all of the data stored in its
    // XIB file
    
    
    self.tableView.restorationIdentifier = @"BNRItemsViewControllerTableView";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

#pragma mark - buttons
- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    // This instance of UINavigationController will never be used for navigation,
    // but gives this view the same title bar across the top that every other
    // view has, also a place to put Done and Cancel buttons
    UINavigationController *navController =[[UINavigationController alloc]
                                            initWithRootViewController:detailViewController];
    // Change the presetnation style of the UINavigationCOntoller that is being
    // presented
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // state restoration support
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    navController.restorationClass = [navController class];
    
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{
                                 UIContentSizeCategoryExtraSmall : @44,
                                 UIContentSizeCategorySmall : @44,
                                 UIContentSizeCategoryMedium : @44,
                                 UIContentSizeCategoryLarge : @44,
                                 UIContentSizeCategoryExtraLarge : @55,
                                 UIContentSizeCategoryExtraExtraLarge: @65,
                                 UIContentSizeCategoryExtraExtraExtraLarge :@75
                                 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    
    [self.tableView setRowHeight: cellHeight.floatValue];
    [self.tableView reloadData];
}


- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        // Change text of button
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change text
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // Enter editing mode
        [self setEditing:YES animated:YES];
    }
}
#pragma mark - dealloc

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

#pragma mark - state restoration
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)paths coder:(nonnull NSCoder *)coder
{
    return [[self alloc]init];
}

- (void)encodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
}

#pragma mark - UIDataSourceModelAssociation
- (NSString *)modelIdentifierForElementAtIndexPath:(nonnull NSIndexPath *)idx
                                            inView:(nonnull UIView *)view
{
    NSString *identifier = nil;
    
    if (idx && view) {
        // Return an identifier of the given NSIndexPath
        // in case next time the data source changes
        BNRItem *item = [[BNRItemStore sharedStore] allItems][idx.row];
        identifier = item.itemKey;
    }
    
    return identifier;
}

-(NSIndexPath *)indexPathForElementWithModelIdentifier:(nonnull NSString *)identifier inView:(nonnull UIView *)view
{
    NSIndexPath *indexPath = nil;
    if (identifier && view) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        for (BNRItem *item in items) {
            if ([identifier isEqualToString:item.itemKey]){
                int row = (int) [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}

#pragma mark - NSCurrentLocaleDidChangeNotification
- (void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}
@end
