//
//  FlickrCDTVC.m
//  Shutterbug
//
//  Created by Tom Lai on 9/9/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "FlickrCDTVC.h"
#import "ShutterbugDatabaseAvailability.h"

@implementation FlickrCDTVC
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ShutterbugDataBaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[ShutterbugDataBaseAvailabilityContext];
                                                      NSLog(@"ShutterbugDataBaseAvailabilityContext is working");
                                                  }];
}
@end
