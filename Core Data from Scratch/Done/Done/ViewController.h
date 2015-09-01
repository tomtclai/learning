//
//  ViewController.h
//  Done
//
//  Created by Tom Lai on 8/31/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

