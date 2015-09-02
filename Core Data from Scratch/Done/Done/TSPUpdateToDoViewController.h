//
//  TSPUpdateToDoViewController.h
//  Done
//
//  Created by Tom Lai on 9/1/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreData;

@interface TSPUpdateToDoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSManagedObjectContext *managgedObjectContext;

@property (strong, nonatomic) NSManagedObject *record;

@end
