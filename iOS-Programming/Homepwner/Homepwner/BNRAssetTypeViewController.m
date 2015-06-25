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
@interface BNRAssetTypeViewController () <UIAlertViewDelegate>

@end
@implementation BNRAssetTypeViewController

#pragma mark - init
- (instancetype)init
{
    
    self.navigationItem.title = NSLocalizedString(@"Asset Type", @"BNRAssetTypeViewController title");
    
    self.itemsOfSelectedType = [[NSMutableArray alloc]init];
    self  = [super initWithStyle:UITableViewStylePlain];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]init];
    
    [editButton setTarget:self];
    [editButton setAction:@selector(toggleEditingMode)];
    [editButton setTitle:@"Edit"];
    [self navigationItem].leftBarButtonItem = editButton;
    self.editButton = editButton;


    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntityType)];
    self.addButton = addButton;
    [self navigationItem].rightBarButtonItem = addButton;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        self.doneButton = doneButton;
        [self navigationItem].rightBarButtonItem = doneButton;
    }
    return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}
- (void)viewWillAppear:(BOOL)animated
{
    for (int i = 0 ; i < [self.tableView numberOfRowsInSection:0]; i++)
    {
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            [self itemsOfTypeAtIndexPath:indexpath];
            [[self tableView] reloadData];
            return;
        }
    }

}
#pragma mark - Table view
- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return [[[BNRItemStore sharedStore] allAssetTypes] count];
    }
    else
    {
        return [[self itemsOfSelectedType] count];;
    }
}

- (void)itemsOfTypeAtIndexPath:(NSIndexPath* ) indexpath
{
    if (indexpath.section == 1 )return;
    NSManagedObject *assetType = [[self item]assetType];
    if (assetType == nil) return;

    NSString* typeName = [[[self tableView]cellForRowAtIndexPath:indexpath]textLabel].text;
    
    NSSet* items = [[BNRItemStore sharedStore]itemsForAssetType:typeName];
    
    [self.itemsOfSelectedType removeAllObjects];
    for (BNRItem* i in items)
    {
        [self.itemsOfSelectedType addObject:i];
    }
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UITableViewCell"
                             forIndexPath:indexPath];

    if (indexPath.section==0)
    {
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
    }
    else
    {
        
        cell.textLabel.text = [[[self itemsOfSelectedType]objectAtIndex:indexPath.row]itemName];// this crashes
        
    }
    return cell;
}
- (void)tableView:(nonnull UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [[self tableView]deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    for (UITableViewCell *cell in [tableView visibleCells])
    {
        cell.accessoryType = UITableViewStylePlain;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.accessoryType = UITableViewCellAccessoryCheckmark;




    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];

    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    [self.navigationController popViewControllerAnimated:YES];
    [self itemsOfTypeAtIndexPath:indexPath];
    [[self tableView] reloadData];
    [[self tableView]deselectRowAtIndexPath:indexPath animated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return 2;
}

- (BOOL)tableView:(nonnull UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 1) return NO;
    return YES;
}

- (NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section== 0) return @"Asset Category";
    else return @"Items in the current category";
}
#pragma mark - buttons
- (void)toggleEditingMode
{
    if (self.editing)
    {
        [self setEditing:NO animated:YES];
        [[self editButton] setTitle:@"Edit"];
        [[self editButton] setStyle:UIBarButtonItemStylePlain];
        [self navigationItem].rightBarButtonItem = self.doneButton;

    }
    else
    {
        [self setEditing:YES animated:YES];
        [[self editButton] setTitle:@"Done"];
        [[self editButton] setStyle:UIBarButtonItemStyleDone];
        [self navigationItem].rightBarButtonItem = self.addButton;
    }
}
- (void)addEntityType
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Asset Type" message:@"Enter new type" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)done
{
    [[self navigationController]popViewControllerAnimated:YES];
}
#pragma mark - UIAlertView
- (void)alertView:(nonnull UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *newValue = [alertView textFieldAtIndex:0].text;
        [[BNRItemStore sharedStore]addValue:newValue forKey:@"label" toEntity:@"BNRAssetType"];
        [[self tableView] reloadData];
    }
}
@end
