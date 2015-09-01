//
//  TSPAddToDoViewController.m
//  Done
//
//  Created by Tom Lai on 9/1/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "TSPAddToDoViewController.h"
@import CoreData;
@interface TSPAddToDoViewController ()

@end

@implementation TSPAddToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)cancel:(id)sender {
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    NSString *name = self.textField.text;
    
    if (name && name.length) {
        // Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TSPItem"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        // Initialize Record
        NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Populate Record
        [record setValue:name forKey:@"name"];
        [record setValue:[NSDate date] forKey:@"createdAt"];
        
        // Save Record
        NSError *error = nil;
        
        if ([self.managedObjectContext save:&error]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            if (error) {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    } else {
        [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Your to-do needs a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
