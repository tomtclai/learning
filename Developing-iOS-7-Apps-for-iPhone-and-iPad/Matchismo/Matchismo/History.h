//
//  History.h
//  Matchismo
//
//  Created by Tom Lai on 8/13/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject
@property (nonatomic, strong, readonly) NSAttributedString *attributedLog;
- (void) appendString:(NSString*) string;
- (void) appendAttributedString:(NSAttributedString*) attributedString;
- (void) clearAllLogs;
@end
