//
//  PTKEntry.h
//  photoKeepr
//
//  Created by Tom Lai on 9/21/15.
//  Copyright © 2015 Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class PTKMetadata;
@interface PTKEntry : NSObject

@property (strong) NSURL * fileURL;
@property (strong) PTKMetadata * metadata;
@property (assign) UIDocumentState state;
@property (strong) NSFileVersion * version;

- (id)initWithFileURL:(NSURL *)fileURL metadata:(PTKMetadata *)metadata state:(UIDocumentState)state version:(NSFileVersion *)version;
- (NSString *)description;
@end
