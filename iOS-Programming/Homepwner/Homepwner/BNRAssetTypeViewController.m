//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by Tom Lai on 6/17/15.
//  Copyright © 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRDetailViewController.h"
@import UIKit;
@interface BNRAssetTypeViewController ()

@end
@implementation BNRAssetTypeViewController
#pragma mark - init
- (instancetype)init
{
    self  = [super initWithStyle:UITableViewStylePlain];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditingMode)];
    [self navigationItem].leftBarButtonItem = editButton;
    self.editButton=editButton;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntityType)];
    self.addButton = addButton;

    [self navigationItem].rightBarButtonItem = addButton;
    return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view
- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UITableViewCell"
                             forIndexPath:indexPath];
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    
    // Use key-value coding to get the asset type's label
    NSString *assetLabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetLabel;
    
    // Checkmark the one that is currently selected
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    for (UITableViewCell *cell in [tableView visibleCells])
    {
        cell.accessoryType = UITableViewStylePlain;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[self tableView]deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command ...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [[BNRItemStore sharedStore] removeValue:[cell textLabel].text
                                         forKey:@"label"
                                     fromEntity:@"BNRAssetType"];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
        

    }
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [[BNRItemStore sharedStore] addValue:[cell textLabel].text
                                      forKey:@"label"
                                    toEntity:@"BNRAssetType"];
        
        
        // Also add that row from the table view with an animation
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)toggleEditingMode
{
    if (self.editing)
    {
        [self setEditing:NO animated:YES];
        [[self editButton] setTitle:@"Done"];
        [[self editButton] setStyle:UIBarButtonItemStyleDone];
    }
    else
    {
        [self setEditing:YES animated:YES];
        [[self editButton] setTitle:@"Edit"];
        [[self editButton] setStyle:UIBarButtonItemStylePlain];
    }
}
- (void)addEntityType
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter new type" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add"];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
@end
