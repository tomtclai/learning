//
//  History.m
//  Matchismo
//
//  Created by Tom Lai on 8/13/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "History.h"
@interface History() {
    NSMutableAttributedString *_mutableAttributedLog;
}
@property (nonatomic, strong, readwrite) NSMutableAttributedString *mutableAttributedLog;
@end

@implementation History

- (NSMutableAttributedString *)attributedLog {
    if (!_mutableAttributedLog) {
        _mutableAttributedLog = [[NSMutableAttributedString alloc]init];
    }
    return _mutableAttributedLog;
}

- (NSMutableAttributedString *)mutableAttributedLog {
    if (!_mutableAttributedLog) {
        _mutableAttributedLog = [[NSMutableAttributedString alloc]init];
    }
    return _mutableAttributedLog;
}

- (void) appendString:(NSString*) string{
    [[self mutableAttributedLog] appendAttributedString:
     [[NSAttributedString alloc] initWithString:string]];
}
- (void) appendAttributedString:(NSAttributedString*) attributedString{
    [[self mutableAttributedLog] appendAttributedString:attributedString];
}
- (void) clearAllLogs{
    _mutableAttributedLog = nil;
}
@end
