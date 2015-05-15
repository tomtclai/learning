//
//  Document.h
//  TahDoodle
//
//  Created by Tsz Chun Lai on 1/22/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument <NSTableViewDataSource>
@property (nonatomic) NSMutableArray *tasks;
@property (nonatomic) IBOutlet NSTableView *taskTable;

-(IBAction)addTask:(id)sender;
-(IBAction)removeTask:(id)sender;
@end

