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
@interface BNRItemsViewController()

@end

@implementation BNRItemsViewController


// Changing designated initializer to init
// 1. Call the superclass's designated initilizer from yours
- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // Create a new bar button that will send
        // addNewItem: to BNRItemsVIewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        
        // Set this bar button item as the right items in the navigation Item
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

// 2. Override the superclass's designated initilizer to call yours
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==[[[BNRItemStore sharedStore] allItems] count] )
    {
        return 44;
    }
    else
    {
        return 60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];

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
//    // Create an instance of UITableViewCell, with default appearance
//    UITableViewCell *cell = [[UITableViewCell alloc]
//                             initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//
    // Get a new or recycled cell
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
     forIndexPath:indexPath];
    // Set the test on the cell with the descriptiont of the item
    // that is at the n-th index of items, where n = row this cell
    // will appear in on the tableview
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    
    if (indexPath.row == [items count])
    {
        cell.textLabel.text = @"No more items!";

        return cell;
    }
    BNRItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    return cell;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
//    UIImage *tempImage = [UIImage imageNamed:@"Hazy-Nature.jpg"];
//    UIImageView *tempImageView = [[UIImageView alloc]initWithImage:tempImage];
//    [tempImageView setFrame:self.tableView.frame];
//    self.tableView.backgroundView = tempImageView;
//    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
//    
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
}

//- (UIView *)headerView
//{
//    if (!_headerView) {
//        // Load HeaderView.xib
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
//                                      owner:self
//                                    options:nil];
//    }
//    return _headerView;
//}

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
        
        // Also remove that row form the table view with an animation
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [[[BNRItemStore sharedStore] allItems] count])
        return NO;
    else return YES;
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
    
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

@end
