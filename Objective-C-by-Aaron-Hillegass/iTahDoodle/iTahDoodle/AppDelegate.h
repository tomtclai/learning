//
//  AppDelegate.h
//  iTahDoodle
//
//  Created by Tsz Chun Lai on 1/21/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

// Declare a helper function that you will use to get a path
// to the location on disk where you can save the to-do list
NSString *DocPath(void);

//Controller
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITableViewDataSource>

//Views
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UITableView *taskTable;
@property (nonatomic) UITextField *taskField;
@property (nonatomic) UIButton *insertButton;
//Model
@property (nonatomic) NSMutableArray *tasks;

-(void) addTask:(id) sender;

@end

