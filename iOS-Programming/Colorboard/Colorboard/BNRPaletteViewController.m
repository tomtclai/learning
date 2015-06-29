//
//  BNRPaletteViewController.m
//  Colorboard
//
//  Created by Tom Lai on 6/29/15.
//  Copyright © 2015 Tom. All rights reserved.
//

#import "BNRPaletteViewController.h"
#import "BNRColorViewController.h"
#import "BNRColorDescription.h"
@interface BNRPaletteViewController ()

@property (nonatomic) NSMutableArray *colors;

@end

@implementation BNRPaletteViewController

#pragma mark - UIView
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - tableview
- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.colors count];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    BNRColorDescription *color = self.colors[indexPath.row];
    
    cell.textLabel.text = color.name;
    
    return cell;
}

#pragma mark - BNRPaletteView
- (NSMutableArray *)colors
{
    if (!_colors) {
        _colors = [NSMutableArray array];
        BNRColorDescription *cd = [[BNRColorDescription alloc] init];
        [_colors addObject:cd];
    }
    
    return _colors;
}

- (void) prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.identifier isEqualToString:@"NewColor"])
    {
        BNRColorDescription *color = [[BNRColorDescription alloc]init];
        [self.colors addObject:color];
        
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        
        BNRColorViewController *cvc = (BNRColorViewController *)[nc topViewController];
        
        cvc.colorDescription = color;
    }
    else if ([segue.identifier isEqualToString:@"ExistingColor"]) {
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        BNRColorDescription *color = self.colors[ip.row];
        
        // set color
        BNRColorViewController *cvc = (BNRColorViewController *)segue.destinationViewController;
        
        cvc.colorDescription = color;
        cvc.existingColor = YES;
    }
}


@end
