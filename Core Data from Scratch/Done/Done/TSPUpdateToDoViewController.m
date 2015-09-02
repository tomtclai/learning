//
//  TSPUpdateToDoViewController.m
//  Done
//
//  Created by Tom Lai on 9/1/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "TSPUpdateToDoViewController.h"

@interface TSPUpdateToDoViewController ()

@end

@implementation TSPUpdateToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.record) {
        // Update Text field
        [self.textField setText:[self.record valueForKey:@"name"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Actions
- (IBAction)cancel:(id)sender {
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    // Helpers
    NSString *name = self.textField.text;
    
    if (name && name.length) {
        // Populate Record
        [self.record setValue:name forKey:@"name"];
        
        // Save Record
        NSError *error = nil;
        
        if ([self.managgedObjectContext save:&error]) {
            // Pop view controller
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (error) {
                NSLog(@"Unable to save record");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            // Show Alert View
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do needs a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}
@end
