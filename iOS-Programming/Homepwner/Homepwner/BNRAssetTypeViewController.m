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
@implementation BNRAssetTypeViewController
#pragma mark - init
- (instancetype)init
{
    self  = [super initWithStyle:UITableViewStylePlain];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]init];
    editButton.style = UIBarButtonSystemItemEdit;
    [self navigationItem].leftBarButtonItem = editButton;
    editButton.enabled = YES;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.padPopover)
    {
        [[self padPopover] dismissPopoverAnimated:YES];
        [self.dvc setTypeLabel];
    }
}
@end
