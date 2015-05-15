//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Tsz Chun Lai on 3/2/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
@interface BNRItemsViewController()
{
    NSInteger numOfSections;
    NSMutableArray* expensiveItems;
    NSMutableArray* cheapItems;
}
@end
@implementation BNRItemsViewController

// Changing designated initializer to init
// 1. Call the superclass's designated initilizer from yours
- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    
    numOfSections = 2;
    [self splitArray:[[BNRItemStore sharedStore] allItems]
                cost:@50];
    printf("%ld",[expensiveItems count]);
    printf("%ld",[cheapItems count]);
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numOfSections;
}

// 2. Override the superclass's designated initilizer to call yours
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    printf("%ld",[expensiveItems count]);
    printf("%ld",[cheapItems count]);
    if (section==0) return [expensiveItems count];
    else return [cheapItems count];
}

- (void)splitArray:(NSArray *)source
              cost:(NSNumber *) cost
{
    if (cheapItems==nil)
        cheapItems = [[NSMutableArray alloc] init];
    if (expensiveItems==nil)
        expensiveItems = [[NSMutableArray alloc] init];
    
    for (BNRItem* tmp in source) {
        if ([tmp valueInDollars] >=50)
            [expensiveItems addObject:tmp];
        else
            [cheapItems addObject:tmp];
    }
}// brozne challenge in progress, I made this function to split
 // one array into two according to the specified price point

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"expensive items";
    else return @"cheap items";
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
//    NSArray *items = [[BNRItemStore sharedStore] allItems];
//    BNRItem *item = items[indexPath.row];
//    cell.textLabel.text = [item description];
    BNRItem *item;
    if ( [indexPath section]==0)
    {
        item = expensiveItems[indexPath.row];
    }
    else
    {
        item = cheapItems[indexPath.row];
    }
    assert(item!=nil);
    cell.textLabel.text = [item description];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}
@end
