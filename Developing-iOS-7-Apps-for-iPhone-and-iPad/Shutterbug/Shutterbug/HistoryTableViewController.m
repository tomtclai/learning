//
//  HistoryTableViewController.m
//  Shutterbug
//
//  Created by Tom Lai on 9/3/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "AppDelegate.h"
#import "FlickrFetcher.h"
@interface HistoryTableViewController ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end
@implementation HistoryTableViewController
- (NSUserDefaults *) defaults {
    if (!_defaults)
    {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}
- (void)viewDidLoad {
    self.refreshControl = nil;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadPhotosFromNSDefault];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)loadPhotosFromNSDefault {
//    self.photos = [self.defaults objectForKey: historyKey];
}

- (IBAction)clearHistory:(id)sender {
//    [self.defaults setObject:[NSArray array] forKey:historyKey];
//    [self loadPhotosFromNSDefault];
//    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
